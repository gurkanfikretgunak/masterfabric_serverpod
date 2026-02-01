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
import '../../../../core/real_time/notifications_center/models/notification_channel.dart'
    as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Channel list response model
/// Response for listing channels
abstract class ChannelListResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChannelListResponse._({
    required this.success,
    required this.channels,
    required this.totalCount,
    required this.timestamp,
  });

  factory ChannelListResponse({
    required bool success,
    required List<_i2.NotificationChannel> channels,
    required int totalCount,
    required DateTime timestamp,
  }) = _ChannelListResponseImpl;

  factory ChannelListResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChannelListResponse(
      success: jsonSerialization['success'] as bool,
      channels: _i3.Protocol().deserialize<List<_i2.NotificationChannel>>(
        jsonSerialization['channels'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  List<_i2.NotificationChannel> channels;

  int totalCount;

  DateTime timestamp;

  /// Returns a shallow copy of this [ChannelListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChannelListResponse copyWith({
    bool? success,
    List<_i2.NotificationChannel>? channels,
    int? totalCount,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChannelListResponse',
      'success': success,
      'channels': channels.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChannelListResponse',
      'success': success,
      'channels': channels.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'totalCount': totalCount,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChannelListResponseImpl extends ChannelListResponse {
  _ChannelListResponseImpl({
    required bool success,
    required List<_i2.NotificationChannel> channels,
    required int totalCount,
    required DateTime timestamp,
  }) : super._(
         success: success,
         channels: channels,
         totalCount: totalCount,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [ChannelListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChannelListResponse copyWith({
    bool? success,
    List<_i2.NotificationChannel>? channels,
    int? totalCount,
    DateTime? timestamp,
  }) {
    return ChannelListResponse(
      success: success ?? this.success,
      channels: channels ?? this.channels.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
