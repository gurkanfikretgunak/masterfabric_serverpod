import 'package:serverpod/serverpod.dart';

import '../../../services/auth/rbac/rbac_service.dart';
import '../base/middleware_base.dart';
import '../base/middleware_chain.dart';
import '../base/middleware_config.dart';
import '../interceptors/logging_middleware.dart';
import '../interceptors/rate_limit_middleware.dart';
import '../interceptors/auth_middleware.dart';
import '../interceptors/validation_middleware.dart';
import '../interceptors/metrics_middleware.dart';
import '../interceptors/error_middleware.dart';

/// Central registry for all middleware
///
/// Manages middleware registration, configuration, and chain creation.
/// Provides a singleton pattern for global access.
class MiddlewareRegistry {
  /// Singleton instance
  static MiddlewareRegistry? _instance;

  /// Get the singleton instance
  static MiddlewareRegistry get instance {
    _instance ??= MiddlewareRegistry._();
    return _instance!;
  }

  /// Reset the singleton (for testing)
  static void reset() {
    _instance = null;
  }

  /// Registered middleware
  final List<MiddlewareHandler> _middleware = [];

  /// Global configuration
  MiddlewareGlobalConfig _globalConfig = MiddlewareGlobalConfig.defaults;

  /// Per-endpoint configurations
  final Map<String, EndpointMiddlewareConfig> _endpointConfigs = {};

  /// Private constructor
  MiddlewareRegistry._();

  /// Create a new registry (not singleton)
  factory MiddlewareRegistry.create() {
    return MiddlewareRegistry._();
  }

  /// Get global configuration
  MiddlewareGlobalConfig get globalConfig => _globalConfig;

  /// Get all registered middleware
  List<MiddlewareHandler> get middleware => List.unmodifiable(_middleware);

  /// Configure the registry with global settings
  void configure(MiddlewareGlobalConfig config) {
    _globalConfig = config;
  }

  /// Register a middleware
  MiddlewareRegistry register(MiddlewareHandler middleware) {
    // Check for duplicate names
    if (_middleware.any((m) => m.name == middleware.name)) {
      throw StateError('Middleware "${middleware.name}" is already registered');
    }

    _middleware.add(middleware);
    _middleware.sort((a, b) => a.priority.compareTo(b.priority));
    return this;
  }

  /// Unregister a middleware by name
  bool unregister(String name) {
    final index = _middleware.indexWhere((m) => m.name == name);
    if (index >= 0) {
      _middleware.removeAt(index);
      return true;
    }
    return false;
  }

  /// Get a middleware by name
  MiddlewareHandler? getMiddleware(String name) {
    try {
      return _middleware.firstWhere((m) => m.name == name);
    } catch (_) {
      return null;
    }
  }

  /// Check if a middleware is registered
  bool hasMiddleware(String name) {
    return _middleware.any((m) => m.name == name);
  }

  /// Register endpoint-specific configuration
  void registerEndpointConfig(
    String endpoint,
    EndpointMiddlewareConfig config,
  ) {
    _endpointConfigs[endpoint] = config;
  }

  /// Get endpoint configuration
  EndpointMiddlewareConfig? getEndpointConfig(String endpoint) {
    // Try exact match first
    if (_endpointConfigs.containsKey(endpoint)) {
      return _endpointConfigs[endpoint];
    }

    // Try endpoint-only match (without method)
    final parts = endpoint.split('/');
    if (parts.isNotEmpty && _endpointConfigs.containsKey(parts.first)) {
      return _endpointConfigs[parts.first];
    }

    return null;
  }

  /// Remove endpoint configuration
  void removeEndpointConfig(String endpoint) {
    _endpointConfigs.remove(endpoint);
  }

  /// Create a middleware chain for an endpoint
  MiddlewareChain createChain({
    String? endpoint,
    EndpointMiddlewareConfig? endpointConfig,
  }) {
    // Get endpoint config from registry if not provided
    final config =
        endpointConfig ?? (endpoint != null ? getEndpointConfig(endpoint) : null);

    return MiddlewareChain.forEndpoint(
      middleware: _middleware,
      globalConfig: _globalConfig,
      endpointConfig: config,
    );
  }

  /// Register all default middleware with sensible defaults
  ///
  /// [config] - Optional global middleware configuration
  /// [rbacService] - Optional RBAC service for role/permission verification
  /// [customRoleChecker] - Optional custom function to check roles
  /// [customPermissionChecker] - Optional custom function to check permissions
  /// [customAuthorizers] - Optional map of custom authorizer functions
  ///
  /// Example with RBAC:
  /// ```dart
  /// MiddlewareRegistry.instance.registerDefaults(
  ///   rbacService: RbacService(),
  /// );
  /// ```
  MiddlewareRegistry registerDefaults({
    MiddlewareGlobalConfig? config,
    RbacService? rbacService,
    Future<bool> Function(Session session, List<String> roles, {bool requireAll})?
        customRoleChecker,
    Future<bool> Function(Session session, List<String> permissions, {bool requireAll})?
        customPermissionChecker,
    Map<String, Future<bool> Function(Session session)>? customAuthorizers,
  }) {
    if (config != null) {
      configure(config);
    }

    // Register middleware in priority order
    register(LoggingMiddleware(
      logLevel: _globalConfig.logLevel,
      maskedFields: _globalConfig.maskedFields,
      maxParamLength: _globalConfig.maxLogParamLength,
    ));

    register(RateLimitMiddleware(
      defaultConfig: _globalConfig.defaultRateLimit,
    ));

    // Register AuthMiddleware with RBAC integration
    register(AuthMiddleware(
      rbacService: rbacService,
      roleChecker: customRoleChecker,
      permissionChecker: customPermissionChecker,
      customAuthorizers: customAuthorizers,
    ));

    register(ValidationMiddleware());

    register(MetricsMiddleware());

    register(ErrorMiddleware.development());

    return this;
  }

  /// Register default middleware with RBAC service
  ///
  /// Convenience method that creates an RbacService and registers
  /// the middleware with it.
  ///
  /// Example:
  /// ```dart
  /// MiddlewareRegistry.instance.registerDefaultsWithRbac();
  /// ```
  MiddlewareRegistry registerDefaultsWithRbac({
    MiddlewareGlobalConfig? config,
    Map<String, Future<bool> Function(Session session)>? customAuthorizers,
  }) {
    return registerDefaults(
      config: config,
      rbacService: RbacService(),
      customAuthorizers: customAuthorizers,
    );
  }

  /// Clear all registered middleware
  void clear() {
    _middleware.clear();
    _endpointConfigs.clear();
  }

  /// Get middleware statistics
  Map<String, dynamic> getStats() {
    return {
      'registeredCount': _middleware.length,
      'middleware': _middleware.map((m) {
        return {
          'name': m.name,
          'priority': m.priority,
          'enabledByDefault': m.enabledByDefault,
        };
      }).toList(),
      'endpointConfigs': _endpointConfigs.keys.toList(),
      'globalConfig': {
        'enableLogging': _globalConfig.enableLogging,
        'enableRateLimit': _globalConfig.enableRateLimit,
        'enableAuth': _globalConfig.enableAuth,
        'enableValidation': _globalConfig.enableValidation,
        'enableMetrics': _globalConfig.enableMetrics,
        'enableErrorHandling': _globalConfig.enableErrorHandling,
      },
    };
  }
}
