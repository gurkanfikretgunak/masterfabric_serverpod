import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// A banner widget that displays rate limit information and countdown
/// 
/// Shows when the user is rate limited with:
/// - Countdown timer until reset
/// - Visual progress indicator
/// - Retry button when ready
class RateLimitBanner extends StatefulWidget {
  final RateLimitException exception;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const RateLimitBanner({
    super.key,
    required this.exception,
    this.onRetry,
    this.onDismiss,
  });

  @override
  State<RateLimitBanner> createState() => _RateLimitBannerState();
}

class _RateLimitBannerState extends State<RateLimitBanner> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _canRetry = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.exception.retryAfterSeconds;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canRetry = true;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / widget.exception.retryAfterSeconds;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _canRetry ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _canRetry ? Colors.green.shade200 : Colors.orange.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: LinearProgressIndicator(
              value: 1 - progress,
              backgroundColor: Colors.orange.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                _canRetry ? Colors.green : Colors.orange,
              ),
              minHeight: 4,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Icon and title row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _canRetry 
                            ? Colors.green.shade100 
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _canRetry ? LucideIcons.circleCheck : LucideIcons.timer,
                        color: _canRetry ? Colors.green : Colors.orange.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _canRetry ? 'Ready to retry!' : 'Rate limit reached',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _canRetry 
                                  ? Colors.green.shade800 
                                  : Colors.orange.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _canRetry 
                                ? 'You can try again now'
                                : 'Please wait before trying again',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.onDismiss != null)
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: widget.onDismiss,
                        color: Colors.grey.shade500,
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Stats row
                if (!_canRetry) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: LucideIcons.clock,
                          label: 'Wait time',
                          value: _formatTime(_secondsRemaining),
                          color: Colors.orange,
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        _StatItem(
                          icon: LucideIcons.repeat,
                          label: 'Requests',
                          value: '${widget.exception.current}/${widget.exception.limit}',
                          color: Colors.red,
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        _StatItem(
                          icon: LucideIcons.calendarClock,
                          label: 'Window',
                          value: '${widget.exception.windowSeconds}s',
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Retry button
                if (_canRetry && widget.onRetry != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.onRetry,
                      icon: const Icon(LucideIcons.refreshCw),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

/// A simple inline rate limit indicator for showing remaining requests
class RateLimitIndicator extends StatelessWidget {
  final int current;
  final int limit;
  final int remaining;

  const RateLimitIndicator({
    super.key,
    required this.current,
    required this.limit,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = current / limit;
    final isWarning = remaining <= 5;
    final isDanger = remaining <= 2;
    
    Color getColor() {
      if (isDanger) return Colors.red;
      if (isWarning) return Colors.orange;
      return Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: getColor().withAlpha(26), // 0.1 * 255 ≈ 26
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: getColor().withAlpha(77)), // 0.3 * 255 ≈ 77
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDanger ? LucideIcons.triangleAlert : LucideIcons.gauge,
            size: 16,
            color: getColor(),
          ),
          const SizedBox(width: 6),
          Text(
            '$remaining left',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: getColor(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(getColor()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
