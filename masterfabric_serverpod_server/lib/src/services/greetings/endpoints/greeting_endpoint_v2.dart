import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';

/// Example endpoint using the MasterFabric middleware system.
///
/// This demonstrates how to use the new middleware-based approach
/// instead of manual rate limiting and logging calls.
///
/// Key differences from the original GreetingEndpoint:
/// - Extends [MasterfabricEndpoint] instead of [Endpoint]
/// - Uses [executeWithMiddleware] to wrap method logic
/// - Rate limiting, logging, auth, and metrics are handled automatically
/// - Can customize middleware behavior via [middlewareConfig]
///
/// Usage from client:
/// ```dart
/// final response = await client.greetingV2.hello('World');
/// ```
class GreetingV2Endpoint extends MasterfabricEndpoint {
  /// Middleware configuration for this endpoint.
  ///
  /// - Custom rate limit: 20 requests per minute
  /// - All other middleware uses defaults (logging, metrics, error handling)
  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 20,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'greeting_v2',
        ),
      );

  /// Cache TTL for greetings
  static const Duration _cacheTtl = Duration(minutes: 5);

  /// Returns a personalized greeting message: "Hello {name}".
  ///
  /// Middleware automatically handles:
  /// - Rate limiting (20 requests/minute)
  /// - Request/response logging
  /// - Metrics collection
  /// - Error handling
  Future<GreetingResponse> hello(Session session, String name) async {
    // Wrap the business logic with middleware
    return executeWithMiddleware(
      session: session,
      methodName: 'hello',
      parameters: {'name': name},
      handler: () async {
        // Your business logic here - clean and simple!
        final now = DateTime.now();

        // Create fresh greeting
        final greeting = Greeting(
          message: 'Hello $name',
          author: 'Serverpod (v2)',
          timestamp: now,
        );

        // Cache the greeting
        final cacheKey = 'greeting_v2:$name';
        await session.caches.local.put(
          cacheKey,
          greeting,
          lifetime: _cacheTtl,
        );

        // Build response
        // Note: Rate limit info is available via context metadata
        // if you need it, but middleware handles the checks
        return GreetingResponse(
          message: greeting.message,
          author: greeting.author,
          timestamp: now,
          rateLimitMax: 20,
          rateLimitRemaining: 19, // In practice, get from context
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }

  /// Example of a public method (no authentication required).
  ///
  /// Uses per-method configuration to skip auth middleware.
  Future<GreetingResponse> helloPublic(Session session, String name) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'helloPublic',
      parameters: {'name': name},
      // Override middleware config for this specific method
      config: const EndpointMiddlewareConfig(
        skipAuth: true, // This method doesn't require authentication
      ),
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Hello $name (public)',
          author: 'Serverpod',
          timestamp: now,
          rateLimitMax: 20,
          rateLimitRemaining: 19,
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }

  /// Example of a method with strict rate limiting.
  ///
  /// Uses per-method configuration for stricter limits.
  Future<GreetingResponse> helloStrict(Session session, String name) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'helloStrict',
      parameters: {'name': name},
      config: EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 5, // Only 5 requests per minute
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'greeting_v2_strict',
        ),
      ),
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Hello $name (strict)',
          author: 'Serverpod',
          timestamp: now,
          rateLimitMax: 7,
          rateLimitRemaining: 4,
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }
}
