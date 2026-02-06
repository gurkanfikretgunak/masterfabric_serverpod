import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/integrations/integration_manager.dart';
import '../email/email_service.dart';
import 'verification_service.dart';
import 'verification_channel_router.dart';

/// Endpoint for managing verification channel preferences
///
/// Provides API for:
/// - Getting available verification channels
/// - Getting user's current preferences
/// - Updating verification preferences
/// - Linking Telegram account
/// - Verifying phone number for WhatsApp
class VerificationPreferencesEndpoint extends MasterfabricEndpoint {
  IntegrationManager? _integrationManager;
  EmailService? _emailService;
  VerificationService? _verificationService;

  VerificationService get verificationService {
    _verificationService ??= VerificationService(
      integrationManager: _integrationManager,
      emailService: _emailService,
    );
    return _verificationService!;
  }

  VerificationChannelRouter get channelRouter {
    return VerificationChannelRouter(
      integrationManager: _integrationManager,
      emailService: _emailService,
    );
  }

  /// Get available verification channels
  ///
  /// Returns a list of channels that are currently enabled
  Future<List<VerificationChannel>> getAvailableChannels(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getAvailableChannels',
      handler: () async {
        return channelRouter.getAvailableChannels();
      },
    );
  }

  /// Get current user's verification preferences
  ///
  /// Returns the user's current preferences or null if not set
  Future<UserVerificationPreferences?> getPreferences(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getPreferences',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        return channelRouter.getUserPreferences(session, auth.userIdentifier.toString());
      },
    );
  }

  /// Update verification preferences
  ///
  /// [preferredChannel] - Preferred channel for verification codes
  /// [backupChannel] - Optional backup channel
  /// [phoneNumber] - Phone number for Telegram/WhatsApp (E.164 format)
  /// [locale] - Preferred locale for verification messages (e.g., 'en', 'tr', 'de', 'es')
  ///
  /// Returns the updated preferences
  Future<UserVerificationPreferences> updatePreferences(
    Session session, {
    required VerificationChannel preferredChannel,
    VerificationChannel? backupChannel,
    String? phoneNumber,
    String? locale,
  }) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'updatePreferences',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        final userId = auth.userIdentifier.toString();

        // Get existing preferences or create new
        final existing = await channelRouter.getUserPreferences(session, userId);

        // Validate phone number format if provided
        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          if (!_isValidPhoneNumber(phoneNumber)) {
            throw ValidationError('Invalid phone number format. Use E.164 format (e.g., +14155551234)');
          }
        }

        // Validate locale if provided
        if (locale != null && locale.isNotEmpty) {
          final validLocales = ['en', 'tr', 'de', 'es'];
          if (!validLocales.contains(locale)) {
            throw ValidationError('Invalid locale. Supported locales: ${validLocales.join(", ")}');
          }
        }

        final preferences = UserVerificationPreferences(
          id: existing?.id,
          userId: userId,
          preferredChannel: preferredChannel,
          backupChannel: backupChannel,
          phoneNumber: phoneNumber ?? existing?.phoneNumber,
          telegramChatId: existing?.telegramChatId,
          telegramLinked: existing?.telegramLinked ?? false,
          whatsappVerified: existing?.whatsappVerified ?? false,
          locale: locale ?? existing?.locale,
          createdAt: existing?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return await channelRouter.saveUserPreferences(session, preferences);
      },
    );
  }

  /// Generate Telegram linking code
  ///
  /// Returns a one-time code that user sends to the bot to link their account
  Future<VerificationResponse> generateTelegramLinkCode(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'generateTelegramLinkCode',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        final userId = auth.userIdentifier.toString();

        // Generate a verification code for telegram linking
        return verificationService.requestVerificationCode(
          session,
          userId,
          'telegram_link',
          channel: VerificationChannel.email, // Send via email for now
        );
      },
    );
  }

  /// Link Telegram account using chat ID
  ///
  /// Called when user sends /start command with linking code to bot
  /// This would typically be called from a webhook handler
  ///
  /// [code] - The linking code user sent to the bot
  /// [chatId] - Telegram chat ID from the message
  Future<bool> linkTelegramAccount(
    Session session,
    String code,
    String chatId,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'linkTelegramAccount',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        final userId = auth.userIdentifier.toString();

        // Verify the linking code
        final isValid = await verificationService.verifyCode(
          session,
          userId,
          code,
          'telegram_link',
        );

        if (!isValid) {
          throw ValidationError('Invalid linking code');
        }

        // Update preferences with Telegram chat ID
        final existing = await channelRouter.getUserPreferences(session, userId);

        final preferences = UserVerificationPreferences(
          id: existing?.id,
          userId: userId,
          preferredChannel: existing?.preferredChannel ?? VerificationChannel.email,
          backupChannel: existing?.backupChannel,
          phoneNumber: existing?.phoneNumber,
          telegramChatId: chatId,
          telegramLinked: true,
          whatsappVerified: existing?.whatsappVerified ?? false,
          locale: existing?.locale,
          createdAt: existing?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await channelRouter.saveUserPreferences(session, preferences);

        session.log(
          'Telegram account linked for user $userId',
          level: LogLevel.info,
        );

        return true;
      },
    );
  }

  /// Unlink Telegram account
  Future<bool> unlinkTelegramAccount(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'unlinkTelegramAccount',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        final userId = auth.userIdentifier.toString();
        final existing = await channelRouter.getUserPreferences(session, userId);

        if (existing == null || !existing.telegramLinked) {
          throw ValidationError('Telegram account not linked');
        }

        final preferences = existing.copyWith(
          telegramChatId: null,
          telegramLinked: false,
          updatedAt: DateTime.now(),
        );

        await channelRouter.saveUserPreferences(session, preferences);

        return true;
      },
    );
  }

  /// Send verification code to phone number for WhatsApp
  ///
  /// [phoneNumber] - Phone number in E.164 format
  Future<VerificationResponse> sendPhoneVerificationCode(
    Session session,
    String phoneNumber,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'sendPhoneVerificationCode',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        // Validate phone number
        if (!_isValidPhoneNumber(phoneNumber)) {
          throw ValidationError('Invalid phone number format. Use E.164 format (e.g., +14155551234)');
        }

        // Request verification code via WhatsApp
        return verificationService.requestVerificationCode(
          session,
          auth.userIdentifier.toString(),
          'phone_verification',
          channel: VerificationChannel.whatsapp,
          phoneNumber: phoneNumber,
        );
      },
    );
  }

  /// Verify phone number with code
  ///
  /// [phoneNumber] - Phone number that was verified
  /// [code] - Verification code received via WhatsApp
  Future<bool> verifyPhoneNumber(
    Session session,
    String phoneNumber,
    String code,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'verifyPhoneNumber',
      handler: () async {
        final auth = session.authenticated;
        if (auth == null) {
          throw AuthenticationError('User not authenticated');
        }

        final userId = auth.userIdentifier.toString();

        // Verify the code
        final isValid = await verificationService.verifyCode(
          session,
          userId,
          code,
          'phone_verification',
        );

        if (!isValid) {
          throw ValidationError('Invalid verification code');
        }

        // Update preferences with verified phone number
        final existing = await channelRouter.getUserPreferences(session, userId);

        final preferences = UserVerificationPreferences(
          id: existing?.id,
          userId: userId,
          preferredChannel: existing?.preferredChannel ?? VerificationChannel.email,
          backupChannel: existing?.backupChannel,
          phoneNumber: phoneNumber,
          telegramChatId: existing?.telegramChatId,
          telegramLinked: existing?.telegramLinked ?? false,
          whatsappVerified: true,
          locale: existing?.locale,
          createdAt: existing?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await channelRouter.saveUserPreferences(session, preferences);

        session.log(
          'Phone number verified for user $userId',
          level: LogLevel.info,
        );

        return true;
      },
    );
  }

  /// Get Telegram bot info for user to link account
  ///
  /// Returns the bot username and URL for user to start conversation
  Future<Map<String, String?>> getTelegramBotInfo(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getTelegramBotInfo',
      handler: () async {
        final telegram = _integrationManager?.telegram;

        return {
          'botUsername': telegram?.botUsername,
          'botUrl': telegram?.botUrl,
          'available': (telegram?.enabled ?? false).toString(),
        };
      },
    );
  }

  /// Validate E.164 phone number format
  bool _isValidPhoneNumber(String phoneNumber) {
    // E.164 format: +[country code][number]
    // Length: 7-15 digits total (including country code)
    final e164Regex = RegExp(r'^\+[1-9]\d{6,14}$');
    return e164Regex.hasMatch(phoneNumber);
  }
}
