import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/logging/core_logger.dart';

/// Service for loading and managing translations
/// 
/// Provides translation management with caching support.
/// Translations are stored as JSON strings in the database (slang format).
/// Automatically seeds from assets/i18n/ folder on initialization.
class TranslationService {
  /// Cache TTL for translations (1 hour)
  static const Duration cacheTtl = Duration(hours: 1);
  
  /// Default locale when translations are not found
  static const String defaultLocale = 'en';
  
  /// Path to i18n assets folder
  static const String i18nAssetsPath = 'assets/i18n';
  
  /// Whether translations have been seeded
  static bool _seeded = false;

  /// Get translations for a specific locale
  /// 
  /// [session] - Serverpod session
  /// [locale] - Locale code (e.g., 'en', 'tr')
  /// [namespace] - Optional namespace identifier
  /// 
  /// Returns `Map<String, dynamic>` containing translations in slang JSON format
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
  /// Returns `Map<String, dynamic>` if found in database, null otherwise
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
  /// Uses Serverpod's caching system with TranslationEntry (SerializableModel).
  /// Tries caches in order of speed: localPrio -> local -> global (Redis)
  Future<Map<String, dynamic>?> _loadFromCache(
    Session session,
    String cacheKey,
  ) async {
    try {
      // Try priority local cache first (fastest, for frequently accessed)
      var entry = await session.caches.localPrio.get<TranslationEntry>(cacheKey);
      if (entry != null) {
        return _parseTranslationsFromJson(entry.translationsJson);
      }

      // Try regular local cache
      entry = await session.caches.local.get<TranslationEntry>(cacheKey);
      if (entry != null) {
        return _parseTranslationsFromJson(entry.translationsJson);
      }

      // Try global cache (Redis - shared across servers in cluster)
      entry = await session.caches.global.get<TranslationEntry>(cacheKey);
      if (entry != null) {
        return _parseTranslationsFromJson(entry.translationsJson);
      }

      return null;
    } catch (e) {
      // Cache miss or error - return null to load from database
      return null;
    }
  }

  /// Store translations in cache
  /// 
  /// Stores TranslationEntry in both local and global (Redis) cache.
  /// Uses priority local cache for frequently accessed translations.
  Future<void> _storeInCache(
    Session session,
    String cacheKey,
    Map<String, dynamic> translations,
  ) async {
    try {
      // Create a TranslationEntry for caching (without DB id)
      final entry = TranslationEntry(
        locale: cacheKey.split(':')[1], // Extract locale from cache key
        namespace: cacheKey.contains(':') && cacheKey.split(':').length > 2 
            ? cacheKey.split(':')[2] 
            : null,
        translationsJson: _translationsToJson(translations),
        version: 1,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      // Store in priority local cache (for frequently accessed data)
      await session.caches.localPrio.put(
        cacheKey, 
        entry,
        lifetime: cacheTtl,
      );

      // Store in global cache (Redis - shared across servers in cluster)
      await session.caches.global.put(
        cacheKey, 
        entry,
        lifetime: cacheTtl,
      );
    } catch (e) {
      // Ignore cache errors - translations will still be returned from DB
      // Cache failures shouldn't break the endpoint
    }
  }

  /// Save translations to database
  /// 
  /// This method can be used by admin endpoints to update translations
  /// 
  /// [session] - Serverpod session
  /// [locale] - Locale code
  /// [translations] - Translations as `Map<String, dynamic>` (slang JSON format)
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
  /// 
  /// Invalidates both local and global (Redis) cache.
  Future<void> _invalidateCache(Session session, String cacheKey) async {
    final logger = CoreLogger(session);
    try {
      // Invalidate local priority cache
      await session.caches.localPrio.invalidateKey(cacheKey);
      
      // Invalidate local cache
      await session.caches.local.invalidateKey(cacheKey);
      
      // Invalidate global cache (Redis)
      await session.caches.global.invalidateKey(cacheKey);
      
      logger.debug('Cache invalidated successfully', context: {
        'cacheKey': cacheKey,
      });
    } catch (e) {
      logger.warning('Failed to invalidate cache: $e', context: {
        'cacheKey': cacheKey,
      });
    }
  }

  /// Seed translations from assets/i18n/ folder
  /// 
  /// This method reads all .i18n.json files from the assets/i18n/ directory
  /// and saves them to the database. It's designed to be called once during
  /// server startup.
  /// 
  /// [session] - Serverpod session
  /// [forceReseed] - If true, reseed even if already seeded
  /// 
  /// Returns the number of locales seeded
  Future<int> seedFromAssets(Session session, {bool forceReseed = false}) async {
    final logger = CoreLogger(session);
    
    // Skip if already seeded (unless forced)
    if (_seeded && !forceReseed) {
      logger.debug('Translations already seeded, skipping');
      return 0;
    }

    final i18nDir = Directory(i18nAssetsPath);
    if (!i18nDir.existsSync()) {
      logger.warning('i18n assets directory not found: $i18nAssetsPath');
      return 0;
    }

    final files = i18nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.i18n.json'))
        .toList();

    if (files.isEmpty) {
      logger.warning('No .i18n.json files found in $i18nAssetsPath');
      return 0;
    }

    logger.info('Found ${files.length} translation file(s) to seed');

    int successCount = 0;

    for (final file in files) {
      try {
        // Parse filename: <namespace>_<locale>.i18n.json or <locale>.i18n.json
        final fileName = file.path.split('/').last;
        final baseName = fileName.replaceAll('.i18n.json', '');

        String locale;
        String? namespace;

        // Check if it's namespaced (contains underscore but not locale like zh_CN)
        final underscoreIndex = baseName.indexOf('_');
        if (underscoreIndex > 0 && underscoreIndex < baseName.length - 1) {
          // Could be namespace_locale or locale with underscore (zh_CN)
          // Check if the part after underscore is a valid 2-letter locale or known locale
          final afterUnderscore = baseName.substring(underscoreIndex + 1);
          if (afterUnderscore.length == 2 || ['CN', 'TW', 'HK'].contains(afterUnderscore.toUpperCase())) {
            // Likely a locale like zh_CN, treat whole thing as locale
            locale = baseName;
          } else {
            // It's namespace_locale format
            namespace = baseName.substring(0, underscoreIndex);
            locale = afterUnderscore;
          }
        } else {
          locale = baseName;
        }

        // Read and parse JSON
        final jsonString = await file.readAsString();
        final translations = jsonDecode(jsonString) as Map<String, dynamic>;

        // Save to database
        await saveTranslations(
          session,
          locale,
          translations,
          namespace: namespace,
          isActive: true,
        );

        logger.info('Seeded translations', context: {
          'locale': locale,
          'namespace': namespace ?? 'default',
          'keys': translations.length,
        });

        successCount++;
      } catch (e) {
        logger.error('Failed to seed translation file: ${file.path}', exception: e is Exception ? e : null);
      }
    }

    _seeded = true;
    logger.info('Translation seeding complete', context: {
      'total': files.length,
      'success': successCount,
      'failed': files.length - successCount,
    });

    return successCount;
  }

  /// Check if a locale exists in the database
  Future<bool> localeExists(Session session, String locale, {String? namespace}) async {
    try {
      TranslationEntry? entry;
      if (namespace != null) {
        entry = await TranslationEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.locale.equals(locale) &
              t.namespace.equals(namespace) &
              t.isActive.equals(true),
        );
      } else {
        entry = await TranslationEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.locale.equals(locale) &
              t.namespace.equals(null) &
              t.isActive.equals(true),
        );
      }
      return entry != null;
    } catch (e) {
      return false;
    }
  }

  /// Get all available locales
  Future<List<String>> getAvailableLocales(Session session) async {
    try {
      final entries = await TranslationEntry.db.find(
        session,
        where: (t) => t.isActive.equals(true),
      );
      
      // Extract unique locales
      final locales = entries.map((e) => e.locale).toSet().toList();
      locales.sort();
      return locales;
    } catch (e) {
      return [];
    }
  }

  /// Reset seeded flag (useful for testing or forced re-seeding)
  static void resetSeededFlag() {
    _seeded = false;
  }
}
