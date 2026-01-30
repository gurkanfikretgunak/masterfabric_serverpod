import 'base_integration.dart';
import 'firebase_integration.dart';
import 'sentry_integration.dart';
import 'mixpanel_integration.dart';

/// Manager for all external service integrations
/// 
/// Handles initialization, lifecycle, and provides unified access to all integrations.
class IntegrationManager {
  final List<BaseIntegration> _integrations = [];

  /// Initialize all integrations from configuration
  /// 
  /// [config] - Configuration map from YAML config file
  Future<void> initializeFromConfig(Map<String, dynamic> config) async {
    final integrationsConfig = config['integrations'] as Map<String, dynamic>?;
    
    if (integrationsConfig == null) {
      return;
    }

    // Initialize Firebase
    if (integrationsConfig.containsKey('firebase')) {
      final firebaseConfig = integrationsConfig['firebase'] as Map<String, dynamic>;
      final firebase = FirebaseIntegration(
        enabled: firebaseConfig['enabled'] as bool? ?? false,
        projectId: firebaseConfig['projectId'] as String?,
        apiKey: firebaseConfig['apiKey'] as String?,
        additionalConfig: firebaseConfig,
      );
      
      if (firebase.enabled) {
        await firebase.initialize();
        _integrations.add(firebase);
      }
    }

    // Initialize Sentry
    if (integrationsConfig.containsKey('sentry')) {
      final sentryConfig = integrationsConfig['sentry'] as Map<String, dynamic>;
      final sentry = SentryIntegration(
        enabled: sentryConfig['enabled'] as bool? ?? false,
        dsn: sentryConfig['dsn'] as String?,
        environment: sentryConfig['environment'] as String?,
        additionalConfig: sentryConfig,
      );
      
      if (sentry.enabled) {
        await sentry.initialize();
        _integrations.add(sentry);
      }
    }

    // Initialize Mixpanel
    if (integrationsConfig.containsKey('mixpanel')) {
      final mixpanelConfig = integrationsConfig['mixpanel'] as Map<String, dynamic>;
      final mixpanel = MixpanelIntegration(
        enabled: mixpanelConfig['enabled'] as bool? ?? false,
        token: mixpanelConfig['token'] as String?,
        projectId: mixpanelConfig['projectId'] as String?,
        additionalConfig: mixpanelConfig,
      );
      
      if (mixpanel.enabled) {
        await mixpanel.initialize();
        _integrations.add(mixpanel);
      }
    }
  }

  /// Get an integration by name
  /// 
  /// [name] - Integration name (e.g., 'firebase', 'sentry', 'mixpanel')
  /// 
  /// Returns the integration or null if not found
  T? getIntegration<T extends BaseIntegration>(String name) {
    try {
      return _integrations.firstWhere(
        (integration) => integration.name == name,
      ) as T?;
    } catch (e) {
      return null;
    }
  }

  /// Get Firebase integration
  FirebaseIntegration? get firebase => getIntegration<FirebaseIntegration>('firebase');

  /// Get Sentry integration
  SentryIntegration? get sentry => getIntegration<SentryIntegration>('sentry');

  /// Get Mixpanel integration
  MixpanelIntegration? get mixpanel => getIntegration<MixpanelIntegration>('mixpanel');

  /// Get all integrations
  List<BaseIntegration> getAllIntegrations() {
    return List.unmodifiable(_integrations);
  }

  /// Get all enabled integrations
  List<BaseIntegration> getEnabledIntegrations() {
    return _integrations.where((integration) => integration.enabled).toList();
  }

  /// Dispose all integrations
  Future<void> disposeAll() async {
    for (final integration in _integrations) {
      try {
        await integration.dispose();
      } catch (e) {
        // Log error but continue disposing others
        // Note: We can't use logger here as this might be called during shutdown
        // ignore: avoid_print
        print('Error disposing integration ${integration.name}: $e');
      }
    }
    _integrations.clear();
  }

  /// Check health of all integrations
  /// 
  /// Returns a map of integration names to their health status
  Future<Map<String, bool>> checkAllHealth() async {
    final healthMap = <String, bool>{};
    
    for (final integration in _integrations) {
      if (integration.enabled) {
        try {
          healthMap[integration.name] = await integration.isHealthy();
        } catch (e) {
          healthMap[integration.name] = false;
        }
      }
    }
    
    return healthMap;
  }
}
