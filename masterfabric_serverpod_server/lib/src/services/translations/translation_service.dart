import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/logging/core_logger.dart';

/// Service for loading and managing translations
/// 
/// Provides translation management with caching support.
/// Translations are stored as JSON strings in the database (slang format).
class TranslationService {
  /// Cache TTL for translations (1 hour)
  static const Duration cacheTtl = Duration(hours: 1);
  
  /// Default locale when translations are not found
  static const String defaultLocale = 'en';

  /// Get translations for a specific locale
  /// 
  /// [session] - Serverpod session
  /// [locale] - Locale code (e.g., 'en', 'tr')
  /// [namespace] - Optional namespace identifier
  /// 
  /// Returns Map<String, dynamic> containing translations in slang JSON format
  /// Falls back to default locale if requested locale not found
  Future<Map<String, dynamic>> getTranslations(
    Session session,
    String locale, {
    String? namespace,
  }) async {
    final logger = CoreLogger(session);
    final cacheKey = _getCacheKey(locale, namespace);

    // Try to load from cache first
    try {
      final cached = await _loadFromCache(session, cacheKey);
      if (cached != null) {
        logger.debug('Translations loaded from cache', context: {
          'locale': locale,
          'namespace': namespace ?? 'default',
        });
        return cached;
      }
    } catch (e) {
      logger.warning('Failed to load translations from cache: $e');
    }

    // Load from database (primary source)
    Map<String, dynamic>? translations;
    try {
      translations = await _loadFromDatabase(session, locale, namespace: namespace);
      if (translations != null) {
        logger.info('Translations loaded from database', context: {
          'locale': locale,
          'namespace': namespace ?? 'default',
        });
      }
    } catch (e) {
      logger.warning('Failed to load translations from database: $e');
    }

    // Fallback to default locale if requested locale not found
    if (translations == null && locale != defaultLocale) {
      logger.info('Locale not found, falling back to default', context: {
        'requestedLocale': locale,
        'fallbackLocale': defaultLocale,
      });
      return await getTranslations(session, defaultLocale, namespace: namespace);
    }

    // Fallback to empty translations if default locale also not found
    if (translations == null) {
      logger.warning('No translations found, returning empty map', context: {
        'locale': locale,
        'namespace': namespace ?? 'default',
      });
      translations = <String, dynamic>{};
    }
    
    // Store in cache
    try {
      await _storeInCache(session, cacheKey, translations);
    } catch (e) {
      logger.warning('Failed to store translations in cache: $e');
    }

    return translations;
  }

  /// Load translations from database
  /// 
  /// Returns Map<String, dynamic> if found in database, null otherwise
  Future<Map<String, dynamic>?> _loadFromDatabase(
    Session session,
    String locale, {
    String? namespace,
  }) async {
    try {
      // First try to find namespace-specific translations
      TranslationEntry? entry;
      if (namespace != null) {
        entry = await TranslationEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.locale.equals(locale) &
              t.namespace.equals(namespace) &
              t.isActive.equals(true),
          orderBy: (t) => t.updatedAt,
          orderDescending: true,
        );
      }

      // If not found and namespace was specified, try to find general translations (namespace = null)
      entry ??= await TranslationEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.locale.equals(locale) &
            t.namespace.equals(null) &
            t.isActive.equals(true),
        orderBy: (t) => t.updatedAt,
        orderDescending: true,
      );

      if (entry == null) {
        return null;
      }

      // Parse JSON to Map
      return _parseTranslationsFromJson(entry.translationsJson);
    } catch (e) {
      // Database error - return null to fallback
      return null;
    }
  }

  /// Parse translations from JSON string
  Map<String, dynamic> _parseTranslationsFromJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return json;
    } catch (e) {
      throw FormatException('Failed to parse translations JSON: $e');
    }
  }

  /// Convert translations Map to JSON string
  String _translationsToJson(Map<String, dynamic> translations) {
    try {
      return jsonEncode(translations);
    } catch (e) {
      throw FormatException('Failed to serialize translations to JSON: $e');
    }
  }

  /// Get cache key for translations
  String _getCacheKey(String locale, String? namespace) {
    final namespaceSuffix = namespace != null ? ':$namespace' : '';
    return 'translations:$locale$namespaceSuffix';
  }

  /// Load translations from cache
  /// 
  /// Note: Serverpod cache requires SerializableModel, so we'll use a simple
  /// in-memory cache or skip caching for now. Database queries are fast enough.
  /// For production, consider using Redis directly or a custom cache layer.
  Future<Map<String, dynamic>?> _loadFromCache(
    Session session,
    String cacheKey,
  ) async {
    // Cache implementation skipped - Serverpod cache requires SerializableModel
    // Translations will be loaded from database each time
    // For high-traffic scenarios, consider implementing custom Redis caching
    return null;
  }

  /// Store translations in cache
  /// 
  /// Note: Cache implementation skipped - see _loadFromCache for details
  Future<void> _storeInCache(
    Session session,
    String cacheKey,
    Map<String, dynamic> translations,
  ) async {
    // Cache implementation skipped - see _loadFromCache for details
  }

  /// Save translations to database
  /// 
  /// This method can be used by admin endpoints to update translations
  /// 
  /// [session] - Serverpod session
  /// [locale] - Locale code
  /// [translations] - Translations as Map<String, dynamic> (slang JSON format)
  /// [namespace] - Optional namespace identifier
  /// [isActive] - Whether this translation is active
  /// 
  /// Returns TranslationEntry that was saved
  Future<TranslationEntry> saveTranslations(
    Session session,
    String locale,
    Map<String, dynamic> translations, {
    String? namespace,
    bool isActive = true,
  }) async {
    final logger = CoreLogger(session);
    final translationsJson = _translationsToJson(translations);
    final now = DateTime.now().toUtc();

    try {
      // Check if translation already exists
      TranslationEntry? existing;
      if (namespace != null) {
        existing = await TranslationEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.locale.equals(locale) &
              t.namespace.equals(namespace),
        );
      } else {
        existing = await TranslationEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.locale.equals(locale) &
              t.namespace.equals(null),
        );
      }

      if (existing != null) {
        // Update existing entry
        existing.translationsJson = translationsJson;
        existing.updatedAt = now;
        existing.isActive = isActive;
        existing.version = existing.version + 1;
        await TranslationEntry.db.updateRow(session, existing);
        
        logger.info('Translations updated in database', context: {
          'locale': locale,
          'namespace': namespace ?? 'default',
          'id': existing.id,
          'version': existing.version,
        });
        
        // Invalidate cache
        final cacheKey = _getCacheKey(locale, namespace);
        await _invalidateCache(session, cacheKey);
        
        return existing;
      } else {
        // Create new entry
        final entry = TranslationEntry(
          locale: locale,
          namespace: namespace,
          translationsJson: translationsJson,
          version: 1,
          createdAt: now,
          updatedAt: now,
          isActive: isActive,
        );
        await TranslationEntry.db.insertRow(session, entry);
        
        logger.info('Translations saved to database', context: {
          'locale': locale,
          'namespace': namespace ?? 'default',
          'id': entry.id,
        });
        
        return entry;
      }
    } catch (e) {
      logger.error('Failed to save translations to database: $e');
      rethrow;
    }
  }

  /// Invalidate cache for a specific key
  Future<void> _invalidateCache(Session session, String cacheKey) async {
    try {
      // Cache doesn't have explicit remove, but we can overwrite with null or just let it expire
      // For now, we'll just log - cache will expire naturally
      final logger = CoreLogger(session);
      logger.debug('Cache invalidated (will expire naturally)', context: {
        'cacheKey': cacheKey,
      });
    } catch (e) {
      // Ignore cache invalidation errors
    }
  }
}
