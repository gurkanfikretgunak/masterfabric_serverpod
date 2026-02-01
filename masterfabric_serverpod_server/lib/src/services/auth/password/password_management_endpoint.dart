import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/base_error_handler.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/logging/core_logger.dart';
import 'password_management_service.dart';

/// Endpoint for password management
/// 
/// Provides endpoints for changing passwords and validating password strength.
class PasswordManagementEndpoint extends Endpoint {
  final PasswordManagementService _passwordService = PasswordManagementService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Change user password
  /// 
  /// [session] - Serverpod session
  /// [currentPassword] - Current password for verification
  /// [newPassword] - New password
  /// 
  /// Throws ValidationError if password validation fails
  /// Throws AuthenticationError if current password is incorrect
  Future<void> changePassword(
    Session session, {
    required String currentPassword,
    required String newPassword,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Password change requested');

      await _passwordService.changePassword(
        session,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      logger.info('Password changed successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to change password: ${e.toString()}',
      );
    }
  }

  /// Validate password strength
  /// 
  /// [session] - Serverpod session
  /// [password] - Password to validate
  /// 
  /// Returns PasswordStrengthResponse with validation result
  Future<PasswordStrengthResponse> validatePasswordStrength(
    Session session, {
    required String password,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.debug('Password strength validation requested');

      final strength = _passwordService.validatePassword(password);

      return PasswordStrengthResponse(
        isValid: strength.isValid,
        score: strength.score,
        issues: strength.issues,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      throw InternalServerError(
        'Failed to validate password strength: ${e.toString()}',
      );
    }
  }
}
