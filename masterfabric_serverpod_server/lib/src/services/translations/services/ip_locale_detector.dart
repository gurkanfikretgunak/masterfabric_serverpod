import 'package:serverpod/serverpod.dart';

/// IP-based locale detector using Cloudflare headers
/// 
/// Detects user locale from Cloudflare CF-IPCountry header.
/// Falls back to Accept-Language header if Cloudflare header is not available.
class IpLocaleDetector {
  /// Default locale when detection fails
  static const String defaultLocale = 'en';
  
  /// Country code to locale mapping
  /// Maps ISO country codes to locale codes
  static const Map<String, String> _countryToLocale = {
    'TR': 'tr', // Turkey -> Turkish
    'US': 'en', // United States -> English
    'GB': 'en', // United Kingdom -> English
    'CA': 'en', // Canada -> English
    'AU': 'en', // Australia -> English
    'DE': 'de', // Germany -> German
    'FR': 'fr', // France -> French
    'ES': 'es', // Spain -> Spanish
    'IT': 'it', // Italy -> Italian
    'NL': 'nl', // Netherlands -> Dutch
    'PL': 'pl', // Poland -> Polish
    'RU': 'ru', // Russia -> Russian
    'CN': 'zh', // China -> Chinese
    'JP': 'ja', // Japan -> Japanese
    'KR': 'ko', // South Korea -> Korean
  };
  
  /// Detect locale from request headers
  /// 
  /// Priority:
  /// 1. CF-IPCountry header (Cloudflare) - if Request is provided
  /// 2. Accept-Language header (browser)
  /// 3. Default locale (en)
  /// 
  /// [session] - Serverpod session with request context
  /// [request] - Optional HTTP request (for web routes with direct header access)
  /// 
  /// Returns locale code (e.g., 'tr', 'en')
  static String detectLocale(Session session, {Request? request}) {
    // Try Cloudflare country header first (from Request if available)
    String? cfCountry;
    if (request != null) {
      cfCountry = request.headers['cf-ipcountry']?.first;
    }
    
    if (cfCountry != null && cfCountry.isNotEmpty) {
      final locale = _countryToLocale[cfCountry.toUpperCase()];
      if (locale != null) {
        return locale;
      }
    }
    
    // Fallback to Accept-Language header (from Request if available)
    String? acceptLanguage;
    if (request != null) {
      acceptLanguage = request.headers['accept-language']?.first;
    }
    
    if (acceptLanguage != null && acceptLanguage.isNotEmpty) {
      final locale = _parseAcceptLanguage(acceptLanguage);
      if (locale != null) {
        return locale;
      }
    }
    
    // Default to English
    return defaultLocale;
  }
  
  /// Parse Accept-Language header to extract locale
  /// 
  /// Accept-Language format: "en-US,en;q=0.9,tr;q=0.8"
  /// Returns the first supported locale or null
  static String? _parseAcceptLanguage(String acceptLanguage) {
    try {
      // Split by comma and get first language tag
      final parts = acceptLanguage.split(',');
      if (parts.isEmpty) return null;
      
      // Get first language tag (before semicolon if present)
      final firstLang = parts.first.split(';').first.trim();
      
      // Extract language code (e.g., "en-US" -> "en")
      final langCode = firstLang.split('-').first.toLowerCase();
      
      // Check if it's a supported locale
      if (_countryToLocale.containsValue(langCode)) {
        return langCode;
      }
      
      // Map common language codes
      final langMap = {
        'en': 'en',
        'tr': 'tr',
        'de': 'de',
        'fr': 'fr',
        'es': 'es',
        'it': 'it',
        'nl': 'nl',
        'pl': 'pl',
        'ru': 'ru',
        'zh': 'zh',
        'ja': 'ja',
        'ko': 'ko',
      };
      
      return langMap[langCode];
    } catch (e) {
      return null;
    }
  }
  
  /// Get locale from country code
  /// 
  /// [countryCode] - ISO country code (e.g., 'TR', 'US')
  /// 
  /// Returns locale code or default locale
  static String getLocaleFromCountry(String countryCode) {
    return _countryToLocale[countryCode.toUpperCase()] ?? defaultLocale;
  }
  
  /// Check if locale is supported
  /// 
  /// [locale] - Locale code to check
  /// 
  /// Returns true if locale is supported
  static bool isLocaleSupported(String locale) {
    return _countryToLocale.containsValue(locale.toLowerCase());
  }
}
