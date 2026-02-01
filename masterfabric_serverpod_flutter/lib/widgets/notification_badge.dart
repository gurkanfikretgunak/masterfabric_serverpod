import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/notification_service.dart';

/// Notification bell icon with unread badge
/// 
/// Displays a bell icon with an animated badge showing
/// the number of unread notifications.
class NotificationBadge extends StatefulWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  final double iconSize;

  const NotificationBadge({
    super.key,
    this.onTap,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService.instance;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _notificationService.addListener(_onServiceUpdate);
    _previousCount = _notificationService.unreadCount;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onServiceUpdate);
    _animationController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      final newCount = _notificationService.unreadCount;
      if (newCount > _previousCount) {
        // New notification received - animate
        _animationController.forward(from: 0);
      }
      _previousCount = newCount;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notificationService.unreadCount;
    final isConnected = _notificationService.isConnected;

    return IconButton(
      onPressed: widget.onTap,
      tooltip: 'Notifications',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bell icon
          Icon(
            isConnected ? LucideIcons.bell : LucideIcons.bellOff,
            color: widget.iconColor,
            size: widget.iconSize,
          ),

          // Badge
          if (unreadCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Connection indicator
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isConnected ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact notification indicator for smaller spaces
class NotificationIndicator extends StatelessWidget {
  final int count;
  final bool isConnected;

  const NotificationIndicator({
    super.key,
    required this.count,
    this.isConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Connection dot
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),

        // Bell icon
        Icon(
          isConnected ? LucideIcons.bell : LucideIcons.bellOff,
          size: 16,
          color: Colors.grey[600],
        ),

        // Count
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
