import 'package:serverpod/serverpod.dart';

import 'middleware_config.dart';
import '../services/endpoint_middleware_resolver.dart';

/// Base class for MasterFabric endpoints with built-in middleware support
///
/// Extend this class instead of [Endpoint] to automatically get
/// middleware execution for all methods.
///
/// Example:
/// ```dart
/// class PaymentEndpoint extends MasterfabricEndpoint {
///   @override
///   EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
///     requiredPermissions: ['payment:read'],
///     customRateLimit: RateLimitConfig(maxRequests: 10, windowDuration: Duration(minutes: 1)),
///   );
///
///   Future<PaymentResponse> process(Session session, PaymentRequest request) async {
///     return executeWithMiddleware(
///       session: session,
///       methodName: 'process',
///       parameters: {'request': request.toJson()},
///       handler: () async {
///         // Your business logic here
///         return PaymentResponse(success: true);
///       },
///     );
///   }
/// }
/// ```
abstract class MasterfabricEndpoint extends Endpoint {
  /// Middleware configuration for this endpoint
  ///
  /// Override to customize middleware behavior for all methods in this endpoint.
  /// Return null to use default configuration.
  EndpointMiddlewareConfig? get middlewareConfig => null;

  /// Get the endpoint name (derived from class name)
  String get endpointName {
    final name = runtimeType.toString();
    // Convert PascalCase to snake_case and remove 'Endpoint' suffix
    final withoutEndpoint = name.endsWith('Endpoint')
        ? name.substring(0, name.length - 8)
        : name;
    return _toSnakeCase(withoutEndpoint);
  }

  /// Execute a handler with middleware
  ///
  /// Wrap your endpoint method logic with this to get automatic
  /// middleware execution (logging, rate limiting, auth, etc.)
  ///
  /// [session] - The Serverpod session
  /// [methodName] - Name of the method being called
  /// [parameters] - Request parameters (for logging/validation)
  /// [handler] - The actual business logic to execute
  /// [config] - Optional per-method middleware config override
  Future<T> executeWithMiddleware<T>({
    required Session session,
    required String methodName,
    Map<String, dynamic>? parameters,
    required Future<T> Function() handler,
    EndpointMiddlewareConfig? config,
  }) async {
    // Merge configs: method config > endpoint config > global defaults
    final effectiveConfig = _mergeConfigs(config, middlewareConfig);

    return middlewareResolver.execute<T>(
      session: session,
      endpoint: endpointName,
      method: methodName,
      parameters: parameters,
      handler: handler,
      config: effectiveConfig,
    );
  }

  /// Execute without middleware (for internal calls)
  ///
  /// Use this when you need to bypass middleware for internal operations.
  Future<T> executeRaw<T>(Future<T> Function() handler) async {
    return await handler();
  }

  /// Merge method config with endpoint config
  ///
  /// Method config takes precedence over endpoint config for single-value fields.
  /// Lists (roles, permissions) are merged together.
  EndpointMiddlewareConfig? _mergeConfigs(
    EndpointMiddlewareConfig? methodConfig,
    EndpointMiddlewareConfig? endpointConfig,
  ) {
    if (methodConfig == null && endpointConfig == null) {
      return null;
    }

    if (methodConfig == null) {
      return endpointConfig;
    }

    if (endpointConfig == null) {
      return methodConfig;
    }

    // Merge: method config takes precedence for single values
    // Lists are combined (endpoint + method)
    return EndpointMiddlewareConfig(
      skipLogging: methodConfig.skipLogging || endpointConfig.skipLogging,
      skipRateLimit: methodConfig.skipRateLimit || endpointConfig.skipRateLimit,
      skipAuth: methodConfig.skipAuth || endpointConfig.skipAuth,
      skipValidation:
          methodConfig.skipValidation || endpointConfig.skipValidation,
      skipMetrics: methodConfig.skipMetrics || endpointConfig.skipMetrics,
      customRateLimit:
          methodConfig.customRateLimit ?? endpointConfig.customRateLimit,
      requiredPermissions: [
        ...endpointConfig.requiredPermissions,
        ...methodConfig.requiredPermissions,
      ],
      requiredRoles: [
        ...endpointConfig.requiredRoles,
        ...methodConfig.requiredRoles,
      ],
      // Method config overrides endpoint config for requireAll flags
      requireAllRoles:
          methodConfig.requiredRoles.isNotEmpty
              ? methodConfig.requireAllRoles
              : endpointConfig.requireAllRoles,
      requireAllPermissions:
          methodConfig.requiredPermissions.isNotEmpty
              ? methodConfig.requireAllPermissions
              : endpointConfig.requireAllPermissions,
      customAuthorizerId:
          methodConfig.customAuthorizerId ?? endpointConfig.customAuthorizerId,
      logLevel: methodConfig.logLevel ?? endpointConfig.logLevel,
      additionalMaskedFields: [
        ...endpointConfig.additionalMaskedFields,
        ...methodConfig.additionalMaskedFields,
      ],
      validationRules: {
        ...?endpointConfig.validationRules,
        ...?methodConfig.validationRules,
      },
      metadata: {
        ...endpointConfig.metadata,
        ...methodConfig.metadata,
      },
    );
  }

  /// Convert PascalCase to snake_case
  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst('_', '');
  }
}

/// Mixin for endpoints that need custom middleware configuration per method
mixin MethodMiddlewareConfigMixin on MasterfabricEndpoint {
  /// Get middleware config for a specific method
  ///
  /// Override to provide method-specific configurations.
  EndpointMiddlewareConfig? getMethodConfig(String methodName) => null;

  /// Execute with method-specific config
  Future<T> executeMethod<T>({
    required Session session,
    required String methodName,
    Map<String, dynamic>? parameters,
    required Future<T> Function() handler,
  }) {
    return executeWithMiddleware<T>(
      session: session,
      methodName: methodName,
      parameters: parameters,
      handler: handler,
      config: getMethodConfig(methodName),
    );
  }
}

/// Mixin for public endpoints (no authentication required)
mixin PublicEndpointMixin on MasterfabricEndpoint {
  @override
  EndpointMiddlewareConfig? get middlewareConfig =>
      EndpointMiddlewareConfig.publicEndpoint;
}

/// Mixin for admin-only endpoints
mixin AdminEndpointMixin on MasterfabricEndpoint {
  @override
  bool get requireLogin => true;

  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
        requiredRoles: ['admin'],
      );
}

/// Mixin for rate-limited endpoints with custom limits
mixin RateLimitedEndpointMixin on MasterfabricEndpoint {
  /// Override to set custom rate limit
  int get maxRequestsPerMinute => 60;

  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
        customRateLimit: _createRateLimitConfig(),
      );

  dynamic _createRateLimitConfig() {
    // Returns a RateLimitConfig - import would be needed
    return null; // Override in implementation
  }
}

/// Mixin for RBAC-enabled endpoints
///
/// Provides a declarative way to define role and permission requirements
/// at both endpoint and method levels.
///
/// Example:
/// ```dart
/// class UserManagementEndpoint extends MasterfabricEndpoint with RbacEndpointMixin {
///   // All methods require 'user' role
///   @override
///   List<String> get requiredRoles => ['user'];
///
///   // Specific methods require additional roles
///   @override
///   Map<String, List<String>> get methodRoles => {
///     'deleteUser': ['admin'],
///     'updatePermissions': ['admin', 'superuser'],
///   };
///
///   // Specific methods require specific permissions
///   @override
///   Map<String, List<String>> get methodPermissions => {
///     'viewSensitiveData': ['user:read:sensitive'],
///   };
///
///   Future<void> deleteUser(Session session, String userId) async {
///     return executeWithRbac(
///       session: session,
///       methodName: 'deleteUser',
///       handler: () async { /* ... */ },
///     );
///   }
/// }
/// ```
mixin RbacEndpointMixin on MasterfabricEndpoint {
  /// Roles required for all methods in this endpoint.
  ///
  /// Override to specify roles that ALL methods require.
  /// By default, requires at least ONE of the specified roles.
  List<String> get requiredRoles => const [];

  /// Permissions required for all methods in this endpoint.
  ///
  /// Override to specify permissions that ALL methods require.
  List<String> get requiredPermissions => const [];

  /// Whether ALL endpoint-level roles are required (AND) vs at least ONE (OR).
  ///
  /// Default is false (at least ONE role is sufficient).
  bool get requireAllRoles => false;

  /// Whether ALL endpoint-level permissions are required (AND) vs at least ONE (OR).
  ///
  /// Default is false (at least ONE permission is sufficient).
  bool get requireAllPermissions => false;

  /// Method-specific role requirements.
  ///
  /// Override to specify additional roles required for specific methods.
  /// These are added to the endpoint-level roles.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Map<String, List<String>> get methodRoles => {
  ///   'deleteUser': ['admin'],
  ///   'banUser': ['admin', 'moderator'],
  /// };
  /// ```
  Map<String, List<String>> get methodRoles => const {};

  /// Method-specific permission requirements.
  ///
  /// Override to specify additional permissions required for specific methods.
  /// These are added to the endpoint-level permissions.
  Map<String, List<String>> get methodPermissions => const {};

  /// Method-specific requireAll flags for roles.
  ///
  /// Override to specify whether specific methods require ALL roles.
  /// Default is false (at least ONE role).
  Map<String, bool> get methodRequireAllRoles => const {};

  /// Method-specific requireAll flags for permissions.
  ///
  /// Override to specify whether specific methods require ALL permissions.
  /// Default is false (at least ONE permission).
  Map<String, bool> get methodRequireAllPermissions => const {};

  /// Get the middleware config including RBAC requirements
  @override
  EndpointMiddlewareConfig? get middlewareConfig {
    if (requiredRoles.isEmpty && requiredPermissions.isEmpty) {
      return null;
    }

    return EndpointMiddlewareConfig(
      requiredRoles: requiredRoles,
      requiredPermissions: requiredPermissions,
      requireAllRoles: requireAllRoles,
      requireAllPermissions: requireAllPermissions,
    );
  }

  /// Get RBAC config for a specific method
  EndpointMiddlewareConfig? getRbacConfigForMethod(String methodName) {
    final List<String> roles = [
      ...requiredRoles,
      ...(methodRoles[methodName] ?? <String>[]),
    ];
    final List<String> permissions = [
      ...requiredPermissions,
      ...(methodPermissions[methodName] ?? <String>[]),
    ];

    if (roles.isEmpty && permissions.isEmpty) {
      return null;
    }

    // Method-level requireAll overrides endpoint-level
    final methodRequireAllRolesFlag =
        methodRequireAllRoles[methodName] ?? requireAllRoles;
    final methodRequireAllPermissionsFlag =
        methodRequireAllPermissions[methodName] ?? requireAllPermissions;

    return EndpointMiddlewareConfig(
      requiredRoles: roles,
      requiredPermissions: permissions,
      requireAllRoles: methodRequireAllRolesFlag,
      requireAllPermissions: methodRequireAllPermissionsFlag,
    );
  }

  /// Execute with RBAC-aware middleware
  ///
  /// Automatically applies role and permission requirements based on
  /// the endpoint and method configurations.
  Future<T> executeWithRbac<T>({
    required Session session,
    required String methodName,
    Map<String, dynamic>? parameters,
    required Future<T> Function() handler,
    EndpointMiddlewareConfig? additionalConfig,
  }) {
    // Get RBAC config for this method
    final rbacConfig = getRbacConfigForMethod(methodName);

    // Merge with any additional config provided
    EndpointMiddlewareConfig? finalConfig;
    if (rbacConfig != null && additionalConfig != null) {
      finalConfig = EndpointMiddlewareConfig(
        skipLogging: additionalConfig.skipLogging,
        skipRateLimit: additionalConfig.skipRateLimit,
        skipAuth: additionalConfig.skipAuth,
        skipValidation: additionalConfig.skipValidation,
        skipMetrics: additionalConfig.skipMetrics,
        customRateLimit: additionalConfig.customRateLimit,
        requiredRoles: [
          ...rbacConfig.requiredRoles,
          ...additionalConfig.requiredRoles,
        ],
        requiredPermissions: [
          ...rbacConfig.requiredPermissions,
          ...additionalConfig.requiredPermissions,
        ],
        requireAllRoles: rbacConfig.requireAllRoles,
        requireAllPermissions: rbacConfig.requireAllPermissions,
        customAuthorizerId: additionalConfig.customAuthorizerId,
        logLevel: additionalConfig.logLevel,
        additionalMaskedFields: additionalConfig.additionalMaskedFields,
        validationRules: additionalConfig.validationRules,
        metadata: additionalConfig.metadata,
      );
    } else {
      finalConfig = rbacConfig ?? additionalConfig;
    }

    return executeWithMiddleware<T>(
      session: session,
      methodName: methodName,
      parameters: parameters,
      handler: handler,
      config: finalConfig,
    );
  }
}

/// Mixin for user-only endpoints (requires 'user' role)
mixin UserEndpointMixin on MasterfabricEndpoint {
  @override
  bool get requireLogin => true;

  @override
  EndpointMiddlewareConfig? get middlewareConfig => const EndpointMiddlewareConfig(
        requiredRoles: ['user'],
      );
}

/// Mixin for moderator endpoints (requires 'moderator' or 'admin' role)
mixin ModeratorEndpointMixin on MasterfabricEndpoint {
  @override
  bool get requireLogin => true;

  @override
  EndpointMiddlewareConfig? get middlewareConfig => const EndpointMiddlewareConfig(
        requiredRoles: ['moderator', 'admin'],
        requireAllRoles: false, // Either role is sufficient
      );
}
