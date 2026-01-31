import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/errors/base_error_handler.dart';
import '../../core/errors/error_types.dart';
import '../../core/logging/core_logger.dart';
import 'user_management_service.dart';

/// Endpoint for user management (admin features)
/// 
/// Provides endpoints for listing, viewing, blocking, and managing users.
class UserManagementEndpoint extends Endpoint {
  final UserManagementService _userService = UserManagementService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// List users with pagination and filtering
  /// 
  /// [session] - Serverpod session
  /// [page] - Page number (1-based)
  /// [pageSize] - Number of items per page
  /// [search] - Optional search term
  /// [blocked] - Optional filter by blocked status
  /// 
  /// Returns UserListResponse with paginated users
  /// 
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<UserListResponse> listUsers(
    Session session, {
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? blocked,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('User list requested', context: {
        'page': page,
        'pageSize': pageSize,
        if (search != null) 'search': search,
        if (blocked != null) 'blocked': blocked,
      });

      final users = await _userService.listUsers(
        session,
        page: page,
        pageSize: pageSize,
        search: search,
        blocked: blocked,
      );

      logger.info('User list retrieved', context: {
        'count': users.length,
      });

      return UserListResponse(
        users: users.map((u) => UserInfoResponse(
          id: u.id.toString(),
          createdAt: u.createdAt,
          blocked: u.blocked,
          email: u.email,
          fullName: u.fullName,
          userName: u.userName,
        )).toList(),
        total: users.length, // Note: This is page size, not total count
        page: page,
        pageSize: pageSize,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to list users: ${e.toString()}',
      );
    }
  }

  /// Get user by ID
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// 
  /// Returns UserInfoResponse
  /// 
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  Future<UserInfoResponse> getUser(
    Session session,
    String userId,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('User details requested', context: {
        'userId': userId,
      });

      final user = await _userService.getUser(
        session,
        UuidValue.fromString(userId),
      );

      logger.info('User details retrieved');

      return UserInfoResponse(
        id: user.id.toString(),
        createdAt: user.createdAt,
        blocked: user.blocked,
        email: user.email,
        fullName: user.fullName,
        userName: user.userName,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get user: ${e.toString()}',
      );
    }
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
    String userId,
    bool blocked,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('User block/unblock requested', context: {
        'userId': userId,
        'blocked': blocked,
      });

      await _userService.blockUser(
        session,
        UuidValue.fromString(userId),
        blocked,
      );

      logger.info('User ${blocked ? "blocked" : "unblocked"} successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to ${blocked ? "block" : "unblock"} user: ${e.toString()}',
      );
    }
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
    String userId,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('User deletion requested', context: {
        'userId': userId,
      });

      await _userService.deleteUser(
        session,
        UuidValue.fromString(userId),
      );

      logger.info('User deleted successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to delete user: ${e.toString()}',
      );
    }
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
    String userId,
    List<String> roleNames,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('User roles update requested', context: {
        'userId': userId,
        'roleNames': roleNames,
      });

      await _userService.updateUserRoles(
        session,
        UuidValue.fromString(userId),
        roleNames,
      );

      logger.info('User roles updated successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to update user roles: ${e.toString()}',
      );
    }
  }
}
