import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/integrations/integration_manager.dart';
import '../config/auth_config_service.dart';
import '../email/email_service.dart';
import 'verification_channel_router.dart';

/// Service for handling verification codes (OTP)
/// 
/// Uses secure hashing to store codes so they cannot be guessed from the database.
/// The code is hashed with SHA-256 using a secret salt, user ID, and purpose
/// for additional security.
/// 
/// Supports multi-channel delivery:
/// - Email (default)
/// - Telegram Bot API
/// - WhatsApp Business Cloud API
/// - SMS (future)
class VerificationService {
  final VerificationCodeConfig _config;
  final Random _random = Random.secure();
  final VerificationChannelRouter? _channelRouter;

  /// Create a new VerificationService with the given configuration
  /// 
  /// [config] - Verification code configuration
  /// [integrationManager] - Integration manager for multi-channel delivery
  /// [emailService] - Email service for sending verification emails
  VerificationService({
    VerificationCodeConfig? config,
    IntegrationManager? integrationManager,
    EmailService? emailService,
  })  : _config = config ?? VerificationCodeConfig(),
        _channelRouter = VerificationChannelRouter(
          integrationManager: integrationManager,
          emailService: emailService,
        );

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
  /// [channel] - Delivery channel (optional, defaults to user's preferred or email)
  /// [email] - Email address (required for email channel)
  /// [phoneNumber] - Phone number (required for WhatsApp/SMS)
  /// [telegramChatId] - Telegram chat ID (required for Telegram)
  /// 
  /// Returns the generated code (in production, this would be sent via email/SMS)
  Future<VerificationResponse> requestVerificationCode(
    Session session,
    String userId,
    String purpose, {
    VerificationChannel? channel,
    String? email,
    String? phoneNumber,
    String? telegramChatId,
  }) async {
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

    // Determine the delivery channel
    VerificationChannel deliveryChannel = channel ?? VerificationChannel.email;
    String? userLocale;
    
    // If no channel specified, try to get user's preferred channel
    if (channel == null && _channelRouter != null) {
      deliveryChannel = await _channelRouter!.getBestChannelForUser(session, userId);
      
      // Get user preferences to populate delivery details
      final prefs = await _channelRouter!.getUserPreferences(session, userId);
      if (prefs != null) {
        phoneNumber ??= prefs.phoneNumber;
        telegramChatId ??= prefs.telegramChatId;
        userLocale = prefs.locale;
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
      'Verification code generated - userId: $userId, purpose: $purpose, codeLength: ${_config.codeLength}, channel: ${deliveryChannel.name}',
      level: LogLevel.info,
    );

    // Send code via the selected channel
    String deliveryMessage = 'Verification code sent.';
    
    if (_channelRouter != null) {
      try {
        final sent = await _channelRouter!.sendCode(
          session: session,
          channel: deliveryChannel,
          code: code,
          userId: userId,
          purpose: purpose,
          email: email,
          phoneNumber: phoneNumber,
          telegramChatId: telegramChatId,
          locale: userLocale,
          expiresInMinutes: _config.expirationMinutes,
        );
        
        if (sent) {
          deliveryMessage = _getDeliveryMessage(deliveryChannel);
        } else {
          deliveryMessage = 'Verification code sent (delivery status unknown).';
        }
      } catch (e) {
        session.log(
          'Failed to send verification code via ${deliveryChannel.name}: $e',
          level: LogLevel.error,
        );
        // Fall back to logging the code for development
        session.log(
          'VERIFICATION CODE (DEV ONLY): $code',
          level: LogLevel.warning,
        );
        deliveryMessage = 'Verification code generated. Check your logs for development.';
      }
    } else {
      // No channel router - log for development
      session.log(
        'VERIFICATION CODE (DEV ONLY): $code',
        level: LogLevel.warning,
      );
    }

    return VerificationResponse(
      success: true,
      message: deliveryMessage,
      expiresInSeconds: _config.expirationMinutes * 60,
      resendCooldownSeconds: _config.resendCooldownSeconds,
    );
  }

  /// Get delivery message based on channel
  String _getDeliveryMessage(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return 'Verification code sent to your email.';
      case VerificationChannel.telegram:
        return 'Verification code sent via Telegram.';
      case VerificationChannel.whatsapp:
        return 'Verification code sent via WhatsApp.';
      case VerificationChannel.sms:
        return 'Verification code sent via SMS.';
    }
  }

  /// Get available verification channels
  List<VerificationChannel> getAvailableChannels() {
    return _channelRouter?.getAvailableChannels() ?? [VerificationChannel.email];
  }

  /// Check if a channel is available
  bool isChannelAvailable(VerificationChannel channel) {
    return _channelRouter?.isChannelAvailable(channel) ?? (channel == VerificationChannel.email);
  }

  /// Get user's verification preferences
  Future<UserVerificationPreferences?> getUserPreferences(
    Session session,
    String userId,
  ) async {
    return _channelRouter?.getUserPreferences(session, userId);
  }

  /// Save user's verification preferences
  Future<UserVerificationPreferences?> saveUserPreferences(
    Session session,
    UserVerificationPreferences preferences,
  ) async {
    return _channelRouter?.saveUserPreferences(session, preferences);
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
