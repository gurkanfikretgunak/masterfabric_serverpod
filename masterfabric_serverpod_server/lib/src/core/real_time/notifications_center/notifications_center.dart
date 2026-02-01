/// Notification Center Module
/// 
/// Real-time notification system with support for:
/// - User-specific notifications
/// - Public broadcast notifications (cached for 50k+ users)
/// - Project-based channels
/// - WebSocket streaming via Serverpod streaming methods
/// - Future push notification integration (FCM, APNs)
/// 
/// ## Quick Start
/// 
/// ### Subscribe to notifications (client-side):
/// ```dart
/// // Subscribe to channels
/// final stream = client.notificationStream.subscribe(['channel-id']);
/// stream.listen((notification) {
///   print('Received: ${notification.title}');
/// });
/// ```
/// 
/// ### Send a notification (server-side):
/// ```dart
/// // Send to user
/// await NotificationService.sendToUser(
///   session,
///   userId: 'user-123',
///   title: 'Hello',
///   body: 'You have a new message',
/// );
/// 
/// // Broadcast to channel
/// await NotificationService.broadcast(
///   session,
///   channelId: 'public-announcements',
///   title: 'New Feature',
///   body: 'Check out our latest update!',
/// );
/// ```
// Services
export 'services/notification_service.dart';
export 'services/notification_channel_service.dart';
export 'services/notification_cache_service.dart';

// Endpoints
export 'endpoints/notification_endpoint.dart';
export 'endpoints/notification_stream_endpoint.dart';

// Integrations
export 'integrations/push_notification_integration.dart';
