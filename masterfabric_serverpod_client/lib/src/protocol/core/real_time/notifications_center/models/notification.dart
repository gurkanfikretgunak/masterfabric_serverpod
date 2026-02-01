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
import '../../../../core/real_time/notifications_center/models/notification_type.dart'
    as _i2;
import '../../../../core/real_time/notifications_center/models/notification_priority.dart'
    as _i3;

/// Core notification model
/// Represents a single notification that can be sent to users
abstract class Notification implements _i1.SerializableModel {
  Notification._({
    required this.id,
    required this.type,
    required this.channelId,
    required this.title,
    required this.body,
    this.payload,
    required this.priority,
    this.targetUserId,
    this.senderId,
    this.senderName,
    this.actionUrl,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
    this.expiresAt,
    this.metadata,
  });

  factory Notification({
    required String id,
    required _i2.NotificationType type,
    required String channelId,
    required String title,
    required String body,
    String? payload,
    required _i3.NotificationPriority priority,
    String? targetUserId,
    String? senderId,
    String? senderName,
    String? actionUrl,
    String? imageUrl,
    required bool isRead,
    required DateTime createdAt,
    DateTime? expiresAt,
    String? metadata,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] as String,
      type: _i2.NotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      channelId: jsonSerialization['channelId'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      payload: jsonSerialization['payload'] as String?,
      priority: _i3.NotificationPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      targetUserId: jsonSerialization['targetUserId'] as String?,
      senderId: jsonSerialization['senderId'] as String?,
      senderName: jsonSerialization['senderName'] as String?,
      actionUrl: jsonSerialization['actionUrl'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      isRead: jsonSerialization['isRead'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  String id;

  _i2.NotificationType type;

  String channelId;

  String title;

  String body;

  String? payload;

  _i3.NotificationPriority priority;

  String? targetUserId;

  String? senderId;

  String? senderName;

  String? actionUrl;

  String? imageUrl;

  bool isRead;

  DateTime createdAt;

  DateTime? expiresAt;

  String? metadata;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Notification copyWith({
    String? id,
    _i2.NotificationType? type,
    String? channelId,
    String? title,
    String? body,
    String? payload,
    _i3.NotificationPriority? priority,
    String? targetUserId,
    String? senderId,
    String? senderName,
    String? actionUrl,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Notification',
      'id': id,
      'type': type.toJson(),
      'channelId': channelId,
      'title': title,
      'body': body,
      if (payload != null) 'payload': payload,
      'priority': priority.toJson(),
      if (targetUserId != null) 'targetUserId': targetUserId,
      if (senderId != null) 'senderId': senderId,
      if (senderName != null) 'senderName': senderName,
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    required String id,
    required _i2.NotificationType type,
    required String channelId,
    required String title,
    required String body,
    String? payload,
    required _i3.NotificationPriority priority,
    String? targetUserId,
    String? senderId,
    String? senderName,
    String? actionUrl,
    String? imageUrl,
    required bool isRead,
    required DateTime createdAt,
    DateTime? expiresAt,
    String? metadata,
  }) : super._(
         id: id,
         type: type,
         channelId: channelId,
         title: title,
         body: body,
         payload: payload,
         priority: priority,
         targetUserId: targetUserId,
         senderId: senderId,
         senderName: senderName,
         actionUrl: actionUrl,
         imageUrl: imageUrl,
         isRead: isRead,
         createdAt: createdAt,
         expiresAt: expiresAt,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Notification copyWith({
    String? id,
    _i2.NotificationType? type,
    String? channelId,
    String? title,
    String? body,
    Object? payload = _Undefined,
    _i3.NotificationPriority? priority,
    Object? targetUserId = _Undefined,
    Object? senderId = _Undefined,
    Object? senderName = _Undefined,
    Object? actionUrl = _Undefined,
    Object? imageUrl = _Undefined,
    bool? isRead,
    DateTime? createdAt,
    Object? expiresAt = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload is String? ? payload : this.payload,
      priority: priority ?? this.priority,
      targetUserId: targetUserId is String? ? targetUserId : this.targetUserId,
      senderId: senderId is String? ? senderId : this.senderId,
      senderName: senderName is String? ? senderName : this.senderName,
      actionUrl: actionUrl is String? ? actionUrl : this.actionUrl,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}
