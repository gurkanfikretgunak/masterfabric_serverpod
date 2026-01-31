import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/errors/error_types.dart';
import 'auth_helper_service.dart';

/// RBAC (Role-Based Access Control) service
/// 
/// Handles role and permission management for users.
class RbacService {
  final AuthHelperService _authHelper = AuthHelperService();

  /// Check if user has a specific role
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to check
  /// [roleName] - Role name to check
  /// 
  /// Returns true if user has the role, false otherwise
  Future<bool> hasRole(
    Session session,
    UuidValue userId,
    String roleName,
  ) async {
    // Get user roles
    final userRoles = await UserRole.db.find(
      session,
      where: (t) => t.userId.equals(userId.toString()),
    );

    // Get role by name
    final role = await Role.db.findFirstRow(
      session,
      where: (t) => t.name.equals(roleName) & t.isActive.equals(true),
    );

    if (role == null) {
      return false;
    }

    // Check if user has this role
    return userRoles.any((ur) => ur.roleId == role.id);
  }

  /// Check if user has a specific permission
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to check
  /// [permissionName] - Permission name to check
  /// 
  /// Returns true if user has the permission, false otherwise
  Future<bool> hasPermission(
    Session session,
    UuidValue userId,
    String permissionName,
  ) async {
    // Get user roles
    final userRoles = await UserRole.db.find(
      session,
      where: (t) => t.userId.equals(userId.toString()),
    );

    if (userRoles.isEmpty) {
      return false;
    }

    // Get role IDs
    final roleIds = userRoles.map((ur) => ur.roleId).toSet();

    // Get all roles for the user
    // Query each role ID separately since OR conditions create type issues
    final roles = <Role>[];
    for (final roleId in roleIds) {
      final role = await Role.db.findFirstRow(
        session,
        where: (t) => t.id.equals(roleId) & t.isActive.equals(true),
      );
      if (role != null) {
        roles.add(role);
      }
    }

    // Check if any role has the permission
    for (final role in roles) {
      if (role.permissions.contains(permissionName)) {
        return true;
      }
    }

    // Also check direct permission (if permission exists as standalone)
    final permission = await Permission.db.findFirstRow(
      session,
      where: (t) => t.name.equals(permissionName),
    );

    if (permission != null) {
      // Check if any role has this permission
      for (final role in roles) {
        if (role.permissions.contains(permissionName)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Assign a role to a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to assign
  /// [assignedBy] - Optional user ID who assigned the role (for audit)
  /// 
  /// Throws NotFoundError if role not found
  /// Throws ValidationError if user already has the role
  Future<void> assignRole(
    Session session,
    UuidValue userId,
    String roleName, {
    UuidValue? assignedBy,
  }) async {
    // Get role
    final role = await Role.db.findFirstRow(
      session,
      where: (t) => t.name.equals(roleName) & t.isActive.equals(true),
    );

    if (role == null) {
      throw NotFoundError(
        'Role not found',
        details: {'roleName': roleName},
      );
    }

    // Check if user already has this role
    final existing = await UserRole.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId.toString()) & t.roleId.equals(role.id),
    );

    if (existing != null) {
      throw ValidationError(
        'User already has this role',
        details: {
          'userId': userId.toString(),
          'roleName': roleName,
        },
      );
    }

    // Assign role
    final userRole = UserRole(
      userId: userId.toString(),
      roleId: role.id!,
      assignedAt: DateTime.now(),
      assignedBy: assignedBy?.toString(),
    );

    await UserRole.db.insertRow(session, userRole);

    session.log(
      'Role assigned to user - userId: ${userId.toString()}, roleName: $roleName, assignedBy: ${assignedBy?.toString()}',
      level: LogLevel.info,
    );
  }

  /// Revoke a role from a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to revoke
  /// 
  /// Throws NotFoundError if role or user-role assignment not found
  Future<void> revokeRole(
    Session session,
    UuidValue userId,
    String roleName,
  ) async {
    // Get role
    final role = await Role.db.findFirstRow(
      session,
      where: (t) => t.name.equals(roleName) & t.isActive.equals(true),
    );

    if (role == null) {
      throw NotFoundError(
        'Role not found',
        details: {'roleName': roleName},
      );
    }

    // Find user-role assignment
    final userRole = await UserRole.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId.toString()) & t.roleId.equals(role.id),
    );

    if (userRole == null) {
      throw NotFoundError(
        'User does not have this role',
        details: {
          'userId': userId.toString(),
          'roleName': roleName,
        },
      );
    }

    // Revoke role
    await UserRole.db.deleteRow(session, userRole);

    session.log(
      'Role revoked from user - userId: ${userId.toString()}, roleName: $roleName',
      level: LogLevel.info,
    );
  }

  /// Get all roles for a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// 
  /// Returns list of Role names
  Future<List<String>> getUserRoles(
    Session session,
    UuidValue userId,
  ) async {
    final userRoles = await UserRole.db.find(
      session,
      where: (t) => t.userId.equals(userId.toString()),
    );

    if (userRoles.isEmpty) {
      return [];
    }

    final roleIds = userRoles.map((ur) => ur.roleId).toList();
    // Query each role ID separately
    final roles = <Role>[];
    for (final roleId in roleIds) {
      final role = await Role.db.findFirstRow(
        session,
        where: (t) => t.id.equals(roleId) & t.isActive.equals(true),
      );
      if (role != null) {
        roles.add(role);
      }
    }

    return roles.map((r) => r.name).toList();
  }

  /// Get all permissions for a user (from their roles)
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// 
  /// Returns set of permission names
  Future<Set<String>> getUserPermissions(
    Session session,
    UuidValue userId,
  ) async {
    final roleNames = await getUserRoles(session, userId);
    if (roleNames.isEmpty) {
      return {};
    }

    // Query each role name separately
    final roles = <Role>[];
    for (final roleName in roleNames) {
      final role = await Role.db.findFirstRow(
        session,
        where: (t) => t.name.equals(roleName) & t.isActive.equals(true),
      );
      if (role != null) {
        roles.add(role);
      }
    }

    final permissions = <String>{};
    for (final role in roles) {
      permissions.addAll(role.permissions);
    }

    return permissions;
  }

  /// Require that user has a specific role
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to check
  /// [roleName] - Role name required
  /// 
  /// Throws AuthorizationError if user doesn't have the role
  Future<void> requireRole(
    Session session,
    UuidValue userId,
    String roleName,
  ) async {
    final hasRole = await this.hasRole(session, userId, roleName);
    if (!hasRole) {
      throw AuthorizationError(
        'User does not have required role: $roleName',
        details: {
          'userId': userId.toString(),
          'requiredRole': roleName,
        },
      );
    }
  }

  /// Require that user has a specific permission
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to check
  /// [permissionName] - Permission name required
  /// 
  /// Throws AuthorizationError if user doesn't have the permission
  Future<void> requirePermission(
    Session session,
    UuidValue userId,
    String permissionName,
  ) async {
    final hasPermission = await this.hasPermission(session, userId, permissionName);
    if (!hasPermission) {
      throw AuthorizationError(
        'User does not have required permission: $permissionName',
        details: {
          'userId': userId.toString(),
          'requiredPermission': permissionName,
        },
      );
    }
  }
}
