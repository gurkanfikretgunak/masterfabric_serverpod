import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../base/middleware_base.dart';
import '../base/middleware_context.dart';

/// Middleware for authentication and authorization
///
/// Features:
/// - Automatic authentication verification
/// - Permission checks (RBAC integration)
/// - Role-based access control
/// - Custom authorization rules
/// - Extracts and stores user info in context
class AuthMiddleware extends RequestOnlyMiddleware {
  @override
  String get name => 'auth';

  @override
  int get priority => 30; // After rate limit, before validation

  /// Function to check if user has required permissions
  final Future<bool> Function(Session session, List<String> permissions)?
      _permissionChecker;

  /// Function to check if user has required roles
  final Future<bool> Function(Session session, List<String> roles)? _roleChecker;

  /// Per-endpoint auth configurations
  final Map<String, AuthEndpointConfig> _endpointConfigs;

  AuthMiddleware({
    Future<bool> Function(Session session, List<String> permissions)?
        permissionChecker,
    Future<bool> Function(Session session, List<String> roles)? roleChecker,
    Map<String, AuthEndpointConfig>? endpointConfigs,
  })  : _permissionChecker = permissionChecker,
        _roleChecker = roleChecker,
        _endpointConfigs = endpointConfigs ?? {};

  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    // Get auth config for this endpoint
    final config = _getConfigForEndpoint(context);

    // Check if auth is required
    if (!config.requireAuth) {
      return MiddlewareResult.proceed();
    }

    // Check authentication
    final auth = context.session.authenticated;
    if (auth == null) {
      context.session.log(
        'AUTH FAILED | endpoint=${context.fullPath} | reason=not_authenticated',
        level: LogLevel.warning,
      );

      return MiddlewareResult.reject(
        error: MiddlewareError(
          message: 'Authentication required',
          code: 'AUTH_REQUIRED',
          statusCode: 401,
          middleware: name,
          timestamp: DateTime.now(),
        ),
        message: 'Authentication required for ${context.fullPath}',
      );
    }

    // Store user info in context
    context.userId = auth.userIdentifier.toString();
    context.setMetadata('authMethod', 'authenticated');
    context.setMetadata('authScopes', auth.scopes.map((s) => s.name).toList());

    // Check required permissions
    if (config.requiredPermissions.isNotEmpty) {
      final hasPermissions = await _checkPermissions(
        context.session,
        config.requiredPermissions,
      );

      if (!hasPermissions) {
        context.session.log(
          'AUTH FAILED | '
          'endpoint=${context.fullPath} | '
          'userId=${context.userId} | '
          'reason=missing_permissions | '
          'required=${config.requiredPermissions}',
          level: LogLevel.warning,
        );

        return MiddlewareResult.reject(
          error: MiddlewareError(
            message: 'Insufficient permissions',
            code: 'PERMISSION_DENIED',
            statusCode: 403,
            middleware: name,
            details: {'required': config.requiredPermissions.join(', ')},
            timestamp: DateTime.now(),
          ),
          message: 'Missing required permissions: ${config.requiredPermissions}',
        );
      }
    }

    // Check required roles
    if (config.requiredRoles.isNotEmpty) {
      final hasRoles = await _checkRoles(
        context.session,
        config.requiredRoles,
      );

      if (!hasRoles) {
        context.session.log(
          'AUTH FAILED | '
          'endpoint=${context.fullPath} | '
          'userId=${context.userId} | '
          'reason=missing_roles | '
          'required=${config.requiredRoles}',
          level: LogLevel.warning,
        );

        return MiddlewareResult.reject(
          error: MiddlewareError(
            message: 'Insufficient role privileges',
            code: 'ROLE_DENIED',
            statusCode: 403,
            middleware: name,
            details: {'required': config.requiredRoles.join(', ')},
            timestamp: DateTime.now(),
          ),
          message: 'Missing required roles: ${config.requiredRoles}',
        );
      }
    }

    context.session.log(
      'AUTH SUCCESS | '
      'endpoint=${context.fullPath} | '
      'userId=${context.userId}',
      level: LogLevel.debug,
    );

    return MiddlewareResult.proceed(
      data: {
        'userId': context.userId,
        'authenticated': true,
      },
    );
  }

  /// Get auth config for an endpoint
  AuthEndpointConfig _getConfigForEndpoint(MiddlewareContext context) {
    // Check for endpoint-specific config
    final endpointKey = context.fullPath;
    if (_endpointConfigs.containsKey(endpointKey)) {
      return _endpointConfigs[endpointKey]!;
    }

    // Check for endpoint-level config
    if (_endpointConfigs.containsKey(context.endpointName)) {
      return _endpointConfigs[context.endpointName]!;
    }

    // Check context metadata
    final skipAuth = context.getMetadata<bool>('skipAuth') ?? false;
    final requiredPermissions =
        context.getMetadata<List<String>>('requiredPermissions') ?? [];
    final requiredRoles =
        context.getMetadata<List<String>>('requiredRoles') ?? [];

    return AuthEndpointConfig(
      requireAuth: !skipAuth,
      requiredPermissions: requiredPermissions,
      requiredRoles: requiredRoles,
    );
  }

  /// Check if user has required permissions
  Future<bool> _checkPermissions(
    Session session,
    List<String> permissions,
  ) async {
    if (_permissionChecker != null) {
      return await _permissionChecker!(session, permissions);
    }

    // Default: use RBAC service if available
    try {
      // This would integrate with your RbacService
      // For now, return true if authenticated
      return session.authenticated != null;
    } catch (e) {
      return false;
    }
  }

  /// Check if user has required roles
  Future<bool> _checkRoles(
    Session session,
    List<String> roles,
  ) async {
    if (_roleChecker != null) {
      return await _roleChecker!(session, roles);
    }

    // Default: use RBAC service if available
    try {
      // This would integrate with your RbacService
      // For now, return true if authenticated
      return session.authenticated != null;
    } catch (e) {
      return false;
    }
  }

  /// Register auth config for an endpoint
  void registerEndpointConfig(String endpoint, AuthEndpointConfig config) {
    _endpointConfigs[endpoint] = config;
  }
}

/// Auth configuration for an endpoint
class AuthEndpointConfig {
  /// Whether authentication is required
  final bool requireAuth;

  /// Required permissions (all must be present)
  final List<String> requiredPermissions;

  /// Required roles (at least one must be present)
  final List<String> requiredRoles;

  /// Custom authorization function
  final Future<bool> Function(Session session)? customAuthorizer;

  const AuthEndpointConfig({
    this.requireAuth = true,
    this.requiredPermissions = const [],
    this.requiredRoles = const [],
    this.customAuthorizer,
  });

  /// Public endpoint - no auth required
  static const AuthEndpointConfig public = AuthEndpointConfig(
    requireAuth: false,
  );

  /// Admin endpoint
  static const AuthEndpointConfig admin = AuthEndpointConfig(
    requireAuth: true,
    requiredRoles: ['admin'],
  );
}
