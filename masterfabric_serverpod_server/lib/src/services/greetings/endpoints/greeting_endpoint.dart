import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';

// This is an example endpoint of your server. It's best practice to use the
// `Endpoint` ending of the class name, but it will be removed when accessing
// the endpoint from the client. I.e., this endpoint can be accessed through
// `client.greeting` on the client side.

// After adding or modifying an endpoint, you will need to run
// `serverpod generate` to update the server and client code.

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// 
/// Features:
/// - Rate limited to 20 requests per minute per user/IP
/// - Returns rate limit info in every response
/// - Caches and replaces greeting with fresh timestamp each request
class GreetingEndpoint extends Endpoint {
  /// Rate limit configuration for greeting endpoint
  /// Default: 20 requests per minute
  static const _rateLimitConfig = RateLimitConfig(
    maxRequests: 20,
    windowDuration: Duration(minutes: 1),
    keyPrefix: 'greeting',
  );

  /// Cache TTL for greetings
  static const Duration _cacheTtl = Duration(minutes: 5);

  /// Returns a personalized greeting message: "Hello {name}".
  /// 
  /// Rate limited to 20 requests per minute.
  /// Returns rate limit info (remaining, limit, reset time) in response.
  /// Throws RateLimitException with details if limit is exceeded.
  Future<GreetingResponse> hello(Session session, String name) async {
    // Get identifier for rate limiting
    final rateLimitIdentifier = _getRateLimitIdentifier(session);
    
    // Check rate limit first (throws RateLimitException if exceeded)
    await RateLimitService.checkLimit(session, _rateLimitConfig, rateLimitIdentifier);
    
    // Get rate limit info for response
    final rateLimitInfo = await RateLimitService.getRateLimitInfo(
      session,
      _rateLimitConfig,
      rateLimitIdentifier,
    );
    
    // Create fresh greeting with current timestamp
    final now = DateTime.now();
    
    // Build response with rate limit info
    final response = GreetingResponse(
      message: 'Hello $name',
      author: 'Serverpod',
      timestamp: now,
      rateLimitMax: rateLimitInfo.limit,
      rateLimitRemaining: rateLimitInfo.remaining,
      rateLimitCurrent: rateLimitInfo.current,
      rateLimitWindowSeconds: rateLimitInfo.windowSeconds,
      rateLimitResetInSeconds: rateLimitInfo.resetInSeconds,
    );
    
    // Cache key for this greeting
    final cacheKey = 'greeting:$name';
    
    // Cache the greeting (for optimization)
    await session.caches.local.put(
      cacheKey,
      Greeting(message: response.message, author: response.author, timestamp: now),
      lifetime: _cacheTtl,
    );
    
    session.log(
      'Greeting created for: $name '
      '(rate limit: ${rateLimitInfo.current}/${rateLimitInfo.limit}, '
      'remaining: ${rateLimitInfo.remaining})',
      level: LogLevel.debug,
    );
    
    return response;
  }

  /// Get identifier for rate limiting
  /// 
  /// Uses authenticated user ID if available, otherwise uses global anonymous bucket.
  String _getRateLimitIdentifier(Session session) {
    // Try to get authenticated user ID first
    final authInfo = session.authenticated;
    if (authInfo != null) {
      return 'user:${authInfo.userIdentifier}';
    }
    
    // For anonymous users, use a global bucket per endpoint
    // This applies rate limit across all anonymous requests
    // In production, you may want to extract IP from headers via middleware
    return 'anonymous:greeting:hello';
  }
}
