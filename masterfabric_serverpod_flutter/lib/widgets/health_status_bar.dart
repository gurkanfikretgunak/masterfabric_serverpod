import 'package:flutter/material.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import '../services/health_service.dart';

/// Health status indicator for app bar
class HealthStatusIndicator extends StatelessWidget {
  final VoidCallback? onTap;

  const HealthStatusIndicator({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: HealthService.instance,
      builder: (context, _) {
        final health = HealthService.instance;
        final isChecking = health.isChecking;
        final status = health.overallStatus;

        Color statusColor;
        IconData statusIcon;
        String tooltip;

        if (isChecking) {
          statusColor = Colors.blue;
          statusIcon = Icons.sync;
          tooltip = 'Checking health...';
        } else if (health.lastResponse == null) {
          statusColor = Colors.grey;
          statusIcon = Icons.help_outline;
          tooltip = health.lastError ?? 'Health unknown';
        } else {
          switch (status) {
            case ServiceStatus.healthy:
              statusColor = Colors.green;
              statusIcon = Icons.check_circle;
              tooltip = 'All services healthy (${health.lastResponse!.totalLatencyMs}ms)';
              break;
            case ServiceStatus.degraded:
              statusColor = Colors.orange;
              statusIcon = Icons.warning;
              tooltip = '${health.healthyCount}/${health.totalCount} services healthy';
              break;
            case ServiceStatus.unhealthy:
              statusColor = Colors.red;
              statusIcon = Icons.error;
              tooltip = 'Services unhealthy';
              break;
            case ServiceStatus.unknown:
              statusColor = Colors.grey;
              statusIcon = Icons.help_outline;
              tooltip = 'Health unknown';
              break;
          }
        }

        return Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: onTap ?? () => health.checkHealth(),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isChecking)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(statusColor),
                      ),
                    )
                  else
                    Icon(statusIcon, color: statusColor, size: 20),
                  const SizedBox(width: 4),
                  if (health.lastResponse != null && !isChecking)
                    Text(
                      '${health.healthyCount}/${health.totalCount}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Detailed health status card with categorized services
class HealthStatusCard extends StatelessWidget {
  const HealthStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: HealthService.instance,
      builder: (context, _) {
        final health = HealthService.instance;
        final response = health.lastResponse;
        final isChecking = health.isChecking;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.monitor_heart,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Service Health',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (isChecking)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => health.checkHealth(),
                        tooltip: 'Refresh',
                      ),
                  ],
                ),
                const Divider(),
                if (response == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(health.lastError ?? 'Tap refresh to check health.'),
                    ),
                  )
                else ...[
                  _buildOverallStatus(response),
                  const SizedBox(height: 16),
                  _buildServiceCategories(response.services),
                  const SizedBox(height: 12),
                  Text(
                    'Last checked: ${_formatTime(response.timestamp)} • ${response.services.length} services',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCategories(List<ServiceHealthInfo> services) {
    // Categorize services
    final infrastructure = services.where((s) => 
      s.name == 'Database' || s.name == 'Cache'
    ).toList();
    
    final application = services.where((s) =>
      s.name == 'Translations' || s.name == 'App Config' || s.name == 'Greeting'
    ).toList();
    
    final auth = services.where((s) =>
      s.name.startsWith('Auth:')
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (infrastructure.isNotEmpty) ...[
          _buildCategoryHeader('Infrastructure', Icons.storage),
          ...infrastructure.map((s) => _buildServiceRow(s)),
          const SizedBox(height: 12),
        ],
        if (application.isNotEmpty) ...[
          _buildCategoryHeader('Application', Icons.apps),
          ...application.map((s) => _buildServiceRow(s)),
          const SizedBox(height: 12),
        ],
        if (auth.isNotEmpty) ...[
          _buildCategoryHeader('Authentication', Icons.security),
          ...auth.map((s) => _buildServiceRow(s)),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus(HealthCheckResponse response) {
    Color color;
    String text;
    IconData icon;

    final healthyCount = response.services.where((s) => s.status == 'healthy').length;
    final total = response.services.length;

    switch (response.status) {
      case 'healthy':
        color = Colors.green;
        text = 'All Systems Operational';
        icon = Icons.check_circle;
        break;
      case 'degraded':
        color = Colors.orange;
        text = 'Partial Outage ($healthyCount/$total)';
        icon = Icons.warning;
        break;
      case 'unhealthy':
        color = Colors.red;
        text = 'Major Outage ($healthyCount/$total)';
        icon = Icons.error;
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '${response.totalLatencyMs}ms',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(ServiceHealthInfo service) {
    Color color;
    IconData icon;

    switch (service.status) {
      case 'healthy':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'degraded':
        color = Colors.orange;
        icon = Icons.warning_amber_outlined;
        break;
      case 'unhealthy':
        color = Colors.red;
        icon = Icons.error_outline;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    // Remove "Auth: " prefix for cleaner display
    final displayName = service.name.startsWith('Auth: ') 
        ? service.name.substring(6) 
        : service.name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              displayName,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          if (service.latencyMs != null)
            SizedBox(
              width: 45,
              child: Text(
                '${service.latencyMs}ms',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.right,
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              service.message ?? '',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}
