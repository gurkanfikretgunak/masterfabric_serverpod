import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/error_types.dart';
import '../core/auth_helper_service.dart';

/// Two-factor authentication service
/// 
/// Handles TOTP-based two-factor authentication with QR codes and backup codes.
class TwoFactorService {
  final AuthHelperService _authHelper = AuthHelperService();
  final Random _random = Random.secure();

  /// Generate a secret key for TOTP
  /// 
  /// Returns a base32-encoded secret key
  String _generateSecret() {
    // Generate 20 random bytes (160 bits) for TOTP secret
    final bytes = List<int>.generate(20, (_) => _random.nextInt(256));
    // Convert to base32
    return _base32Encode(bytes);
  }

  /// Base32 encode bytes
  String _base32Encode(List<int> bytes) {
    const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final result = StringBuffer();
    
    int buffer = 0;
    int bitsLeft = 0;
    
    for (final byte in bytes) {
      buffer = (buffer << 8) | byte;
      bitsLeft += 8;
      
      while (bitsLeft >= 5) {
        result.write(base32Chars[(buffer >> (bitsLeft - 5)) & 0x1F]);
        bitsLeft -= 5;
      }
    }
    
    if (bitsLeft > 0) {
      result.write(base32Chars[(buffer << (5 - bitsLeft)) & 0x1F]);
    }
    
    return result.toString();
  }

  /// Generate backup codes
  /// 
  /// [count] - Number of backup codes to generate (default: 10)
  /// 
  /// Returns list of backup codes
  List<String> _generateBackupCodes({int count = 10}) {
    return List.generate(count, (_) {
      // Generate 8-digit backup codes
      return (10000000 + _random.nextInt(90000000)).toString();
    });
  }

  /// Generate QR code URI for authenticator apps
  /// 
  /// [secret] - TOTP secret key
  /// [email] - User email
  /// [issuer] - Issuer name (default: "MasterFabric")
  /// 
  /// Returns QR code URI string
  String generateQrCodeUri(
    String secret,
    String email, {
    String issuer = 'MasterFabric',
  }) {
    // Format: otpauth://totp/{issuer}:{email}?secret={secret}&issuer={issuer}
    final uri = 'otpauth://totp/$issuer:$email?secret=$secret&issuer=$issuer&algorithm=SHA1&digits=6&period=30';
    return uri;
  }

  /// Enable 2FA for a user
  /// 
  /// [session] - Serverpod session
  /// [email] - User email (for QR code label)
  /// 
  /// Returns TwoFactorSecret with secret and backup codes
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<TwoFactorSecret> enableTwoFactor(
    Session session,
    String email,
  ) async {
    final userId = await _authHelper.requireAuth(session);
    await _authHelper.requireNotBlocked(session);

    // Check if 2FA is already enabled
    final existing = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId.toString()) & t.enabled.equals(true),
    );

    if (existing != null) {
      throw ValidationError(
        'Two-factor authentication is already enabled',
        details: {'userId': userId.toString()},
      );
    }

    // Generate secret and backup codes
    final secret = _generateSecret();
    final backupCodes = _generateBackupCodes();

    // Create or update TwoFactorSecret
    final twoFactorSecret = TwoFactorSecret(
      userId: userId.toString(),
      secret: secret,
      backupCodes: backupCodes,
      enabled: false, // Will be enabled after verification
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final created = await TwoFactorSecret.db.insertRow(session, twoFactorSecret);

    session.log(
      '2FA setup initiated - userId: ${userId.toString()}',
      level: LogLevel.info,
    );

    return created;
  }

  /// Verify TOTP code and enable 2FA
  /// 
  /// [session] - Serverpod session
  /// [code] - TOTP code from authenticator app
  /// 
  /// Throws ValidationError if code is invalid
  /// Throws AuthenticationError if not authenticated
  Future<void> verifyAndEnableTwoFactor(
    Session session,
    String code,
  ) async {
    final userId = await _authHelper.requireAuth(session);

    // Get pending 2FA secret
    final twoFactorSecret = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId.toString()) & t.enabled.equals(false),
    );

    if (twoFactorSecret == null) {
      throw NotFoundError(
        'Two-factor authentication setup not found. Please start the setup process first.',
      );
    }

    // Verify TOTP code
    final isValid = verifyTotpCode(twoFactorSecret.secret, code);

    if (!isValid) {
      throw ValidationError(
        'Invalid verification code',
        details: {'field': 'code'},
      );
    }

    // Enable 2FA
    final updated = TwoFactorSecret(
      id: twoFactorSecret.id,
      userId: twoFactorSecret.userId,
      secret: twoFactorSecret.secret,
      backupCodes: twoFactorSecret.backupCodes,
      enabled: true,
      createdAt: twoFactorSecret.createdAt,
      updatedAt: DateTime.now(),
    );

    await TwoFactorSecret.db.updateRow(session, updated);

    session.log(
      '2FA enabled successfully - userId: ${userId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Verify TOTP code
  /// 
  /// [secret] - TOTP secret key
  /// [code] - TOTP code to verify
  /// 
  /// Returns true if code is valid, false otherwise
  /// 
  /// Note: This is a placeholder implementation. Install totp_generator package
  /// and uncomment the TOTP verification logic.
  bool verifyTotpCode(String secret, String code) {
    // TODO: Implement TOTP verification once totp_generator package is installed
    // For now, return false to prevent unauthorized access
    // When package is installed, use:
    // TOTPGenerator.generateTOTP(secret, timestamp, algorithm: Algorithm.SHA1, length: 6, period: 30)
    return false;
  }

  /// Verify backup code
  /// 
  /// [session] - Serverpod session
  /// [backupCode] - Backup code to verify
  /// 
  /// Returns true if backup code is valid, false otherwise
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<bool> verifyBackupCode(
    Session session,
    String backupCode,
  ) async {
    final userId = await _authHelper.requireAuth(session);

    final twoFactorSecret = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId.toString()) & t.enabled.equals(true),
    );

    if (twoFactorSecret == null) {
      return false;
    }

    // Check if backup code exists
    if (!twoFactorSecret.backupCodes.contains(backupCode)) {
      return false;
    }

    // Remove used backup code
    final updatedBackupCodes = twoFactorSecret.backupCodes
        .where((code) => code != backupCode)
        .toList();

    final updated = TwoFactorSecret(
      id: twoFactorSecret.id,
      userId: twoFactorSecret.userId,
      secret: twoFactorSecret.secret,
      backupCodes: updatedBackupCodes,
      enabled: twoFactorSecret.enabled,
      createdAt: twoFactorSecret.createdAt,
      updatedAt: DateTime.now(),
    );

    await TwoFactorSecret.db.updateRow(session, updated);

    session.log(
      'Backup code used - userId: ${userId.toString()}',
      level: LogLevel.info,
    );

    return true;
  }

  /// Disable 2FA for a user
  /// 
  /// [session] - Serverpod session
  /// [verificationCode] - TOTP code or backup code for verification
  /// 
  /// Throws ValidationError if verification code is invalid
  /// Throws AuthenticationError if not authenticated
  Future<void> disableTwoFactor(
    Session session,
    String verificationCode,
  ) async {
    final userId = await _authHelper.requireAuth(session);

    final twoFactorSecret = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId.toString()) & t.enabled.equals(true),
    );

    if (twoFactorSecret == null) {
      throw NotFoundError('Two-factor authentication is not enabled');
    }

    // Verify code (TOTP or backup)
    final isValidTotp = verifyTotpCode(twoFactorSecret.secret, verificationCode);
    final isValidBackup = twoFactorSecret.backupCodes.contains(verificationCode);

    if (!isValidTotp && !isValidBackup) {
      throw ValidationError(
        'Invalid verification code',
        details: {'field': 'verificationCode'},
      );
    }

    // Delete 2FA secret
    await TwoFactorSecret.db.deleteRow(session, twoFactorSecret);

    session.log(
      '2FA disabled - userId: ${userId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Check if 2FA is enabled for a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  /// 
  /// Returns true if 2FA is enabled, false otherwise
  Future<bool> isTwoFactorEnabled(
    Session session, {
    UuidValue? userId,
  }) async {
    final targetUserId = userId ?? await _authHelper.requireAuth(session);

    final twoFactorSecret = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(targetUserId.toString()) & t.enabled.equals(true),
    );

    return twoFactorSecret != null;
  }

  /// Get backup codes for a user
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns list of backup codes
  /// 
  /// Throws NotFoundError if 2FA is not enabled
  /// Throws AuthenticationError if not authenticated
  Future<List<String>> getBackupCodes(Session session) async {
    final userId = await _authHelper.requireAuth(session);

    final twoFactorSecret = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId.toString()) & t.enabled.equals(true),
    );

    if (twoFactorSecret == null) {
      throw NotFoundError('Two-factor authentication is not enabled');
    }

    return twoFactorSecret.backupCodes;
  }

  /// Regenerate backup codes
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns new list of backup codes
  /// 
  /// Throws NotFoundError if 2FA is not enabled
  /// Throws AuthenticationError if not authenticated
  Future<List<String>> regenerateBackupCodes(Session session) async {
    final userId = await _authHelper.requireAuth(session);

    final twoFactorSecret = await TwoFactorSecret.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId.toString()) & t.enabled.equals(true),
    );

    if (twoFactorSecret == null) {
      throw NotFoundError('Two-factor authentication is not enabled');
    }

    // Generate new backup codes
    final newBackupCodes = _generateBackupCodes();

    final updated = TwoFactorSecret(
      id: twoFactorSecret.id,
      userId: twoFactorSecret.userId,
      secret: twoFactorSecret.secret,
      backupCodes: newBackupCodes,
      enabled: twoFactorSecret.enabled,
      createdAt: twoFactorSecret.createdAt,
      updatedAt: DateTime.now(),
    );

    await TwoFactorSecret.db.updateRow(session, updated);

    session.log(
      'Backup codes regenerated - userId: ${userId.toString()}',
      level: LogLevel.info,
    );

    return newBackupCodes;
  }
}
