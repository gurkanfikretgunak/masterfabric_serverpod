import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../core/errors/error_types.dart';
import 'auth_helper_service.dart';
import 'rbac_service.dart';

/// User information model
class UserInfo {
  final UuidValue id;
  final DateTime createdAt;
  final bool blocked;
  final String? email;
  final String? fullName;
  final String? userName;

  UserInfo({
    required this.id,
    required this.createdAt,
    required this.blocked,
    this.email,
    this.fullName,
    this.userName,
  });
}

/// User management service
/// 
/// Handles user management operations for administrators.
class UserManagementService {
  final AuthHelperService _authHelper = AuthHelperService();
  final RbacService _rbacService = RbacService();

  /// List users with pagination and filtering
  /// 
  /// [session] - Serverpod session
  /// [page] - Page number (1-based)
  /// [pageSize] - Number of items per page
  /// [search] - Optional search term (searches email, username, fullName)
  /// [blocked] - Optional filter by blocked status
  /// 
  /// Returns list of UserInfo
  /// 
  /// Throws AuthenticationError if not authenticated
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<List<UserInfo>> listUsers(
    Session session, {
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? blocked,
  }) async {
    // Require admin permission
    final currentUserId = await _authHelper.requireAuth(session);
    await _rbacService.requirePermission(
      session,
      currentUserId,
      'admin.manage_users',
    );

    // Get all auth users
    // Note: Serverpod doesn't have a direct listUsers method,
    // so we'll query AuthUser table directly
    final users = <UserInfo>[];

    // Build where clause - use blocked filter or null (all users)
    WhereExpressionBuilder<AuthUserTable>? whereBuilder;
    if (blocked != null) {
      whereBuilder = (t) => t.blocked.equals(blocked);
    }

    // Get auth users with pagination
    final authUsers = await AuthUser.db.find(
      session,
      where: whereBuilder,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: pageSize,
      offset: (page - 1) * pageSize,
    );

    // Get profiles for users and apply search filter
    for (final authUser in authUsers) {
      final authUserId = authUser.id;
      if (authUserId == null) continue;
      
      final profile = await AuthServices.instance.userProfiles.maybeFindUserProfileByUserId(
        session,
        authUserId,
      );

      // Apply search filter if provided
      if (search != null && search.isNotEmpty) {
        final searchLower = search.toLowerCase();
        final matchesEmail = profile?.email?.toLowerCase().contains(searchLower) ?? false;
        final matchesUserName = profile?.userName?.toLowerCase().contains(searchLower) ?? false;
        final matchesFullName = profile?.fullName?.toLowerCase().contains(searchLower) ?? false;
        
        if (!matchesEmail && !matchesUserName && !matchesFullName) {
          continue; // Skip this user if doesn't match search
        }
      }

      users.add(UserInfo(
        id: authUserId,
        createdAt: authUser.createdAt,
        blocked: authUser.blocked,
        email: profile?.email,
        fullName: profile?.fullName,
        userName: profile?.userName,
      ));
    }

    return users;
  }

  /// Get user by ID
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// 
  /// Returns UserInfo if found
  /// 
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<UserInfo> getUser(
    Session session,
    UuidValue userId,
  ) async {
    // Require admin permission
    final currentUserId = await _authHelper.requireAuth(session);
    await _rbacService.requirePermission(
      session,
      currentUserId,
      'admin.manage_users',
    );

    final authUser = await AuthUser.db.findById(session, userId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': userId.toString()},
      );
    }

    final profile = await AuthServices.instance.userProfiles.maybeFindUserProfileByUserId(
      session,
      userId,
    );

    return UserInfo(
      id: userId,
      createdAt: authUser.createdAt,
      blocked: authUser.blocked,
      email: profile?.email,
      fullName: profile?.fullName,
      userName: profile?.userName,
    );
  }

  /// Block or unblock a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [blocked] - Whether to block (true) or unblock (false)
  /// 
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<void> blockUser(
    Session session,
    UuidValue userId,
    bool blocked,
  ) async {
    // Require admin permission
    final currentUserId = await _authHelper.requireAuth(session);
    await _rbacService.requirePermission(
      session,
      currentUserId,
      'admin.manage_users',
    );

    // Prevent blocking yourself
    if (userId == currentUserId) {
      throw ValidationError(
        'Cannot block your own account',
        details: {'userId': userId.toString()},
      );
    }

    final authUser = await AuthUser.db.findById(session, userId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': userId.toString()},
      );
    }

    await AuthServices.instance.authUsers.update(
      session,
      authUserId: userId,
      blocked: blocked,
    );

    session.log(
      'User ${blocked ? "blocked" : "unblocked"} - userId: ${userId.toString()}, blockedBy: ${currentUserId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Delete a user (soft delete)
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to delete
  /// 
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<void> deleteUser(
    Session session,
    UuidValue userId,
  ) async {
    // Require admin permission
    final currentUserId = await _authHelper.requireAuth(session);
    await _rbacService.requirePermission(
      session,
      currentUserId,
      'admin.manage_users',
    );

    // Prevent deleting yourself
    if (userId == currentUserId) {
      throw ValidationError(
        'Cannot delete your own account',
        details: {'userId': userId.toString()},
      );
    }

    // Soft delete: Block the user
    await blockUser(session, userId, true);

    session.log(
      'User deleted (soft delete) - userId: ${userId.toString()}, deletedBy: ${currentUserId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Update user roles
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleNames] - List of role names to assign
  /// 
  /// Throws NotFoundError if user or role not found
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<void> updateUserRoles(
    Session session,
    UuidValue userId,
    List<String> roleNames,
  ) async {
    // Require admin permission
    final currentUserId = await _authHelper.requireAuth(session);
    await _rbacService.requirePermission(
      session,
      currentUserId,
      'admin.manage_users',
    );

    // Get current roles
    final currentRoles = await _rbacService.getUserRoles(session, userId);

    // Roles to add
    final rolesToAdd = roleNames.where((r) => !currentRoles.contains(r)).toList();

    // Roles to remove
    final rolesToRemove = currentRoles.where((r) => !roleNames.contains(r)).toList();

    // Add new roles
    for (final roleName in rolesToAdd) {
      await _rbacService.assignRole(
        session,
        userId,
        roleName,
        assignedBy: currentUserId,
      );
    }

    // Remove old roles
    for (final roleName in rolesToRemove) {
      await _rbacService.revokeRole(session, userId, roleName);
    }

    session.log(
      'User roles updated - userId: ${userId.toString()}, addedRoles: $rolesToAdd, removedRoles: $rolesToRemove, updatedBy: ${currentUserId.toString()}',
      level: LogLevel.info,
    );
  }
}
