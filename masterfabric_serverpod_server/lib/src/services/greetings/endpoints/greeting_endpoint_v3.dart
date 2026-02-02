import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';

/// Example endpoint demonstrating RBAC (Role-Based Access Control) integration.
///
/// This endpoint showcases how to use the [RbacEndpointMixin] to define
/// role and permission requirements at both endpoint and method levels.
///
/// ## Key Features:
/// - Endpoint-level role requirements (applied to all methods)
/// - Method-specific role requirements (override/add to endpoint roles)
/// - Permission-based access control
/// - Public methods that bypass authentication
/// - Admin-only methods
///
/// ## Usage from client:
/// ```dart
/// // Regular user greeting (requires 'user' role)
/// final response = await client.greetingV3.hello('World');
///
/// // Admin-only greeting (requires 'admin' role)
/// final adminResponse = await client.greetingV3.adminHello('Admin');
///
/// // Public greeting (no authentication required)
/// final publicResponse = await client.greetingV3.publicHello('Guest');
/// ```
///
/// ## Role Requirements:
/// - `publicHello`: No auth required (public)
/// - `hello`: Requires 'user' role
/// - `goodbye`: Requires 'user' role
/// - `adminHello`: Requires 'user' OR 'admin' role
/// - `moderatorHello`: Requires 'moderator' OR 'admin' role
/// - `deleteGreeting`: Requires 'user' AND 'admin' (both!)
/// - `strictHello`: Requires 'user' role + 5 req/min limit
class GreetingV3Endpoint extends MasterfabricEndpoint with RbacEndpointMixin {
  /// Endpoint-level role requirements.
  ///
  /// Base methods (hello, goodbye, strictHello) require 'user' role.
  /// Methods with specific requirements override this in [methodRoles].
  @override
  List<String> get requiredRoles => ['user'];

  /// Method-specific role requirements.
  ///
  /// These roles REPLACE the endpoint-level roles for specific methods.
  /// - adminHello: 'user' OR 'admin' (either grants access)
  /// - moderatorHello: 'moderator' OR 'admin' (either grants access)
  /// - deleteGreeting: 'user' AND 'admin' (both required, see methodRequireAllRoles)
  @override
  Map<String, List<String>> get methodRoles => {
        'adminHello': ['user', 'admin'], // Either user OR admin
        'moderatorHello': ['moderator', 'admin'], // Either moderator OR admin
        'deleteGreeting': ['user', 'admin'], // Both user AND admin (requireAll)
      };

  /// Method-specific "require all" flags for roles.
  ///
  /// By default (false), user needs at least ONE of the specified roles.
  /// Set to true to require ALL specified roles.
  @override
  Map<String, bool> get methodRequireAllRoles => {
        'adminHello': false, // User needs 'user' OR 'admin'
        'moderatorHello': false, // User needs 'moderator' OR 'admin'
        'deleteGreeting': true, // User needs 'user' AND 'admin' (must have BOTH)
      };

  /// Cache TTL for greetings
  static const Duration _cacheTtl = Duration(minutes: 5);

  // ============================================================
  // USER-LEVEL METHODS (require 'user' role)
  // ============================================================

  /// Returns a personalized greeting message: "Hello {name}".
  ///
  /// **Required Roles:** 'user'
  ///
  /// This method demonstrates the basic RBAC pattern where
  /// only authenticated users with the 'user' role can access it.
  Future<GreetingResponse> hello(Session session, String name) async {
    return executeWithRbac(
      session: session,
      methodName: 'hello',
      parameters: {'name': name},
      handler: () async {
        final now = DateTime.now();

        final greeting = Greeting(
          message: 'Hello $name',
          author: 'Serverpod (v3 RBAC)',
          timestamp: now,
        );

        // Cache the greeting
        final cacheKey = 'greeting_v3:$name';
        await session.caches.local.put(
          cacheKey,
          greeting,
          lifetime: _cacheTtl,
        );

        return GreetingResponse(
          message: greeting.message,
          author: greeting.author,
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

  /// Returns a farewell message: "Goodbye {name}".
  ///
  /// **Required Roles:** 'user'
  Future<GreetingResponse> goodbye(Session session, String name) async {
    return executeWithRbac(
      session: session,
      methodName: 'goodbye',
      parameters: {'name': name},
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Goodbye $name',
          author: 'Serverpod (v3 RBAC)',
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

  // ============================================================
  // ADMIN-LEVEL METHODS (require 'admin' or elevated roles)
  // ============================================================

  /// Admin greeting with special privileges.
  ///
  /// **Required Roles:** 'user' OR 'admin' (either role grants access)
  ///
  /// This demonstrates the OR pattern where having ANY of the
  /// specified roles grants access to the method.
  Future<GreetingResponse> adminHello(Session session, String name) async {
    return executeWithRbac(
      session: session,
      methodName: 'adminHello',
      parameters: {'name': name},
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Admin Hello $name! You have elevated privileges.',
          author: 'Serverpod Admin (v3 RBAC)',
          timestamp: now,
          rateLimitMax: 100,
          rateLimitRemaining: 99,
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }

  /// Delete a greeting (requires both 'user' AND 'admin' roles).
  ///
  /// **Required Roles:** 'user' AND 'admin' (both roles required)
  ///
  /// This demonstrates the requireAllRoles=true pattern where
  /// the user must have ALL specified roles.
  Future<bool> deleteGreeting(Session session, String greetingId) async {
    return executeWithRbac(
      session: session,
      methodName: 'deleteGreeting',
      parameters: {'greetingId': greetingId},
      handler: () async {
        // In a real implementation, you would delete from database
        session.log(
          'Greeting deleted: $greetingId by user ${session.authenticated?.userIdentifier}',
          level: LogLevel.info,
        );
        return true;
      },
    );
  }

  // ============================================================
  // MODERATOR-LEVEL METHODS (require 'moderator' or 'admin' role)
  // ============================================================

  /// Moderator greeting with moderation privileges.
  ///
  /// **Required Roles:** 'moderator' OR 'admin' (either role grants access)
  ///
  /// Demonstrates allowing multiple roles where having ANY one is sufficient.
  Future<GreetingResponse> moderatorHello(Session session, String name) async {
    return executeWithRbac(
      session: session,
      methodName: 'moderatorHello',
      parameters: {'name': name},
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Moderator Hello $name! You have moderation privileges.',
          author: 'Serverpod Moderator (v3 RBAC)',
          timestamp: now,
          rateLimitMax: 50,
          rateLimitRemaining: 49,
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }

  // ============================================================
  // PUBLIC METHODS (no authentication required)
  // ============================================================

  /// Public greeting that doesn't require authentication.
  ///
  /// **Required Roles:** None (public endpoint)
  ///
  /// This demonstrates how to bypass authentication for specific methods
  /// using the [skipAuth] configuration.
  Future<GreetingResponse> publicHello(Session session, String name) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'publicHello',
      parameters: {'name': name},
      config: const EndpointMiddlewareConfig(
        skipAuth: true, // Skip authentication for this method
      ),
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Public Hello $name! (No auth required)',
          author: 'Serverpod Public (v3 RBAC)',
          timestamp: now,
          rateLimitMax: 10,
          rateLimitRemaining: 9,
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }

  // ============================================================
  // RATE-LIMITED METHODS (custom rate limits)
  // ============================================================

  /// Greeting with strict rate limiting.
  ///
  /// **Required Roles:** 'user'
  /// **Rate Limit:** 5 requests per minute
  ///
  /// Demonstrates combining RBAC with custom rate limiting.
  Future<GreetingResponse> strictHello(Session session, String name) async {
    return executeWithRbac(
      session: session,
      methodName: 'strictHello',
      parameters: {'name': name},
      additionalConfig: EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 5,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'greeting_v3_strict',
        ),
      ),
      handler: () async {
        final now = DateTime.now();
        return GreetingResponse(
          message: 'Strict Hello $name (rate limited)',
          author: 'Serverpod (v3 RBAC)',
          timestamp: now,
          rateLimitMax: 5,
          rateLimitRemaining: 4,
          rateLimitCurrent: 1,
          rateLimitWindowSeconds: 60,
          rateLimitResetInSeconds: 60,
        );
      },
    );
  }
}
