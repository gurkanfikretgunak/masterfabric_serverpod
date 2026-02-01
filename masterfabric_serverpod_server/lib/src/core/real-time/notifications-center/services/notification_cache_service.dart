import 'package:serverpod/serverpod.dart';
import '../../../../generated/protocol.dart';

/// Configuration for notification caching
class NotificationCacheConfig {
  /// Default TTL for cached broadcasts (5 minutes)
  final Duration defaultTtl;

  /// Maximum notifications to cache per channel
  final int maxCachedPerChannel;

  /// Key prefix for notification cache
  final String keyPrefix;

  const NotificationCacheConfig({
    this.defaultTtl = const Duration(seconds: 300),
    this.maxCachedPerChannel = 100,
    this.keyPrefix = 'notification',
  });
}

/// High-performance caching service for notifications
/// 
/// Provides Redis-based caching optimized for high-concurrency scenarios
/// (50k+ concurrent users). Uses Serverpod's global cache (Redis) for
/// distributed caching across server instances.
class NotificationCacheService {
  /// Default configuration
  static const defaultConfig = NotificationCacheConfig();

  /// Cache a notification for a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to cache notification for
  /// [notification] - Notification to cache
  /// [ttl] - Optional custom TTL (defaults to channel's cacheTtlSeconds)
  static Future<void> cacheNotification(
    Session session,
    String channelId,
    Notification notification, {
    Duration? ttl,
  }) async {
    final cacheKey = _getNotificationCacheKey(channelId, notification.id);
    final lifetime = ttl ?? defaultConfig.defaultTtl;

    try {
      await session.caches.global.put(
        cacheKey,
        notification,
        lifetime: lifetime,
      );

      // Also add to the channel's notification list
      await _addToChannelList(session, channelId, notification.id, lifetime);

      session.log(
        'Cached notification ${notification.id} for channel $channelId',
        level: LogLevel.debug,
      );
    } catch (e) {
      session.log(
        'Failed to cache notification: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Get a cached notification by ID
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to retrieve
  static Future<Notification?> getCachedNotification(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    final cacheKey = _getNotificationCacheKey(channelId, notificationId);

    try {
      return await session.caches.global.get<Notification>(cacheKey);
    } catch (e) {
      session.log(
        'Failed to get cached notification: $e',
        level: LogLevel.debug,
      );
      return null;
    }
  }

  /// Get recent cached notifications for a channel
  /// 
  /// Retrieves the most recent notifications from cache for initial sync
  /// when a client connects to the stream.
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to get notifications for
  /// [limit] - Maximum number of notifications to retrieve
  static Future<List<Notification>> getRecentNotifications(
    Session session,
    String channelId, {
    int limit = 50,
  }) async {
    final notifications = <Notification>[];
    final listKey = _getChannelListKey(channelId);

    try {
      // Get the list of notification IDs
      final cachedList = await session.caches.global.get<CachedIdList>(listKey);
      
      if (cachedList == null || cachedList.ids.isEmpty) {
        return notifications;
      }

      // Parse the comma-separated list of IDs
      final ids = cachedList.ids.split(',').take(limit).toList();

      // Fetch each notification from cache
      for (final id in ids) {
        final notification = await getCachedNotification(session, channelId, id);
        if (notification != null) {
          notifications.add(notification);
        }
      }

      session.log(
        'Retrieved ${notifications.length} cached notifications for channel $channelId',
        level: LogLevel.debug,
      );
    } catch (e) {
      session.log(
        'Failed to get recent notifications: $e',
        level: LogLevel.warning,
      );
    }

    return notifications;
  }

  /// Cache multiple notifications at once (batch operation)
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to cache notifications for
  /// [notifications] - List of notifications to cache
  /// [ttl] - Optional custom TTL
  static Future<void> cacheNotifications(
    Session session,
    String channelId,
    List<Notification> notifications, {
    Duration? ttl,
  }) async {
    for (final notification in notifications) {
      await cacheNotification(session, channelId, notification, ttl: ttl);
    }
  }

  /// Invalidate a specific notification from cache
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to invalidate
  static Future<void> invalidateNotification(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    final cacheKey = _getNotificationCacheKey(channelId, notificationId);

    try {
      await session.caches.global.invalidateKey(cacheKey);
      await _removeFromChannelList(session, channelId, notificationId);

      session.log(
        'Invalidated notification $notificationId from channel $channelId cache',
        level: LogLevel.debug,
      );
    } catch (e) {
      session.log(
        'Failed to invalidate notification: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Invalidate all cached notifications for a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to clear cache for
  static Future<void> invalidateChannel(
    Session session,
    String channelId,
  ) async {
    final listKey = _getChannelListKey(channelId);

    try {
      // Get all notification IDs for this channel
      final cachedList = await session.caches.global.get<CachedIdList>(listKey);
      
      if (cachedList != null && cachedList.ids.isNotEmpty) {
        final ids = cachedList.ids.split(',');
        
        // Invalidate each notification
        for (final id in ids) {
          final cacheKey = _getNotificationCacheKey(channelId, id);
          await session.caches.global.invalidateKey(cacheKey);
        }
      }

      // Clear the channel list
      await session.caches.global.invalidateKey(listKey);

      session.log(
        'Invalidated all cached notifications for channel $channelId',
        level: LogLevel.debug,
      );
    } catch (e) {
      session.log(
        'Failed to invalidate channel cache: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Get cache statistics for a channel
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to get stats for
  static Future<Map<String, dynamic>> getCacheStats(
    Session session,
    String channelId,
  ) async {
    final listKey = _getChannelListKey(channelId);
    
    try {
      final cachedList = await session.caches.global.get<CachedIdList>(listKey);
      final count = cachedList != null && cachedList.ids.isNotEmpty 
          ? cachedList.ids.split(',').length 
          : 0;
      
      return {
        'channelId': channelId,
        'cachedCount': count,
        'maxCached': defaultConfig.maxCachedPerChannel,
        'defaultTtlSeconds': defaultConfig.defaultTtl.inSeconds,
      };
    } catch (e) {
      return {
        'channelId': channelId,
        'error': e.toString(),
      };
    }
  }

  // Private helper methods

  /// Generate cache key for a notification
  static String _getNotificationCacheKey(String channelId, String notificationId) {
    return '${defaultConfig.keyPrefix}:channel:$channelId:msg:$notificationId';
  }

  /// Generate cache key for channel's notification list
  static String _getChannelListKey(String channelId) {
    return '${defaultConfig.keyPrefix}:channel:$channelId:list';
  }

  /// Add notification ID to channel's list (maintains order, newest first)
  static Future<void> _addToChannelList(
    Session session,
    String channelId,
    String notificationId,
    Duration ttl,
  ) async {
    final listKey = _getChannelListKey(channelId);
    final now = DateTime.now();

    try {
      final existing = await session.caches.global.get<CachedIdList>(listKey);
      
      List<String> ids;
      if (existing != null && existing.ids.isNotEmpty) {
        ids = existing.ids.split(',');
        // Remove if already exists (to move to front)
        ids.remove(notificationId);
      } else {
        ids = [];
      }

      // Add to front (newest first)
      ids.insert(0, notificationId);

      // Trim to max size
      if (ids.length > defaultConfig.maxCachedPerChannel) {
        ids = ids.take(defaultConfig.maxCachedPerChannel).toList();
      }

      // Store updated list
      final cachedList = CachedIdList(
        ids: ids.join(','),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );
      
      await session.caches.global.put(
        listKey,
        cachedList,
        lifetime: ttl + const Duration(minutes: 5), // List lives slightly longer
      );
    } catch (e) {
      session.log(
        'Failed to add to channel list: $e',
        level: LogLevel.debug,
      );
    }
  }

  /// Remove notification ID from channel's list
  static Future<void> _removeFromChannelList(
    Session session,
    String channelId,
    String notificationId,
  ) async {
    final listKey = _getChannelListKey(channelId);
    final now = DateTime.now();

    try {
      final existing = await session.caches.global.get<CachedIdList>(listKey);
      
      if (existing != null && existing.ids.isNotEmpty) {
        final ids = existing.ids.split(',');
        ids.remove(notificationId);
        
        if (ids.isNotEmpty) {
          final cachedList = CachedIdList(
            ids: ids.join(','),
            createdAt: existing.createdAt,
            updatedAt: now,
          );
          
          await session.caches.global.put(
            listKey,
            cachedList,
            lifetime: defaultConfig.defaultTtl + const Duration(minutes: 5),
          );
        } else {
          await session.caches.global.invalidateKey(listKey);
        }
      }
    } catch (e) {
      session.log(
        'Failed to remove from channel list: $e',
        level: LogLevel.debug,
      );
    }
  }
}
