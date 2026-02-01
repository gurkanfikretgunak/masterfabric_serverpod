import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../../../../generated/protocol.dart';

/// Service for managing notification channels
/// 
/// Handles channel creation, subscription management, and access control.
/// Channels can be public (anyone can join), project-based (restricted to members),
/// or user-specific (private).
class NotificationChannelService {
  static const _uuid = Uuid();

  /// Cache key prefix for channel data
  static const String _cacheKeyPrefix = 'notification:channel';

  /// Cache TTL for channel metadata
  static const Duration _channelCacheTtl = Duration(minutes: 15);

  /// Cache TTL for subscription data
  static const Duration _subscriptionCacheTtl = Duration(minutes: 5);

  // In-memory stream controllers for active channels
  // Key: channelId, Value: StreamController for broadcasting
  static final Map<String, StreamController<Notification>> _channelStreams = {};

  /// Create a new notification channel
  /// 
  /// [session] - Serverpod session
  /// [name] - Channel display name
  /// [type] - Channel type (public, project, user, system)
  /// [ownerId] - Optional owner user ID
  /// [projectId] - Optional project ID (for project channels)
  /// [isPublic] - Whether channel is publicly joinable
  /// [maxSubscribers] - Optional limit on subscribers
  /// [cacheTtlSeconds] - How long to cache notifications (default 300)
  static Future<NotificationChannel> createChannel(
    Session session, {
    required String name,
    required ChannelType type,
    String? description,
    String? ownerId,
    String? projectId,
    bool isPublic = true,
    int? maxSubscribers,
    int cacheTtlSeconds = 300,
    int maxCachedNotifications = 100,
    String? metadata,
  }) async {
    final channelId = _uuid.v4();
    final now = DateTime.now();

    final channel = NotificationChannel(
      id: channelId,
      name: name,
      description: description,
      type: type,
      ownerId: ownerId,
      projectId: projectId,
      isActive: true,
      isPublic: isPublic,
      maxSubscribers: maxSubscribers,
      subscriberCount: 0,
      cacheTtlSeconds: cacheTtlSeconds,
      maxCachedNotifications: maxCachedNotifications,
      createdAt: now,
      updatedAt: now,
      metadata: metadata,
    );

    // Cache the channel
    await _cacheChannel(session, channel);

    session.log(
      'Created notification channel: $name (${type.name})',
      level: LogLevel.info,
    );

    return channel;
  }

  /// Get a channel by ID
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel ID to retrieve
  static Future<NotificationChannel?> getChannel(
    Session session,
    String channelId,
  ) async {
    final cacheKey = _getChannelCacheKey(channelId);

    try {
      final cached = await session.caches.global.get<NotificationChannel>(cacheKey);
      if (cached != null) {
        return cached;
      }
    } catch (e) {
      session.log(
        'Failed to get channel from cache: $e',
        level: LogLevel.debug,
      );
    }

    // Channel not in cache - would normally fetch from database
    // For now, return null (implement DB fetch when persistence is added)
    return null;
  }

  /// Get or create a user's private channel
  /// 
  /// Each user has a personal channel for direct notifications.
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  static Future<NotificationChannel> getOrCreateUserChannel(
    Session session,
    String userId,
  ) async {
    final userChannelId = 'user:$userId';
    
    var channel = await getChannel(session, userChannelId);
    
    if (channel == null) {
      channel = await createChannel(
        session,
        name: 'User $userId Notifications',
        type: ChannelType.user,
        ownerId: userId,
        isPublic: false,
        maxSubscribers: 1,
      );
      
      // Override the ID to be user-specific
      channel = NotificationChannel(
        id: userChannelId,
        name: channel.name,
        description: channel.description,
        type: channel.type,
        ownerId: channel.ownerId,
        projectId: channel.projectId,
        isActive: channel.isActive,
        isPublic: channel.isPublic,
        maxSubscribers: channel.maxSubscribers,
        subscriberCount: channel.subscriberCount,
        cacheTtlSeconds: channel.cacheTtlSeconds,
        maxCachedNotifications: channel.maxCachedNotifications,
        createdAt: channel.createdAt,
        updatedAt: channel.updatedAt,
        metadata: channel.metadata,
      );
      
      await _cacheChannel(session, channel);
    }
    
    return channel;
  }

  /// Subscribe a user to a channel
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID subscribing
  /// [channelId] - Channel ID to subscribe to
  static Future<ChannelSubscription> subscribe(
    Session session,
    String userId,
    String channelId,
  ) async {
    // Check if channel exists and user has access
    final channel = await getChannel(session, channelId);
    
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

    // Check access based on channel type
    if (!channel.isPublic && channel.type == ChannelType.project) {
      // Would check project membership here
      // For now, allow if public or user is owner
      if (channel.ownerId != userId) {
        throw NotificationException(
          code: 'ACCESS_DENIED',
          message: 'User does not have access to this channel',
        );
      }
    }

    // Check subscriber limit
    if (channel.maxSubscribers != null && 
        channel.subscriberCount >= channel.maxSubscribers!) {
      throw NotificationException(
        code: 'CHANNEL_FULL',
        message: 'Channel has reached maximum subscriber limit',
      );
    }

    // Check for existing subscription
    final existingSubscription = await getSubscription(session, userId, channelId);
    if (existingSubscription != null && existingSubscription.isActive) {
      return existingSubscription;
    }

    // Create subscription
    final subscriptionId = _uuid.v4();
    final now = DateTime.now();

    final subscription = ChannelSubscription(
      id: subscriptionId,
      userId: userId,
      channelId: channelId,
      isActive: true,
      isMuted: false,
      subscribedAt: now,
      lastReadAt: null,
      unreadCount: 0,
      metadata: null,
    );

    // Cache the subscription
    await _cacheSubscription(session, subscription);

    // Update subscriber count (would also update in DB)
    final updatedChannel = NotificationChannel(
      id: channel.id,
      name: channel.name,
      description: channel.description,
      type: channel.type,
      ownerId: channel.ownerId,
      projectId: channel.projectId,
      isActive: channel.isActive,
      isPublic: channel.isPublic,
      maxSubscribers: channel.maxSubscribers,
      subscriberCount: channel.subscriberCount + 1,
      cacheTtlSeconds: channel.cacheTtlSeconds,
      maxCachedNotifications: channel.maxCachedNotifications,
      createdAt: channel.createdAt,
      updatedAt: DateTime.now(),
      metadata: channel.metadata,
    );
    await _cacheChannel(session, updatedChannel);

    session.log(
      'User $userId subscribed to channel $channelId',
      level: LogLevel.info,
    );

    return subscription;
  }

  /// Unsubscribe a user from a channel
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID unsubscribing
  /// [channelId] - Channel ID to unsubscribe from
  static Future<void> unsubscribe(
    Session session,
    String userId,
    String channelId,
  ) async {
    final subscription = await getSubscription(session, userId, channelId);
    
    if (subscription == null || !subscription.isActive) {
      return; // Already unsubscribed
    }

    // Update subscription to inactive
    final updatedSubscription = ChannelSubscription(
      id: subscription.id,
      userId: subscription.userId,
      channelId: subscription.channelId,
      isActive: false,
      isMuted: subscription.isMuted,
      subscribedAt: subscription.subscribedAt,
      lastReadAt: subscription.lastReadAt,
      unreadCount: subscription.unreadCount,
      metadata: subscription.metadata,
    );

    await _cacheSubscription(session, updatedSubscription);

    // Update subscriber count
    final channel = await getChannel(session, channelId);
    if (channel != null && channel.subscriberCount > 0) {
      final updatedChannel = NotificationChannel(
        id: channel.id,
        name: channel.name,
        description: channel.description,
        type: channel.type,
        ownerId: channel.ownerId,
        projectId: channel.projectId,
        isActive: channel.isActive,
        isPublic: channel.isPublic,
        maxSubscribers: channel.maxSubscribers,
        subscriberCount: channel.subscriberCount - 1,
        cacheTtlSeconds: channel.cacheTtlSeconds,
        maxCachedNotifications: channel.maxCachedNotifications,
        createdAt: channel.createdAt,
        updatedAt: DateTime.now(),
        metadata: channel.metadata,
      );
      await _cacheChannel(session, updatedChannel);
    }

    session.log(
      'User $userId unsubscribed from channel $channelId',
      level: LogLevel.info,
    );
  }

  /// Get a user's subscription to a channel
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [channelId] - Channel ID
  static Future<ChannelSubscription?> getSubscription(
    Session session,
    String userId,
    String channelId,
  ) async {
    final cacheKey = _getSubscriptionCacheKey(userId, channelId);

    try {
      return await session.caches.global.get<ChannelSubscription>(cacheKey);
    } catch (e) {
      session.log(
        'Failed to get subscription from cache: $e',
        level: LogLevel.debug,
      );
      return null;
    }
  }

  /// Get all active subscriptions for a user
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  static Future<List<String>> getUserSubscribedChannels(
    Session session,
    String userId,
  ) async {
    final listKey = _getUserSubscriptionsKey(userId);

    try {
      final cachedList = await session.caches.global.get<CachedIdList>(listKey);
      if (cachedList != null && cachedList.ids.isNotEmpty) {
        return cachedList.ids.split(',');
      }
    } catch (e) {
      session.log(
        'Failed to get user subscriptions: $e',
        level: LogLevel.debug,
      );
    }

    return [];
  }

  /// Check if a user has access to a channel
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [channelId] - Channel ID
  static Future<bool> hasAccess(
    Session session,
    String userId,
    String channelId,
  ) async {
    final channel = await getChannel(session, channelId);
    
    if (channel == null) {
      return false;
    }

    // Public channels are accessible to all
    if (channel.isPublic) {
      return true;
    }

    // User channels are only accessible to the owner
    if (channel.type == ChannelType.user) {
      return channel.ownerId == userId;
    }

    // Project channels check membership
    if (channel.type == ChannelType.project) {
      final subscription = await getSubscription(session, userId, channelId);
      return subscription != null && subscription.isActive;
    }

    // System channels are public
    if (channel.type == ChannelType.system) {
      return true;
    }

    return false;
  }

  /// Get or create the stream controller for a channel
  /// 
  /// Used internally for broadcasting notifications to subscribers.
  static StreamController<Notification> getChannelStream(String channelId) {
    if (!_channelStreams.containsKey(channelId)) {
      _channelStreams[channelId] = StreamController<Notification>.broadcast();
    }
    return _channelStreams[channelId]!;
  }

  /// Broadcast a notification to all subscribers of a channel
  /// 
  /// [channelId] - Channel to broadcast to
  /// [notification] - Notification to broadcast
  static void broadcastToChannel(String channelId, Notification notification) {
    final stream = getChannelStream(channelId);
    if (!stream.isClosed) {
      stream.add(notification);
    }
  }

  /// Close a channel's stream
  /// 
  /// Should be called when a channel is deleted or deactivated.
  static Future<void> closeChannelStream(String channelId) async {
    if (_channelStreams.containsKey(channelId)) {
      await _channelStreams[channelId]!.close();
      _channelStreams.remove(channelId);
    }
  }

  /// Get all public channels
  /// 
  /// Returns list of all public channels that are currently active.
  /// 
  /// [session] - Serverpod session
  static Future<List<NotificationChannel>> getPublicChannels(
    Session session,
  ) async {
    final listKey = _getPublicChannelsListKey();
    
    try {
      final cachedList = await session.caches.global.get<CachedIdList>(listKey);
      
      if (cachedList == null || cachedList.ids.isEmpty) {
        return [];
      }
      
      final channelIds = cachedList.ids.split(',');
      final channels = <NotificationChannel>[];
      
      for (final channelId in channelIds) {
        final channel = await getChannel(session, channelId);
        if (channel != null && channel.isActive && channel.isPublic) {
          channels.add(channel);
        }
      }
      
      return channels;
    } catch (e) {
      session.log(
        'Failed to get public channels: $e',
        level: LogLevel.debug,
      );
      return [];
    }
  }

  /// Update channel settings
  /// 
  /// [session] - Serverpod session
  /// [channelId] - Channel to update
  /// [name] - Optional new name
  /// [description] - Optional new description
  /// [isActive] - Optional active status
  /// [isPublic] - Optional public status
  static Future<NotificationChannel?> updateChannel(
    Session session,
    String channelId, {
    String? name,
    String? description,
    bool? isActive,
    bool? isPublic,
    int? maxSubscribers,
    int? cacheTtlSeconds,
  }) async {
    final channel = await getChannel(session, channelId);
    
    if (channel == null) {
      return null;
    }

    final updatedChannel = NotificationChannel(
      id: channel.id,
      name: name ?? channel.name,
      description: description ?? channel.description,
      type: channel.type,
      ownerId: channel.ownerId,
      projectId: channel.projectId,
      isActive: isActive ?? channel.isActive,
      isPublic: isPublic ?? channel.isPublic,
      maxSubscribers: maxSubscribers ?? channel.maxSubscribers,
      subscriberCount: channel.subscriberCount,
      cacheTtlSeconds: cacheTtlSeconds ?? channel.cacheTtlSeconds,
      maxCachedNotifications: channel.maxCachedNotifications,
      createdAt: channel.createdAt,
      updatedAt: DateTime.now(),
      metadata: channel.metadata,
    );

    await _cacheChannel(session, updatedChannel);

    return updatedChannel;
  }

  // Private helper methods

  static String _getChannelCacheKey(String channelId) {
    return '$_cacheKeyPrefix:$channelId';
  }

  static String _getSubscriptionCacheKey(String userId, String channelId) {
    return '$_cacheKeyPrefix:sub:$userId:$channelId';
  }

  static String _getUserSubscriptionsKey(String userId) {
    return '$_cacheKeyPrefix:user:$userId:channels';
  }

  static String _getPublicChannelsListKey() {
    return '$_cacheKeyPrefix:public:list';
  }

  static Future<void> _cacheChannel(
    Session session,
    NotificationChannel channel,
  ) async {
    final cacheKey = _getChannelCacheKey(channel.id);

    try {
      await session.caches.global.put(
        cacheKey,
        channel,
        lifetime: _channelCacheTtl,
      );
      
      // Track public channels in a separate list
      if (channel.isPublic && channel.isActive) {
        await _addToPublicChannelsList(session, channel.id);
      }
    } catch (e) {
      session.log(
        'Failed to cache channel: $e',
        level: LogLevel.warning,
      );
    }
  }

  static Future<void> _addToPublicChannelsList(
    Session session,
    String channelId,
  ) async {
    final listKey = _getPublicChannelsListKey();
    final now = DateTime.now();

    try {
      final existing = await session.caches.global.get<CachedIdList>(listKey);
      
      List<String> channels;
      if (existing != null && existing.ids.isNotEmpty) {
        channels = existing.ids.split(',');
        if (!channels.contains(channelId)) {
          channels.add(channelId);
        }
      } else {
        channels = [channelId];
      }

      final cachedList = CachedIdList(
        ids: channels.join(','),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      await session.caches.global.put(
        listKey,
        cachedList,
        lifetime: const Duration(hours: 1),
      );
    } catch (e) {
      session.log(
        'Failed to add to public channels list: $e',
        level: LogLevel.debug,
      );
    }
  }

  static Future<void> _cacheSubscription(
    Session session,
    ChannelSubscription subscription,
  ) async {
    final cacheKey = _getSubscriptionCacheKey(
      subscription.userId,
      subscription.channelId,
    );

    try {
      await session.caches.global.put(
        cacheKey,
        subscription,
        lifetime: _subscriptionCacheTtl,
      );

      // Update user's subscription list
      if (subscription.isActive) {
        await _addToUserSubscriptions(session, subscription.userId, subscription.channelId);
      } else {
        await _removeFromUserSubscriptions(session, subscription.userId, subscription.channelId);
      }
    } catch (e) {
      session.log(
        'Failed to cache subscription: $e',
        level: LogLevel.warning,
      );
    }
  }

  static Future<void> _addToUserSubscriptions(
    Session session,
    String userId,
    String channelId,
  ) async {
    final listKey = _getUserSubscriptionsKey(userId);
    final now = DateTime.now();

    try {
      final existing = await session.caches.global.get<CachedIdList>(listKey);
      
      List<String> channels;
      if (existing != null && existing.ids.isNotEmpty) {
        channels = existing.ids.split(',');
        if (!channels.contains(channelId)) {
          channels.add(channelId);
        }
      } else {
        channels = [channelId];
      }

      final cachedList = CachedIdList(
        ids: channels.join(','),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      await session.caches.global.put(
        listKey,
        cachedList,
        lifetime: _subscriptionCacheTtl,
      );
    } catch (e) {
      session.log(
        'Failed to update user subscriptions: $e',
        level: LogLevel.debug,
      );
    }
  }

  static Future<void> _removeFromUserSubscriptions(
    Session session,
    String userId,
    String channelId,
  ) async {
    final listKey = _getUserSubscriptionsKey(userId);
    final now = DateTime.now();

    try {
      final existing = await session.caches.global.get<CachedIdList>(listKey);
      
      if (existing != null && existing.ids.isNotEmpty) {
        final channels = existing.ids.split(',');
        channels.remove(channelId);
        
        if (channels.isNotEmpty) {
          final cachedList = CachedIdList(
            ids: channels.join(','),
            createdAt: existing.createdAt,
            updatedAt: now,
          );
          
          await session.caches.global.put(
            listKey,
            cachedList,
            lifetime: _subscriptionCacheTtl,
          );
        } else {
          await session.caches.global.invalidateKey(listKey);
        }
      }
    } catch (e) {
      session.log(
        'Failed to update user subscriptions: $e',
        level: LogLevel.debug,
      );
    }
  }
}
