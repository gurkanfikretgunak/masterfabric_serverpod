import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/errors/base_error_handler.dart';
import '../../core/errors/error_types.dart';
import '../../core/logging/core_logger.dart';
import 'two_factor_service.dart';
import 'auth_helper_service.dart';

/// Endpoint for two-factor authentication
/// 
/// Provides endpoints for enabling, disabling, and managing 2FA.
class TwoFactorEndpoint extends Endpoint {
  final TwoFactorService _twoFactorService = TwoFactorService();
  final AuthHelperService _authHelper = AuthHelperService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Check if 2FA is enabled
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns true if 2FA is enabled
  Future<bool> isTwoFactorEnabled(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.debug('2FA status check requested');

      final enabled = await _twoFactorService.isTwoFactorEnabled(session);

      return enabled;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to check 2FA status: ${e.toString()}',
      );
    }
  }

  /// Start 2FA setup (generate secret and QR code)
  /// 
  /// [session] - Serverpod session
  /// [email] - User email (for QR code label)
  /// 
  /// Returns TwoFactorSetupResponse with secret, QR code URI, and backup codes
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<TwoFactorSetupResponse> startSetup(
    Session session,
    String email,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('2FA setup started', context: {'email': email});

      final twoFactorSecret = await _twoFactorService.enableTwoFactor(
        session,
        email,
      );

      final qrCodeUri = _twoFactorService.generateQrCodeUri(
        twoFactorSecret.secret,
        email,
      );

      logger.info('2FA setup initiated successfully');

      return TwoFactorSetupResponse(
        secret: twoFactorSecret.secret,
        qrCodeUri: qrCodeUri,
        backupCodes: twoFactorSecret.backupCodes,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to start 2FA setup: ${e.toString()}',
      );
    }
  }

  /// Verify TOTP code and complete 2FA setup
  /// 
  /// [session] - Serverpod session
  /// [code] - TOTP code from authenticator app
  /// 
  /// Throws ValidationError if code is invalid
  /// Throws AuthenticationError if not authenticated
  Future<void> verifyAndEnable(
    Session session,
    String code,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('2FA verification requested');

      await _twoFactorService.verifyAndEnableTwoFactor(session, code);

      logger.info('2FA enabled successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to verify and enable 2FA: ${e.toString()}',
      );
    }
  }

  /// Disable 2FA
  /// 
  /// [session] - Serverpod session
  /// [verificationCode] - TOTP code or backup code for verification
  /// 
  /// Throws ValidationError if verification code is invalid
  /// Throws AuthenticationError if not authenticated
  Future<void> disable(
    Session session,
    String verificationCode,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('2FA disable requested');

      await _twoFactorService.disableTwoFactor(session, verificationCode);

      logger.info('2FA disabled successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to disable 2FA: ${e.toString()}',
      );
    }
  }

  /// Get backup codes
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns list of backup codes
  /// 
  /// Throws NotFoundError if 2FA is not enabled
  Future<List<String>> getBackupCodes(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Backup codes requested');

      final backupCodes = await _twoFactorService.getBackupCodes(session);

      logger.info('Backup codes retrieved', context: {
        'count': backupCodes.length,
      });

      return backupCodes;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get backup codes: ${e.toString()}',
      );
    }
  }

  /// Regenerate backup codes
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns new list of backup codes
  /// 
  /// Throws NotFoundError if 2FA is not enabled
  Future<List<String>> regenerateBackupCodes(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Backup codes regeneration requested');

      final backupCodes = await _twoFactorService.regenerateBackupCodes(session);

      logger.info('Backup codes regenerated successfully', context: {
        'count': backupCodes.length,
      });

      return backupCodes;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to regenerate backup codes: ${e.toString()}',
      );
    }
  }
}
