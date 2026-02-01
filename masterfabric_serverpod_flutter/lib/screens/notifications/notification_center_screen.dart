import 'package:flutter/material.dart' hide Notification;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import '../../services/notification_service.dart';
import 'notification_item_widget.dart';

/// Notification Center Screen
/// 
/// Displays a list of notifications with real-time updates,
/// filtering options, and actions like mark as read.
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final NotificationService _notificationService = NotificationService.instance;
  
  // Filter options
  NotificationFilter _currentFilter = NotificationFilter.all;
  
  @override
  void initState() {
    super.initState();
    _notificationService.addListener(_onServiceUpdate);
    _loadNotifications();
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadNotifications() async {
    await _notificationService.loadHistory(limit: 50);
  }

  Future<void> _connectToStream() async {
    // First load public channels and subscribe to broadcasts
    await _loadAndSubscribeToBroadcasts();
  }

  Future<void> _loadAndSubscribeToBroadcasts() async {
    try {
      // Get available public channels
      final response = await _notificationService.getPublicChannels();
      if (response != null && response.isNotEmpty) {
        final channelIds = response.map((c) => c.id).toList();
        await _notificationService.subscribeToBroadcasts(channelIds);
      } else {
        // Fallback to user notifications if no public channels
        await _notificationService.subscribeToUserNotifications();
      }
    } catch (e) {
      debugPrint('Error subscribing to broadcasts: $e');
      // Fallback to user notifications
      await _notificationService.subscribeToUserNotifications();
    }
  }

  List<Notification> get _filteredNotifications {
    final notifications = _notificationService.notifications;
    
    switch (_currentFilter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.unread:
        return notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.read:
        return notifications.where((n) => n.isRead).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        titleSpacing: 0,
        actions: [
          // Connection status indicator
          _buildConnectionIndicator(),
          
          // Mark all as read
          if (_notificationService.unreadCount > 0)
            IconButton(
              icon: const Icon(LucideIcons.checkCheck, size: 20),
              tooltip: 'Mark all as read',
              onPressed: _markAllAsRead,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          
          // Refresh
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 20),
            tooltip: 'Refresh',
            onPressed: _loadNotifications,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          _buildFilterBar(),
          
          // Error banner
          if (_notificationService.error != null)
            _buildErrorBanner(),
          
          // Notification list
          Expanded(
            child: _buildNotificationList(),
          ),
        ],
      ),
      floatingActionButton: !_notificationService.isConnected
          ? FloatingActionButton.extended(
              onPressed: _connectToStream,
              icon: const Icon(LucideIcons.radio),
              label: const Text('Connect'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildConnectionIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: _notificationService.isConnected 
            ? Colors.green.withAlpha(20) 
            : Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _notificationService.isConnected 
                  ? Colors.green 
                  : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _notificationService.isConnected ? 'Live' : 'Off',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _notificationService.isConnected 
                  ? Colors.green[700] 
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filter chips
            _buildFilterChip(
              label: 'All',
              filter: NotificationFilter.all,
              count: _notificationService.notifications.length,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Unread',
              filter: NotificationFilter.unread,
              count: _notificationService.unreadCount,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Read',
              filter: NotificationFilter.read,
              count: _notificationService.notifications.length - 
                     _notificationService.unreadCount,
            ),
            
            const SizedBox(width: 16),
            
            // Clear all button
            if (_notificationService.notifications.isNotEmpty)
              TextButton.icon(
                onPressed: _showClearConfirmation,
                icon: const Icon(LucideIcons.trash2, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required NotificationFilter filter,
    required int count,
  }) {
    final isSelected = _currentFilter == filter;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withAlpha(50) 
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _currentFilter = filter;
        });
      },
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
      side: BorderSide(
        color: isSelected ? Colors.blue : Colors.grey[300]!,
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red[50],
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, color: Colors.red[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _notificationService.error!,
              style: TextStyle(color: Colors.red[700], fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: _connectToStream,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    if (_notificationService.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationItemWidget(
            notification: notification,
            onTap: () => _onNotificationTap(notification),
            onMarkAsRead: () => _markAsRead(notification),
            onDelete: () => _deleteNotification(notification),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    IconData icon;
    String title;
    String subtitle;

    switch (_currentFilter) {
      case NotificationFilter.all:
        icon = LucideIcons.bellOff;
        title = 'No notifications';
        subtitle = 'You\'re all caught up! New notifications will appear here.';
        break;
      case NotificationFilter.unread:
        icon = LucideIcons.circleCheck;
        title = 'All caught up!';
        subtitle = 'You have no unread notifications.';
        break;
      case NotificationFilter.read:
        icon = LucideIcons.inbox;
        title = 'No read notifications';
        subtitle = 'Notifications you\'ve read will appear here.';
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNotificationTap(Notification notification) {
    // Mark as read when tapped
    if (!notification.isRead) {
      _markAsRead(notification);
    }

    // Handle action URL if present
    if (notification.actionUrl != null) {
      // TODO: Navigate to action URL
      debugPrint('Action URL: ${notification.actionUrl}');
    }

    // Show notification details
    _showNotificationDetails(notification);
  }

  void _showNotificationDetails(Notification notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Priority badge
              _buildPriorityBadge(notification.priority),
              const SizedBox(height: 16),
              
              // Title
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Body
              Text(
                notification.body,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              
              // Metadata
              _buildMetadataRow(
                icon: LucideIcons.clock,
                label: 'Received',
                value: _formatDateTime(notification.createdAt),
              ),
              if (notification.senderName != null)
                _buildMetadataRow(
                  icon: LucideIcons.user,
                  label: 'From',
                  value: notification.senderName!,
                ),
              _buildMetadataRow(
                icon: LucideIcons.hash,
                label: 'Channel',
                value: notification.channelId,
              ),
              
              const SizedBox(height: 24),
              
              // Action button
              if (notification.actionUrl != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Handle action URL
                    },
                    icon: const Icon(LucideIcons.externalLink),
                    label: const Text('Open'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    Color color;
    String label;
    
    switch (priority) {
      case NotificationPriority.low:
        color = Colors.grey;
        label = 'Low Priority';
        break;
      case NotificationPriority.normal:
        color = Colors.blue;
        label = 'Normal';
        break;
      case NotificationPriority.high:
        color = Colors.orange;
        label = 'High Priority';
        break;
      case NotificationPriority.urgent:
        color = Colors.red;
        label = 'Urgent';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMetadataRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _markAsRead(Notification notification) {
    _notificationService.markAsRead(notification.channelId, notification.id);
  }

  void _markAllAsRead() {
    // Get unique channel IDs
    final channelIds = _notificationService.notifications
        .where((n) => !n.isRead)
        .map((n) => n.channelId)
        .toSet();
    
    for (final channelId in channelIds) {
      _notificationService.markAllAsRead(channelId);
    }
  }

  void _deleteNotification(Notification notification) {
    _notificationService.deleteNotification(notification.id);
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text(
          'This will remove all notifications from your list. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _notificationService.clearAll();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

/// Filter options for notifications
enum NotificationFilter {
  all,
  unread,
  read,
}
