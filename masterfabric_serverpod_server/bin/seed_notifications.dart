import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Script to seed notification channels and sample notifications
/// 
/// This script connects to a running Serverpod server and seeds
/// notification data via the API.
/// 
/// Usage:
///   dart bin/seed_notifications.dart              # Seed all default channels and notifications
///   dart bin/seed_notifications.dart --channels   # Seed only channels
///   dart bin/seed_notifications.dart --demo       # Seed demo notifications
///   dart bin/seed_notifications.dart --help       # Show help
/// 
/// Requirements:
///   - Server must be running on localhost:8080

void main(List<String> args) async {
  // Parse arguments
  if (args.contains('--help') || args.contains('-h')) {
    printUsage();
    return;
  }

  // Server URL
  final serverUrl = const String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'http://localhost:8080/',
  );

  print('🔔 Notification Seeder');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Server: $serverUrl');
  print('');

  // Create client
  final client = Client(serverUrl);

  try {
    // Test connection
    print('🔗 Testing connection...');
    try {
      await client.health.check();
      print('   ✅ Connected to server\n');
    } catch (e) {
      print('   ❌ Failed to connect to server');
      print('   💡 Make sure the server is running: dart bin/main.dart\n');
      exit(1);
    }

    if (args.contains('--channels')) {
      await seedChannels(client);
      return;
    }

    if (args.contains('--demo')) {
      await seedDemoNotifications(client);
      return;
    }

    // Default: seed everything
    await seedChannels(client);
    await seedDemoNotifications(client);
    
    print('\n✨ Notification seeding complete!');
  } finally {
    client.close();
  }
}

void printUsage() {
  print('''
🔔 Notification Seeder

Usage:
  dart bin/seed_notifications.dart [options]

Options:
  --channels    Seed default notification channels only
  --demo        Seed demo notifications only
  --help, -h    Show this help message

Examples:
  dart bin/seed_notifications.dart              # Seed channels + demo notifications
  dart bin/seed_notifications.dart --channels   # Seed only channels
  dart bin/seed_notifications.dart --demo       # Seed only demo notifications

Requirements:
  - Server must be running on localhost:8080
  - Run: dart bin/main.dart (in another terminal)

Default Channels Created:
  - system-announcements  (System - public broadcasts)
  - app-updates           (System - app update notifications)
  - promotions            (Public - marketing/promotions)
  - news                  (Public - news and updates)
''');
}

/// Seed default notification channels
Future<void> seedChannels(Client client) async {
  print('📢 Seeding notification channels...\n');

  final channels = [
    // System channels
    _ChannelConfig(
      name: 'System Announcements',
      description: 'Important system-wide announcements',
      type: ChannelType.system,
      isPublic: true,
      cacheTtlSeconds: 600,
    ),
    _ChannelConfig(
      name: 'App Updates',
      description: 'New features and app update notifications',
      type: ChannelType.system,
      isPublic: true,
      cacheTtlSeconds: 3600,
    ),
    
    // Public channels
    _ChannelConfig(
      name: 'Promotions & Offers',
      description: 'Special offers, discounts, and promotional content',
      type: ChannelType.public,
      isPublic: true,
      cacheTtlSeconds: 1800,
    ),
    _ChannelConfig(
      name: 'News & Updates',
      description: 'Latest news and updates from MasterFabric',
      type: ChannelType.public,
      isPublic: true,
      cacheTtlSeconds: 3600,
    ),
    _ChannelConfig(
      name: 'Tips & Tricks',
      description: 'Helpful tips and best practices',
      type: ChannelType.public,
      isPublic: true,
      cacheTtlSeconds: 7200,
    ),
  ];

  int successCount = 0;
  int errorCount = 0;

  for (final config in channels) {
    try {
      print('  📌 Creating channel: ${config.name}');
      
      final response = await client.notification.createChannel(
        name: config.name,
        type: config.type,
        description: config.description,
        isPublic: config.isPublic,
        cacheTtlSeconds: config.cacheTtlSeconds,
      );
      
      if (response.success) {
        print('     ✅ Created: ${response.channel?.id}');
        successCount++;
      } else {
        print('     ⚠️  ${response.message}');
        errorCount++;
      }
    } catch (e) {
      print('     ❌ Error: $e');
      errorCount++;
    }
  }

  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('✅ Channels created: $successCount');
  if (errorCount > 0) {
    print('❌ Errors: $errorCount');
  }
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}

/// Seed demo notifications
Future<void> seedDemoNotifications(Client client) async {
  print('\n📬 Seeding demo notifications...\n');

  // First, get the channel list to get channel IDs
  print('  📋 Fetching channels...\n');
  
  // We'll use the channel names to send notifications
  // The server will create user channels automatically
  
  final notifications = [
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: 'Welcome to MasterFabric!',
      body: 'Thank you for joining MasterFabric. Explore our features and start building amazing apps today.',
      priority: NotificationPriority.normal,
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: 'Scheduled Maintenance Notice',
      body: 'We will be performing scheduled maintenance tonight from 2:00 AM to 4:00 AM UTC. Services may be temporarily unavailable.',
      priority: NotificationPriority.high,
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: 'New Feature: Real-time Notifications',
      body: 'We\'ve added real-time notifications! Stay updated with instant alerts and broadcasts.',
      priority: NotificationPriority.normal,
      actionUrl: '/features/notifications',
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: 'Version 2.0 Released',
      body: 'MasterFabric 2.0 is here with improved performance, new UI, and exciting features. Update now!',
      priority: NotificationPriority.high,
      actionUrl: '/changelog',
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: '🎉 Special Launch Offer',
      body: 'Get 50% off on all premium plans this month. Use code LAUNCH50 at checkout.',
      priority: NotificationPriority.normal,
      actionUrl: '/pricing',
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: 'MasterFabric at DevConf 2026',
      body: 'Join us at DevConf 2026 for live demos, workshops, and exclusive announcements. Register now!',
      priority: NotificationPriority.normal,
      actionUrl: '/events/devconf-2026',
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: '💡 Tip: Use Channels Effectively',
      body: 'Subscribe only to channels you care about to reduce notification noise. You can manage your subscriptions in Settings.',
      priority: NotificationPriority.low,
    ),
    _NotificationConfig(
      type: NotificationType.broadcast,
      title: '💡 Tip: Mark as Read',
      body: 'Swipe right on any notification to mark it as read, or swipe left to delete. Keep your notification center clean!',
      priority: NotificationPriority.low,
    ),
  ];

  int successCount = 0;
  int errorCount = 0;

  // First create a channel for broadcasting
  print('  📌 Creating broadcast channel...');
  final channelResponse = await client.notification.createChannel(
    name: 'Demo Broadcasts',
    type: ChannelType.public,
    description: 'Demo broadcast notifications',
    isPublic: true,
    cacheTtlSeconds: 3600,
  );
  
  if (!channelResponse.success || channelResponse.channel == null) {
    print('     ❌ Failed to create broadcast channel');
    return;
  }
  
  final channelId = channelResponse.channel!.id;
  print('     ✅ Channel ID: $channelId\n');

  for (final config in notifications) {
    try {
      print('  📨 Sending: ${config.title.length > 40 ? '${config.title.substring(0, 40)}...' : config.title}');
      
      final request = SendNotificationRequest(
        type: config.type,
        channelId: channelId,
        title: config.title,
        body: config.body,
        priority: config.priority,
        actionUrl: config.actionUrl,
      );
      
      final response = await client.notification.send(request);
      
      if (response.success) {
        print('     ✅ Sent: ${response.notificationId}');
        successCount++;
      } else {
        print('     ⚠️  ${response.message}');
        errorCount++;
      }
      
      // Small delay between notifications
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      print('     ❌ Error: $e');
      errorCount++;
    }
  }

  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('✅ Notifications sent: $successCount');
  if (errorCount > 0) {
    print('❌ Errors: $errorCount');
  }
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}

/// Channel configuration helper
class _ChannelConfig {
  final String name;
  final String description;
  final ChannelType type;
  final bool isPublic;
  final int cacheTtlSeconds;

  _ChannelConfig({
    required this.name,
    required this.description,
    required this.type,
    required this.isPublic,
    required this.cacheTtlSeconds,
  });
}

/// Notification configuration helper
class _NotificationConfig {
  final NotificationType type;
  final String title;
  final String body;
  final NotificationPriority priority;
  final String? actionUrl;

  _NotificationConfig({
    required this.type,
    required this.title,
    required this.body,
    required this.priority,
    this.actionUrl,
  });
}
