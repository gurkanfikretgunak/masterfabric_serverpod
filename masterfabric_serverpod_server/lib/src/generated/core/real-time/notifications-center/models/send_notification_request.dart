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
import '../../../../core/real-time/notifications-center/models/notification_type.dart'
    as _i2;
import '../../../../core/real-time/notifications-center/models/notification_priority.dart'
    as _i3;

/// Send notification request model
/// Request payload for sending notifications
abstract class SendNotificationRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SendNotificationRequest._({
    required this.type,
    this.channelId,
    this.targetUserId,
    required this.title,
    required this.body,
    this.payload,
    this.priority,
    this.actionUrl,
    this.imageUrl,
    this.expiresInSeconds,
    this.metadata,
  });

  factory SendNotificationRequest({
    required _i2.NotificationType type,
    String? channelId,
    String? targetUserId,
    required String title,
    required String body,
    String? payload,
    _i3.NotificationPriority? priority,
    String? actionUrl,
    String? imageUrl,
    int? expiresInSeconds,
    String? metadata,
  }) = _SendNotificationRequestImpl;

  factory SendNotificationRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SendNotificationRequest(
      type: _i2.NotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      channelId: jsonSerialization['channelId'] as String?,
      targetUserId: jsonSerialization['targetUserId'] as String?,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      payload: jsonSerialization['payload'] as String?,
      priority: jsonSerialization['priority'] == null
          ? null
          : _i3.NotificationPriority.fromJson(
              (jsonSerialization['priority'] as String),
            ),
      actionUrl: jsonSerialization['actionUrl'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      expiresInSeconds: jsonSerialization['expiresInSeconds'] as int?,
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  _i2.NotificationType type;

  String? channelId;

  String? targetUserId;

  String title;

  String body;

  String? payload;

  _i3.NotificationPriority? priority;

  String? actionUrl;

  String? imageUrl;

  int? expiresInSeconds;

  String? metadata;

  /// Returns a shallow copy of this [SendNotificationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SendNotificationRequest copyWith({
    _i2.NotificationType? type,
    String? channelId,
    String? targetUserId,
    String? title,
    String? body,
    String? payload,
    _i3.NotificationPriority? priority,
    String? actionUrl,
    String? imageUrl,
    int? expiresInSeconds,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SendNotificationRequest',
      'type': type.toJson(),
      if (channelId != null) 'channelId': channelId,
      if (targetUserId != null) 'targetUserId': targetUserId,
      'title': title,
      'body': body,
      if (payload != null) 'payload': payload,
      if (priority != null) 'priority': priority?.toJson(),
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SendNotificationRequest',
      'type': type.toJson(),
      if (channelId != null) 'channelId': channelId,
      if (targetUserId != null) 'targetUserId': targetUserId,
      'title': title,
      'body': body,
      if (payload != null) 'payload': payload,
      if (priority != null) 'priority': priority?.toJson(),
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SendNotificationRequestImpl extends SendNotificationRequest {
  _SendNotificationRequestImpl({
    required _i2.NotificationType type,
    String? channelId,
    String? targetUserId,
    required String title,
    required String body,
    String? payload,
    _i3.NotificationPriority? priority,
    String? actionUrl,
    String? imageUrl,
    int? expiresInSeconds,
    String? metadata,
  }) : super._(
         type: type,
         channelId: channelId,
         targetUserId: targetUserId,
         title: title,
         body: body,
         payload: payload,
         priority: priority,
         actionUrl: actionUrl,
         imageUrl: imageUrl,
         expiresInSeconds: expiresInSeconds,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [SendNotificationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SendNotificationRequest copyWith({
    _i2.NotificationType? type,
    Object? channelId = _Undefined,
    Object? targetUserId = _Undefined,
    String? title,
    String? body,
    Object? payload = _Undefined,
    Object? priority = _Undefined,
    Object? actionUrl = _Undefined,
    Object? imageUrl = _Undefined,
    Object? expiresInSeconds = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return SendNotificationRequest(
      type: type ?? this.type,
      channelId: channelId is String? ? channelId : this.channelId,
      targetUserId: targetUserId is String? ? targetUserId : this.targetUserId,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload is String? ? payload : this.payload,
      priority: priority is _i3.NotificationPriority?
          ? priority
          : this.priority,
      actionUrl: actionUrl is String? ? actionUrl : this.actionUrl,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      expiresInSeconds: expiresInSeconds is int?
          ? expiresInSeconds
          : this.expiresInSeconds,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}
