# Create Server Endpoint

Create a new MasterFabric Serverpod endpoint using the middleware (V2) or RBAC (V3) pattern.

## Usage

```
/create-server-endpoint <endpoint_name> [options]
```

## Arguments

- `endpoint_name` - Name of the endpoint in snake_case (e.g., `user_profile`, `payment`, `order`)

## Options

- `--v2` - Use middleware pattern (default) - rate limiting, logging, auth skip
- `--v3` - Use RBAC pattern - role-based access control with middleware
- `--service <name>` - Create in existing service folder (default: creates new service folder)
- `--public` - Include a public method (no auth required)
- `--admin` - Include admin-only method (V3 only)

## Pattern Comparison

| Feature | V2 (Middleware) | V3 (RBAC) |
|---------|-----------------|-----------|
| Base Class | `MasterfabricEndpoint` | `MasterfabricEndpoint with RbacEndpointMixin` |
| Execute Method | `executeWithMiddleware()` | `executeWithRbac()` |
| Rate Limiting | `customRateLimit` in config | `additionalConfig` parameter |
| Auth Skip | `config: EndpointMiddlewareConfig(skipAuth: true)` | Same (use `executeWithMiddleware`) |
| Role-based | Not available | `requiredRoles`, `methodRoles`, `methodRequireAllRoles` |

## V2 Pattern (Middleware) - Default

Best for: Simple endpoints with rate limiting, logging, and optional auth.

### Structure Created

```
masterfabric_serverpod_server/lib/src/services/<endpoint_name>/
├── endpoints/
│   └── <endpoint_name>_endpoint.dart
└── models/
    └── <endpoint_name>_response.spy.yaml
```

### Endpoint Template (V2)

**File:** `endpoints/<endpoint_name>_endpoint.dart`

```dart
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';

/// <EndpointName> endpoint using the MasterFabric middleware system.
///
/// Features:
/// - Automatic rate limiting (configurable)
/// - Request/response logging
/// - Error handling
/// - Metrics collection
///
/// Usage from client:
/// ```dart
/// final response = await client.<endpointName>.get('param');
/// ```
class <EndpointName>Endpoint extends MasterfabricEndpoint {
  /// Middleware configuration for this endpoint.
  ///
  /// - Custom rate limit: 60 requests per minute
  /// - All other middleware uses defaults
  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: '<endpoint_name>',
        ),
      );

  /// Cache TTL for responses
  static const Duration _cacheTtl = Duration(minutes: 5);

  // ============================================================
  // STANDARD METHODS (with default middleware)
  // ============================================================

  /// Get <endpoint_name> by parameter.
  ///
  /// Middleware automatically handles:
  /// - Rate limiting (60 requests/minute)
  /// - Request/response logging
  /// - Metrics collection
  /// - Error handling
  Future<<EndpointName>Response> get(Session session, String param) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'get',
      parameters: {'param': param},
      handler: () async {
        final now = DateTime.now();

        // TODO: Implement your business logic here

        // Example: Cache the result
        final cacheKey = '<endpoint_name>:$param';
        // await session.caches.local.put(cacheKey, result, lifetime: _cacheTtl);

        return <EndpointName>Response(
          success: true,
          message: 'Success',
          timestamp: now,
          data: 'Result for $param',
        );
      },
    );
  }

  /// Create a new <endpoint_name> resource.
  Future<<EndpointName>Response> create(
    Session session,
    String name,
    String? description,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'create',
      parameters: {'name': name, 'description': description},
      handler: () async {
        final now = DateTime.now();

        // TODO: Implement create logic

        return <EndpointName>Response(
          success: true,
          message: 'Created successfully',
          timestamp: now,
          data: name,
        );
      },
    );
  }

  // ============================================================
  // PUBLIC METHODS (no authentication required)
  // ============================================================

  /// Public method that doesn't require authentication.
  ///
  /// Uses per-method configuration to skip auth middleware.
  Future<<EndpointName>Response> getPublic(Session session, String param) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getPublic',
      parameters: {'param': param},
      config: const EndpointMiddlewareConfig(
        skipAuth: true, // This method doesn't require authentication
      ),
      handler: () async {
        final now = DateTime.now();
        return <EndpointName>Response(
          success: true,
          message: 'Public response',
          timestamp: now,
          data: 'Public result for $param',
        );
      },
    );
  }

  // ============================================================
  // RATE-LIMITED METHODS (strict limits)
  // ============================================================

  /// Method with strict rate limiting (5 requests/minute).
  Future<<EndpointName>Response> getStrict(Session session, String param) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getStrict',
      parameters: {'param': param},
      config: EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 5, // Only 5 requests per minute
          windowDuration: Duration(minutes: 1),
          keyPrefix: '<endpoint_name>_strict',
        ),
      ),
      handler: () async {
        final now = DateTime.now();
        return <EndpointName>Response(
          success: true,
          message: 'Strict rate limited response',
          timestamp: now,
          data: 'Strict result for $param',
        );
      },
    );
  }
}
```

---

## V3 Pattern (RBAC) - Role-Based Access Control

Best for: Endpoints requiring role-based permissions (user, admin, moderator, etc.)

### Structure Created

```
masterfabric_serverpod_server/lib/src/services/<endpoint_name>/
├── endpoints/
│   └── <endpoint_name>_endpoint.dart
└── models/
    └── <endpoint_name>_response.spy.yaml
```

### Endpoint Template (V3)

**File:** `endpoints/<endpoint_name>_endpoint.dart`

```dart
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';

/// <EndpointName> endpoint with RBAC (Role-Based Access Control).
///
/// ## Role Requirements:
/// - `getPublic`: No auth required (public)
/// - `get`: Requires 'user' role
/// - `create`: Requires 'user' role
/// - `adminGet`: Requires 'user' OR 'admin' role
/// - `moderatorGet`: Requires 'moderator' OR 'admin' role
/// - `delete`: Requires 'user' AND 'admin' (both!)
///
/// Usage from client:
/// ```dart
/// // User method (requires 'user' role)
/// final response = await client.<endpointName>.get('param');
///
/// // Admin method (requires 'admin' role)
/// final adminResponse = await client.<endpointName>.adminGet('param');
///
/// // Public method (no auth required)
/// final publicResponse = await client.<endpointName>.getPublic('param');
/// ```
class <EndpointName>Endpoint extends MasterfabricEndpoint with RbacEndpointMixin {
  /// Endpoint-level role requirements.
  ///
  /// Base methods require 'user' role by default.
  /// Methods with specific requirements override this in [methodRoles].
  @override
  List<String> get requiredRoles => ['user'];

  /// Method-specific role requirements.
  ///
  /// These roles REPLACE the endpoint-level roles for specific methods.
  @override
  Map<String, List<String>> get methodRoles => {
        'adminGet': ['user', 'admin'], // Either user OR admin
        'moderatorGet': ['moderator', 'admin'], // Either moderator OR admin
        'delete': ['user', 'admin'], // Both required (see methodRequireAllRoles)
      };

  /// Method-specific "require all" flags for roles.
  ///
  /// By default (false), user needs at least ONE of the specified roles.
  /// Set to true to require ALL specified roles.
  @override
  Map<String, bool> get methodRequireAllRoles => {
        'adminGet': false, // User needs 'user' OR 'admin'
        'moderatorGet': false, // User needs 'moderator' OR 'admin'
        'delete': true, // User needs 'user' AND 'admin' (must have BOTH)
      };

  /// Cache TTL for responses
  static const Duration _cacheTtl = Duration(minutes: 5);

  // ============================================================
  // USER-LEVEL METHODS (require 'user' role)
  // ============================================================

  /// Get <endpoint_name> by parameter.
  ///
  /// **Required Roles:** 'user'
  Future<<EndpointName>Response> get(Session session, String param) async {
    return executeWithRbac(
      session: session,
      methodName: 'get',
      parameters: {'param': param},
      handler: () async {
        final now = DateTime.now();

        // TODO: Implement your business logic here

        return <EndpointName>Response(
          success: true,
          message: 'Success',
          timestamp: now,
          data: 'Result for $param',
        );
      },
    );
  }

  /// Create a new <endpoint_name> resource.
  ///
  /// **Required Roles:** 'user'
  Future<<EndpointName>Response> create(
    Session session,
    String name,
    String? description,
  ) async {
    return executeWithRbac(
      session: session,
      methodName: 'create',
      parameters: {'name': name, 'description': description},
      handler: () async {
        final now = DateTime.now();

        // TODO: Implement create logic

        return <EndpointName>Response(
          success: true,
          message: 'Created successfully',
          timestamp: now,
          data: name,
        );
      },
    );
  }

  // ============================================================
  // ADMIN-LEVEL METHODS (require 'admin' or elevated roles)
  // ============================================================

  /// Admin method with special privileges.
  ///
  /// **Required Roles:** 'user' OR 'admin' (either role grants access)
  Future<<EndpointName>Response> adminGet(Session session, String param) async {
    return executeWithRbac(
      session: session,
      methodName: 'adminGet',
      parameters: {'param': param},
      handler: () async {
        final now = DateTime.now();
        return <EndpointName>Response(
          success: true,
          message: 'Admin response - elevated privileges',
          timestamp: now,
          data: 'Admin result for $param',
        );
      },
    );
  }

  /// Delete resource (requires both 'user' AND 'admin' roles).
  ///
  /// **Required Roles:** 'user' AND 'admin' (both roles required)
  Future<bool> delete(Session session, String id) async {
    return executeWithRbac(
      session: session,
      methodName: 'delete',
      parameters: {'id': id},
      handler: () async {
        // TODO: Implement delete logic
        session.log(
          'Resource deleted: $id by user ${session.authenticated?.userIdentifier}',
          level: LogLevel.info,
        );
        return true;
      },
    );
  }

  // ============================================================
  // MODERATOR-LEVEL METHODS (require 'moderator' or 'admin' role)
  // ============================================================

  /// Moderator method with moderation privileges.
  ///
  /// **Required Roles:** 'moderator' OR 'admin' (either role grants access)
  Future<<EndpointName>Response> moderatorGet(Session session, String param) async {
    return executeWithRbac(
      session: session,
      methodName: 'moderatorGet',
      parameters: {'param': param},
      handler: () async {
        final now = DateTime.now();
        return <EndpointName>Response(
          success: true,
          message: 'Moderator response - moderation privileges',
          timestamp: now,
          data: 'Moderator result for $param',
        );
      },
    );
  }

  // ============================================================
  // PUBLIC METHODS (no authentication required)
  // ============================================================

  /// Public method that doesn't require authentication.
  ///
  /// **Required Roles:** None (public endpoint)
  ///
  /// Note: Uses executeWithMiddleware, not executeWithRbac.
  Future<<EndpointName>Response> getPublic(Session session, String param) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getPublic',
      parameters: {'param': param},
      config: const EndpointMiddlewareConfig(
        skipAuth: true, // Skip authentication for this method
      ),
      handler: () async {
        final now = DateTime.now();
        return <EndpointName>Response(
          success: true,
          message: 'Public response (no auth required)',
          timestamp: now,
          data: 'Public result for $param',
        );
      },
    );
  }

  // ============================================================
  // RATE-LIMITED METHODS (RBAC + custom rate limits)
  // ============================================================

  /// Method with strict rate limiting (5 requests/minute).
  ///
  /// **Required Roles:** 'user'
  /// **Rate Limit:** 5 requests per minute
  Future<<EndpointName>Response> getStrict(Session session, String param) async {
    return executeWithRbac(
      session: session,
      methodName: 'getStrict',
      parameters: {'param': param},
      additionalConfig: EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 5,
          windowDuration: Duration(minutes: 1),
          keyPrefix: '<endpoint_name>_strict',
        ),
      ),
      handler: () async {
        final now = DateTime.now();
        return <EndpointName>Response(
          success: true,
          message: 'Strict rate limited response',
          timestamp: now,
          data: 'Strict result for $param',
        );
      },
    );
  }
}
```

---

## Response Model Template

**File:** `models/<endpoint_name>_response.spy.yaml`

```yaml
### <EndpointName> response model
class: <EndpointName>Response
fields:
  success: bool
  message: String
  timestamp: DateTime
  data: String?
```

---

## Instructions

### Step 1: Create Directory Structure

```bash
mkdir -p masterfabric_serverpod_server/lib/src/services/<endpoint_name>/{endpoints,models}
```

### Step 2: Create Endpoint File

Choose V2 or V3 pattern based on your needs and create the endpoint file.

### Step 3: Create Response Model

Create the `.spy.yaml` model file with your response fields.

### Step 4: Generate Code

```bash
cd masterfabric_serverpod_server && serverpod generate
```

### Step 5: Verify Generation

Check that `lib/src/generated/endpoints.dart` includes your new endpoint.

---

## Examples

### Create V2 Endpoint (Middleware)

```
/create-server-endpoint user_profile --v2
```

Creates a user_profile endpoint with:
- Rate limiting (60 req/min default)
- Standard `get`, `create` methods
- Public method (no auth)
- Strict rate limited method

### Create V3 Endpoint (RBAC)

```
/create-server-endpoint order --v3
```

Creates an order endpoint with:
- Role-based access control
- User methods (require 'user' role)
- Admin methods (require 'admin' role)
- Moderator methods (require 'moderator' role)
- Public method (no auth)
- Delete with dual-role requirement

### Create in Existing Service

```
/create-server-endpoint payment_refund --v3 --service payment
```

Creates endpoint in `services/payment/endpoints/payment_refund_endpoint.dart`.

---

## Available Middleware Options

```dart
EndpointMiddlewareConfig(
  skipLogging: false,      // Skip request logging
  skipRateLimit: false,    // Skip rate limiting
  skipAuth: false,         // Skip authentication
  skipValidation: false,   // Skip validation
  skipMetrics: false,      // Skip metrics collection
  customRateLimit: null,   // Custom rate limit config
  requiredPermissions: [], // Required RBAC permissions
  requiredRoles: [],       // Required user roles
  validationRules: {},     // Custom validation rules
);
```

---

## Checklist

- [ ] Create directory structure (`endpoints/`, `models/`)
- [ ] Create endpoint file (V2 or V3 pattern)
- [ ] Create response model `.spy.yaml`
- [ ] Run `serverpod generate`
- [ ] Verify endpoint appears in `generated/endpoints.dart`
- [ ] Test endpoint with Flutter client or curl
- [ ] Add unit/integration tests if needed

---

## Quick Reference

### V2 Method Patterns

```dart
// Standard method
Future<Response> method(Session session, String param) async {
  return executeWithMiddleware(
    session: session,
    methodName: 'method',
    parameters: {'param': param},
    handler: () async { /* logic */ },
  );
}

// Public method (no auth)
Future<Response> publicMethod(Session session) async {
  return executeWithMiddleware(
    session: session,
    methodName: 'publicMethod',
    parameters: {},
    config: const EndpointMiddlewareConfig(skipAuth: true),
    handler: () async { /* logic */ },
  );
}

// Strict rate limit
Future<Response> strictMethod(Session session) async {
  return executeWithMiddleware(
    session: session,
    methodName: 'strictMethod',
    parameters: {},
    config: EndpointMiddlewareConfig(
      customRateLimit: RateLimitConfig(maxRequests: 5, ...),
    ),
    handler: () async { /* logic */ },
  );
}
```

### V3 Method Patterns

```dart
// User-level method (uses endpoint default roles)
Future<Response> userMethod(Session session) async {
  return executeWithRbac(
    session: session,
    methodName: 'userMethod',
    parameters: {},
    handler: () async { /* logic */ },
  );
}

// Admin method (uses methodRoles override)
Future<Response> adminMethod(Session session) async {
  return executeWithRbac(
    session: session,
    methodName: 'adminMethod',
    parameters: {},
    handler: () async { /* logic */ },
  );
}

// Public method (bypass RBAC)
Future<Response> publicMethod(Session session) async {
  return executeWithMiddleware(  // Note: executeWithMiddleware, not executeWithRbac
    session: session,
    methodName: 'publicMethod',
    parameters: {},
    config: const EndpointMiddlewareConfig(skipAuth: true),
    handler: () async { /* logic */ },
  );
}

// RBAC + Custom Rate Limit
Future<Response> limitedMethod(Session session) async {
  return executeWithRbac(
    session: session,
    methodName: 'limitedMethod',
    parameters: {},
    additionalConfig: EndpointMiddlewareConfig(
      customRateLimit: RateLimitConfig(maxRequests: 5, ...),
    ),
    handler: () async { /* logic */ },
  );
}
```
