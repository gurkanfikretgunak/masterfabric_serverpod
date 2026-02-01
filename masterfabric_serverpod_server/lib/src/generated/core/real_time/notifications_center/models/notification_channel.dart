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
import '../../../../core/real_time/notifications_center/models/channel_type.dart'
    as _i2;

/// Notification channel model
/// Represents a channel that users can subscribe to for notifications
abstract class NotificationChannel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NotificationChannel._({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    this.ownerId,
    this.projectId,
    required this.isActive,
    required this.isPublic,
    this.maxSubscribers,
    required this.subscriberCount,
    required this.cacheTtlSeconds,
    required this.maxCachedNotifications,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory NotificationChannel({
    required String id,
    required String name,
    String? description,
    required _i2.ChannelType type,
    String? ownerId,
    String? projectId,
    required bool isActive,
    required bool isPublic,
    int? maxSubscribers,
    required int subscriberCount,
    required int cacheTtlSeconds,
    required int maxCachedNotifications,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? metadata,
  }) = _NotificationChannelImpl;

  factory NotificationChannel.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotificationChannel(
      id: jsonSerialization['id'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      type: _i2.ChannelType.fromJson((jsonSerialization['type'] as String)),
      ownerId: jsonSerialization['ownerId'] as String?,
      projectId: jsonSerialization['projectId'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      isPublic: jsonSerialization['isPublic'] as bool,
      maxSubscribers: jsonSerialization['maxSubscribers'] as int?,
      subscriberCount: jsonSerialization['subscriberCount'] as int,
      cacheTtlSeconds: jsonSerialization['cacheTtlSeconds'] as int,
      maxCachedNotifications:
          jsonSerialization['maxCachedNotifications'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  String id;

  String name;

  String? description;

  _i2.ChannelType type;

  String? ownerId;

  String? projectId;

  bool isActive;

  bool isPublic;

  int? maxSubscribers;

  int subscriberCount;

  int cacheTtlSeconds;

  int maxCachedNotifications;

  DateTime createdAt;

  DateTime updatedAt;

  String? metadata;

  /// Returns a shallow copy of this [NotificationChannel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationChannel copyWith({
    String? id,
    String? name,
    String? description,
    _i2.ChannelType? type,
    String? ownerId,
    String? projectId,
    bool? isActive,
    bool? isPublic,
    int? maxSubscribers,
    int? subscriberCount,
    int? cacheTtlSeconds,
    int? maxCachedNotifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationChannel',
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'type': type.toJson(),
      if (ownerId != null) 'ownerId': ownerId,
      if (projectId != null) 'projectId': projectId,
      'isActive': isActive,
      'isPublic': isPublic,
      if (maxSubscribers != null) 'maxSubscribers': maxSubscribers,
      'subscriberCount': subscriberCount,
      'cacheTtlSeconds': cacheTtlSeconds,
      'maxCachedNotifications': maxCachedNotifications,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationChannel',
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'type': type.toJson(),
      if (ownerId != null) 'ownerId': ownerId,
      if (projectId != null) 'projectId': projectId,
      'isActive': isActive,
      'isPublic': isPublic,
      if (maxSubscribers != null) 'maxSubscribers': maxSubscribers,
      'subscriberCount': subscriberCount,
      'cacheTtlSeconds': cacheTtlSeconds,
      'maxCachedNotifications': maxCachedNotifications,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationChannelImpl extends NotificationChannel {
  _NotificationChannelImpl({
    required String id,
    required String name,
    String? description,
    required _i2.ChannelType type,
    String? ownerId,
    String? projectId,
    required bool isActive,
    required bool isPublic,
    int? maxSubscribers,
    required int subscriberCount,
    required int cacheTtlSeconds,
    required int maxCachedNotifications,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? metadata,
  }) : super._(
         id: id,
         name: name,
         description: description,
         type: type,
         ownerId: ownerId,
         projectId: projectId,
         isActive: isActive,
         isPublic: isPublic,
         maxSubscribers: maxSubscribers,
         subscriberCount: subscriberCount,
         cacheTtlSeconds: cacheTtlSeconds,
         maxCachedNotifications: maxCachedNotifications,
         createdAt: createdAt,
         updatedAt: updatedAt,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [NotificationChannel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationChannel copyWith({
    String? id,
    String? name,
    Object? description = _Undefined,
    _i2.ChannelType? type,
    Object? ownerId = _Undefined,
    Object? projectId = _Undefined,
    bool? isActive,
    bool? isPublic,
    Object? maxSubscribers = _Undefined,
    int? subscriberCount,
    int? cacheTtlSeconds,
    int? maxCachedNotifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? metadata = _Undefined,
  }) {
    return NotificationChannel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      type: type ?? this.type,
      ownerId: ownerId is String? ? ownerId : this.ownerId,
      projectId: projectId is String? ? projectId : this.projectId,
      isActive: isActive ?? this.isActive,
      isPublic: isPublic ?? this.isPublic,
      maxSubscribers: maxSubscribers is int?
          ? maxSubscribers
          : this.maxSubscribers,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      cacheTtlSeconds: cacheTtlSeconds ?? this.cacheTtlSeconds,
      maxCachedNotifications:
          maxCachedNotifications ?? this.maxCachedNotifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}
