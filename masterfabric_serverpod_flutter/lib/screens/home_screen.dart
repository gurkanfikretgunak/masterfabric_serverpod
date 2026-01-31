import 'package:flutter/material.dart';
import '../services/health_service.dart';
import '../widgets/health_status_bar.dart';
import 'service_test_screen.dart';

/// Home screen after authentication
class HomeScreen extends StatelessWidget {
  final VoidCallback? onSignOut;

  const HomeScreen({super.key, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MasterFabric'),
        actions: [
          HealthStatusIndicator(
            onTap: () => _navigateToServiceTest(context),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: 'Service Testing',
            onPressed: () => _navigateToServiceTest(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: onSignOut,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are signed in',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              const HealthStatusCard(),
              const SizedBox(height: 24),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.science_outlined,
                title: 'Test Services',
                subtitle: 'API, Auth, Rate Limit',
                onTap: () => _navigateToServiceTest(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.refresh,
                title: 'Health Check',
                subtitle: 'Check all services',
                onTap: () => _runHealthCheck(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToServiceTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServiceTestScreen()),
    );
  }

  void _runHealthCheck(BuildContext context) {
    HealthService.instance.checkHealth();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Running health check...'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
