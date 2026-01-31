import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Global translations instance
/// 
/// This holds the translations loaded from the server on app bootstrap
Map<String, dynamic>? _translations;

/// Current locale code
String _currentLocale = 'en';

/// Available locales from server
List<String> _availableLocales = [];

/// Service for managing translations
/// 
/// Provides translation loading and lookup functionality.
/// Translations are fetched from the server during app bootstrap.
class TranslationService {
  /// Get current locale
  static String get currentLocale => _currentLocale;
  
  /// Get available locales
  static List<String> get availableLocales => _availableLocales;

  /// Detect device locale
  /// 
  /// Returns the device's preferred locale code (e.g., 'en', 'tr')
  static String detectDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    return deviceLocale.languageCode;
  }

  /// Load translations from server
  /// 
  /// [client] - Serverpod client instance
  /// [locale] - Optional locale code (auto-detects from device if not provided)
  /// [namespace] - Optional namespace for scoped translations
  /// 
  /// Returns translations as a Map
  /// Throws exception if loading fails
  static Future<Map<String, dynamic>> loadTranslations(
    Client client, {
    String? locale,
    String? namespace,
  }) async {
    try {
      // Auto-detect locale if not provided
      final targetLocale = locale ?? detectDeviceLocale();
      
      debugPrint('Loading translations for locale: $targetLocale');
      
      // Fetch translations from server
      final response = await client.translation.getTranslations(
        locale: targetLocale,
        namespace: namespace,
      );
      
      // Parse JSON to Map
      final translations = jsonDecode(response.translationsJson) as Map<String, dynamic>;
      
      // Store globally
      _translations = translations;
      _currentLocale = response.locale;
      
      debugPrint('Translations loaded: ${translations.keys.length} keys for locale: ${response.locale}');
      
      return translations;
    } catch (e) {
      debugPrint('Failed to load translations: $e');
      rethrow;
    }
  }

  /// Load available locales from server
  /// 
  /// [client] - Serverpod client instance
  /// 
  /// Returns list of available locale codes
  static Future<List<String>> loadAvailableLocales(Client client) async {
    try {
      final locales = await client.translation.getAvailableLocales();
      _availableLocales = locales;
      debugPrint('Available locales: ${locales.join(", ")}');
      return locales;
    } catch (e) {
      debugPrint('Failed to load available locales: $e');
      return [];
    }
  }

  /// Change locale and reload translations
  /// 
  /// [client] - Serverpod client instance
  /// [locale] - New locale code
  /// [namespace] - Optional namespace
  /// 
  /// Returns updated translations
  static Future<Map<String, dynamic>> changeLocale(
    Client client,
    String locale, {
    String? namespace,
  }) async {
    return await loadTranslations(client, locale: locale, namespace: namespace);
  }

  /// Get stored translations
  /// 
  /// Returns the loaded translations or null if not loaded yet
  static Map<String, dynamic>? getTranslations() {
    return _translations;
  }

  /// Translate a key
  /// 
  /// [key] - Translation key in dot notation (e.g., 'welcome.title')
  /// [args] - Optional arguments for string interpolation
  /// 
  /// Returns translated string or key if not found
  static String t(String key, {Map<String, dynamic>? args}) {
    if (_translations == null) {
      return key;
    }

    // Navigate through nested keys
    final parts = key.split('.');
    dynamic value = _translations;
    
    for (final part in parts) {
      if (value is Map<String, dynamic> && value.containsKey(part)) {
        value = value[part];
      } else {
        // Key not found, return original key
        return key;
      }
    }

    if (value is! String) {
      return key;
    }

    // Apply string interpolation if args provided
    if (args != null && args.isNotEmpty) {
      return _interpolate(value, args);
    }

    return value;
  }

  /// Interpolate string with arguments
  /// 
  /// Supports $variable and ${variable} syntax
  static String _interpolate(String template, Map<String, dynamic> args) {
    String result = template;
    
    for (final entry in args.entries) {
      // Replace $key and ${key} patterns
      result = result.replaceAll('\$${entry.key}', entry.value.toString());
      result = result.replaceAll('\${${entry.key}}', entry.value.toString());
    }
    
    return result;
  }

  /// Check if a translation key exists
  static bool has(String key) {
    if (_translations == null) {
      return false;
    }

    final parts = key.split('.');
    dynamic value = _translations;
    
    for (final part in parts) {
      if (value is Map<String, dynamic> && value.containsKey(part)) {
        value = value[part];
      } else {
        return false;
      }
    }

    return value is String;
  }

  /// Get a nested translation group
  /// 
  /// [key] - Group key (e.g., 'common' returns all common translations)
  /// 
  /// Returns Map of translations in that group
  static Map<String, dynamic>? group(String key) {
    if (_translations == null) {
      return null;
    }

    final parts = key.split('.');
    dynamic value = _translations;
    
    for (final part in parts) {
      if (value is Map<String, dynamic> && value.containsKey(part)) {
        value = value[part];
      } else {
        return null;
      }
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    return null;
  }

  /// Reset translations (useful for testing or forced reload)
  static void reset() {
    _translations = null;
    _currentLocale = 'en';
    _availableLocales = [];
  }
}

/// Shorthand function for translation
/// 
/// Usage: tr('welcome.title', args: {'name': 'John'})
String tr(String key, {Map<String, dynamic>? args}) {
  return TranslationService.t(key, args: args);
}
