import 'package:serverpod/serverpod.dart';
import '../integrations/integration_manager.dart';

/// Custom health check handler for Serverpod
/// 
/// Performs health checks on:
/// - External integrations status
/// - Custom metrics
/// 
/// Note: Database and Redis health are automatically monitored by Serverpod
Future<List<ServerHealthMetric>> customHealthCheckHandler(
  Serverpod pod,
  DateTime timestamp, {
  IntegrationManager? integrationManager,
}) async {
  final metrics = <ServerHealthMetric>[];

  // Check external integrations
  if (integrationManager != null) {
    final integrations = integrationManager.getAllIntegrations();
    for (final integration in integrations) {
      if (!integration.enabled) {
        continue;
      }

      try {
        final isHealthy = await integration.isHealthy();
        metrics.add(ServerHealthMetric(
          name: 'integration_${integration.name}',
          serverId: pod.serverId,
          timestamp: timestamp,
          isHealthy: isHealthy,
          value: isHealthy ? 1.0 : 0.0,
          granularity: 60000, // 1 minute in milliseconds
        ));
      } catch (e) {
        metrics.add(ServerHealthMetric(
          name: 'integration_${integration.name}',
          serverId: pod.serverId,
          timestamp: timestamp,
          isHealthy: false,
          value: 0.0,
          granularity: 60000, // 1 minute in milliseconds
        ));
      }
    }
  }

  return metrics;
}
