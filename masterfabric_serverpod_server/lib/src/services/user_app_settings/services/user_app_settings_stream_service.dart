import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Service for managing real-time settings updates via streaming
/// 
/// Handles stream controllers for user settings updates.
class UserAppSettingsStreamService {
  static final UserAppSettingsStreamService _instance =
      UserAppSettingsStreamService._internal();
  
  static UserAppSettingsStreamService get instance => _instance;
  
  UserAppSettingsStreamService._internal();

  // In-memory stream controllers for each user
  // Key: userId, Value: StreamController for broadcasting
  final Map<String, StreamController<UserAppSettingsEvent>> _userStreams = {};

  /// Get or create stream controller for a user
  StreamController<UserAppSettingsEvent> _getOrCreateStream(String userId) {
    if (!_userStreams.containsKey(userId)) {
      _userStreams[userId] = StreamController<UserAppSettingsEvent>.broadcast();
    }
    return _userStreams[userId]!;
  }

  /// Get stream for a user's settings updates
  Stream<UserAppSettingsEvent> getStream(String userId) {
    final controller = _getOrCreateStream(userId);
    return controller.stream;
  }

  /// Broadcast settings update to user's stream
  void broadcastUpdate(
    Session session,
    String userId,
    UserAppSettings settings,
  ) {
    final controller = _userStreams[userId];
    if (controller != null && !controller.isClosed) {
      final event = UserAppSettingsEvent(
        type: 'updated',
        settings: settings,
        timestamp: DateTime.now(),
      );
      controller.add(event);

      session.log(
        'Broadcasted settings update to user stream - userId: $userId',
        level: LogLevel.debug,
      );
    }
  }

  /// Broadcast settings deletion to user's stream
  void broadcastDelete(Session session, String userId) {
    final controller = _userStreams[userId];
    if (controller != null && !controller.isClosed) {
      final event = UserAppSettingsEvent(
        type: 'deleted',
        settings: null,
        timestamp: DateTime.now(),
      );
      controller.add(event);

      session.log(
        'Broadcasted settings deletion to user stream - userId: $userId',
        level: LogLevel.debug,
      );
    }
  }

  /// Clean up stream for a user (when they disconnect)
  void cleanup(String userId) {
    final controller = _userStreams[userId];
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
    _userStreams.remove(userId);
  }

  /// Clean up all streams (for shutdown)
  void cleanupAll() {
    for (final controller in _userStreams.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    _userStreams.clear();
  }
}
