import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/integrations/integration_manager.dart';
import '../../../core/logging/core_logger.dart';
import '../email/email_service.dart';

/// Service for routing verification codes to the appropriate delivery channel
///
/// Supports multiple delivery channels:
/// - Email (default)
/// - Telegram Bot API
/// - WhatsApp Business Cloud API
/// - SMS (future)
///
/// The router selects the channel based on user preferences and handles
/// fallback to email if the preferred channel is unavailable.
class VerificationChannelRouter {
  final IntegrationManager? _integrationManager;
  final EmailService? _emailService;

  VerificationChannelRouter({
    IntegrationManager? integrationManager,
    EmailService? emailService,
  })  : _integrationManager = integrationManager,
        _emailService = emailService;

  /// Send a verification code via the specified channel
  ///
  /// [session] - Serverpod session
  /// [channel] - Delivery channel to use
  /// [code] - Verification code to send
  /// [userId] - User ID for logging
  /// [purpose] - Purpose of verification (e.g., 'profile_update')
  /// [email] - Email address (required for email channel)
  /// [phoneNumber] - Phone number (required for Telegram/WhatsApp/SMS)
  /// [telegramChatId] - Telegram chat ID (required for Telegram)
  /// [locale] - Preferred locale for messages (e.g., 'en', 'tr')
  /// [expiresInMinutes] - Code expiration time
  ///
  /// Returns true if code was sent successfully
  Future<bool> sendCode({
    required Session session,
    required VerificationChannel channel,
    required String code,
    required String userId,
    required String purpose,
    String? email,
    String? phoneNumber,
    String? telegramChatId,
    String? locale,
    int expiresInMinutes = 5,
  }) async {
    final logger = CoreLogger(session);

    logger.info('Sending verification code', context: {
      'channel': channel.name,
      'userId': userId,
      'purpose': purpose,
    });

    try {
      switch (channel) {
        case VerificationChannel.email:
          return await _sendViaEmail(
            session,
            email: email!,
            code: code,
            purpose: purpose,
            locale: locale,
            expiresInMinutes: expiresInMinutes,
          );

        case VerificationChannel.telegram:
          return await _sendViaTelegram(
            session,
            chatId: telegramChatId!,
            code: code,
            purpose: purpose,
            expiresInMinutes: expiresInMinutes,
          );

        case VerificationChannel.whatsapp:
          return await _sendViaWhatsApp(
            session,
            phoneNumber: phoneNumber!,
            code: code,
            purpose: purpose,
            expiresInMinutes: expiresInMinutes,
          );

        case VerificationChannel.sms:
          // SMS is not yet implemented
          logger.warning('SMS channel not yet implemented, falling back to log');
          _logCodeForDevelopment(session, code, purpose);
          return true;
      }
    } catch (e) {
      logger.error('Failed to send verification code via $channel', context: {
        'error': e.toString(),
        'userId': userId,
      });

      // Rethrow for caller to handle
      rethrow;
    }
  }

  /// Send verification code via email
  Future<bool> _sendViaEmail(
    Session session, {
    required String email,
    required String code,
    required String purpose,
    String? locale,
    required int expiresInMinutes,
  }) async {
    if (_emailService != null) {
      // Use email service
      await _emailService!.sendVerificationCode(
        session,
        to: email,
        code: code,
        purpose: purpose,
        locale: locale,
        expiresInMinutes: expiresInMinutes,
      );
      return true;
    }

    // Fallback to direct email integration
    final emailIntegration = _integrationManager?.email;
    if (emailIntegration != null && emailIntegration.enabled) {
      final subject = _getEmailSubject(purpose);
      final body = _buildEmailBody(code, purpose, expiresInMinutes);
      final htmlBody = _buildEmailHtmlBody(code, purpose, expiresInMinutes);

      await emailIntegration.sendEmail(
        to: email,
        subject: subject,
        body: body,
        htmlBody: htmlBody,
      );
      return true;
    }

    // Development fallback - log the code
    _logCodeForDevelopment(session, code, purpose);
    return true;
  }

  /// Send verification code via Telegram Bot API
  Future<bool> _sendViaTelegram(
    Session session, {
    required String chatId,
    required String code,
    required String purpose,
    required int expiresInMinutes,
  }) async {
    final telegramIntegration = _integrationManager?.telegram;

    if (telegramIntegration == null || !telegramIntegration.enabled) {
      session.log(
        'Telegram integration not enabled, falling back to log',
        level: LogLevel.warning,
      );
      _logCodeForDevelopment(session, code, purpose);
      return true;
    }

    return await telegramIntegration.sendVerificationCode(
      chatId: chatId,
      code: code,
      purpose: purpose,
      expiresInMinutes: expiresInMinutes,
    );
  }

  /// Send verification code via WhatsApp Business Cloud API
  Future<bool> _sendViaWhatsApp(
    Session session, {
    required String phoneNumber,
    required String code,
    required String purpose,
    required int expiresInMinutes,
  }) async {
    final whatsappIntegration = _integrationManager?.whatsapp;

    if (whatsappIntegration == null || !whatsappIntegration.enabled) {
      session.log(
        'WhatsApp integration not enabled, falling back to log',
        level: LogLevel.warning,
      );
      _logCodeForDevelopment(session, code, purpose);
      return true;
    }

    final messageId = await whatsappIntegration.sendVerificationCode(
      to: phoneNumber,
      code: code,
      expiresInMinutes: expiresInMinutes,
    );

    return messageId != null;
  }

  /// Log code for development (when integrations are disabled)
  void _logCodeForDevelopment(Session session, String code, String purpose) {
    session.log(
      'VERIFICATION CODE (DEV ONLY): $code for $purpose',
      level: LogLevel.warning,
    );
  }

  /// Get email subject based on purpose
  String _getEmailSubject(String purpose) {
    switch (purpose) {
      case 'login':
        return 'Your Login Verification Code';
      case 'profile_update':
        return 'Verify Your Profile Update';
      case 'password_reset':
        return 'Reset Your Password';
      case 'phone_verification':
        return 'Verify Your Phone Number';
      case 'registration':
        return 'Complete Your Registration';
      default:
        return 'Your Verification Code';
    }
  }

  /// Build plain text email body
  String _buildEmailBody(String code, String purpose, int expiresInMinutes) {
    final purposeText = _getPurposeText(purpose);
    return '''
Your verification code for $purposeText is: $code

This code will expire in $expiresInMinutes minutes.

If you did not request this code, please ignore this email.

Best regards,
The MasterFabric Team
''';
  }

  /// Build HTML email body
  String _buildEmailHtmlBody(String code, String purpose, int expiresInMinutes) {
    final purposeText = _getPurposeText(purpose);
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { text-align: center; margin-bottom: 30px; }
    .code-box { background: #f5f5f5; border-radius: 8px; padding: 20px; text-align: center; margin: 20px 0; }
    .code { font-size: 32px; font-weight: bold; letter-spacing: 4px; color: #2563eb; font-family: monospace; }
    .footer { text-align: center; font-size: 12px; color: #666; margin-top: 30px; }
    .warning { font-size: 14px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>🔐 Verification Code</h2>
    </div>
    <p>Your verification code for <strong>$purposeText</strong> is:</p>
    <div class="code-box">
      <span class="code">$code</span>
    </div>
    <p class="warning">⏱ This code will expire in <strong>$expiresInMinutes minutes</strong>.</p>
    <p class="warning">⚠️ Do not share this code with anyone.</p>
    <div class="footer">
      <p>If you did not request this code, please ignore this email.</p>
      <p>Best regards,<br>The MasterFabric Team</p>
    </div>
  </div>
</body>
</html>
''';
  }

  /// Get human-readable purpose text
  String _getPurposeText(String purpose) {
    switch (purpose) {
      case 'login':
        return 'logging in';
      case 'profile_update':
        return 'updating your profile';
      case 'password_reset':
        return 'resetting your password';
      case 'phone_verification':
        return 'verifying your phone number';
      case 'registration':
        return 'completing your registration';
      default:
        return 'your request';
    }
  }

  /// Get available channels based on enabled integrations
  List<VerificationChannel> getAvailableChannels() {
    final channels = <VerificationChannel>[VerificationChannel.email];

    if (_integrationManager?.telegram?.enabled == true) {
      channels.add(VerificationChannel.telegram);
    }

    if (_integrationManager?.whatsapp?.enabled == true) {
      channels.add(VerificationChannel.whatsapp);
    }

    // SMS would be added here when implemented
    // if (_integrationManager?.sms?.enabled == true) {
    //   channels.add(VerificationChannel.sms);
    // }

    return channels;
  }

  /// Check if a specific channel is available
  bool isChannelAvailable(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return true; // Email is always available (fallback to log)
      case VerificationChannel.telegram:
        return _integrationManager?.telegram?.enabled == true;
      case VerificationChannel.whatsapp:
        return _integrationManager?.whatsapp?.enabled == true;
      case VerificationChannel.sms:
        return false; // Not yet implemented
    }
  }

  /// Get user verification preferences
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID
  ///
  /// Returns the user's preferences or null if not set
  Future<UserVerificationPreferences?> getUserPreferences(
    Session session,
    String userId,
  ) async {
    final preferences = await UserVerificationPreferences.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return preferences;
  }

  /// Save or update user verification preferences
  ///
  /// [session] - Serverpod session
  /// [preferences] - Preferences to save
  ///
  /// Returns the saved preferences
  Future<UserVerificationPreferences> saveUserPreferences(
    Session session,
    UserVerificationPreferences preferences,
  ) async {
    final existing = await getUserPreferences(session, preferences.userId);

    if (existing != null) {
      final updated = preferences.copyWith(
        id: existing.id,
        updatedAt: DateTime.now(),
      );
      return await UserVerificationPreferences.db.updateRow(session, updated);
    } else {
      final newPrefs = preferences.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await UserVerificationPreferences.db.insertRow(session, newPrefs);
    }
  }

  /// Get the best available channel for a user
  ///
  /// Returns the user's preferred channel if available,
  /// falls back to backup channel, then email.
  Future<VerificationChannel> getBestChannelForUser(
    Session session,
    String userId,
  ) async {
    final preferences = await getUserPreferences(session, userId);

    if (preferences != null) {
      // Check preferred channel
      if (isChannelAvailable(preferences.preferredChannel)) {
        // Verify channel is properly configured for user
        if (_isChannelConfiguredForUser(preferences, preferences.preferredChannel)) {
          return preferences.preferredChannel;
        }
      }

      // Check backup channel
      if (preferences.backupChannel != null &&
          isChannelAvailable(preferences.backupChannel!)) {
        if (_isChannelConfiguredForUser(preferences, preferences.backupChannel!)) {
          return preferences.backupChannel!;
        }
      }
    }

    // Default to email
    return VerificationChannel.email;
  }

  /// Check if a channel is properly configured for a user
  bool _isChannelConfiguredForUser(
    UserVerificationPreferences preferences,
    VerificationChannel channel,
  ) {
    switch (channel) {
      case VerificationChannel.email:
        return true; // Email is always available via auth
      case VerificationChannel.telegram:
        return preferences.telegramLinked &&
            preferences.telegramChatId != null &&
            preferences.telegramChatId!.isNotEmpty;
      case VerificationChannel.whatsapp:
        return preferences.whatsappVerified &&
            preferences.phoneNumber != null &&
            preferences.phoneNumber!.isNotEmpty;
      case VerificationChannel.sms:
        return preferences.phoneNumber != null &&
            preferences.phoneNumber!.isNotEmpty;
    }
  }
}
