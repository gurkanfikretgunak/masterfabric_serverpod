import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../../../../generated/protocol.dart';
import '../services/notification_service.dart';
import '../services/notification_channel_service.dart';

/// Real-time notification streaming endpoint
/// 
/// Provides WebSocket-based streaming for real-time notifications.
/// Uses Serverpod's streaming methods for automatic connection management.
/// 
/// Clients can subscribe to multiple channels and receive notifications
/// in real-time as they are published.
class NotificationStreamEndpoint extends Endpoint {
  /// Whether authentication is required
  /// 
  /// Set to true to require authenticated sessions for streaming.
  /// Public channels can still be accessed without auth if desired.
  @override
  bool get requireLogin => false;

  /// Subscribe to notification channels and receive real-time updates
  /// 
  /// This is the main streaming method. Clients call this to establish
  /// a WebSocket connection and receive notifications as they arrive.
  /// 
  /// [session] - Serverpod session (automatically managed)
  /// [channelIds] - List of channel IDs to subscribe to
  /// 
  /// Returns a stream of notifications from all subscribed channels.
  /// The stream first yields any cached notifications, then continues
  /// with real-time updates.
  Stream<Notification> subscribe(
    Session session,
    List<String> channelIds,
  ) async* {
    final userId = session.authenticated?.userIdentifier.toString();
    
    session.log(
      'Notification stream subscription started: '
      '${channelIds.length} channels, user: ${userId ?? "anonymous"}',
      level: LogLevel.info,
    );

    // Validate access to each channel
    final accessibleChannels = <String>[];
    
    for (final channelId in channelIds) {
      final hasAccess = await _validateChannelAccess(
        session,
        channelId,
        userId,
      );
      
      if (hasAccess) {
        accessibleChannels.add(channelId);
      } else {
        session.log(
          'Access denied to channel $channelId for user ${userId ?? "anonymous"}',
          level: LogLevel.warning,
        );
      }
    }

    if (accessibleChannels.isEmpty) {
      throw NotificationException(
        code: 'NO_ACCESSIBLE_CHANNELS',
        message: 'No accessible channels found in the subscription request',
      );
    }

    // Send cached notifications first (initial sync)
    final cachedNotifications = await NotificationService
        .getRecentNotificationsForChannels(
      session,
      accessibleChannels,
      limitPerChannel: 20,
    );

    for (final notification in cachedNotifications) {
      yield notification;
    }

    session.log(
      'Sent ${cachedNotifications.length} cached notifications',
      level: LogLevel.debug,
    );

    // Create a merged stream from all subscribed channels
    final streamController = StreamController<Notification>();
    final subscriptions = <StreamSubscription<Notification>>[];

    try {
      for (final channelId in accessibleChannels) {
        final channelStream = NotificationChannelService.getChannelStream(channelId);
        
        final subscription = channelStream.stream.listen(
          (notification) {
            if (!streamController.isClosed) {
              streamController.add(notification);
            }
          },
          onError: (error) {
            session.log(
              'Error in channel $channelId stream: $error',
              level: LogLevel.error,
            );
          },
        );
        
        subscriptions.add(subscription);
      }

      // Yield notifications from the merged stream
      await for (final notification in streamController.stream) {
        yield notification;
      }
    } finally {
      // Clean up when the stream is closed
      for (final subscription in subscriptions) {
        await subscription.cancel();
      }
      if (!streamController.isClosed) {
        await streamController.close();
      }
      
      session.log(
        'Notification stream subscription ended for user ${userId ?? "anonymous"}',
        level: LogLevel.info,
      );
    }
  }

  /// Subscribe to a user's personal notification channel
  /// 
  /// Convenience method for subscribing to the current user's notifications.
  /// Requires authentication.
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns a stream of notifications for the authenticated user.
  Stream<Notification> subscribeToUserNotifications(
    Session session,
  ) async* {
    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      throw NotificationException(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'Authentication required for user notifications',
      );
    }

    // Get or create the user's personal channel
    final userChannel = await NotificationChannelService.getOrCreateUserChannel(
      session,
      userId,
    );

    // Delegate to the main subscribe method
    yield* subscribe(session, [userChannel.id]);
  }

  /// Subscribe to a project's notification channel
  /// 
  /// [session] - Serverpod session
  /// [projectId] - Project ID to subscribe to
  /// [projectChannelId] - The project's notification channel ID
  /// 
  /// Returns a stream of notifications for the project.
  Stream<Notification> subscribeToProject(
    Session session,
    String projectId,
    String projectChannelId,
  ) async* {
    final userId = session.authenticated?.userIdentifier.toString();

    // Verify the channel belongs to the project
    final channel = await NotificationChannelService.getChannel(
      session,
      projectChannelId,
    );

    if (channel == null) {
      throw NotificationException(
        code: 'CHANNEL_NOT_FOUND',
        message: 'Project notification channel not found',
      );
    }

    if (channel.projectId != projectId) {
      throw NotificationException(
        code: 'CHANNEL_PROJECT_MISMATCH',
        message: 'Channel does not belong to the specified project',
      );
    }

    // Check access
    if (!channel.isPublic && userId != null) {
      final hasAccess = await NotificationChannelService.hasAccess(
        session,
        userId,
        projectChannelId,
      );

      if (!hasAccess) {
        throw NotificationException(
          code: 'ACCESS_DENIED',
          message: 'User does not have access to this project channel',
        );
      }
    }

    // Delegate to the main subscribe method
    yield* subscribe(session, [projectChannelId]);
  }

  /// Subscribe to public broadcast channels
  /// 
  /// [session] - Serverpod session
  /// [channelIds] - List of public channel IDs to subscribe to
  /// 
  /// Returns a stream of broadcast notifications.
  /// Only public channels can be subscribed without authentication.
  Stream<Notification> subscribeToBroadcasts(
    Session session,
    List<String> channelIds,
  ) async* {
    // Filter to only public channels
    final publicChannels = <String>[];

    for (final channelId in channelIds) {
      final channel = await NotificationChannelService.getChannel(
        session,
        channelId,
      );

      if (channel != null && channel.isPublic) {
        publicChannels.add(channelId);
      }
    }

    if (publicChannels.isEmpty) {
      throw NotificationException(
        code: 'NO_PUBLIC_CHANNELS',
        message: 'No public channels found in the subscription request',
      );
    }

    // Delegate to the main subscribe method
    yield* subscribe(session, publicChannels);
  }

  // Private helper methods

  /// Validate that a user has access to a channel
  Future<bool> _validateChannelAccess(
    Session session,
    String channelId,
    String? userId,
  ) async {
    final channel = await NotificationChannelService.getChannel(
      session,
      channelId,
    );

    if (channel == null) {
      return false;
    }

    // Public channels are accessible to all
    if (channel.isPublic) {
      return true;
    }

    // User channels require the user to be the owner
    if (channel.type == ChannelType.user) {
      return userId != null && channel.ownerId == userId;
    }

    // Project channels require membership
    if (channel.type == ChannelType.project) {
      if (userId == null) {
        return false;
      }
      return await NotificationChannelService.hasAccess(
        session,
        userId,
        channelId,
      );
    }

    // System channels are public
    if (channel.type == ChannelType.system) {
      return true;
    }

    return false;
  }
}
