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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../../core/real_time/notifications_center/models/notification.dart'
    as _i2;
import 'package:masterfabric_serverpod_client/src/protocol/protocol.dart'
    as _i3;

/// Notification list response model
/// Response for listing notifications with pagination
abstract class NotificationListResponse implements _i1.SerializableModel {
  NotificationListResponse._({
    required this.success,
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
    required this.hasMore,
    this.nextCursor,
    required this.timestamp,
  });

  factory NotificationListResponse({
    required bool success,
    required List<_i2.Notification> notifications,
    required int totalCount,
    required int unreadCount,
    required bool hasMore,
    String? nextCursor,
    required DateTime timestamp,
  }) = _NotificationListResponseImpl;

  factory NotificationListResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationListResponse(
      success: jsonSerialization['success'] as bool,
      notifications: _i3.Protocol().deserialize<List<_i2.Notification>>(
        jsonSerialization['notifications'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
      unreadCount: jsonSerialization['unreadCount'] as int,
      hasMore: jsonSerialization['hasMore'] as bool,
      nextCursor: jsonSerialization['nextCursor'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  List<_i2.Notification> notifications;

  int totalCount;

  int unreadCount;

  bool hasMore;

  String? nextCursor;

  DateTime timestamp;

  /// Returns a shallow copy of this [NotificationListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationListResponse copyWith({
    bool? success,
    List<_i2.Notification>? notifications,
    int? totalCount,
    int? unreadCount,
    bool? hasMore,
    String? nextCursor,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationListResponse',
      'success': success,
      'notifications': notifications.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      'unreadCount': unreadCount,
      'hasMore': hasMore,
      if (nextCursor != null) 'nextCursor': nextCursor,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationListResponseImpl extends NotificationListResponse {
  _NotificationListResponseImpl({
    required bool success,
    required List<_i2.Notification> notifications,
    required int totalCount,
    required int unreadCount,
    required bool hasMore,
    String? nextCursor,
    required DateTime timestamp,
  }) : super._(
         success: success,
         notifications: notifications,
         totalCount: totalCount,
         unreadCount: unreadCount,
         hasMore: hasMore,
         nextCursor: nextCursor,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [NotificationListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationListResponse copyWith({
    bool? success,
    List<_i2.Notification>? notifications,
    int? totalCount,
    int? unreadCount,
    bool? hasMore,
    Object? nextCursor = _Undefined,
    DateTime? timestamp,
  }) {
    return NotificationListResponse(
      success: success ?? this.success,
      notifications:
          notifications ??
          this.notifications.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor is String? ? nextCursor : this.nextCursor,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
