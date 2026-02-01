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

    // Merge: method config takes precedence
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
