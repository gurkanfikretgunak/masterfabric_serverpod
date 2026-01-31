import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'translation_service.dart';
import 'ip_locale_detector.dart';
import '../../core/logging/core_logger.dart';
import '../../core/errors/base_error_handler.dart';
import '../../core/errors/error_types.dart';
import '../../generated/protocol.dart';

/// Endpoint for providing translations to clients
/// 
/// This endpoint provides translations in slang-compatible JSON format.
/// Locale is auto-detected from Cloudflare CF-IPCountry header if not specified.
class TranslationEndpoint extends Endpoint {
  final TranslationService _translationService = TranslationService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Get translations for a locale
  /// 
  /// [session] - Serverpod session
  /// [locale] - Optional locale code (e.g., 'en', 'tr'). If not provided, 
  ///   locale will be auto-detected from IP address via Cloudflare headers.
  /// [namespace] - Optional namespace identifier for organizing translations
  /// 
  /// Returns TranslationResponse containing translations in slang JSON format
  /// 
  /// Throws InternalServerError if translations cannot be loaded
  Future<TranslationResponse> getTranslations(
    Session session, {
    String? locale,
    String? namespace,
  }) async {
    final logger = CoreLogger(session);

    try {
      // Auto-detect locale from IP if not provided
      // Note: For endpoints, we can't access Cloudflare headers directly,
      // so we'll rely on Accept-Language or default to 'en'
      final detectedLocale = locale ?? IpLocaleDetector.detectLocale(session);
      
      logger.info('Translations requested', context: {
        'requestedLocale': locale,
        'detectedLocale': detectedLocale,
        'namespace': namespace ?? 'default',
      });

      // Load translations
      final translations = await _translationService.getTranslations(
        session,
        detectedLocale,
        namespace: namespace,
      );

      logger.info('Translations loaded successfully', context: {
        'locale': detectedLocale,
        'namespace': namespace ?? 'default',
        'keyCount': translations.length,
      });

      // Convert translations map to JSON string
      final translationsJson = jsonEncode(translations);
      
      return TranslationResponse(
        translationsJson: translationsJson,
        locale: detectedLocale,
        namespace: namespace,
      );
    } catch (e, stackTrace) {
      // Log error
      await _errorHandler.logError(session, e, stackTrace);

      // Convert to standardized error response
      final errorResponse = _errorHandler.errorToResponse(e, stackTrace);

      // Throw appropriate exception
      throw InternalServerError(
        'Failed to load translations: ${errorResponse.message}',
        details: errorResponse.details,
      );
    }
  }

  /// Save translations (admin method)
  /// 
  /// [session] - Serverpod session
  /// [locale] - Locale code (e.g., 'en', 'tr')
  /// [translations] - Translations as Map<String, dynamic> (slang JSON format)
  /// [namespace] - Optional namespace identifier
  /// [isActive] - Whether this translation is active
  /// 
  /// Returns TranslationResponse with saved translations
  /// 
  /// Note: This should be protected by authentication/authorization in production
  Future<TranslationResponse> saveTranslations(
    Session session,
    String locale,
    Map<String, dynamic> translations, {
    String? namespace,
    bool isActive = true,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Saving translations', context: {
        'locale': locale,
        'namespace': namespace ?? 'default',
        'keyCount': translations.length,
      });

      final entry = await _translationService.saveTranslations(
        session,
        locale,
        translations,
        namespace: namespace,
        isActive: isActive,
      );

      logger.info('Translations saved successfully', context: {
        'locale': locale,
        'namespace': namespace ?? 'default',
        'id': entry.id,
        'version': entry.version,
      });

      // Return the saved translations wrapped in TranslationResponse
      final translationsJson = jsonEncode(translations);
      
      return TranslationResponse(
        translationsJson: translationsJson,
        locale: locale,
        namespace: namespace,
      );
    } catch (e, stackTrace) {
      // Log error
      await _errorHandler.logError(session, e, stackTrace);

      // Convert to standardized error response
      final errorResponse = _errorHandler.errorToResponse(e, stackTrace);

      // Throw appropriate exception
      throw InternalServerError(
        'Failed to save translations: ${errorResponse.message}',
        details: errorResponse.details,
      );
    }
  }
}
