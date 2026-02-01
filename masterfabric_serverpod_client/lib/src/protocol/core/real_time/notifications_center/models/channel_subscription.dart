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

/// Channel subscription model
/// Represents a user's subscription to a notification channel
abstract class ChannelSubscription implements _i1.SerializableModel {
  ChannelSubscription._({
    required this.id,
    required this.userId,
    required this.channelId,
    required this.isActive,
    required this.isMuted,
    required this.subscribedAt,
    this.lastReadAt,
    required this.unreadCount,
    this.metadata,
  });

  factory ChannelSubscription({
    required String id,
    required String userId,
    required String channelId,
    required bool isActive,
    required bool isMuted,
    required DateTime subscribedAt,
    DateTime? lastReadAt,
    required int unreadCount,
    String? metadata,
  }) = _ChannelSubscriptionImpl;

  factory ChannelSubscription.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChannelSubscription(
      id: jsonSerialization['id'] as String,
      userId: jsonSerialization['userId'] as String,
      channelId: jsonSerialization['channelId'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      isMuted: jsonSerialization['isMuted'] as bool,
      subscribedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['subscribedAt'],
      ),
      lastReadAt: jsonSerialization['lastReadAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastReadAt']),
      unreadCount: jsonSerialization['unreadCount'] as int,
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  String id;

  String userId;

  String channelId;

  bool isActive;

  bool isMuted;

  DateTime subscribedAt;

  DateTime? lastReadAt;

  int unreadCount;

  String? metadata;

  /// Returns a shallow copy of this [ChannelSubscription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChannelSubscription copyWith({
    String? id,
    String? userId,
    String? channelId,
    bool? isActive,
    bool? isMuted,
    DateTime? subscribedAt,
    DateTime? lastReadAt,
    int? unreadCount,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChannelSubscription',
      'id': id,
      'userId': userId,
      'channelId': channelId,
      'isActive': isActive,
      'isMuted': isMuted,
      'subscribedAt': subscribedAt.toJson(),
      if (lastReadAt != null) 'lastReadAt': lastReadAt?.toJson(),
      'unreadCount': unreadCount,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChannelSubscriptionImpl extends ChannelSubscription {
  _ChannelSubscriptionImpl({
    required String id,
    required String userId,
    required String channelId,
    required bool isActive,
    required bool isMuted,
    required DateTime subscribedAt,
    DateTime? lastReadAt,
    required int unreadCount,
    String? metadata,
  }) : super._(
         id: id,
         userId: userId,
         channelId: channelId,
         isActive: isActive,
         isMuted: isMuted,
         subscribedAt: subscribedAt,
         lastReadAt: lastReadAt,
         unreadCount: unreadCount,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [ChannelSubscription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChannelSubscription copyWith({
    String? id,
    String? userId,
    String? channelId,
    bool? isActive,
    bool? isMuted,
    DateTime? subscribedAt,
    Object? lastReadAt = _Undefined,
    int? unreadCount,
    Object? metadata = _Undefined,
  }) {
    return ChannelSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      isActive: isActive ?? this.isActive,
      isMuted: isMuted ?? this.isMuted,
      subscribedAt: subscribedAt ?? this.subscribedAt,
      lastReadAt: lastReadAt is DateTime? ? lastReadAt : this.lastReadAt,
      unreadCount: unreadCount ?? this.unreadCount,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}
