import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/error_types.dart';
import '../config/auth_config_service.dart';

/// Service for handling verification codes (OTP)
/// 
/// Uses secure hashing to store codes so they cannot be guessed from the database.
/// The code is hashed with SHA-256 using a secret salt, user ID, and purpose
/// for additional security.
class VerificationService {
  final VerificationCodeConfig _config;
  final Random _random = Random.secure();

  /// Create a new VerificationService with the given configuration
  VerificationService({VerificationCodeConfig? config})
      : _config = config ?? VerificationCodeConfig();

  /// Configuration getters for external access
  int get codeLength => _config.codeLength;
  int get expirationMinutes => _config.expirationMinutes;
  int get resendCooldownSeconds => _config.resendCooldownSeconds;

  /// Alphanumeric character set for more secure codes
  static const _alphanumericChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Generate a random verification code
  /// 
  /// If [useAlphanumeric] is true in config, generates an alphanumeric code
  /// that is harder to guess (excludes confusing characters like 0/O, 1/I/L)
  String _generateCode() {
    if (_config.useAlphanumeric) {
      return List.generate(
        _config.codeLength,
        (_) => _alphanumericChars[_random.nextInt(_alphanumericChars.length)],
      ).join();
    }
    return List.generate(_config.codeLength, (_) => _random.nextInt(10)).join();
  }

  /// Get the secret salt, preferring passwords.yaml over config
  /// 
  /// Looks for 'verificationCodeSecretSalt' in session.passwords first,
  /// then falls back to the config secretSalt value.
  String _getSecretSalt(Session session) {
    // Try to get from passwords.yaml first (more secure)
    final passwordSalt = session.passwords['verificationCodeSecretSalt'];
    if (passwordSalt != null && passwordSalt.isNotEmpty) {
      return passwordSalt;
    }
    // Fall back to config value
    return _config.secretSalt;
  }

  /// Hash the verification code with salt for secure storage
  /// 
  /// Uses SHA-256 with the secret salt, user ID, and purpose to create
  /// a unique hash that cannot be reversed or guessed.
  String _hashCode(String code, String userId, String purpose, String secretSalt) {
    final data = '$secretSalt:$userId:$purpose:$code';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify if a code matches its hash
  bool _verifyCodeHash(String code, String hash, String userId, String purpose, String secretSalt) {
    final computedHash = _hashCode(code, userId, purpose, secretSalt);
    // Use constant-time comparison to prevent timing attacks
    if (computedHash.length != hash.length) return false;
    var result = 0;
    for (var i = 0; i < computedHash.length; i++) {
      result |= computedHash.codeUnitAt(i) ^ hash.codeUnitAt(i);
    }
    return result == 0;
  }

  /// Request a verification code for profile update
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [purpose] - Purpose of verification (e.g., 'profile_update')
  /// 
  /// Returns the generated code (in production, this would be sent via email/SMS)
  Future<VerificationResponse> requestVerificationCode(
    Session session,
    String userId,
    String purpose,
  ) async {
    // Check for cooldown - find the most recent code
    final recentCodes = await VerificationCode.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.purpose.equals(purpose),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 1,
    );

    if (recentCodes.isNotEmpty) {
      final lastCode = recentCodes.first;
      final secondsSinceLastCode = DateTime.now().difference(lastCode.createdAt).inSeconds;
      
      if (secondsSinceLastCode < _config.resendCooldownSeconds) {
        final remainingCooldown = _config.resendCooldownSeconds - secondsSinceLastCode;
        return VerificationResponse(
          success: false,
          message: 'Please wait before requesting a new code.',
          expiresInSeconds: null,
          resendCooldownSeconds: remainingCooldown,
        );
      }
    }

    // Invalidate any existing codes for this user and purpose
    await _invalidateExistingCodes(session, userId, purpose);

    // Generate new code
    final code = _generateCode();
    final now = DateTime.now();
    final expiresAt = now.add(Duration(minutes: _config.expirationMinutes));

    // Get secret salt from passwords.yaml or config
    final secretSalt = _getSecretSalt(session);

    // Hash the code for secure storage - the plain code is never stored
    final hashedCode = _hashCode(code, userId, purpose, secretSalt);

    // Store the hashed code
    final verificationCode = VerificationCode(
      userId: userId,
      code: hashedCode, // Store hash, not plain code
      purpose: purpose,
      expiresAt: expiresAt,
      used: false,
      createdAt: now,
    );

    await VerificationCode.db.insertRow(session, verificationCode);

    session.log(
      'Verification code generated - userId: $userId, purpose: $purpose, codeLength: ${_config.codeLength}',
      level: LogLevel.info,
    );

    // In production, send this code via email/SMS
    // For now, we'll log it (REMOVE IN PRODUCTION!)
    session.log(
      'VERIFICATION CODE (DEV ONLY): $code',
      level: LogLevel.warning,
    );

    return VerificationResponse(
      success: true,
      message: 'Verification code sent. Check your email.',
      expiresInSeconds: _config.expirationMinutes * 60,
      resendCooldownSeconds: _config.resendCooldownSeconds,
    );
  }

  /// Verify a code
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [code] - Code to verify (plain text from user input)
  /// [purpose] - Purpose of verification
  /// 
  /// Returns true if code is valid
  /// Throws ValidationError if code is invalid or expired
  Future<bool> verifyCode(
    Session session,
    String userId,
    String code,
    String purpose,
  ) async {
    // Normalize code input (trim whitespace, uppercase for alphanumeric)
    final normalizedCode = _config.useAlphanumeric 
        ? code.trim().toUpperCase() 
        : code.trim();

    // Find all unused codes for this user and purpose
    // We can't query by hash directly since we need to hash with the same params
    final codes = await VerificationCode.db.find(
      session,
      where: (t) => t.userId.equals(userId) & 
                    t.purpose.equals(purpose) &
                    t.used.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: _config.maxAttempts, // Limit to prevent DoS
    );

    if (codes.isEmpty) {
      throw ValidationError(
        'Invalid verification code',
        details: {'reason': 'code_not_found'},
      );
    }

    // Get secret salt from passwords.yaml or config
    final secretSalt = _getSecretSalt(session);

    // Find a matching code by comparing hashes
    VerificationCode? matchedCode;
    for (final storedCode in codes) {
      // Check if expired first
      if (DateTime.now().isAfter(storedCode.expiresAt)) {
        continue; // Skip expired codes
      }
      
      // Verify the hash matches
      if (_verifyCodeHash(normalizedCode, storedCode.code, userId, purpose, secretSalt)) {
        matchedCode = storedCode;
        break;
      }
    }

    if (matchedCode == null) {
      session.log(
        'Verification code failed - userId: $userId, purpose: $purpose',
        level: LogLevel.warning,
      );
      throw ValidationError(
        'Invalid verification code',
        details: {'reason': 'code_invalid_or_expired'},
      );
    }

    // Mark as used
    final updated = matchedCode.copyWith(used: true);
    await VerificationCode.db.updateRow(session, updated);

    session.log(
      'Verification code verified - userId: $userId, purpose: $purpose',
      level: LogLevel.info,
    );

    return true;
  }

  /// Invalidate existing codes for a user and purpose
  Future<void> _invalidateExistingCodes(
    Session session,
    String userId,
    String purpose,
  ) async {
    final existingCodes = await VerificationCode.db.find(
      session,
      where: (t) => t.userId.equals(userId) & 
                    t.purpose.equals(purpose) &
                    t.used.equals(false),
    );

    for (final code in existingCodes) {
      await VerificationCode.db.updateRow(
        session,
        code.copyWith(used: true),
      );
    }
  }

  /// Clean up expired codes (call periodically)
  Future<int> cleanupExpiredCodes(Session session) async {
    final expiredCodes = await VerificationCode.db.find(
      session,
      where: (t) => t.expiresAt < DateTime.now(),
    );

    for (final code in expiredCodes) {
      await VerificationCode.db.deleteRow(session, code);
    }

    return expiredCodes.length;
  }
}
