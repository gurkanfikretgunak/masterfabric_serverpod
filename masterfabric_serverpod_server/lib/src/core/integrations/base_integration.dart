/// Abstract base class for external service integrations
/// 
/// Provides a common interface for managing integrations with external services
/// like Firebase, Sentry, Mixpanel, etc.
abstract class BaseIntegration {
  /// Whether this integration is enabled
  bool get enabled;

  /// Name of the integration (e.g., 'firebase', 'sentry', 'mixpanel')
  String get name;

  /// Initialize the integration
  /// 
  /// Called when the integration is first set up.
  /// Should handle any initialization logic, SDK setup, etc.
  Future<void> initialize();

  /// Dispose of the integration
  /// 
  /// Called when the integration is being shut down.
  /// Should clean up resources, close connections, etc.
  Future<void> dispose();

  /// Check if the integration is healthy
  /// 
  /// Returns true if the integration is functioning properly,
  /// false otherwise.
  Future<bool> isHealthy();

  /// Get integration configuration
  /// 
  /// Returns a map of configuration values (without sensitive data)
  Map<String, dynamic> getConfig();

  /// Validate configuration
  /// 
  /// Checks if the configuration is valid.
  /// Throws an exception if configuration is invalid.
  void validateConfig() {
    if (!enabled) {
      return; // Skip validation if disabled
    }

    final config = getConfig();
    if (config.isEmpty) {
      throw Exception('Configuration is empty for integration: $name');
    }
  }
}
