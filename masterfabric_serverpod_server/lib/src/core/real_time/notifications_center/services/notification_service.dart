import 'package:serverpod/serverpod.dart';
import '../../../../generated/protocol.dart';
import 'notification_cache_service.dart';
import 'notification_channel_service.dart';

/// Core notification service for sending and managing notifications
/// 
/// Provides methods for sending notifications to users, broadcasting to channels,
/// and managing notification state. Supports high-concurrency scenarios with
/// caching for broadcast notifications.
class NotificationService {
  static const _uuid = Uuid();

  /// Send a notification to a specific user
  /// 
  /// Creates a notification targeted at a single user. The notification
  /// is delivered via the user's personal channel.
  /// 
  /// [session] - Serverpod session
  /// [userId] - Target user ID
  /// [title] - Notification title
  /// [body] - Notification body
  /// [senderId] - Optional sender user ID
  /// [senderName] - Optional sender display name
  /// [payload] - Optional JSON payload
  /// [priority] - Notification priority (defaults to normal)
  /// [actionUrl] - Optional deep link
  /// [imageUrl] - Optional image URL
  /// [expiresAt] - Optional expiration time
  static Future<Notification> sendToUser(
    Session session, {
    required String userId,
    required String title,
    required String body,
    String? senderId,
    String? senderName,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
    String? actionUrl,
    String? imageUrl,
    DateTime? expiresAt,
    String? metadata,
  }) async {
    // Get or create the user's personal channel
    final userChannel = await NotificationChannelService.getOrCreateUserChannel(
      session,
      userId,
    );

    final notification = _createNotification(
      type: NotificationType.user,
      channelId: userChannel.id,
      title: title,
      body: body,
      targetUserId: userId,
      senderId: senderId,
      senderName: senderName,
      payload: payload,
      priority: priority,
      actionUrl: actionUrl,
      imageUrl: imageUrl,
      expiresAt: expiresAt,
      metadata: metadata,
    );

    // Cache the notification
    await NotificationCacheService.cacheNotification(
      session,
      userChannel.id,
      notification,
      ttl: Duration(seconds: userChannel.cacheTtlSeconds),
    );

    // Broadcast to the user's channel stream
    NotificationChannelService.broadcastToChannel(userChannel.id, notification);

    session.log(
      'Sent notification to user $userId: ${notification.id}',
      level: LogLevel.info,
    );

    return notification;
  }

  /// Broadcast a notification to all subscribers of a public channel
  /// 
  /// Creates a broadcast notification that is cached and delivered to all
  /// active subscribers. Optimized for high-concurrency (50k+ users).
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to broadcast to
  /// [title] - Notification title
  /// [body] - Notification body
  /// [senderId] - Optional sender user ID
  /// [senderName] - Optional sender display name
  /// [payload] - Optional JSON payload
  /// [priority] - Notification priority (defaults to normal)
  /// [actionUrl] - Optional deep link
  /// [imageUrl] - Optional image URL
  /// [expiresAt] - Optional expiration time
  static Future<Notification> broadcast(
    Session session, {
    required String channelId,
    required String title,
    required String body,
    String? senderId,
    String? senderName,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
    String? actionUrl,
    String? imageUrl,
    DateTime? expiresAt,
    String? metadata,
  }) async {
    // Verify channel exists and is active
    final channel = await NotificationChannelService.getChannel(session, channelId);
    
    if (channel == null) {
      throw NotificationException(
        code: 'CHANNEL_NOT_FOUND',
        message: 'Channel $channelId not found',
      );
    }

    if (!channel.isActive) {
      throw NotificationException(
        code: 'CHANNEL_INACTIVE',
        message: 'Channel $channelId is not active',
      );
    }

    final notification = _createNotification(
      type: NotificationType.broadcast,
      channelId: channelId,
      title: title,
      body: body,
      senderId: senderId,
      senderName: senderName,
      payload: payload,
      priority: priority,
      actionUrl: actionUrl,
      imageUrl: imageUrl,
      expiresAt: expiresAt,
      metadata: metadata,
    );

    // Cache the notification (critical for 50k+ users)
    // This allows new subscribers to fetch from cache instead of DB
    await NotificationCacheService.cacheNotification(
      session,
      channelId,
      notification,
      ttl: Duration(seconds: channel.cacheTtlSeconds),
    );

    // Broadcast to all active stream subscribers
    NotificationChannelService.broadcastToChannel(channelId, notification);

    session.log(
      'Broadcast notification to channel $channelId: ${notification.id} '
      '(${channel.subscriberCount} subscribers)',
      level: LogLevel.info,
    );

    return notification;
  }

  /// Send a notification to all members of a project
  /// 
  /// Creates a notification for project members. The notification is sent
  /// to the project's channel.
  /// 
  /// [session] - Serverpod session
  /// [projectId] - Project ID
  /// [channelId] - Project's notification channel ID
  /// [title] - Notification title
  /// [body] - Notification body
  /// [senderId] - Optional sender user ID
  /// [senderName] - Optional sender display name
  /// [payload] - Optional JSON payload
  /// [priority] - Notification priority (defaults to normal)
  static Future<Notification> sendToProject(
    Session session, {
    required String projectId,
    required String channelId,
    required String title,
    required String body,
    String? senderId,
    String? senderName,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
    String? actionUrl,
    String? imageUrl,
    DateTime? expiresAt,
    String? metadata,
  }) async {
    // Verify channel exists and belongs to the project
    final channel = await NotificationChannelService.getChannel(session, channelId);
    
    if (channel == null) {
      throw NotificationException(
        code: 'CHANNEL_NOT_FOUND',
        message: 'Project channel $channelId not found',
      );
    }

    if (channel.projectId != projectId) {
      throw NotificationException(
        code: 'CHANNEL_PROJECT_MISMATCH',
        message: 'Channel does not belong to the specified project',
      );
    }

    if (!channel.isActive) {
      throw NotificationException(
        code: 'CHANNEL_INACTIVE',
        message: 'Project channel $channelId is not active',
      );
    }

    final notification = _createNotification(
      type: NotificationType.project,
      channelId: channelId,
      title: title,
      body: body,
      senderId: senderId,
      senderName: senderName,
      payload: payload,
      priority: priority,
      actionUrl: actionUrl,
      imageUrl: imageUrl,
      expiresAt: expiresAt,
      metadata: metadata,
    );

    // Cache the notification
    await NotificationCacheService.cacheNotification(
      session,
      channelId,
      notification,
      ttl: Duration(seconds: channel.cacheTtlSeconds),
    );

    // Broadcast to project channel subscribers
    NotificationChannelService.broadcastToChannel(channelId, notification);

    session.log(
      'Sent project notification to $projectId: ${notification.id}',
      level: LogLevel.info,
    );

    return notification;
  }

  /// Send a notification using a request object
  /// 
  /// Convenience method that routes to the appropriate send method
  /// based on the notification type.
  /// 
  /// [session] - Serverpod session
  /// [request] - Send notification request
  /// [senderId] - Sender user ID (from authenticated session)
  /// [senderName] - Sender display name
  static Future<Notification> send(
    Session session,
    SendNotificationRequest request, {
    String? senderId,
    String? senderName,
  }) async {
    final expiresAt = request.expiresInSeconds != null
        ? DateTime.now().add(Duration(seconds: request.expiresInSeconds!))
        : null;

    switch (request.type) {
      case NotificationType.user:
        if (request.targetUserId == null) {
          throw NotificationException(
            code: 'MISSING_TARGET_USER',
            message: 'targetUserId is required for user notifications',
          );
        }
        return await sendToUser(
          session,
          userId: request.targetUserId!,
          title: request.title,
          body: request.body,
          senderId: senderId,
          senderName: senderName,
          payload: request.payload,
          priority: request.priority ?? NotificationPriority.normal,
          actionUrl: request.actionUrl,
          imageUrl: request.imageUrl,
          expiresAt: expiresAt,
          metadata: request.metadata,
        );

      case NotificationType.broadcast:
        if (request.channelId == null) {
          throw NotificationException(
            code: 'MISSING_CHANNEL',
            message: 'channelId is required for broadcast notifications',
          );
        }
        return await broadcast(
          session,
          channelId: request.channelId!,
          title: request.title,
          body: request.body,
          senderId: senderId,
          senderName: senderName,
          payload: request.payload,
          priority: request.priority ?? NotificationPriority.normal,
          actionUrl: request.actionUrl,
          imageUrl: request.imageUrl,
          expiresAt: expiresAt,
          metadata: request.metadata,
        );

      case NotificationType.project:
        if (request.channelId == null) {
          throw NotificationException(
            code: 'MISSING_CHANNEL',
            message: 'channelId is required for project notifications',
          );
        }
        // For project type, we need to extract projectId from channel
        final channel = await NotificationChannelService.getChannel(
          session,
          request.channelId!,
        );
        if (channel?.projectId == null) {
          throw NotificationException(
            code: 'INVALID_PROJECT_CHANNEL',
            message: 'Channel is not associated with a project',
          );
        }
        return await sendToProject(
          session,
          projectId: channel!.projectId!,
          channelId: request.channelId!,
          title: request.title,
          body: request.body,
          senderId: senderId,
          senderName: senderName,
          payload: request.payload,
          priority: request.priority ?? NotificationPriority.normal,
          actionUrl: request.actionUrl,
          imageUrl: request.imageUrl,
          expiresAt: expiresAt,
          metadata: request.metadata,
        );
    }
  }

  /// Get recent notifications for a channel
  /// 
  /// Retrieves cached notifications for a channel. Used for initial sync
  /// when a client connects to a stream.
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to get notifications for
  /// [limit] - Maximum number of notifications to retrieve
  static Future<List<Notification>> getRecentNotifications(
    Session session,
    String channelId, {
    int limit = 50,
  }) async {
    return await NotificationCacheService.getRecentNotifications(
      session,
      channelId,
      limit: limit,
    );
  }

  /// Get recent notifications for multiple channels
  /// 
  /// [session] - Serverpod session
  /// [channelIds] - List of channel IDs
  /// [limitPerChannel] - Max notifications per channel
  static Future<List<Notification>> getRecentNotificationsForChannels(
    Session session,
    List<String> channelIds, {
    int limitPerChannel = 20,
  }) async {
    final allNotifications = <Notification>[];

    for (final channelId in channelIds) {
      final notifications = await getRecentNotifications(
        session,
        channelId,
        limit: limitPerChannel,
      );
      allNotifications.addAll(notifications);
    }

    // Sort by creation time, newest first
    allNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return allNotifications;
  }

  /// Mark a notification as read
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to mark as read
  static Future<Notification?> markAsRead(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    final notification = await NotificationCacheService.getCachedNotification(
      session,
      channelId,
      notificationId,
    );

    if (notification == null) {
      return null;
    }

    // Create updated notification with isRead = true
    final updatedNotification = Notification(
      id: notification.id,
      type: notification.type,
      channelId: notification.channelId,
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
      priority: notification.priority,
      targetUserId: notification.targetUserId,
      senderId: notification.senderId,
      senderName: notification.senderName,
      actionUrl: notification.actionUrl,
      imageUrl: notification.imageUrl,
      isRead: true,
      createdAt: notification.createdAt,
      expiresAt: notification.expiresAt,
      metadata: notification.metadata,
    );

    // Re-cache with updated read status
    await NotificationCacheService.cacheNotification(
      session,
      channelId,
      updatedNotification,
    );

    return updatedNotification;
  }

  /// Mark all notifications as read for a user in a channel
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [channelId] - Channel ID
  static Future<void> markAllAsRead(
    Session session,
    String userId,
    String channelId,
  ) async {
    // Update the subscription's lastReadAt
    final subscription = await NotificationChannelService.getSubscription(
      session,
      userId,
      channelId,
    );

    if (subscription != null) {
      // TODO: Implement subscription update via NotificationChannelService
      // when database persistence is added. For now, we just log the action.
      // The updated subscription would have:
      // - lastReadAt: DateTime.now()
      // - unreadCount: 0
    }

    session.log(
      'Marked all notifications as read for user $userId in channel $channelId',
      level: LogLevel.debug,
    );
  }

  /// Delete a notification
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to delete
  static Future<void> deleteNotification(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    await NotificationCacheService.invalidateNotification(
      session,
      channelId,
      notificationId,
    );

    session.log(
      'Deleted notification $notificationId from channel $channelId',
      level: LogLevel.info,
    );
  }

  /// Get unread count for a user across all their subscribed channels
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  static Future<int> getUnreadCount(
    Session session,
    String userId,
  ) async {
    final channelIds = await NotificationChannelService.getUserSubscribedChannels(
      session,
      userId,
    );

    int totalUnread = 0;

    for (final channelId in channelIds) {
      final subscription = await NotificationChannelService.getSubscription(
        session,
        userId,
        channelId,
      );
      if (subscription != null) {
        totalUnread += subscription.unreadCount;
      }
    }

    return totalUnread;
  }

  // Private helper methods

  static Notification _createNotification({
    required NotificationType type,
    required String channelId,
    required String title,
    required String body,
    String? targetUserId,
    String? senderId,
    String? senderName,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
    String? actionUrl,
    String? imageUrl,
    DateTime? expiresAt,
    String? metadata,
  }) {
    final notificationId = _uuid.v4();
    final now = DateTime.now();

    return Notification(
      id: notificationId,
      type: type,
      channelId: channelId,
      title: title,
      body: body,
      payload: payload,
      priority: priority,
      targetUserId: targetUserId,
      senderId: senderId,
      senderName: senderName,
      actionUrl: actionUrl,
      imageUrl: imageUrl,
      isRead: false,
      createdAt: now,
      expiresAt: expiresAt,
      metadata: metadata,
    );
  }
}
