import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../rate_limit/services/rate_limit_service.dart';
import '../base/middleware_base.dart';
import '../base/middleware_context.dart';

/// Middleware for automatic rate limiting
///
/// Features:
/// - Automatic rate limit checks before endpoint execution
/// - Uses existing RateLimitService for distributed limiting
/// - Per-endpoint rate limit configurations
/// - Fallback to global defaults
/// - Adds rate limit info to context for response headers
class RateLimitMiddleware extends RequestOnlyMiddleware {
  @override
  String get name => 'rate_limit';

  @override
  int get priority => 20; // After logging, before auth

  /// Global rate limit configuration
  final RateLimitConfig _defaultConfig;

  /// Per-endpoint rate limit configurations
  final Map<String, RateLimitConfig> _endpointConfigs;

  RateLimitMiddleware({
    RateLimitConfig? defaultConfig,
    Map<String, RateLimitConfig>? endpointConfigs,
  })  : _defaultConfig = defaultConfig ?? _defaultRateLimitConfig,
        _endpointConfigs = endpointConfigs ?? {};

  static final RateLimitConfig _defaultRateLimitConfig = RateLimitConfig(
    maxRequests: 100,
    windowDuration: Duration(minutes: 1),
    keyPrefix: 'global',
  );

  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    // Get rate limit config for this endpoint
    final config = _getConfigForEndpoint(context);
    
    // Get identifier for rate limiting
    final identifier = context.rateLimitIdentifier;

    try {
      // Check rate limit
      await RateLimitService.checkLimit(context.session, config, identifier);

      // Get rate limit info for response
      final info = await RateLimitService.getRateLimitInfo(
        context.session,
        config,
        identifier,
      );

      // Store rate limit info in context
      context.setMetadata('rateLimitMax', info.limit);
      context.setMetadata('rateLimitRemaining', info.remaining);
      context.setMetadata('rateLimitCurrent', info.current);
      context.setMetadata('rateLimitResetInSeconds', info.resetInSeconds);

      return MiddlewareResult.proceed(
        data: {
          'rateLimitMax': info.limit,
          'rateLimitRemaining': info.remaining,
          'rateLimitCurrent': info.current,
          'rateLimitResetInSeconds': info.resetInSeconds,
        },
      );
    } on RateLimitException catch (e) {
      // Rate limit exceeded
      context.session.log(
        'RATE LIMIT | '
        'endpoint=${context.fullPath} | '
        'identifier=$identifier | '
        'limit=${e.limit} | '
        'current=${e.current} | '
        'retryAfter=${e.retryAfterSeconds}s',
        level: LogLevel.warning,
      );

      return MiddlewareResult.reject(
        error: e,
        message: 'Rate limit exceeded: ${e.message}',
      );
    } catch (e) {
      // Log but don't fail request on rate limit service errors
      context.session.log(
        'Rate limit check failed: $e',
        level: LogLevel.error,
      );

      // Proceed anyway to avoid blocking requests
      return MiddlewareResult.proceed(
        message: 'Rate limit check skipped due to error',
      );
    }
  }

  /// Get rate limit config for an endpoint
  RateLimitConfig _getConfigForEndpoint(MiddlewareContext context) {
    // Check for endpoint-specific config
    final endpointKey = context.fullPath;
    if (_endpointConfigs.containsKey(endpointKey)) {
      return _endpointConfigs[endpointKey]!;
    }

    // Check for endpoint-level config (without method)
    if (_endpointConfigs.containsKey(context.endpointName)) {
      return _endpointConfigs[context.endpointName]!;
    }

    // Check context metadata for custom config
    final customConfig = context.getMetadata<RateLimitConfig>('customRateLimit');
    if (customConfig != null) {
      return customConfig;
    }

    // Use default
    return _defaultConfig.copyWith(
      keyPrefix: context.endpointName,
    );
  }

  /// Register a rate limit config for an endpoint
  void registerEndpointConfig(String endpoint, RateLimitConfig config) {
    _endpointConfigs[endpoint] = config;
  }

  /// Remove rate limit config for an endpoint
  void removeEndpointConfig(String endpoint) {
    _endpointConfigs.remove(endpoint);
  }
}

/// Extension to add copyWith to RateLimitConfig
extension RateLimitConfigCopyWith on RateLimitConfig {
  RateLimitConfig copyWith({
    int? maxRequests,
    Duration? windowDuration,
    String? keyPrefix,
  }) {
    return RateLimitConfig(
      maxRequests: maxRequests ?? this.maxRequests,
      windowDuration: windowDuration ?? this.windowDuration,
      keyPrefix: keyPrefix ?? this.keyPrefix,
    );
  }
}
