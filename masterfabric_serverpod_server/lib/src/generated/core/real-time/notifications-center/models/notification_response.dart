/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../../core/real-time/notifications-center/models/notification.dart'
    as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Notification API response model
/// Standard response for notification operations
abstract class NotificationResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NotificationResponse._({
    required this.success,
    required this.message,
    this.notificationId,
    this.notification,
    required this.timestamp,
  });

  factory NotificationResponse({
    required bool success,
    required String message,
    String? notificationId,
    _i2.Notification? notification,
    required DateTime timestamp,
  }) = _NotificationResponseImpl;

  factory NotificationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String,
      notificationId: jsonSerialization['notificationId'] as String?,
      notification: jsonSerialization['notification'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Notification>(
              jsonSerialization['notification'],
            ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  String message;

  String? notificationId;

  _i2.Notification? notification;

  DateTime timestamp;

  /// Returns a shallow copy of this [NotificationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationResponse copyWith({
    bool? success,
    String? message,
    String? notificationId,
    _i2.Notification? notification,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationResponse',
      'success': success,
      'message': message,
      if (notificationId != null) 'notificationId': notificationId,
      if (notification != null) 'notification': notification?.toJson(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationResponse',
      'success': success,
      'message': message,
      if (notificationId != null) 'notificationId': notificationId,
      if (notification != null)
        'notification': notification?.toJsonForProtocol(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationResponseImpl extends NotificationResponse {
  _NotificationResponseImpl({
    required bool success,
    required String message,
    String? notificationId,
    _i2.Notification? notification,
    required DateTime timestamp,
  }) : super._(
         success: success,
         message: message,
         notificationId: notificationId,
         notification: notification,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [NotificationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationResponse copyWith({
    bool? success,
    String? message,
    Object? notificationId = _Undefined,
    Object? notification = _Undefined,
    DateTime? timestamp,
  }) {
    return NotificationResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      notificationId: notificationId is String?
          ? notificationId
          : this.notificationId,
      notification: notification is _i2.Notification?
          ? notification
          : this.notification?.copyWith(),
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
