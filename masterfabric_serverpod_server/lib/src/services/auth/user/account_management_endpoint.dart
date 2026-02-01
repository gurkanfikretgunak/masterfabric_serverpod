import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/base_error_handler.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/logging/core_logger.dart';
import 'account_management_service.dart';

/// Endpoint for account management
/// 
/// Provides endpoints for managing user accounts (deactivate, reactivate, delete).
class AccountManagementEndpoint extends Endpoint {
  final AccountManagementService _accountService = AccountManagementService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Get account status
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Returns AccountStatusResponse
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<AccountStatusResponse> getAccountStatus(
    Session session, {
    String? userId,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Account status requested', context: {
        if (userId != null) 'userId': userId,
      });

      final status = await _accountService.getAccountStatus(
        session,
        userId: userId != null ? UuidValue.fromString(userId) : null,
      );

      logger.info('Account status retrieved');

      return AccountStatusResponse(
        isActive: status.isActive,
        isBlocked: status.isBlocked,
        isDeleted: status.isDeleted,
        deletedAt: status.deletedAt,
        createdAt: status.createdAt,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get account status: ${e.toString()}',
      );
    }
  }

  /// Deactivate user account
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<void> deactivateAccount(
    Session session, {
    String? userId,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Account deactivation requested', context: {
        if (userId != null) 'userId': userId,
      });

      await _accountService.deactivateAccount(
        session,
        userId: userId != null ? UuidValue.fromString(userId) : null,
      );

      logger.info('Account deactivated successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to deactivate account: ${e.toString()}',
      );
    }
  }

  /// Reactivate user account
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to reactivate
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<void> reactivateAccount(
    Session session,
    String userId,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Account reactivation requested', context: {
        'userId': userId,
      });

      await _accountService.reactivateAccount(
        session,
        UuidValue.fromString(userId),
      );

      logger.info('Account reactivated successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to reactivate account: ${e.toString()}',
      );
    }
  }

  /// Delete user account (soft delete)
  /// 
  /// [session] - Serverpod session
  /// [confirmation] - Confirmation string (must be "DELETE" to confirm)
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Throws ValidationError if confirmation is incorrect
  /// Throws AuthenticationError if not authenticated
  Future<void> deleteAccount(
    Session session, {
    required String confirmation,
    String? userId,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Account deletion requested', context: {
        if (userId != null) 'userId': userId,
      });

      await _accountService.deleteAccount(
        session,
        confirmation: confirmation,
        userId: userId != null ? UuidValue.fromString(userId) : null,
      );

      logger.info('Account deleted successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to delete account: ${e.toString()}',
      );
    }
  }
}
