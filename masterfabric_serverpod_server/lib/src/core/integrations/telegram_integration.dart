import 'dart:convert';
import 'dart:io';
import 'base_integration.dart';

/// Telegram Bot API integration for sending verification codes
///
/// Provides integration with Telegram Bot API for sending verification codes
/// and notifications to users via Telegram.
///
/// Usage:
/// 1. Create a bot via @BotFather on Telegram
/// 2. Get the bot token
/// 3. Configure in YAML with botToken
/// 4. Users must start conversation with bot first to receive messages
class TelegramIntegration extends BaseIntegration {
  final bool _enabled;
  final String? _botToken;
  final String? _botUsername;
  final Map<String, dynamic> _config;

  /// Base URL for Telegram Bot API
  static const String _baseUrl = 'https://api.telegram.org';

  /// HTTP client for API calls
  HttpClient? _httpClient;

  TelegramIntegration({
    required bool enabled,
    String? botToken,
    String? botUsername,
    Map<String, dynamic>? additionalConfig,
  })  : _enabled = enabled,
        _botToken = botToken,
        _botUsername = botUsername,
        _config = additionalConfig ?? {};

  @override
  bool get enabled => _enabled;

  @override
  String get name => 'telegram';

  /// Get bot username (without @)
  String? get botUsername => _botUsername;

  /// Get the bot URL for users to start chat
  String? get botUrl => _botUsername != null ? 'https://t.me/$_botUsername' : null;

  @override
  Map<String, dynamic> getConfig() {
    return {
      'enabled': _enabled,
      'hasBotToken': _botToken != null && _botToken!.isNotEmpty,
      'botUsername': _botUsername,
      'botUrl': botUrl,
      ..._config,
    };
  }

  @override
  Future<void> initialize() async {
    if (!_enabled) {
      return;
    }

    if (_botToken == null || _botToken!.isEmpty) {
      throw Exception('Telegram bot token is required when Telegram integration is enabled');
    }

    // Initialize HTTP client
    _httpClient = HttpClient();

    // Verify bot token by calling getMe
    try {
      final botInfo = await _callApi('getMe');
      if (botInfo['ok'] != true) {
        throw Exception('Invalid Telegram bot token');
      }
      print('[TelegramIntegration] Bot initialized: @${botInfo['result']['username']}');
    } catch (e) {
      throw Exception('Failed to initialize Telegram bot: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _httpClient?.close();
    _httpClient = null;
  }

  @override
  Future<bool> isHealthy() async {
    if (!_enabled) {
      return true;
    }

    try {
      final response = await _callApi('getMe');
      return response['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Call Telegram Bot API
  ///
  /// [method] - API method name (e.g., 'sendMessage', 'getMe')
  /// [params] - Optional parameters for the method
  ///
  /// Returns the JSON response from Telegram API
  Future<Map<String, dynamic>> _callApi(
    String method, [
    Map<String, dynamic>? params,
  ]) async {
    if (_httpClient == null) {
      throw Exception('Telegram integration not initialized');
    }

    final uri = Uri.parse('$_baseUrl/bot$_botToken/$method');

    try {
      final request = await _httpClient!.postUrl(uri);
      request.headers.contentType = ContentType.json;

      if (params != null) {
        request.write(jsonEncode(params));
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        throw Exception('Telegram API error: ${response.statusCode} - $responseBody');
      }

      return jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to call Telegram API: $e');
    }
  }

  /// Send a message to a Telegram user
  ///
  /// [chatId] - Telegram chat ID (user must have started conversation with bot)
  /// [text] - Message text
  /// [parseMode] - Optional parse mode ('HTML' or 'Markdown')
  ///
  /// Returns true if message was sent successfully
  Future<bool> sendMessage({
    required String chatId,
    required String text,
    String? parseMode,
  }) async {
    if (!_enabled) {
      print('[TelegramIntegration] Message not sent (disabled):');
      print('  Chat ID: $chatId');
      print('  Text: $text');
      return false;
    }

    try {
      final params = {
        'chat_id': chatId,
        'text': text,
        if (parseMode != null) 'parse_mode': parseMode,
      };

      final response = await _callApi('sendMessage', params);
      return response['ok'] == true;
    } catch (e) {
      print('[TelegramIntegration] Failed to send message: $e');
      return false;
    }
  }

  /// Send a verification code to a user via Telegram
  ///
  /// [chatId] - Telegram chat ID
  /// [code] - Verification code
  /// [purpose] - Purpose of verification (e.g., 'login', 'profile_update')
  /// [expiresInMinutes] - Code expiration time
  ///
  /// Returns true if code was sent successfully
  Future<bool> sendVerificationCode({
    required String chatId,
    required String code,
    String purpose = 'verification',
    int expiresInMinutes = 5,
  }) async {
    final purposeText = _getPurposeText(purpose);

    final message = '''
🔐 *MasterFabric Verification Code*

Your verification code for $purposeText is:

`$code`

⏱ This code will expire in $expiresInMinutes minutes.

⚠️ Do not share this code with anyone.
''';

    return sendMessage(
      chatId: chatId,
      text: message,
      parseMode: 'Markdown',
    );
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

  /// Get updates from Telegram (for webhook setup or polling)
  ///
  /// This can be used to receive messages from users,
  /// particularly the /start command to get their chat ID.
  Future<List<Map<String, dynamic>>> getUpdates({
    int? offset,
    int? limit,
    int? timeout,
  }) async {
    if (!_enabled) {
      return [];
    }

    try {
      final params = {
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (timeout != null) 'timeout': timeout,
      };

      final response = await _callApi('getUpdates', params.isNotEmpty ? params : null);

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(response['result'] ?? []);
      }

      return [];
    } catch (e) {
      print('[TelegramIntegration] Failed to get updates: $e');
      return [];
    }
  }

  /// Set up a webhook for receiving updates
  ///
  /// [url] - HTTPS URL to receive webhook updates
  /// [secretToken] - Optional secret token for webhook verification
  Future<bool> setWebhook({
    required String url,
    String? secretToken,
  }) async {
    if (!_enabled) {
      return false;
    }

    try {
      final params = {
        'url': url,
        if (secretToken != null) 'secret_token': secretToken,
      };

      final response = await _callApi('setWebhook', params);
      return response['ok'] == true;
    } catch (e) {
      print('[TelegramIntegration] Failed to set webhook: $e');
      return false;
    }
  }

  /// Delete the webhook
  Future<bool> deleteWebhook() async {
    if (!_enabled) {
      return false;
    }

    try {
      final response = await _callApi('deleteWebhook');
      return response['ok'] == true;
    } catch (e) {
      print('[TelegramIntegration] Failed to delete webhook: $e');
      return false;
    }
  }

  /// Send a message with inline keyboard for user interaction
  ///
  /// [chatId] - Telegram chat ID
  /// [text] - Message text
  /// [buttons] - List of button rows, each row is a list of buttons
  ///             Each button is a map with 'text' and 'callback_data' or 'url'
  Future<bool> sendMessageWithKeyboard({
    required String chatId,
    required String text,
    required List<List<Map<String, String>>> buttons,
    String? parseMode,
  }) async {
    if (!_enabled) {
      return false;
    }

    try {
      final inlineKeyboard = buttons
          .map((row) => row
              .map((button) => {
                    'text': button['text'],
                    if (button.containsKey('url')) 'url': button['url'],
                    if (button.containsKey('callback_data'))
                      'callback_data': button['callback_data'],
                  })
              .toList())
          .toList();

      final params = {
        'chat_id': chatId,
        'text': text,
        'reply_markup': {
          'inline_keyboard': inlineKeyboard,
        },
        if (parseMode != null) 'parse_mode': parseMode,
      };

      final response = await _callApi('sendMessage', params);
      return response['ok'] == true;
    } catch (e) {
      print('[TelegramIntegration] Failed to send message with keyboard: $e');
      return false;
    }
  }
}
