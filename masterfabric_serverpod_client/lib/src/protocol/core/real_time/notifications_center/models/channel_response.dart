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
import '../../../../core/real_time/notifications_center/models/notification_channel.dart'
    as _i2;
import '../../../../core/real_time/notifications_center/models/channel_subscription.dart'
    as _i3;
import 'package:masterfabric_serverpod_client/src/protocol/protocol.dart'
    as _i4;

/// Channel API response model
/// Standard response for channel operations
abstract class ChannelResponse implements _i1.SerializableModel {
  ChannelResponse._({
    required this.success,
    required this.message,
    this.channel,
    this.subscription,
    required this.timestamp,
  });

  factory ChannelResponse({
    required bool success,
    required String message,
    _i2.NotificationChannel? channel,
    _i3.ChannelSubscription? subscription,
    required DateTime timestamp,
  }) = _ChannelResponseImpl;

  factory ChannelResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChannelResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String,
      channel: jsonSerialization['channel'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.NotificationChannel>(
              jsonSerialization['channel'],
            ),
      subscription: jsonSerialization['subscription'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.ChannelSubscription>(
              jsonSerialization['subscription'],
            ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  String message;

  _i2.NotificationChannel? channel;

  _i3.ChannelSubscription? subscription;

  DateTime timestamp;

  /// Returns a shallow copy of this [ChannelResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChannelResponse copyWith({
    bool? success,
    String? message,
    _i2.NotificationChannel? channel,
    _i3.ChannelSubscription? subscription,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChannelResponse',
      'success': success,
      'message': message,
      if (channel != null) 'channel': channel?.toJson(),
      if (subscription != null) 'subscription': subscription?.toJson(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChannelResponseImpl extends ChannelResponse {
  _ChannelResponseImpl({
    required bool success,
    required String message,
    _i2.NotificationChannel? channel,
    _i3.ChannelSubscription? subscription,
    required DateTime timestamp,
  }) : super._(
         success: success,
         message: message,
         channel: channel,
         subscription: subscription,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [ChannelResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChannelResponse copyWith({
    bool? success,
    String? message,
    Object? channel = _Undefined,
    Object? subscription = _Undefined,
    DateTime? timestamp,
  }) {
    return ChannelResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      channel: channel is _i2.NotificationChannel?
          ? channel
          : this.channel?.copyWith(),
      subscription: subscription is _i3.ChannelSubscription?
          ? subscription
          : this.subscription?.copyWith(),
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
