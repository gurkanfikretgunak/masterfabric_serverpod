import 'package:serverpod/serverpod.dart';
import '../../../../generated/protocol.dart';
import '../../../rate_limit/rate_limit_service.dart';
import '../services/notification_service.dart';
import '../services/notification_channel_service.dart';
import '../services/notification_cache_service.dart';

/// REST API endpoint for notification operations
/// 
/// Provides HTTP endpoints for sending notifications, managing channels,
/// and retrieving notification history. Includes rate limiting for
/// protection against abuse.
class NotificationEndpoint extends Endpoint {
  /// Rate limit configuration for sending notifications
  static const _sendRateLimitConfig = RateLimitConfig(
    maxRequests: 100,
    windowDuration: Duration(minutes: 1),
    keyPrefix: 'notification_send',
  );

  /// Rate limit configuration for read operations
  static const _readRateLimitConfig = RateLimitConfig(
    maxRequests: 300,
    windowDuration: Duration(minutes: 1),
    keyPrefix: 'notification_read',
  );

  @override
  bool get requireLogin => false;

  // ==================== Notification Operations ====================

  /// Send a notification
  /// 
  /// Creates and sends a notification based on the request type.
  /// Rate limited to prevent abuse.
  /// 
  /// [session] - Serverpod session
  /// [request] - Send notification request
  Future<NotificationResponse> send(
    Session session,
    SendNotificationRequest request,
  ) async {
    // Rate limit check
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(
      session,
      _sendRateLimitConfig,
      identifier,
    );

    try {
      final senderId = session.authenticated?.userIdentifier.toString();
      
      final notification = await NotificationService.send(
        session,
        request,
        senderId: senderId,
      );

      return NotificationResponse(
        success: true,
        message: 'Notification sent successfully',
        notificationId: notification.id,
        notification: notification,
        timestamp: DateTime.now(),
      );
    } on NotificationException catch (e) {
      return NotificationResponse(
        success: false,
        message: e.message,
        notificationId: null,
        notification: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log(
        'Failed to send notification: $e',
        level: LogLevel.error,
      );
      return NotificationResponse(
        success: false,
        message: 'Failed to send notification: ${e.toString()}',
        notificationId: null,
        notification: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get notification history for a channel
  /// 
  /// Retrieves recent notifications from cache.
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to get notifications for
  /// [limit] - Maximum number of notifications (default 50)
  Future<NotificationListResponse> getHistory(
    Session session,
    String channelId, {
    int limit = 50,
  }) async {
    // Rate limit check
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(
      session,
      _readRateLimitConfig,
      identifier,
    );

    try {
      final userId = session.authenticated?.userIdentifier.toString();

      // Check access to channel
      if (userId != null) {
        final hasAccess = await NotificationChannelService.hasAccess(
          session,
          userId,
          channelId,
        );
        
        if (!hasAccess) {
          return NotificationListResponse(
            success: false,
            notifications: [],
            totalCount: 0,
            unreadCount: 0,
            hasMore: false,
            nextCursor: null,
            timestamp: DateTime.now(),
          );
        }
      }

      final notifications = await NotificationService.getRecentNotifications(
        session,
        channelId,
        limit: limit,
      );

      // Count unread
      final unreadCount = notifications.where((n) => !n.isRead).length;

      return NotificationListResponse(
        success: true,
        notifications: notifications,
        totalCount: notifications.length,
        unreadCount: unreadCount,
        hasMore: notifications.length >= limit,
        nextCursor: notifications.isNotEmpty ? notifications.last.id : null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log(
        'Failed to get notification history: $e',
        level: LogLevel.error,
      );
      return NotificationListResponse(
        success: false,
        notifications: [],
        totalCount: 0,
        unreadCount: 0,
        hasMore: false,
        nextCursor: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get notifications for a user across all subscribed channels
  /// 
  /// [session] - Serverpod session
  /// [limit] - Maximum notifications per channel (default 20)
  Future<NotificationListResponse> getUserNotifications(
    Session session, {
    int limit = 20,
  }) async {
    // Rate limit check
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(
      session,
      _readRateLimitConfig,
      identifier,
    );

    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      throw NotificationException(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'Authentication required to get user notifications',
      );
    }

    try {
      // Get user's subscribed channels
      final channelIds = await NotificationChannelService
          .getUserSubscribedChannels(session, userId);

      // Add the user's personal channel
      final userChannel = await NotificationChannelService
          .getOrCreateUserChannel(session, userId);
      
      if (!channelIds.contains(userChannel.id)) {
        channelIds.add(userChannel.id);
      }

      final notifications = await NotificationService
          .getRecentNotificationsForChannels(
        session,
        channelIds,
        limitPerChannel: limit,
      );

      final unreadCount = notifications.where((n) => !n.isRead).length;

      return NotificationListResponse(
        success: true,
        notifications: notifications,
        totalCount: notifications.length,
        unreadCount: unreadCount,
        hasMore: false,
        nextCursor: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log(
        'Failed to get user notifications: $e',
        level: LogLevel.error,
      );
      return NotificationListResponse(
        success: false,
        notifications: [],
        totalCount: 0,
        unreadCount: 0,
        hasMore: false,
        nextCursor: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Mark a notification as read
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to mark as read
  Future<NotificationResponse> markAsRead(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    try {
      final notification = await NotificationService.markAsRead(
        session,
        channelId,
        notificationId,
      );

      if (notification == null) {
        return NotificationResponse(
          success: false,
          message: 'Notification not found',
          notificationId: notificationId,
          notification: null,
          timestamp: DateTime.now(),
        );
      }

      return NotificationResponse(
        success: true,
        message: 'Notification marked as read',
        notificationId: notificationId,
        notification: notification,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return NotificationResponse(
        success: false,
        message: 'Failed to mark notification as read: ${e.toString()}',
        notificationId: notificationId,
        notification: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Mark all notifications as read for a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to mark all as read
  Future<NotificationResponse> markAllAsRead(
    Session session,
    String channelId,
  ) async {
    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      throw NotificationException(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'Authentication required',
      );
    }

    try {
      await NotificationService.markAllAsRead(session, userId, channelId);

      return NotificationResponse(
        success: true,
        message: 'All notifications marked as read',
        notificationId: null,
        notification: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return NotificationResponse(
        success: false,
        message: 'Failed to mark all as read: ${e.toString()}',
        notificationId: null,
        notification: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Delete a notification
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to delete
  Future<NotificationResponse> deleteNotification(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    try {
      await NotificationService.deleteNotification(
        session,
        channelId,
        notificationId,
      );

      return NotificationResponse(
        success: true,
        message: 'Notification deleted',
        notificationId: notificationId,
        notification: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return NotificationResponse(
        success: false,
        message: 'Failed to delete notification: ${e.toString()}',
        notificationId: notificationId,
        notification: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get unread notification count for a user
  /// 
  /// [session] - Serverpod session
  Future<int> getUnreadCount(Session session) async {
    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      return 0;
    }

    return await NotificationService.getUnreadCount(session, userId);
  }

  /// Get notifications from public channels (no authentication required)
  /// 
  /// [session] - Serverpod session
  /// [limit] - Maximum number of notifications (default 50)
  Future<NotificationListResponse> getPublicNotifications(
    Session session, {
    int limit = 50,
  }) async {
    // Rate limit check
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(
      session,
      _readRateLimitConfig,
      identifier,
    );

    try {
      // Get all public channels
      final publicChannels = await NotificationChannelService.getPublicChannels(session);
      
      if (publicChannels.isEmpty) {
        return NotificationListResponse(
          success: true,
          notifications: [],
          totalCount: 0,
          unreadCount: 0,
          hasMore: false,
          nextCursor: null,
          timestamp: DateTime.now(),
        );
      }

      // Get channel IDs
      final channelIds = publicChannels.map((c) => c.id).toList();
      
      // Get notifications from all public channels
      final notifications = await NotificationService
          .getRecentNotificationsForChannels(
        session,
        channelIds,
        limitPerChannel: limit ~/ channelIds.length.clamp(1, 10),
      );

      return NotificationListResponse(
        success: true,
        notifications: notifications,
        totalCount: notifications.length,
        unreadCount: notifications.where((n) => !n.isRead).length,
        hasMore: notifications.length >= limit,
        nextCursor: notifications.isNotEmpty ? notifications.last.id : null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log(
        'Failed to get public notifications: $e',
        level: LogLevel.error,
      );
      return NotificationListResponse(
        success: false,
        notifications: [],
        totalCount: 0,
        unreadCount: 0,
        hasMore: false,
        nextCursor: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// List all public channels
  /// 
  /// [session] - Serverpod session
  Future<ChannelListResponse> listPublicChannels(Session session) async {
    try {
      final channels = await NotificationChannelService.getPublicChannels(session);
      
      return ChannelListResponse(
        success: true,
        channels: channels,
        totalCount: channels.length,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log(
        'Failed to list public channels: $e',
        level: LogLevel.error,
      );
      return ChannelListResponse(
        success: false,
        channels: [],
        totalCount: 0,
        timestamp: DateTime.now(),
      );
    }
  }

  // ==================== Channel Operations ====================

  /// Create a new notification channel
  /// 
  /// [session] - Serverpod session
  /// [name] - Channel name
  /// [type] - Channel type
  /// [description] - Optional description
  /// [isPublic] - Whether channel is publicly joinable
  /// [projectId] - Optional project ID (for project channels)
  Future<ChannelResponse> createChannel(
    Session session, {
    required String name,
    required ChannelType type,
    String? description,
    bool isPublic = true,
    String? projectId,
    int? maxSubscribers,
    int cacheTtlSeconds = 300,
  }) async {
    final userId = session.authenticated?.userIdentifier.toString();

    try {
      final channel = await NotificationChannelService.createChannel(
        session,
        name: name,
        type: type,
        description: description,
        ownerId: userId,
        projectId: projectId,
        isPublic: isPublic,
        maxSubscribers: maxSubscribers,
        cacheTtlSeconds: cacheTtlSeconds,
      );

      return ChannelResponse(
        success: true,
        message: 'Channel created successfully',
        channel: channel,
        subscription: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return ChannelResponse(
        success: false,
        message: 'Failed to create channel: ${e.toString()}',
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get a channel by ID
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel ID
  Future<ChannelResponse> getChannel(
    Session session,
    String channelId,
  ) async {
    try {
      final channel = await NotificationChannelService.getChannel(
        session,
        channelId,
      );

      if (channel == null) {
        return ChannelResponse(
          success: false,
          message: 'Channel not found',
          channel: null,
          subscription: null,
          timestamp: DateTime.now(),
        );
      }

      // Get user's subscription if authenticated
      ChannelSubscription? subscription;
      final userId = session.authenticated?.userIdentifier.toString();
      if (userId != null) {
        subscription = await NotificationChannelService.getSubscription(
          session,
          userId,
          channelId,
        );
      }

      return ChannelResponse(
        success: true,
        message: 'Channel retrieved',
        channel: channel,
        subscription: subscription,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return ChannelResponse(
        success: false,
        message: 'Failed to get channel: ${e.toString()}',
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Subscribe to a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to subscribe to
  Future<ChannelResponse> joinChannel(
    Session session,
    String channelId,
  ) async {
    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      throw NotificationException(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'Authentication required to join channel',
      );
    }

    try {
      final subscription = await NotificationChannelService.subscribe(
        session,
        userId,
        channelId,
      );

      final channel = await NotificationChannelService.getChannel(
        session,
        channelId,
      );

      return ChannelResponse(
        success: true,
        message: 'Successfully subscribed to channel',
        channel: channel,
        subscription: subscription,
        timestamp: DateTime.now(),
      );
    } on NotificationException catch (e) {
      return ChannelResponse(
        success: false,
        message: e.message,
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return ChannelResponse(
        success: false,
        message: 'Failed to join channel: ${e.toString()}',
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Unsubscribe from a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to unsubscribe from
  Future<ChannelResponse> leaveChannel(
    Session session,
    String channelId,
  ) async {
    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      throw NotificationException(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'Authentication required to leave channel',
      );
    }

    try {
      await NotificationChannelService.unsubscribe(
        session,
        userId,
        channelId,
      );

      return ChannelResponse(
        success: true,
        message: 'Successfully unsubscribed from channel',
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return ChannelResponse(
        success: false,
        message: 'Failed to leave channel: ${e.toString()}',
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Update channel settings
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to update
  /// [name] - Optional new name
  /// [description] - Optional new description
  /// [isActive] - Optional active status
  Future<ChannelResponse> updateChannel(
    Session session,
    String channelId, {
    String? name,
    String? description,
    bool? isActive,
    bool? isPublic,
  }) async {
    try {
      final channel = await NotificationChannelService.updateChannel(
        session,
        channelId,
        name: name,
        description: description,
        isActive: isActive,
        isPublic: isPublic,
      );

      if (channel == null) {
        return ChannelResponse(
          success: false,
          message: 'Channel not found',
          channel: null,
          subscription: null,
          timestamp: DateTime.now(),
        );
      }

      return ChannelResponse(
        success: true,
        message: 'Channel updated successfully',
        channel: channel,
        subscription: null,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return ChannelResponse(
        success: false,
        message: 'Failed to update channel: ${e.toString()}',
        channel: null,
        subscription: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get cache statistics for a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to get stats for
  Future<Map<String, dynamic>> getCacheStats(
    Session session,
    String channelId,
  ) async {
    return await NotificationCacheService.getCacheStats(session, channelId);
  }

  // ==================== Helper Methods ====================

  /// Get rate limit identifier for the current session
  String _getRateLimitIdentifier(Session session) {
    final auth = session.authenticated;
    if (auth != null) {
      return 'user:${auth.userIdentifier}';
    }
    return 'anonymous:notification';
  }
}
