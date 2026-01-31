import 'package:flutter/material.dart';
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
        final status = health.lastStatus;
        final isChecking = health.isChecking;

        Color statusColor;
        IconData statusIcon;
        String tooltip;

        if (isChecking) {
          statusColor = Colors.blue;
          statusIcon = Icons.sync;
          tooltip = 'Checking health...';
        } else if (status == null) {
          statusColor = Colors.grey;
          statusIcon = Icons.help_outline;
          tooltip = 'Health unknown';
        } else {
          switch (status.overall) {
            case ServiceStatus.healthy:
              statusColor = Colors.green;
              statusIcon = Icons.check_circle;
              tooltip = 'All services healthy (${status.totalLatencyMs}ms)';
              break;
            case ServiceStatus.degraded:
              statusColor = Colors.orange;
              statusIcon = Icons.warning;
              tooltip = '${status.healthyCount}/${status.totalCount} services healthy';
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
                  if (status != null && !isChecking)
                    Text(
                      '${status.healthyCount}/${status.totalCount}',
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

/// Detailed health status card
class HealthStatusCard extends StatelessWidget {
  const HealthStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: HealthService.instance,
      builder: (context, _) {
        final health = HealthService.instance;
        final status = health.lastStatus;
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
                if (status == null)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No health data. Tap refresh to check.'),
                    ),
                  )
                else ...[
                  _buildOverallStatus(status),
                  const SizedBox(height: 12),
                  ...status.services.map((s) => _buildServiceRow(s)),
                  const SizedBox(height: 8),
                  Text(
                    'Last checked: ${_formatTime(status.checkedAt)}',
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

  Widget _buildOverallStatus(HealthStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status.overall) {
      case ServiceStatus.healthy:
        color = Colors.green;
        text = 'All Systems Operational';
        icon = Icons.check_circle;
        break;
      case ServiceStatus.degraded:
        color = Colors.orange;
        text = 'Partial Outage';
        icon = Icons.warning;
        break;
      case ServiceStatus.unhealthy:
        color = Colors.red;
        text = 'Major Outage';
        icon = Icons.error;
        break;
      case ServiceStatus.unknown:
        color = Colors.grey;
        text = 'Unknown';
        icon = Icons.help_outline;
        break;
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
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '${status.totalLatencyMs}ms',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(ServiceHealth service) {
    Color color;
    IconData icon;

    switch (service.status) {
      case ServiceStatus.healthy:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case ServiceStatus.degraded:
        color = Colors.orange;
        icon = Icons.warning_amber_outlined;
        break;
      case ServiceStatus.unhealthy:
        color = Colors.red;
        icon = Icons.error_outline;
        break;
      case ServiceStatus.unknown:
        color = Colors.grey;
        icon = Icons.help_outline;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              service.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (service.latencyMs != null)
            Text(
              '${service.latencyMs}ms',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              service.message ?? '',
              style: TextStyle(
                fontSize: 12,
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
