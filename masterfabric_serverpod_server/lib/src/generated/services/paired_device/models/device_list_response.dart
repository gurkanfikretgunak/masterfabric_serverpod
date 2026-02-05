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
import '../../../services/paired_device/models/paired_device.dart' as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Device list response model
abstract class DeviceListResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeviceListResponse._({
    required this.success,
    required this.devices,
    required this.totalCount,
    required this.activeCount,
  });

  factory DeviceListResponse({
    required bool success,
    required List<_i2.PairedDevice> devices,
    required int totalCount,
    required int activeCount,
  }) = _DeviceListResponseImpl;

  factory DeviceListResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceListResponse(
      success: jsonSerialization['success'] as bool,
      devices: _i3.Protocol().deserialize<List<_i2.PairedDevice>>(
        jsonSerialization['devices'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
      activeCount: jsonSerialization['activeCount'] as int,
    );
  }

  bool success;

  List<_i2.PairedDevice> devices;

  int totalCount;

  int activeCount;

  /// Returns a shallow copy of this [DeviceListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeviceListResponse copyWith({
    bool? success,
    List<_i2.PairedDevice>? devices,
    int? totalCount,
    int? activeCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceListResponse',
      'success': success,
      'devices': devices.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      'activeCount': activeCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceListResponse',
      'success': success,
      'devices': devices.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'totalCount': totalCount,
      'activeCount': activeCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DeviceListResponseImpl extends DeviceListResponse {
  _DeviceListResponseImpl({
    required bool success,
    required List<_i2.PairedDevice> devices,
    required int totalCount,
    required int activeCount,
  }) : super._(
         success: success,
         devices: devices,
         totalCount: totalCount,
         activeCount: activeCount,
       );

  /// Returns a shallow copy of this [DeviceListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeviceListResponse copyWith({
    bool? success,
    List<_i2.PairedDevice>? devices,
    int? totalCount,
    int? activeCount,
  }) {
    return DeviceListResponse(
      success: success ?? this.success,
      devices: devices ?? this.devices.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      activeCount: activeCount ?? this.activeCount,
    );
  }
}
