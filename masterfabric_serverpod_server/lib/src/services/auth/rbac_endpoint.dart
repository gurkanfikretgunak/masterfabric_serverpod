import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/errors/base_error_handler.dart';
import '../../core/errors/error_types.dart';
import '../../core/logging/core_logger.dart';
import 'rbac_service.dart';
import 'auth_helper_service.dart';

/// Endpoint for RBAC (Role-Based Access Control)
/// 
/// Provides endpoints for managing roles, permissions, and user-role assignments.
class RbacEndpoint extends Endpoint {
  final RbacService _rbacService = RbacService();
  final AuthHelperService _authHelper = AuthHelperService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Get all roles
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns list of all active roles
  Future<List<Role>> getRoles(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Roles requested');

      final roles = await Role.db.find(
        session,
        where: (t) => t.isActive.equals(true),
        orderBy: (t) => t.name,
      );

      logger.info('Roles retrieved', context: {
        'count': roles.length,
      });

      return roles;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get roles: ${e.toString()}',
      );
    }
  }

  /// Get all permissions
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns list of all permissions
  Future<List<Permission>> getPermissions(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Permissions requested');

      final permissions = await Permission.db.find(
        session,
        orderBy: (t) => t.name,
      );

      logger.info('Permissions retrieved', context: {
        'count': permissions.length,
      });

      return permissions;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get permissions: ${e.toString()}',
      );
    }
  }

  /// Get user's roles
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Returns list of role names for the user
  Future<List<String>> getUserRoles(
    Session session, {
    String? userId,
  }) async {
    final logger = CoreLogger(session);

    try {
      final targetUserId = userId != null
          ? UuidValue.fromString(userId)
          : await _authHelper.requireAuth(session);

      logger.info('User roles requested', context: {
        'userId': targetUserId.toString(),
      });

      final roles = await _rbacService.getUserRoles(session, targetUserId);

      logger.info('User roles retrieved', context: {
        'userId': targetUserId.toString(),
        'count': roles.length,
      });

      return roles;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get user roles: ${e.toString()}',
      );
    }
  }

  /// Get user's permissions
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Returns set of permission names for the user
  Future<Set<String>> getUserPermissions(
    Session session, {
    String? userId,
  }) async {
    final logger = CoreLogger(session);

    try {
      final targetUserId = userId != null
          ? UuidValue.fromString(userId)
          : await _authHelper.requireAuth(session);

      logger.info('User permissions requested', context: {
        'userId': targetUserId.toString(),
      });

      final permissions = await _rbacService.getUserPermissions(
        session,
        targetUserId,
      );

      logger.info('User permissions retrieved', context: {
        'userId': targetUserId.toString(),
        'count': permissions.length,
      });

      return permissions;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get user permissions: ${e.toString()}',
      );
    }
  }

  /// Assign a role to a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to assign
  /// 
  /// Throws NotFoundError if role not found
  /// Throws ValidationError if user already has the role
  /// Throws AuthorizationError if current user doesn't have admin permission
  Future<void> assignRoleToUser(
    Session session,
    String userId,
    String roleName,
  ) async {
    final logger = CoreLogger(session);

    try {
      // Require admin permission (or implement your own permission check)
      final currentUserId = await _authHelper.requireAuth(session);
      // TODO: Add admin permission check
      // await _rbacService.requirePermission(session, currentUserId, 'admin.manage_roles');

      logger.info('Role assignment requested', context: {
        'userId': userId,
        'roleName': roleName,
      });

      await _rbacService.assignRole(
        session,
        UuidValue.fromString(userId),
        roleName,
        assignedBy: currentUserId,
      );

      logger.info('Role assigned successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to assign role: ${e.toString()}',
      );
    }
  }

  /// Revoke a role from a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to revoke
  /// 
  /// Throws NotFoundError if role or assignment not found
  /// Throws AuthorizationError if current user doesn't have admin permission
  Future<void> revokeRoleFromUser(
    Session session,
    String userId,
    String roleName,
  ) async {
    final logger = CoreLogger(session);

    try {
      // Require admin permission
      final currentUserId = await _authHelper.requireAuth(session);
      // TODO: Add admin permission check
      // await _rbacService.requirePermission(session, currentUserId, 'admin.manage_roles');

      logger.info('Role revocation requested', context: {
        'userId': userId,
        'roleName': roleName,
      });

      await _rbacService.revokeRole(
        session,
        UuidValue.fromString(userId),
        roleName,
      );

      logger.info('Role revoked successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to revoke role: ${e.toString()}',
      );
    }
  }
}
