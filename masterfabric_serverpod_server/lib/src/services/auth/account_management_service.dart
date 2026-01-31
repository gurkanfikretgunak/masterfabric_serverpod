import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../core/errors/error_types.dart';
import 'auth_helper_service.dart';
import 'session_management_service.dart';

/// Account status information
class AccountStatus {
  final bool isActive;
  final bool isBlocked;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;

  AccountStatus({
    required this.isActive,
    required this.isBlocked,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
  });
}

/// Account management service
/// 
/// Handles account operations including deactivation, reactivation, and deletion.
class AccountManagementService {
  final AuthHelperService _authHelper = AuthHelperService();
  final SessionManagementService _sessionService = SessionManagementService();

  /// Get account status
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Returns AccountStatus
  /// 
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if user not found
  Future<AccountStatus> getAccountStatus(
    Session session, {
    UuidValue? userId,
  }) async {
    final targetUserId = userId ?? await _authHelper.requireAuth(session);

    final authUser = await AuthUser.db.findById(session, targetUserId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': targetUserId.toString()},
      );
    }

    // Check if account is deleted (soft delete - we'll use blocked flag for now)
    // In a real implementation, you might have a separate deleted flag
    final isDeleted = authUser.blocked; // Using blocked as deleted indicator
    final isBlocked = authUser.blocked;
    final isActive = !isBlocked;

    return AccountStatus(
      isActive: isActive,
      isBlocked: isBlocked,
      isDeleted: isDeleted,
      createdAt: authUser.createdAt,
    );
  }

  /// Deactivate user account
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if user not found
  Future<void> deactivateAccount(
    Session session, {
    UuidValue? userId,
  }) async {
    final targetUserId = userId ?? await _authHelper.requireAuth(session);

    // If deactivating own account, require authentication
    if (userId == null) {
      await _authHelper.requireAuth(session);
    }

    final authUser = await AuthUser.db.findById(session, targetUserId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': targetUserId.toString()},
      );
    }

    // Block the user account (deactivation)
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: targetUserId,
      blocked: true,
    );

    // Revoke all sessions for the user
    try {
      final sessions = await _sessionService.getActiveSessions(session);
      for (final sessionInfo in sessions) {
        if (sessionInfo.userId == targetUserId) {
          await _sessionService.revokeSession(session, sessionInfo.id);
        }
      }
    } catch (e) {
      // Log but don't fail if session revocation fails
      session.log(
        'Failed to revoke sessions during deactivation: $e',
        level: LogLevel.warning,
      );
    }

    session.log(
      'Account deactivated - userId: ${targetUserId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Reactivate user account
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to reactivate
  /// 
  /// Throws AuthenticationError if not authenticated (admin only)
  /// Throws NotFoundError if user not found
  Future<void> reactivateAccount(
    Session session,
    UuidValue userId,
  ) async {
    // Require authentication (admin should call this)
    await _authHelper.requireAuth(session);

    final authUser = await AuthUser.db.findById(session, userId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': userId.toString()},
      );
    }

    // Unblock the user account (reactivation)
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: userId,
      blocked: false,
    );

    session.log(
      'Account reactivated - userId: ${userId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Delete user account (soft delete)
  /// 
  /// [session] - Serverpod session
  /// [confirmation] - Confirmation string (must be "DELETE" to confirm)
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Throws ValidationError if confirmation is incorrect
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if user not found
  Future<void> deleteAccount(
    Session session, {
    required String confirmation,
    UuidValue? userId,
  }) async {
    // Require confirmation
    if (confirmation != 'DELETE') {
      throw ValidationError(
        'Account deletion requires confirmation. Send "DELETE" as confirmation.',
        details: {'field': 'confirmation'},
      );
    }

    final targetUserId = userId ?? await _authHelper.requireAuth(session);

    // If deleting own account, require authentication
    if (userId == null) {
      await _authHelper.requireAuth(session);
    }

    final authUser = await AuthUser.db.findById(session, targetUserId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': targetUserId.toString()},
      );
    }

    // Soft delete: Block the account and mark as deleted
    // In a real implementation, you might want to:
    // 1. Set a deleted flag
    // 2. Anonymize user data
    // 3. Keep data for a recovery period
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: targetUserId,
      blocked: true,
    );

    // Revoke all sessions
    try {
      final sessions = await _sessionService.getActiveSessions(session);
      for (final sessionInfo in sessions) {
        if (sessionInfo.userId == targetUserId) {
          await _sessionService.revokeSession(session, sessionInfo.id);
        }
      }
    } catch (e) {
      session.log(
        'Failed to revoke sessions during deletion: $e',
        level: LogLevel.warning,
      );
    }

    session.log(
      'Account deleted - userId: ${targetUserId.toString()}',
      level: LogLevel.info,
    );
  }
}
