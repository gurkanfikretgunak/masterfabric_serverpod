import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Notification service for managing real-time notifications
/// 
/// Provides a centralized way to subscribe to notification channels,
/// manage notification state, and broadcast updates to the UI.
class NotificationService extends ChangeNotifier {
  static NotificationService? _instance;
  
  /// Singleton instance
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }
  
  NotificationService._();
  
  Client? _client;
  
  /// Current notifications list
  final List<Notification> _notifications = [];
  List<Notification> get notifications => List.unmodifiable(_notifications);
  
  /// Unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  
  /// Active stream subscription
  StreamSubscription<Notification>? _streamSubscription;
  
  /// Currently subscribed channel IDs
  final Set<String> _subscribedChannels = {};
  Set<String> get subscribedChannels => Set.unmodifiable(_subscribedChannels);
  
  /// Connection state
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  
  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  /// Error state
  String? _error;
  String? get error => _error;

  /// Initialize the notification service
  void initialize(Client client) {
    _client = client;
    debugPrint('NotificationService initialized');
  }

  /// Subscribe to user's personal notifications
  Future<void> subscribeToUserNotifications() async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cancel existing subscription
      await _streamSubscription?.cancel();
      
      // Subscribe to user notifications
      final stream = _client!.notificationStream.subscribeToUserNotifications();
      
      _streamSubscription = stream.listen(
        _onNotificationReceived,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );
      
      _isConnected = true;
      _isLoading = false;
      notifyListeners();
      
      debugPrint('Subscribed to user notifications');
    } catch (e) {
      _error = 'Failed to subscribe: $e';
      _isLoading = false;
      _isConnected = false;
      notifyListeners();
      debugPrint('Error subscribing to user notifications: $e');
    }
  }

  /// Subscribe to specific channels
  Future<void> subscribeToChannels(List<String> channelIds) async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return;
    }

    if (channelIds.isEmpty) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cancel existing subscription
      await _streamSubscription?.cancel();
      
      // Subscribe to channels
      final stream = _client!.notificationStream.subscribe(channelIds);
      
      _streamSubscription = stream.listen(
        _onNotificationReceived,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );
      
      _subscribedChannels.addAll(channelIds);
      _isConnected = true;
      _isLoading = false;
      notifyListeners();
      
      debugPrint('Subscribed to channels: $channelIds');
    } catch (e) {
      _error = 'Failed to subscribe: $e';
      _isLoading = false;
      _isConnected = false;
      notifyListeners();
      debugPrint('Error subscribing to channels: $e');
    }
  }

  /// Subscribe to public broadcasts
  Future<void> subscribeToBroadcasts(List<String> channelIds) async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return;
    }

    if (channelIds.isEmpty) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cancel existing subscription
      await _streamSubscription?.cancel();
      
      // Subscribe to broadcasts
      final stream = _client!.notificationStream.subscribeToBroadcasts(channelIds);
      
      _streamSubscription = stream.listen(
        _onNotificationReceived,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );
      
      _subscribedChannels.addAll(channelIds);
      _isConnected = true;
      _isLoading = false;
      notifyListeners();
      
      debugPrint('Subscribed to broadcasts: $channelIds');
    } catch (e) {
      _error = 'Failed to subscribe: $e';
      _isLoading = false;
      _isConnected = false;
      notifyListeners();
      debugPrint('Error subscribing to broadcasts: $e');
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribe() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    _subscribedChannels.clear();
    _isConnected = false;
    notifyListeners();
    debugPrint('Unsubscribed from all channels');
  }

  /// Load notification history
  /// 
  /// Loads both user notifications (if authenticated) and public notifications.
  Future<void> loadHistory({int limit = 50}) async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications.clear();
      
      // Try to load user notifications first (requires auth)
      try {
        final userResponse = await _client!.notification.getUserNotifications(
          limit: limit,
        );
        if (userResponse.success) {
          _notifications.addAll(userResponse.notifications);
        }
      } catch (e) {
        debugPrint('User notifications not available (may need auth): $e');
      }
      
      // Also load public notifications (available to all)
      final publicResponse = await _client!.notification.getPublicNotifications(
        limit: limit,
      );
      
      if (publicResponse.success) {
        // Add unique public notifications
        for (final notification in publicResponse.notifications) {
          if (!_notifications.any((n) => n.id == notification.id)) {
            _notifications.add(notification);
          }
        }
      }
      
      _sortNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load history: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading notification history: $e');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String channelId, String notificationId) async {
    if (_client == null) return;

    try {
      await _client!.notification.markAsRead(channelId, notificationId);
      
      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = _notifications[index];
        _notifications[index] = Notification(
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
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read for a channel
  Future<void> markAllAsRead(String channelId) async {
    if (_client == null) return;

    try {
      await _client!.notification.markAllAsRead(channelId);
      
      // Update local state
      for (var i = 0; i < _notifications.length; i++) {
        if (_notifications[i].channelId == channelId && !_notifications[i].isRead) {
          final notification = _notifications[i];
          _notifications[i] = Notification(
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
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    }
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  /// Delete a notification locally
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  /// Join a channel
  Future<bool> joinChannel(String channelId) async {
    if (_client == null) return false;

    try {
      final response = await _client!.notification.joinChannel(channelId);
      if (response.success) {
        _subscribedChannels.add(channelId);
        notifyListeners();
      }
      return response.success;
    } catch (e) {
      debugPrint('Error joining channel: $e');
      return false;
    }
  }

  /// Leave a channel
  Future<bool> leaveChannel(String channelId) async {
    if (_client == null) return false;

    try {
      final response = await _client!.notification.leaveChannel(channelId);
      if (response.success) {
        _subscribedChannels.remove(channelId);
        notifyListeners();
      }
      return response.success;
    } catch (e) {
      debugPrint('Error leaving channel: $e');
      return false;
    }
  }

  /// Get available public channels
  Future<List<NotificationChannel>?> getPublicChannels() async {
    if (_client == null) return null;

    try {
      final response = await _client!.notification.listPublicChannels();
      if (response.success) {
        return response.channels;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting public channels: $e');
      return null;
    }
  }

  // Private methods

  void _onNotificationReceived(Notification notification) {
    // Add to beginning of list (newest first)
    _notifications.insert(0, notification);
    
    // Remove duplicates
    final seen = <String>{};
    _notifications.retainWhere((n) => seen.add(n.id));
    
    notifyListeners();
    debugPrint('Notification received: ${notification.title}');
  }

  void _onStreamError(Object error) {
    _error = 'Stream error: $error';
    _isConnected = false;
    notifyListeners();
    debugPrint('Notification stream error: $error');
  }

  void _onStreamDone() {
    _isConnected = false;
    notifyListeners();
    debugPrint('Notification stream closed');
  }

  void _sortNotifications() {
    _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
