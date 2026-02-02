import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/health_service.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';
import '../utils/responsive.dart';
import '../widgets/health_status_bar.dart';
import '../widgets/notification_badge.dart';
import 'service_test_screen.dart';
import 'profile_screen.dart';
import 'notifications/notification_center_screen.dart';
import 'greeting_v2_screen.dart';
import 'greeting_v3_screen.dart';

/// Home screen after authentication
class HomeScreen extends StatelessWidget {
  final VoidCallback? onSignOut;

  const HomeScreen({super.key, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(tr('app.name')),
        actions: [
          HealthStatusIndicator(
            onTap: () => HealthService.instance.checkHealth(),
          ),
          NotificationBadge(
            onTap: () => _navigateToNotifications(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.circleUser),
            tooltip: tr('devTools.profile.title'),
            onPressed: () => _navigateToProfile(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            tooltip: tr('auth.signOut'),
            onPressed: onSignOut,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          maxWidth: 900,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  tr('dashboard.title'),
                  style: TextStyle(
                    fontSize: context.isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('dashboard.subtitle'),
                  style: TextStyle(
                    fontSize: context.isMobile ? 14 : 15,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Health Status
                const HealthStatusCard(),
                const SizedBox(height: 24),

                // Notifications Section
                _buildSectionHeader(tr('notifications.title')),
                const SizedBox(height: 12),
                _buildNotificationCard(context),
                const SizedBox(height: 24),

                // Developer Tools Section
                _buildSectionHeader(tr('devTools.title')),
                const SizedBox(height: 12),
                
                // Responsive grid for tool cards
                ResponsiveBuilder(
                  mobile: Column(
                    children: _buildToolCards(context),
                  ),
                  tablet: ResponsiveGrid(
                    tabletColumns: 2,
                    children: _buildToolCards(context),
                  ),
                ),
                const SizedBox(height: 24),

                // About Section
                _buildSectionHeader(tr('about.title')),
                const SizedBox(height: 12),
                _buildInfoCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildToolCards(BuildContext context) {
    return [
      _buildToolCard(
        context,
        icon: LucideIcons.shieldCheck,
        title: tr('devTools.rbacTest.title'),
        description: tr('devTools.rbacTest.description'),
        onTap: () => _navigateToGreetingV3(context),
        color: Colors.purple,
      ),
      _buildToolCard(
        context,
        icon: LucideIcons.layers,
        title: tr('devTools.middlewareTest.title'),
        description: tr('devTools.middlewareTest.description'),
        onTap: () => _navigateToGreetingV2(context),
        color: Colors.indigo,
      ),
      _buildToolCard(
        context,
        icon: LucideIcons.flaskConical,
        title: tr('devTools.serviceTest.title'),
        description: tr('devTools.serviceTest.description'),
        onTap: () => _navigateToServiceTest(context),
      ),
      _buildToolCard(
        context,
        icon: LucideIcons.userCog,
        title: tr('devTools.profile.title'),
        description: tr('devTools.profile.description'),
        onTap: () => _navigateToProfile(context),
      ),
    ];
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    Color? color,
  }) {
    final cardColor = color ?? Colors.blue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: cardColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    // Use AppConfig if available for dynamic values
    // Rate limit is configured per-endpoint, using default from translations
    final rateLimitDesc = tr('about.rateLimitDesc');

    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.info, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  tr('about.appName'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(tr('about.auth'), tr('about.authDesc')),
            _buildInfoRow(tr('about.rateLimit'), rateLimitDesc),
            _buildInfoRow(tr('about.caching'), tr('about.cachingDesc')),
            _buildInfoRow(tr('about.i18n'), tr('about.i18nDesc')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context) {
    return ListenableBuilder(
      listenable: NotificationService.instance,
      builder: (context, _) {
        final service = NotificationService.instance;
        final unreadCount = service.unreadCount;
        final isConnected = service.isConnected;

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isConnected ? Colors.green.withAlpha(50) : Colors.grey[200]!,
            ),
          ),
          child: InkWell(
            onTap: () => _navigateToNotifications(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon with badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isConnected 
                              ? Colors.green.withAlpha(25) 
                              : Colors.grey.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isConnected ? LucideIcons.bell : LucideIcons.bellOff,
                          color: isConnected ? Colors.green : Colors.grey,
                          size: 24,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              tr('notifications.title'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isConnected 
                                    ? Colors.green.withAlpha(25) 
                                    : Colors.grey.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isConnected 
                                    ? tr('notifications.live') 
                                    : tr('notifications.offline'),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isConnected ? Colors.green : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isConnected
                              ? tr('notifications.realTimeActive')
                              : tr('notifications.tapToConnect'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationCenterScreen()),
    );
  }

  void _navigateToGreetingV3(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GreetingV3Screen()),
    );
  }

  void _navigateToGreetingV2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GreetingV2Screen()),
    );
  }

  void _navigateToServiceTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServiceTestScreen()),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}
