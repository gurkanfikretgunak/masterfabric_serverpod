import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'app_config_service.dart';
import '../core/logging/core_logger.dart';
import '../core/errors/base_error_handler.dart';
import '../core/errors/error_types.dart';

/// Endpoint for providing app configuration to mobile clients
/// 
/// This endpoint is called when a mobile application first launches
/// to retrieve environment-specific configuration needed for initialization.
class AppConfigEndpoint extends Endpoint {
  final AppConfigService _configService = AppConfigService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Get app configuration for the current environment
  /// 
  /// [session] - Serverpod session
  /// [platform] - Optional platform identifier ('ios', 'android', 'web')
  ///   for platform-specific configuration overrides
  /// 
  /// Returns AppConfig with all configuration needed by the mobile client
  /// 
  /// Throws AppException if configuration cannot be loaded
  Future<AppConfig> getConfig(
    Session session, {
    String? platform,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('App config requested', context: {
        'platform': platform ?? 'all',
      });

      // Detect environment from server config
      final environment = _detectEnvironment(session);

      logger.debug('Environment detected: $environment');

      // Load configuration for the environment
      final config = await _configService.getConfigForEnvironment(
        session,
        environment,
        platform: platform,
      );

      logger.info('App config loaded successfully', context: {
        'environment': environment,
        'platform': platform ?? 'all',
        'appName': config.appSettings.appName,
        'appVersion': config.appSettings.appVersion,
      });

      return config;
    } catch (e, stackTrace) {
      // Log error
      await _errorHandler.logError(session, e, stackTrace);

      // Convert to standardized error response
      final errorResponse = _errorHandler.errorToResponse(e, stackTrace);

      // Throw appropriate exception
      throw InternalServerError(
        'Failed to load app configuration: ${errorResponse.message}',
        details: errorResponse.details,
      );
    }
  }

  /// Detect environment from server configuration
  /// 
  /// Determines the environment based on:
  /// 1. Environment variable SERVERPOD_ENVIRONMENT
  /// 2. Request host/scheme heuristics
  /// 3. Defaults to 'development'
  String _detectEnvironment(Session session) {
    // Check environment variable first
    final envVar = Platform.environment['SERVERPOD_ENVIRONMENT'];
    if (envVar != null && envVar.isNotEmpty) {
      return envVar.toLowerCase();
    }

    // Try to infer from request (if available)
    // For endpoints, we can check the request host
    // Default to development for safety
    return 'development';
  }
}
