import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'dart:io' show Platform;
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Global app configuration instance
/// 
/// This holds the configuration loaded from the server on app bootstrap
AppConfig? appConfig;

/// Service for managing app configuration
class AppConfigService {
  /// Detect current platform
  /// 
  /// Returns 'ios', 'android', or 'web'
  static String? detectPlatform() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    }
    return null;
  }

  /// Load app configuration from server
  /// 
  /// [client] - Serverpod client instance
  /// 
  /// Returns AppConfig loaded from server
  /// Throws exception if loading fails
  static Future<AppConfig> loadConfig(Client client) async {
    try {
      final platform = detectPlatform();
      final config = await client.appConfig.getConfig(platform: platform);
      
      // Store globally
      appConfig = config;
      
      return config;
    } catch (e) {
      // Log error but don't fail app startup
      // App can continue with default configuration
      debugPrint('Failed to load app config: $e');
      rethrow;
    }
  }

  /// Get stored app configuration
  /// 
  /// Returns the loaded AppConfig or null if not loaded yet
  static AppConfig? getConfig() {
    return appConfig;
  }
}
