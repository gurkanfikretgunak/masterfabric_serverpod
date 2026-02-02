import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../services/auth/rbac/rbac_service.dart';
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
///
/// The middleware integrates with [RbacService] to verify:
/// - User roles (with support for requireAll mode)
/// - User permissions (with support for requireAll mode)
/// - Custom authorization functions
///
/// Example configuration:
/// ```dart
/// AuthMiddleware(
///   rbacService: RbacService(),
///   endpointConfigs: {
///     'admin/users': AuthEndpointConfig(
///       requiredRoles: ['admin'],
///       requireAllRoles: false,
///     ),
///   },
/// )
/// ```
class AuthMiddleware extends RequestOnlyMiddleware {
  @override
  String get name => 'auth';

  @override
  int get priority => 30; // After rate limit, before validation

  /// RBAC service for role and permission verification
  final RbacService? _rbacService;

  /// Function to check if user has required permissions
  final Future<bool> Function(Session session, List<String> permissions, {bool requireAll})?
      _permissionChecker;

  /// Function to check if user has required roles
  final Future<bool> Function(Session session, List<String> roles, {bool requireAll})?
      _roleChecker;

  /// Per-endpoint auth configurations
  final Map<String, AuthEndpointConfig> _endpointConfigs;

  /// Map of custom authorizer IDs to their functions
  final Map<String, Future<bool> Function(Session session)> _customAuthorizers;

  AuthMiddleware({
    RbacService? rbacService,
    Future<bool> Function(Session session, List<String> permissions, {bool requireAll})?
        permissionChecker,
    Future<bool> Function(Session session, List<String> roles, {bool requireAll})?
        roleChecker,
    Map<String, AuthEndpointConfig>? endpointConfigs,
    Map<String, Future<bool> Function(Session session)>? customAuthorizers,
  })  : _rbacService = rbacService,
        _permissionChecker = permissionChecker,
        _roleChecker = roleChecker,
        _endpointConfigs = endpointConfigs ?? {},
        _customAuthorizers = customAuthorizers ?? {};

  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    // Get auth config for this endpoint
    final config = _getConfigForEndpoint(context);

    // Check if auth is required
    if (!config.requireAuth) {
      context.session.log(
        'AUTH SKIPPED | endpoint=${context.fullPath} | reason=public_endpoint',
        level: LogLevel.debug,
      );
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

    // Check required roles
    if (config.requiredRoles.isNotEmpty) {
      final hasRoles = await _checkRoles(
        context.session,
        config.requiredRoles,
        requireAll: config.requireAllRoles,
      );

      if (!hasRoles) {
        final modeText = config.requireAllRoles ? 'all of' : 'any of';
        context.session.log(
          'AUTH FAILED | '
          'endpoint=${context.fullPath} | '
          'userId=${context.userId} | '
          'reason=missing_roles | '
          'required=$modeText ${config.requiredRoles}',
          level: LogLevel.warning,
        );

        return MiddlewareResult.reject(
          error: MiddlewareError(
            message: 'Insufficient role privileges',
            code: 'ROLE_DENIED',
            statusCode: 403,
            middleware: name,
            details: {
              'required': config.requiredRoles.join(', '),
              'requireAll': config.requireAllRoles.toString(),
            },
            timestamp: DateTime.now(),
          ),
          message: 'Missing required roles: ${config.requiredRoles}',
        );
      }

      // Store user roles in context for downstream use
      final userRoles = await _getUserRoles(context.session);
      context.setMetadata('userRoles', userRoles);
    }

    // Check required permissions
    if (config.requiredPermissions.isNotEmpty) {
      final hasPermissions = await _checkPermissions(
        context.session,
        config.requiredPermissions,
        requireAll: config.requireAllPermissions,
      );

      if (!hasPermissions) {
        final modeText = config.requireAllPermissions ? 'all of' : 'any of';
        context.session.log(
          'AUTH FAILED | '
          'endpoint=${context.fullPath} | '
          'userId=${context.userId} | '
          'reason=missing_permissions | '
          'required=$modeText ${config.requiredPermissions}',
          level: LogLevel.warning,
        );

        return MiddlewareResult.reject(
          error: MiddlewareError(
            message: 'Insufficient permissions',
            code: 'PERMISSION_DENIED',
            statusCode: 403,
            middleware: name,
            details: {
              'required': config.requiredPermissions.join(', '),
              'requireAll': config.requireAllPermissions.toString(),
            },
            timestamp: DateTime.now(),
          ),
          message: 'Missing required permissions: ${config.requiredPermissions}',
        );
      }

      // Store user permissions in context for downstream use
      final userPermissions = await _getUserPermissions(context.session);
      context.setMetadata('userPermissions', userPermissions.toList());
    }

    // Check custom authorizer if specified
    if (config.customAuthorizerId != null) {
      final authorizer = _customAuthorizers[config.customAuthorizerId];
      if (authorizer != null) {
        final authorized = await authorizer(context.session);
        if (!authorized) {
          context.session.log(
            'AUTH FAILED | '
            'endpoint=${context.fullPath} | '
            'userId=${context.userId} | '
            'reason=custom_authorizer_denied | '
            'authorizerId=${config.customAuthorizerId}',
            level: LogLevel.warning,
          );

          return MiddlewareResult.reject(
            error: MiddlewareError(
              message: 'Access denied by custom authorizer',
              code: 'CUSTOM_AUTH_DENIED',
              statusCode: 403,
              middleware: name,
              details: {'authorizerId': config.customAuthorizerId ?? 'unknown'},
              timestamp: DateTime.now(),
            ),
            message: 'Custom authorization failed',
          );
        }
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

    // Check context metadata (from EndpointMiddlewareConfig)
    final skipAuth = context.getMetadata<bool>('skipAuth') ?? false;
    final requiredPermissions =
        context.getMetadata<List<String>>('requiredPermissions') ?? [];
    final requiredRoles =
        context.getMetadata<List<String>>('requiredRoles') ?? [];
    final requireAllRoles =
        context.getMetadata<bool>('requireAllRoles') ?? false;
    final requireAllPermissions =
        context.getMetadata<bool>('requireAllPermissions') ?? false;
    final customAuthorizerId =
        context.getMetadata<String>('customAuthorizerId');

    return AuthEndpointConfig(
      requireAuth: !skipAuth,
      requiredPermissions: requiredPermissions,
      requiredRoles: requiredRoles,
      requireAllRoles: requireAllRoles,
      requireAllPermissions: requireAllPermissions,
      customAuthorizerId: customAuthorizerId,
    );
  }

  /// Check if user has required permissions
  ///
  /// [session] - The current session
  /// [permissions] - List of permission names to check
  /// [requireAll] - If true, user must have ALL permissions; if false, at least ONE
  Future<bool> _checkPermissions(
    Session session,
    List<String> permissions, {
    bool requireAll = false,
  }) async {
    if (permissions.isEmpty) return true;

    // Use custom permission checker if provided
    if (_permissionChecker case final checker?) {
      return await checker(session, permissions, requireAll: requireAll);
    }

    // Use RBAC service if available
    if (_rbacService != null) {
      return await _checkPermissionsWithRbac(session, permissions, requireAll);
    }

    // Fallback: return true if authenticated (no RBAC configured)
    session.log(
      'RBAC WARNING | No RBAC service configured, skipping permission check',
      level: LogLevel.warning,
    );
    return session.authenticated != null;
  }

  /// Check permissions using RbacService
  Future<bool> _checkPermissionsWithRbac(
    Session session,
    List<String> permissions,
    bool requireAll,
  ) async {
    try {
      final auth = session.authenticated;
      if (auth == null) return false;

      final userId = UuidValue.fromString(auth.userIdentifier.toString());

      if (requireAll) {
        // User must have ALL permissions
        for (final permission in permissions) {
          final hasPermission = await _rbacService!.hasPermission(
            session,
            userId,
            permission,
          );
          if (!hasPermission) return false;
        }
        return true;
      } else {
        // User must have at least ONE permission
        for (final permission in permissions) {
          final hasPermission = await _rbacService!.hasPermission(
            session,
            userId,
            permission,
          );
          if (hasPermission) return true;
        }
        return false;
      }
    } catch (e) {
      session.log(
        'RBAC ERROR | Permission check failed: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Check if user has required roles
  ///
  /// [session] - The current session
  /// [roles] - List of role names to check
  /// [requireAll] - If true, user must have ALL roles; if false, at least ONE
  Future<bool> _checkRoles(
    Session session,
    List<String> roles, {
    bool requireAll = false,
  }) async {
    if (roles.isEmpty) return true;

    // Use custom role checker if provided
    if (_roleChecker case final checker?) {
      return await checker(session, roles, requireAll: requireAll);
    }

    // Use RBAC service if available
    if (_rbacService != null) {
      return await _checkRolesWithRbac(session, roles, requireAll);
    }

    // Fallback: return true if authenticated (no RBAC configured)
    session.log(
      'RBAC WARNING | No RBAC service configured, skipping role check',
      level: LogLevel.warning,
    );
    return session.authenticated != null;
  }

  /// Check roles using RbacService
  Future<bool> _checkRolesWithRbac(
    Session session,
    List<String> roles,
    bool requireAll,
  ) async {
    try {
      final auth = session.authenticated;
      if (auth == null) return false;

      final userId = UuidValue.fromString(auth.userIdentifier.toString());

      if (requireAll) {
        // User must have ALL roles
        for (final role in roles) {
          final hasRole = await _rbacService!.hasRole(session, userId, role);
          if (!hasRole) return false;
        }
        return true;
      } else {
        // User must have at least ONE role
        for (final role in roles) {
          final hasRole = await _rbacService!.hasRole(session, userId, role);
          if (hasRole) return true;
        }
        return false;
      }
    } catch (e) {
      session.log(
        'RBAC ERROR | Role check failed: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Get user's roles from RBAC service
  Future<List<String>> _getUserRoles(Session session) async {
    if (_rbacService case final rbacService?) {
      try {
        final auth = session.authenticated;
        if (auth == null) return [];

        final userId = UuidValue.fromString(auth.userIdentifier.toString());
        return await rbacService.getUserRoles(session, userId);
      } catch (e) {
        session.log(
          'RBAC ERROR | Failed to get user roles: $e',
          level: LogLevel.error,
        );
        return [];
      }
    }
    return [];
  }

  /// Get user's permissions from RBAC service
  Future<Set<String>> _getUserPermissions(Session session) async {
    if (_rbacService case final rbacService?) {
      try {
        final auth = session.authenticated;
        if (auth == null) return {};

        final userId = UuidValue.fromString(auth.userIdentifier.toString());
        return await rbacService.getUserPermissions(session, userId);
      } catch (e) {
        session.log(
          'RBAC ERROR | Failed to get user permissions: $e',
          level: LogLevel.error,
        );
        return {};
      }
    }
    return {};
  }

  /// Register auth config for an endpoint
  void registerEndpointConfig(String endpoint, AuthEndpointConfig config) {
    _endpointConfigs[endpoint] = config;
  }

  /// Register a custom authorizer function
  void registerCustomAuthorizer(
    String authorizerId,
    Future<bool> Function(Session session) authorizer,
  ) {
    _customAuthorizers[authorizerId] = authorizer;
  }
}

/// Auth configuration for an endpoint
///
/// Defines authentication and authorization requirements for an endpoint.
///
/// Example:
/// ```dart
/// final config = AuthEndpointConfig(
///   requiredRoles: ['admin', 'moderator'],
///   requireAllRoles: false, // User needs at least ONE of the roles
///   requiredPermissions: ['user:read', 'user:write'],
///   requireAllPermissions: true, // User needs ALL permissions
/// );
/// ```
class AuthEndpointConfig {
  /// Whether authentication is required
  final bool requireAuth;

  /// Required permissions
  final List<String> requiredPermissions;

  /// Required roles
  final List<String> requiredRoles;

  /// If true, user must have ALL required roles.
  /// If false (default), user needs at least ONE of the required roles.
  final bool requireAllRoles;

  /// If true, user must have ALL required permissions.
  /// If false (default), user needs at least ONE of the required permissions.
  final bool requireAllPermissions;

  /// Custom authorization function (deprecated, use customAuthorizerId)
  final Future<bool> Function(Session session)? customAuthorizer;

  /// ID of a registered custom authorizer function
  final String? customAuthorizerId;

  const AuthEndpointConfig({
    this.requireAuth = true,
    this.requiredPermissions = const [],
    this.requiredRoles = const [],
    this.requireAllRoles = false,
    this.requireAllPermissions = false,
    this.customAuthorizer,
    this.customAuthorizerId,
  });

  /// Public endpoint - no auth required
  static const AuthEndpointConfig publicEndpoint = AuthEndpointConfig(
    requireAuth: false,
  );

  /// Admin endpoint - requires 'admin' role
  static const AuthEndpointConfig admin = AuthEndpointConfig(
    requireAuth: true,
    requiredRoles: ['admin'],
  );

  /// User endpoint - requires 'user' role
  static const AuthEndpointConfig user = AuthEndpointConfig(
    requireAuth: true,
    requiredRoles: ['user'],
  );

  /// Create a config for specific roles (any of them)
  factory AuthEndpointConfig.withRoles(
    List<String> roles, {
    bool requireAll = false,
  }) {
    return AuthEndpointConfig(
      requiredRoles: roles,
      requireAllRoles: requireAll,
    );
  }

  /// Create a config for specific permissions (any of them)
  factory AuthEndpointConfig.withPermissions(
    List<String> permissions, {
    bool requireAll = false,
  }) {
    return AuthEndpointConfig(
      requiredPermissions: permissions,
      requireAllPermissions: requireAll,
    );
  }

  /// Create a copy with modified values
  AuthEndpointConfig copyWith({
    bool? requireAuth,
    List<String>? requiredPermissions,
    List<String>? requiredRoles,
    bool? requireAllRoles,
    bool? requireAllPermissions,
    String? customAuthorizerId,
  }) {
    return AuthEndpointConfig(
      requireAuth: requireAuth ?? this.requireAuth,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      requiredRoles: requiredRoles ?? this.requiredRoles,
      requireAllRoles: requireAllRoles ?? this.requireAllRoles,
      requireAllPermissions: requireAllPermissions ?? this.requireAllPermissions,
      customAuthorizerId: customAuthorizerId ?? this.customAuthorizerId,
    );
  }

  @override
  String toString() => 'AuthEndpointConfig('
      'requireAuth: $requireAuth, '
      'roles: $requiredRoles (all: $requireAllRoles), '
      'permissions: $requiredPermissions (all: $requireAllPermissions))';
}
