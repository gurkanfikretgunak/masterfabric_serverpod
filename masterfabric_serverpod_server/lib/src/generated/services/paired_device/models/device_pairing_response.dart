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

/// Device pairing response model
abstract class DevicePairingResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DevicePairingResponse._({
    required this.success,
    required this.message,
    this.device,
    required this.requiresVerification,
    this.verificationCode,
  });

  factory DevicePairingResponse({
    required bool success,
    required String message,
    _i2.PairedDevice? device,
    required bool requiresVerification,
    String? verificationCode,
  }) = _DevicePairingResponseImpl;

  factory DevicePairingResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DevicePairingResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String,
      device: jsonSerialization['device'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.PairedDevice>(
              jsonSerialization['device'],
            ),
      requiresVerification: jsonSerialization['requiresVerification'] as bool,
      verificationCode: jsonSerialization['verificationCode'] as String?,
    );
  }

  bool success;

  String message;

  _i2.PairedDevice? device;

  bool requiresVerification;

  String? verificationCode;

  /// Returns a shallow copy of this [DevicePairingResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DevicePairingResponse copyWith({
    bool? success,
    String? message,
    _i2.PairedDevice? device,
    bool? requiresVerification,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DevicePairingResponse',
      'success': success,
      'message': message,
      if (device != null) 'device': device?.toJson(),
      'requiresVerification': requiresVerification,
      if (verificationCode != null) 'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DevicePairingResponse',
      'success': success,
      'message': message,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'requiresVerification': requiresVerification,
      if (verificationCode != null) 'verificationCode': verificationCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DevicePairingResponseImpl extends DevicePairingResponse {
  _DevicePairingResponseImpl({
    required bool success,
    required String message,
    _i2.PairedDevice? device,
    required bool requiresVerification,
    String? verificationCode,
  }) : super._(
         success: success,
         message: message,
         device: device,
         requiresVerification: requiresVerification,
         verificationCode: verificationCode,
       );

  /// Returns a shallow copy of this [DevicePairingResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DevicePairingResponse copyWith({
    bool? success,
    String? message,
    Object? device = _Undefined,
    bool? requiresVerification,
    Object? verificationCode = _Undefined,
  }) {
    return DevicePairingResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      device: device is _i2.PairedDevice? ? device : this.device?.copyWith(),
      requiresVerification: requiresVerification ?? this.requiresVerification,
      verificationCode: verificationCode is String?
          ? verificationCode
          : this.verificationCode,
    );
  }
}
