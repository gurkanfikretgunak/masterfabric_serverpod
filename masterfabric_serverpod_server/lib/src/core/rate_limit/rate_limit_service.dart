import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

// Note: RateLimitException is now a SerializableException from generated/protocol.dart
// This allows proper error serialization to clients instead of internal server errors

/// Rate limiting configuration for an endpoint
class RateLimitConfig {
  /// Maximum number of requests allowed in the window
  final int maxRequests;
  
  /// Time window duration
  final Duration windowDuration;
  
  /// Key prefix for cache (e.g., 'greeting', 'auth')
  final String keyPrefix;

  const RateLimitConfig({
    required this.maxRequests,
    required this.windowDuration,
    required this.keyPrefix,
  });
}

/// Rate limit information for API responses
class RateLimitInfo {
  /// Maximum requests allowed in window
  final int limit;
  
  /// Remaining requests in current window
  final int remaining;
  
  /// Current request count
  final int current;
  
  /// Time window in seconds
  final int windowSeconds;
  
  /// Seconds until rate limit resets (null if no active window)
  final int? resetInSeconds;
  
  /// Timestamp when rate limit resets (null if no active window)
  final DateTime? resetAt;

  const RateLimitInfo({
    required this.limit,
    required this.remaining,
    required this.current,
    required this.windowSeconds,
    this.resetInSeconds,
    this.resetAt,
  });

  /// Convert to JSON map for API response
  Map<String, dynamic> toJson() => {
    'limit': limit,
    'remaining': remaining,
    'current': current,
    'windowSeconds': windowSeconds,
    if (resetInSeconds != null) 'resetInSeconds': resetInSeconds,
    if (resetAt != null) 'resetAt': resetAt!.toIso8601String(),
  };
}

/// Rate limiting service using Redis cache
/// 
/// Provides distributed rate limiting across server cluster using Serverpod's
/// global cache (Redis). Supports configurable limits per endpoint.
class RateLimitService {
  /// Default rate limit (20 requests per minute)
  static const int defaultMaxRequests = 20;
  static const Duration defaultWindowDuration = Duration(minutes: 1);

  /// Check rate limit for a specific key
  /// 
  /// [session] - Serverpod session
  /// [config] - Rate limit configuration
  /// [identifier] - Unique identifier (e.g., user ID, IP address, session ID)
  /// 
  /// Throws RateLimitError if limit is exceeded
  static Future<void> checkLimit(
    Session session,
    RateLimitConfig config,
    String identifier,
  ) async {
    final cacheKey = _getCacheKey(config.keyPrefix, identifier);
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowMs = config.windowDuration.inMilliseconds;

    try {
      // Check if caches are available
      final caches = session.caches;
      final globalCache = caches.global;
      
      // Try to get existing rate limit entry from cache
      RateLimitEntry? cached;
      try {
        cached = await globalCache.get<RateLimitEntry>(cacheKey);
      } catch (cacheGetError) {
        session.log(
          'Rate limit cache get error: $cacheGetError',
          level: LogLevel.debug,
        );
        // Continue with null cached value
      }
      
      RateLimitEntry entry;
      
      if (cached != null) {
        // Check if window has expired
        if (now - cached.windowStart >= windowMs) {
          // Start a new window
          entry = RateLimitEntry(count: 1, windowStart: now);
        } else {
          // Increment count in current window
          entry = RateLimitEntry(
            count: cached.count + 1,
            windowStart: cached.windowStart,
          );
        }
      } else {
        // No existing entry, create new one
        entry = RateLimitEntry(count: 1, windowStart: now);
      }

      // Check if limit exceeded
      if (entry.count > config.maxRequests) {
        final retryAfterMs = entry.windowStart + windowMs - now;
        final retryAfterSeconds = (retryAfterMs / 1000).ceil();
        final resetAt = DateTime.fromMillisecondsSinceEpoch(
          entry.windowStart + windowMs,
        );
        
        session.log(
          'Rate limit exceeded: ${config.keyPrefix}/$identifier '
          '(${entry.count}/${config.maxRequests}) - '
          'retry after ${retryAfterSeconds}s',
          level: LogLevel.warning,
        );
        
        // Throw SerializableException - properly returned to client
        throw RateLimitException(
          message: 'Rate limit exceeded. You have made ${entry.count} requests. '
              'Maximum allowed is ${config.maxRequests} per ${config.windowDuration.inSeconds} seconds. '
              'Please try again in $retryAfterSeconds seconds.',
          limit: config.maxRequests,
          remaining: 0,
          current: entry.count,
          windowSeconds: config.windowDuration.inSeconds,
          retryAfterSeconds: retryAfterSeconds > 0 ? retryAfterSeconds : 1,
          resetAt: resetAt.toIso8601String(),
        );
      }

      // Store updated entry in cache
      try {
        await globalCache.put(
          cacheKey,
          entry,
          lifetime: config.windowDuration + const Duration(seconds: 10), // Add buffer
        );
      } catch (cachePutError) {
        session.log(
          'Rate limit cache put error: $cachePutError',
          level: LogLevel.debug,
        );
        // Continue even if cache put fails
      }

      session.log(
        'Rate limit check passed: ${config.keyPrefix}/$identifier (${entry.count}/${config.maxRequests})',
        level: LogLevel.debug,
      );
    } catch (e) {
      if (e is RateLimitException) {
        rethrow;
      }
      // On cache errors, allow the request (fail open)
      session.log(
        'Rate limit cache error (allowing request): $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Get remaining requests for a key
  /// 
  /// Returns the number of requests remaining in the current window,
  /// or null if no rate limit data exists.
  static Future<int?> getRemainingRequests(
    Session session,
    RateLimitConfig config,
    String identifier,
  ) async {
    final cacheKey = _getCacheKey(config.keyPrefix, identifier);
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowMs = config.windowDuration.inMilliseconds;

    try {
      final cached = await session.caches.global.get<RateLimitEntry>(cacheKey);
      
      if (cached == null) {
        return config.maxRequests;
      }

      // Check if window has expired
      if (now - cached.windowStart >= windowMs) {
        return config.maxRequests;
      }

      final remaining = config.maxRequests - cached.count;
      return remaining > 0 ? remaining : 0;
    } catch (e) {
      return null;
    }
  }

  /// Get full rate limit info for a key
  /// 
  /// Returns detailed rate limit information for API responses.
  /// Useful for including rate limit headers/info in successful responses.
  static Future<RateLimitInfo> getRateLimitInfo(
    Session session,
    RateLimitConfig config,
    String identifier,
  ) async {
    final cacheKey = _getCacheKey(config.keyPrefix, identifier);
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowMs = config.windowDuration.inMilliseconds;

    try {
      final cached = await session.caches.global.get<RateLimitEntry>(cacheKey);
      
      if (cached == null) {
        // No active window
        return RateLimitInfo(
          limit: config.maxRequests,
          remaining: config.maxRequests,
          current: 0,
          windowSeconds: config.windowDuration.inSeconds,
        );
      }

      // Check if window has expired
      if (now - cached.windowStart >= windowMs) {
        return RateLimitInfo(
          limit: config.maxRequests,
          remaining: config.maxRequests,
          current: 0,
          windowSeconds: config.windowDuration.inSeconds,
        );
      }

      final remaining = config.maxRequests - cached.count;
      final resetAt = DateTime.fromMillisecondsSinceEpoch(
        cached.windowStart + windowMs,
      );
      final resetInSeconds = ((cached.windowStart + windowMs - now) / 1000).ceil();

      return RateLimitInfo(
        limit: config.maxRequests,
        remaining: remaining > 0 ? remaining : 0,
        current: cached.count,
        windowSeconds: config.windowDuration.inSeconds,
        resetInSeconds: resetInSeconds > 0 ? resetInSeconds : 0,
        resetAt: resetAt,
      );
    } catch (e) {
      // On error, return default info
      return RateLimitInfo(
        limit: config.maxRequests,
        remaining: config.maxRequests,
        current: 0,
        windowSeconds: config.windowDuration.inSeconds,
      );
    }
  }

  /// Reset rate limit for a specific key
  static Future<void> resetLimit(
    Session session,
    RateLimitConfig config,
    String identifier,
  ) async {
    final cacheKey = _getCacheKey(config.keyPrefix, identifier);
    
    try {
      await session.caches.global.invalidateKey(cacheKey);
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Generate cache key for rate limiting
  static String _getCacheKey(String prefix, String identifier) {
    return 'rate_limit:$prefix:$identifier';
  }
}
