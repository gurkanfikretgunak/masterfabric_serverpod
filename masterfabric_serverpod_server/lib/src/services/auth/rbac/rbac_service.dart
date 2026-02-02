import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/error_types.dart';
import 'default_roles.dart';

/// RBAC (Role-Based Access Control) service
/// 
/// Handles role and permission management for users.
///
/// ## Default Roles
/// 
/// The system includes the following default roles:
/// - `public`: For unauthenticated/public access
/// - `user`: Default role for all authenticated users (assigned on signup)
/// - `moderator`: Content moderation access
/// - `admin`: Full system access
///
/// ## Usage
/// 
/// ```dart
/// final rbacService = RbacService();
/// 
/// // Seed default roles on server startup
/// await rbacService.seedDefaultRoles(session);
/// 
/// // Assign default role to new user
/// await rbacService.assignDefaultRoleToUser(session, userId);
/// 
/// // Check user role
/// final hasAdmin = await rbacService.hasRole(session, userId, 'admin');
/// ```
class RbacService {
  /// Flag to track if default roles have been seeded
  static bool _defaultRolesSeeded = false;

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

  // ============================================================
  // DEFAULT ROLES MANAGEMENT
  // ============================================================

  /// Seed default roles into the database
  /// 
  /// This should be called once during server startup.
  /// It creates the default roles (public, user, moderator, admin)
  /// if they don't already exist.
  /// 
  /// [session] - Serverpod session
  /// [force] - If true, update existing roles with default permissions
  /// 
  /// Returns the number of roles created/updated
  Future<int> seedDefaultRoles(Session session, {bool force = false}) async {
    if (_defaultRolesSeeded && !force) {
      session.log(
        'Default roles already seeded, skipping...',
        level: LogLevel.debug,
      );
      return 0;
    }

    int count = 0;
    final now = DateTime.now();

    for (final config in DefaultRoleConfig.defaults) {
      // Check if role already exists
      final existing = await Role.db.findFirstRow(
        session,
        where: (t) => t.name.equals(config.name),
      );

      if (existing != null) {
        if (force) {
          // Update existing role
          final updated = existing.copyWith(
            description: config.description,
            permissions: config.permissions,
            isActive: config.isActive,
            updatedAt: now,
          );
          await Role.db.updateRow(session, updated);
          session.log(
            'Updated role: ${config.name}',
            level: LogLevel.info,
          );
          count++;
        } else {
          session.log(
            'Role already exists: ${config.name}',
            level: LogLevel.debug,
          );
        }
      } else {
        // Create new role
        final role = Role(
          name: config.name,
          description: config.description,
          permissions: config.permissions,
          createdAt: now,
          updatedAt: now,
          isActive: config.isActive,
        );
        await Role.db.insertRow(session, role);
        session.log(
          'Created role: ${config.name}',
          level: LogLevel.info,
        );
        count++;
      }
    }

    _defaultRolesSeeded = true;
    session.log(
      'Default roles seeded: $count roles created/updated',
      level: LogLevel.info,
    );

    return count;
  }

  /// Assign the default role to a user
  /// 
  /// This assigns the 'user' role to a new user.
  /// Should be called after user registration/signup.
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to assign the default role to
  /// [assignedBy] - Optional ID of user who triggered this (usually null for auto-assign)
  /// 
  /// Does not throw if user already has the role.
  Future<void> assignDefaultRoleToUser(
    Session session,
    UuidValue userId, {
    UuidValue? assignedBy,
  }) async {
    try {
      await assignRole(
        session,
        userId,
        DefaultRoles.defaultUserRole,
        assignedBy: assignedBy,
      );
      session.log(
        'Default role assigned to user: ${userId.toString()}',
        level: LogLevel.info,
      );
    } on ValidationError {
      // User already has the role - that's fine
      session.log(
        'User already has default role: ${userId.toString()}',
        level: LogLevel.debug,
      );
    } on NotFoundError {
      // Role doesn't exist - try to seed it first
      session.log(
        'Default role not found, seeding roles...',
        level: LogLevel.warning,
      );
      await seedDefaultRoles(session);
      // Try again
      await assignRole(
        session,
        userId,
        DefaultRoles.defaultUserRole,
        assignedBy: assignedBy,
      );
    }
  }

  /// Assign a role to a user if they don't already have it
  /// 
  /// Unlike [assignRole], this doesn't throw if user already has the role.
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to assign
  /// [assignedBy] - Optional user ID who assigned the role
  /// 
  /// Returns true if role was assigned, false if user already had it
  Future<bool> assignRoleIfNotExists(
    Session session,
    UuidValue userId,
    String roleName, {
    UuidValue? assignedBy,
  }) async {
    // Check if user already has this role
    final hasExisting = await hasRole(session, userId, roleName);
    if (hasExisting) {
      return false;
    }

    try {
      await assignRole(session, userId, roleName, assignedBy: assignedBy);
      return true;
    } on ValidationError {
      // User already has the role (race condition)
      return false;
    }
  }

  /// Get a role by name
  /// 
  /// [session] - Serverpod session
  /// [roleName] - Role name
  /// 
  /// Returns the Role or null if not found
  Future<Role?> getRoleByName(Session session, String roleName) async {
    return await Role.db.findFirstRow(
      session,
      where: (t) => t.name.equals(roleName) & t.isActive.equals(true),
    );
  }

  /// Get all available roles
  /// 
  /// [session] - Serverpod session
  /// [activeOnly] - If true, only return active roles
  /// 
  /// Returns list of all roles
  Future<List<Role>> getAllRoles(
    Session session, {
    bool activeOnly = true,
  }) async {
    if (activeOnly) {
      return await Role.db.find(
        session,
        where: (t) => t.isActive.equals(true),
        orderBy: (t) => t.name,
      );
    }
    return await Role.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  /// Check if a user has any of the specified roles
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to check
  /// [roleNames] - List of role names to check
  /// 
  /// Returns true if user has at least one of the roles
  Future<bool> hasAnyRole(
    Session session,
    UuidValue userId,
    List<String> roleNames,
  ) async {
    for (final roleName in roleNames) {
      if (await hasRole(session, userId, roleName)) {
        return true;
      }
    }
    return false;
  }

  /// Check if a user has all of the specified roles
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to check
  /// [roleNames] - List of role names to check
  /// 
  /// Returns true if user has all of the roles
  Future<bool> hasAllRoles(
    Session session,
    UuidValue userId,
    List<String> roleNames,
  ) async {
    for (final roleName in roleNames) {
      if (!await hasRole(session, userId, roleName)) {
        return false;
      }
    }
    return true;
  }
}
