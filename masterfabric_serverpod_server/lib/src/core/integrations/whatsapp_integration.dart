import 'dart:convert';
import 'dart:io';
import 'base_integration.dart';

/// WhatsApp Business Cloud API integration for sending verification codes
///
/// Provides integration with WhatsApp Business Cloud API for sending
/// verification codes and notifications to users via WhatsApp.
///
/// Usage:
/// 1. Create a Meta Business account
/// 2. Set up WhatsApp Business API in Meta Business Suite
/// 3. Create an approved OTP message template
/// 4. Get Phone Number ID and Access Token
/// 5. Configure in YAML
///
/// Note: WhatsApp requires pre-approved message templates for OTP messages.
class WhatsAppIntegration extends BaseIntegration {
  final bool _enabled;
  final String? _phoneNumberId;
  final String? _accessToken;
  final String? _businessAccountId;
  final String? _otpTemplateName;
  final String? _otpTemplateLanguage;
  final String? _apiVersion;
  final Map<String, dynamic> _config;

  /// Base URL for WhatsApp Cloud API
  static const String _baseUrl = 'https://graph.facebook.com';

  /// HTTP client for API calls
  HttpClient? _httpClient;

  WhatsAppIntegration({
    required bool enabled,
    String? phoneNumberId,
    String? accessToken,
    String? businessAccountId,
    String? otpTemplateName,
    String? otpTemplateLanguage,
    String? apiVersion,
    Map<String, dynamic>? additionalConfig,
  })  : _enabled = enabled,
        _phoneNumberId = phoneNumberId,
        _accessToken = accessToken,
        _businessAccountId = businessAccountId,
        _otpTemplateName = otpTemplateName ?? 'verification_code',
        _otpTemplateLanguage = otpTemplateLanguage ?? 'en',
        _apiVersion = apiVersion ?? 'v18.0',
        _config = additionalConfig ?? {};

  @override
  bool get enabled => _enabled;

  @override
  String get name => 'whatsapp';

  /// Get the API version being used
  String get apiVersion => _apiVersion ?? 'v18.0';

  @override
  Map<String, dynamic> getConfig() {
    return {
      'enabled': _enabled,
      'hasPhoneNumberId': _phoneNumberId != null && _phoneNumberId!.isNotEmpty,
      'hasAccessToken': _accessToken != null && _accessToken!.isNotEmpty,
      'businessAccountId': _businessAccountId,
      'otpTemplateName': _otpTemplateName,
      'otpTemplateLanguage': _otpTemplateLanguage,
      'apiVersion': _apiVersion,
      ..._config,
    };
  }

  @override
  Future<void> initialize() async {
    if (!_enabled) {
      return;
    }

    if (_phoneNumberId == null || _phoneNumberId!.isEmpty) {
      throw Exception('WhatsApp Phone Number ID is required when WhatsApp integration is enabled');
    }

    if (_accessToken == null || _accessToken!.isEmpty) {
      throw Exception('WhatsApp Access Token is required when WhatsApp integration is enabled');
    }

    // Initialize HTTP client
    _httpClient = HttpClient();

    // Verify credentials by checking phone number info
    try {
      final phoneInfo = await _getPhoneNumberInfo();
      if (phoneInfo == null) {
        throw Exception('Invalid WhatsApp credentials or Phone Number ID');
      }
      print('[WhatsAppIntegration] Connected to WhatsApp: ${phoneInfo['display_phone_number']}');
    } catch (e) {
      throw Exception('Failed to initialize WhatsApp integration: $e');
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
      final phoneInfo = await _getPhoneNumberInfo();
      return phoneInfo != null;
    } catch (e) {
      return false;
    }
  }

  /// Get phone number information from WhatsApp API
  Future<Map<String, dynamic>?> _getPhoneNumberInfo() async {
    try {
      final uri = Uri.parse('$_baseUrl/$apiVersion/$_phoneNumberId');
      final request = await _httpClient!.getUrl(uri);
      request.headers.set('Authorization', 'Bearer $_accessToken');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Send a WhatsApp message using the Cloud API
  ///
  /// [to] - Recipient phone number with country code (e.g., '14155551234')
  /// [messageData] - Message payload according to WhatsApp API spec
  ///
  /// Returns the message ID if successful, null otherwise
  Future<String?> _sendMessage(String to, Map<String, dynamic> messageData) async {
    if (_httpClient == null) {
      throw Exception('WhatsApp integration not initialized');
    }

    final uri = Uri.parse('$_baseUrl/$apiVersion/$_phoneNumberId/messages');

    try {
      final request = await _httpClient!.postUrl(uri);
      request.headers.set('Authorization', 'Bearer $_accessToken');
      request.headers.contentType = ContentType.json;

      final payload = {
        'messaging_product': 'whatsapp',
        'recipient_type': 'individual',
        'to': _normalizePhoneNumber(to),
        ...messageData,
      };

      request.write(jsonEncode(payload));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final result = jsonDecode(responseBody) as Map<String, dynamic>;
        final messages = result['messages'] as List?;
        if (messages != null && messages.isNotEmpty) {
          return messages[0]['id'] as String?;
        }
      } else {
        print('[WhatsAppIntegration] API error: ${response.statusCode} - $responseBody');
      }

      return null;
    } catch (e) {
      print('[WhatsAppIntegration] Failed to send message: $e');
      return null;
    }
  }

  /// Normalize phone number to WhatsApp format
  ///
  /// Removes any non-digit characters and ensures proper format
  String _normalizePhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Remove leading zeros
    normalized = normalized.replaceFirst(RegExp(r'^0+'), '');

    return normalized;
  }

  /// Send a text message to a WhatsApp user
  ///
  /// [to] - Recipient phone number with country code
  /// [text] - Message text
  /// [previewUrl] - Whether to show URL preview (default: false)
  ///
  /// Returns the message ID if successful, null otherwise
  Future<String?> sendTextMessage({
    required String to,
    required String text,
    bool previewUrl = false,
  }) async {
    if (!_enabled) {
      print('[WhatsAppIntegration] Message not sent (disabled):');
      print('  To: $to');
      print('  Text: $text');
      return null;
    }

    return _sendMessage(to, {
      'type': 'text',
      'text': {
        'preview_url': previewUrl,
        'body': text,
      },
    });
  }

  /// Send a verification code using a pre-approved template
  ///
  /// [to] - Recipient phone number with country code
  /// [code] - Verification code
  /// [expiresInMinutes] - Code expiration time (for display)
  ///
  /// Note: This requires a pre-approved OTP template in your WhatsApp Business account.
  /// The template should have placeholders for the code and expiration time.
  ///
  /// Returns the message ID if successful, null otherwise
  Future<String?> sendVerificationCode({
    required String to,
    required String code,
    int expiresInMinutes = 5,
  }) async {
    if (!_enabled) {
      print('[WhatsAppIntegration] Verification code not sent (disabled):');
      print('  To: $to');
      print('  Code: $code');
      return null;
    }

    // Use template message for OTP (required by WhatsApp for verification codes)
    return _sendMessage(to, {
      'type': 'template',
      'template': {
        'name': _otpTemplateName,
        'language': {
          'code': _otpTemplateLanguage,
        },
        'components': [
          {
            'type': 'body',
            'parameters': [
              {
                'type': 'text',
                'text': code,
              },
              {
                'type': 'text',
                'text': '$expiresInMinutes',
              },
            ],
          },
          // OTP button component (if template uses one-tap autofill)
          {
            'type': 'button',
            'sub_type': 'url',
            'index': '0',
            'parameters': [
              {
                'type': 'text',
                'text': code,
              },
            ],
          },
        ],
      },
    });
  }

  /// Send a verification code with custom template
  ///
  /// [to] - Recipient phone number with country code
  /// [templateName] - Name of the approved template
  /// [templateLanguage] - Language code of the template
  /// [parameters] - List of parameter values for the template
  ///
  /// Returns the message ID if successful, null otherwise
  Future<String?> sendTemplateMessage({
    required String to,
    required String templateName,
    required String templateLanguage,
    required List<String> parameters,
  }) async {
    if (!_enabled) {
      return null;
    }

    final bodyParams = parameters
        .map((param) => {
              'type': 'text',
              'text': param,
            })
        .toList();

    return _sendMessage(to, {
      'type': 'template',
      'template': {
        'name': templateName,
        'language': {
          'code': templateLanguage,
        },
        'components': [
          {
            'type': 'body',
            'parameters': bodyParams,
          },
        ],
      },
    });
  }

  /// Check if a phone number is registered on WhatsApp
  ///
  /// [phoneNumber] - Phone number to check
  ///
  /// Returns true if the number is on WhatsApp, false otherwise
  Future<bool> isPhoneNumberOnWhatsApp(String phoneNumber) async {
    if (!_enabled) {
      return false;
    }

    // Note: WhatsApp Business API doesn't have a direct "check number" endpoint.
    // You can only know if a number is valid when you send a message and check
    // for delivery status. For pre-validation, you might need to use third-party
    // services or attempt to send a message and handle the error.

    // For now, we assume the number is valid if it matches E.164 format
    final normalized = _normalizePhoneNumber(phoneNumber);
    return normalized.length >= 10 && normalized.length <= 15;
  }

  /// Get message status (requires webhook setup for real-time updates)
  ///
  /// [messageId] - The message ID returned from sendMessage
  ///
  /// Note: WhatsApp doesn't provide a direct API to query message status.
  /// Status updates are sent via webhooks. This method is a placeholder
  /// for future webhook integration.
  Future<String?> getMessageStatus(String messageId) async {
    // Message status is delivered via webhooks, not queryable via API
    // This would need to be stored when webhook notifications are received
    print('[WhatsAppIntegration] Message status tracking requires webhook setup');
    return null;
  }

  /// Mark a message as read
  ///
  /// [messageId] - The message ID to mark as read
  Future<bool> markMessageAsRead(String messageId) async {
    if (!_enabled) {
      return false;
    }

    try {
      final uri = Uri.parse('$_baseUrl/$apiVersion/$_phoneNumberId/messages');
      final request = await _httpClient!.postUrl(uri);
      request.headers.set('Authorization', 'Bearer $_accessToken');
      request.headers.contentType = ContentType.json;

      final payload = {
        'messaging_product': 'whatsapp',
        'status': 'read',
        'message_id': messageId,
      };

      request.write(jsonEncode(payload));

      final response = await request.close();
      return response.statusCode == 200;
    } catch (e) {
      print('[WhatsAppIntegration] Failed to mark message as read: $e');
      return false;
    }
  }
}
