import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/logging/core_logger.dart';

/// Service for loading and building app configuration
class AppConfigService {
  /// Cache TTL for configuration (1 hour)
  static const Duration cacheTtl = Duration(hours: 1);

  /// Get configuration for a specific environment
  /// 
  /// [session] - Serverpod session
  /// [environment] - Environment name (development/staging/production)
  /// [platform] - Optional platform identifier ('ios', 'android', 'web')
  /// 
  /// Returns AppConfig for the specified environment
  Future<AppConfig> getConfigForEnvironment(
    Session session,
    String environment, {
    String? platform,
  }) async {
    final logger = CoreLogger(session);
    final cacheKey = _getCacheKey(environment, platform);

    // Try to load from cache first
    try {
      final cached = await _loadFromCache(session, cacheKey);
      if (cached != null) {
        logger.debug('App config loaded from cache', context: {
          'environment': environment,
          'platform': platform ?? 'all',
        });
        return cached;
      }
    } catch (e) {
      logger.warning('Failed to load config from cache: $e');
    }

    // Load from database (primary source)
    AppConfig? config;
    try {
      config = await _loadFromDatabase(session, environment, platform: platform);
      if (config != null) {
        logger.info('App config loaded from database', context: {
          'environment': environment,
          'platform': platform ?? 'all',
        });
      }
    } catch (e) {
      logger.warning('Failed to load config from database: $e');
    }

    // Fallback to default configuration if database doesn't have it
    if (config == null) {
      logger.info('Loading default app config (database not configured)', context: {
        'environment': environment,
        'platform': platform ?? 'all',
      });
      config = await _loadFromConfigFiles(session, environment, platform: platform);
    }
    
    // Store in cache
    try {
      await _storeInCache(session, cacheKey, config);
    } catch (e) {
      logger.warning('Failed to store config in cache: $e');
    }

    return config;
  }

  /// Load configuration from database
  /// 
  /// Returns AppConfig if found in database, null otherwise
  Future<AppConfig?> _loadFromDatabase(
    Session session,
    String environment, {
    String? platform,
  }) async {
    try {
      // First try to find platform-specific config
      AppConfigEntry? entry;
      if (platform != null) {
        entry = await AppConfigEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.environment.equals(environment) &
              t.platform.equals(platform) &
              t.isActive.equals(true),
          orderBy: (t) => t.updatedAt,
          orderDescending: true,
        );
      }

      // If not found and platform was specified, try to find general config (platform = null)
      entry ??= await AppConfigEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.environment.equals(environment) &
            t.platform.equals(null) &
            t.isActive.equals(true),
        orderBy: (t) => t.updatedAt,
        orderDescending: true,
      );

      if (entry == null) {
        return null;
      }

      // Parse JSON to AppConfig
      return _parseConfigFromJson(entry.configJson);
    } catch (e) {
      // Database error - return null to fallback to defaults
      return null;
    }
  }

  /// Parse AppConfig from JSON string
  AppConfig _parseConfigFromJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppConfig.fromJson(json);
    } catch (e) {
      throw FormatException('Failed to parse config JSON: $e');
    }
  }

  /// Convert AppConfig to JSON string
  String _configToJson(AppConfig config) {
    try {
      return jsonEncode(config.toJson());
    } catch (e) {
      throw FormatException('Failed to serialize config to JSON: $e');
    }
  }

  /// Load configuration from server config files (fallback)
  Future<AppConfig> _loadFromConfigFiles(
    Session session,
    String environment, {
    String? platform,
  }) async {
    // Build API URL from session's server information
    // Use the server's public URL if available, otherwise construct from request
    final apiUrl = _buildApiUrlFromSession(session, environment);

    // Build configuration based on environment
    return buildAppConfig(
      environment: environment,
      apiUrl: apiUrl,
      debugMode: environment == 'development',
      platform: platform,
    );
  }

  /// Build AppConfig object with environment-specific values
  /// 
  /// This method is public to allow seeding scripts to use it
  AppConfig buildAppConfig({
    required String environment,
    required String apiUrl,
    required bool debugMode,
    String? platform,
  }) {
    // Determine app name and version based on environment
    final appName = _getAppName(environment);
    final appVersion = _getAppVersion(environment);

    return AppConfig(
      appSettings: AppSettings(
        appName: appName,
        appVersion: appVersion,
        environment: environment,
        debugMode: debugMode,
        maintenanceMode: false,
      ),
      uiConfiguration: UiConfiguration(
        themeMode: 'light',
        fontScale: 1.0,
        devModeGrid: debugMode,
        devModeSpacer: debugMode,
      ),
      splashConfiguration: SplashConfiguration(
        style: 'startup',
        duration: 2000,
        backgroundColor: '#FFFFFF',
        textColor: '#000000',
        primaryColor: '#0066FF',
        logoUrl: null,
        logoWidth: 200,
        logoHeight: 200,
        showLoadingIndicator: true,
        loadingIndicatorSize: 40,
        loadingText: 'Loading...',
        showAppVersion: true,
        appVersion: appVersion,
        showCopyright: true,
        copyrightText: _getCopyrightText(environment),
      ),
      featureFlags: FeatureFlags(
        onboardingEnabled: environment != 'development',
        analyticsEnabled: environment == 'production',
      ),
      navigationConfiguration: NavigationConfiguration(
        defaultRoute: '/',
        deepLinkingEnabled: true,
      ),
      apiConfiguration: ApiConfiguration(
        baseUrl: apiUrl,
        timeout: 30000,
        retryCount: 3,
      ),
      permissionsConfiguration: PermissionsConfiguration(
        required: [],
        optional: [],
      ),
      localizationConfiguration: LocalizationConfiguration(
        defaultLocale: 'en',
        supportedLocales: ['en'],
      ),
      storageConfiguration: StorageConfiguration(
        localStorageType: 'hiveCe',
        encryptionEnabled: environment == 'production',
        cacheEnabled: true,
      ),
      pushNotificationConfiguration: PushNotificationConfiguration(
        enabled: environment == 'production',
        defaultProvider: 'onesignal',
        autoInitialize: environment == 'production',
        providersJson: _buildProvidersJson(environment),
      ),
      forceUpdateConfiguration: ForceUpdateConfiguration(
        latestVersion: appVersion,
        minimumVersion: appVersion,
        releaseNotes: _getReleaseNotes(environment),
        features: [],
        storeUrl: _buildStoreUrl(platform),
        customMessage: 'A new version is available!',
      ),
    );
  }

  /// Get app name based on environment
  String _getAppName(String environment) {
    switch (environment) {
      case 'development':
        return 'MasterFabric Serverpod (Dev)';
      case 'staging':
        return 'MasterFabric Serverpod (Staging)';
      case 'production':
        return 'MasterFabric Serverpod';
      default:
        return 'MasterFabric Serverpod';
    }
  }

  /// Get app version based on environment
  String _getAppVersion(String environment) {
    switch (environment) {
      case 'development':
        return '1.0.0-dev';
      case 'staging':
        return '1.0.0-staging';
      case 'production':
        return '1.0.0';
      default:
        return '1.0.0';
    }
  }

  /// Get copyright text based on environment
  String _getCopyrightText(String environment) {
    switch (environment) {
      case 'development':
        return '© 2025 MasterFabric - Development';
      case 'staging':
        return '© 2025 MasterFabric - Staging';
      case 'production':
        return '© 2025 MasterFabric';
      default:
        return '© 2025 MasterFabric';
    }
  }

  /// Get release notes based on environment
  String _getReleaseNotes(String environment) {
    switch (environment) {
      case 'development':
        return 'Development build';
      case 'staging':
        return 'Staging build for testing';
      case 'production':
        return 'Production release';
      default:
        return 'Initial release';
    }
  }

  /// Build API URL from session
  String _buildApiUrlFromSession(Session session, String environment) {
    // Try to get from request if available
    // Otherwise use environment-specific defaults
    switch (environment) {
      case 'production':
        return 'https://api.examplepod.com';
      case 'staging':
        return 'https://staging-api.examplepod.com';
      case 'development':
      default:
        return 'http://localhost:8080';
    }
  }

  /// Build providers JSON string
  String? _buildProvidersJson(String environment) {
    // Return JSON string for push notification providers
    // This can be extended to read from config files or database
    return '{"onesignal":{"enabled":${environment == 'production'},"appId":""},"firebase":{"enabled":false,"vapidKey":""}}';
  }

  /// Build store URL based on platform
  StoreUrl? _buildStoreUrl(String? platform) {
    if (platform == null) {
      return StoreUrl(ios: null, android: null);
    }
    
    // Platform-specific store URLs can be configured here
    // For now, return empty URLs
    return StoreUrl(ios: null, android: null);
  }

  /// Get cache key for configuration
  String _getCacheKey(String environment, String? platform) {
    final platformSuffix = platform != null ? ':$platform' : '';
    return 'app_config:$environment$platformSuffix';
  }

  /// Load configuration from cache
  /// 
  /// Tries caches in order of speed: localPrio -> local -> global (Redis)
  Future<AppConfig?> _loadFromCache(Session session, String cacheKey) async {
    try {
      // Try priority local cache first (fastest, for frequently accessed)
      var cached = await session.caches.localPrio.get<AppConfig>(cacheKey);
      if (cached != null) {
        return cached;
      }

      // Try regular local cache
      cached = await session.caches.local.get<AppConfig>(cacheKey);
      if (cached != null) {
        return cached;
      }

      // Try global cache (Redis - shared across servers)
      cached = await session.caches.global.get<AppConfig>(cacheKey);
      if (cached != null) {
        return cached;
      }

      return null;
    } catch (e) {
      // Cache miss or error - return null to load from source
      return null;
    }
  }

  /// Store configuration in cache
  Future<void> _storeInCache(
    Session session,
    String cacheKey,
    AppConfig config,
  ) async {
    try {
      // Store in priority local cache (frequently accessed)
      // AppConfig is SerializableModel, so it can be cached directly
      await session.caches.localPrio.put(
        cacheKey, 
        config,
        lifetime: cacheTtl,
      );
      
      // Store in global cache (Redis - shared across servers)
      await session.caches.global.put(
        cacheKey, 
        config,
        lifetime: cacheTtl,
      );
    } catch (e) {
      // Ignore cache errors - configuration will still be returned
      // Cache failures shouldn't break the endpoint
    }
  }

  /// Save configuration to database
  /// 
  /// This method can be used by admin endpoints to update configuration
  /// 
  /// [session] - Serverpod session
  /// [environment] - Environment name
  /// [platform] - Optional platform identifier
  /// [config] - AppConfig to save
  /// [isActive] - Whether this configuration is active
  Future<AppConfigEntry> saveConfigToDatabase(
    Session session,
    String environment,
    AppConfig config, {
    String? platform,
    bool isActive = true,
  }) async {
    final logger = CoreLogger(session);
    final configJson = _configToJson(config);
    final now = DateTime.now().toUtc();

    try {
      // Check if config already exists
      AppConfigEntry? existing;
      if (platform != null) {
        existing = await AppConfigEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.environment.equals(environment) &
              t.platform.equals(platform),
        );
      } else {
        existing = await AppConfigEntry.db.findFirstRow(
          session,
          where: (t) =>
              t.environment.equals(environment) &
              t.platform.equals(null),
        );
      }

      if (existing != null) {
        // Update existing entry
        existing.configJson = configJson;
        existing.updatedAt = now;
        existing.isActive = isActive;
        await AppConfigEntry.db.updateRow(session, existing);
        
        logger.info('App config updated in database', context: {
          'environment': environment,
          'platform': platform ?? 'all',
          'id': existing.id,
        });
        
        // Invalidate cache
        final cacheKey = _getCacheKey(environment, platform);
        await _invalidateCache(session, cacheKey);
        
        return existing;
      } else {
        // Create new entry
        final entry = AppConfigEntry(
          environment: environment,
          platform: platform,
          configJson: configJson,
          createdAt: now,
          updatedAt: now,
          isActive: isActive,
        );
        await AppConfigEntry.db.insertRow(session, entry);
        
        logger.info('App config saved to database', context: {
          'environment': environment,
          'platform': platform ?? 'all',
          'id': entry.id,
        });
        
        return entry;
      }
    } catch (e) {
      logger.error('Failed to save config to database: $e');
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
}
