import 'package:serverpod/serverpod.dart';

import '../base/middleware_chain.dart';
import '../base/middleware_context.dart';
import '../base/middleware_config.dart';
import 'middleware_registry.dart';

/// Resolves and executes middleware for endpoints
///
/// This service bridges the gap between Serverpod endpoints
/// and the middleware system, providing easy-to-use methods
/// for endpoint middleware execution.
class EndpointMiddlewareResolver {
  /// The middleware registry
  final MiddlewareRegistry _registry;

  /// Cache of created chains
  final Map<String, MiddlewareChain> _chainCache = {};

  EndpointMiddlewareResolver({
    MiddlewareRegistry? registry,
  }) : _registry = registry ?? MiddlewareRegistry.instance;

  /// Get a middleware chain for an endpoint
  MiddlewareChain getChain(
    String endpoint, {
    EndpointMiddlewareConfig? config,
  }) {
    // Check cache first
    final cacheKey = '$endpoint:${config?.hashCode ?? 'default'}';
    if (_chainCache.containsKey(cacheKey)) {
      return _chainCache[cacheKey]!;
    }

    // Create new chain
    final chain = _registry.createChain(
      endpoint: endpoint,
      endpointConfig: config,
    );

    // Cache it
    _chainCache[cacheKey] = chain;

    return chain;
  }

  /// Execute middleware chain for an endpoint method
  ///
  /// This is the main entry point for endpoints to use middleware.
  Future<T> execute<T>({
    required Session session,
    required String endpoint,
    required String method,
    required Future<T> Function() handler,
    Map<String, dynamic>? parameters,
    EndpointMiddlewareConfig? config,
  }) async {
    // Create context
    final context = MiddlewareContext(
      session: session,
      endpointName: endpoint,
      methodName: method,
      parameters: parameters ?? {},
    );

    // Apply custom config to context
    if (config != null) {
      _applyConfigToContext(context, config);
    }

    // Get chain
    final chain = getChain('$endpoint/$method', config: config);

    // Execute chain
    final result = await chain.execute<T>(context, handler);

    // Handle result
    if (result.success) {
      return result.result as T;
    } else {
      // Throw the error
      if (result.error != null) {
        throw result.error!;
      }
      throw StateError('Middleware chain failed without error');
    }
  }

  /// Apply endpoint config to context
  void _applyConfigToContext(
    MiddlewareContext context,
    EndpointMiddlewareConfig config,
  ) {
    if (config.skipLogging) {
      context.skipMiddleware('logging');
    }
    if (config.skipRateLimit) {
      context.skipMiddleware('rate_limit');
    }
    if (config.skipAuth) {
      context.skipMiddleware('auth');
      context.setMetadata('skipAuth', true);
    }
    if (config.skipValidation) {
      context.skipMiddleware('validation');
    }
    if (config.skipMetrics) {
      context.skipMiddleware('metrics');
    }

    if (config.customRateLimit != null) {
      context.setMetadata('customRateLimit', config.customRateLimit);
    }

    // RBAC configuration
    if (config.requiredPermissions.isNotEmpty) {
      context.setMetadata('requiredPermissions', config.requiredPermissions);
      context.setMetadata('requireAllPermissions', config.requireAllPermissions);
    }
    if (config.requiredRoles.isNotEmpty) {
      context.setMetadata('requiredRoles', config.requiredRoles);
      context.setMetadata('requireAllRoles', config.requireAllRoles);
    }
    if (config.customAuthorizerId != null) {
      context.setMetadata('customAuthorizerId', config.customAuthorizerId);
    }

    if (config.validationRules != null) {
      context.setMetadata('validationRules', config.validationRules);
    }

    // Add custom metadata
    for (final entry in config.metadata.entries) {
      context.setMetadata(entry.key, entry.value);
    }
  }

  /// Clear the chain cache
  void clearCache() {
    _chainCache.clear();
  }

  /// Get middleware execution statistics from a chain
  List<MiddlewareExecutionRecord> getExecutionRecords(String endpoint) {
    final chain = _chainCache['$endpoint:default'];
    return chain?.records ?? [];
  }
}

/// Global instance for easy access
EndpointMiddlewareResolver? _globalResolver;

/// Get the global middleware resolver
EndpointMiddlewareResolver get middlewareResolver {
  _globalResolver ??= EndpointMiddlewareResolver();
  return _globalResolver!;
}

/// Reset the global resolver (for testing)
void resetMiddlewareResolver() {
  _globalResolver = null;
}

/// Extension methods for Session to make middleware usage easier
extension SessionMiddlewareExtension on Session {
  /// Execute a handler with middleware
  Future<T> withMiddleware<T>({
    required String endpoint,
    required String method,
    required Future<T> Function() handler,
    Map<String, dynamic>? parameters,
    EndpointMiddlewareConfig? config,
  }) {
    return middlewareResolver.execute<T>(
      session: this,
      endpoint: endpoint,
      method: method,
      handler: handler,
      parameters: parameters,
      config: config,
    );
  }
}
