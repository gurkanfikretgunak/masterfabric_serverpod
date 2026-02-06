import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../services/user_app_settings_stream_service.dart';
import '../services/user_app_settings_service.dart';

/// Real-time user app settings streaming endpoint
/// 
/// Provides WebSocket-based streaming for real-time settings updates.
/// Uses Serverpod's streaming methods for automatic connection management.
/// 
/// Clients can subscribe to receive settings updates in real-time.
class UserAppSettingsStreamEndpoint extends Endpoint {
  final UserAppSettingsService _settingsService = UserAppSettingsService();

  /// Require authentication for streaming
  @override
  bool get requireLogin => true;

  /// Subscribe to user's app settings updates
  /// 
  /// This is the main streaming method. Clients call this to establish
  /// a WebSocket connection and receive settings updates as they occur.
  /// 
  /// [session] - Serverpod session (automatically managed)
  /// 
  /// Returns a stream of settings events (updated, deleted).
  /// The stream first yields the current settings, then continues
  /// with real-time updates.
  Stream<UserAppSettingsEvent> subscribe(Session session) async* {
    final userId = session.authenticated?.userIdentifier.toString();
    
    if (userId == null) {
      session.log(
        'Settings stream subscription failed: not authenticated',
        level: LogLevel.warning,
      );
      return;
    }

    session.log(
      'Settings stream subscription started for user: $userId',
      level: LogLevel.info,
    );

    // Load current settings and yield as initial event
    try {
      final currentSettings = await _settingsService.getOrCreateSettings(
        session,
        userId,
      );
      
      yield UserAppSettingsEvent(
        type: 'updated',
        settings: currentSettings,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log(
        'Failed to load initial settings: $e',
        level: LogLevel.warning,
      );
    }

    final streamService = UserAppSettingsStreamService.instance;
    final stream = streamService.getStream(userId);

    try {
      // Yield updates from the stream
      await for (final event in stream) {
        yield event;
      }
    } finally {
      // Clean up when the stream is closed
      streamService.cleanup(userId);
      
      session.log(
        'Settings stream subscription ended for user: $userId',
        level: LogLevel.info,
      );
    }
  }
}
