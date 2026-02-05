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

/// Device pairing request model
abstract class DevicePairingRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DevicePairingRequest._({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    this.deviceFingerprint,
    this.userAgent,
  });

  factory DevicePairingRequest({
    required String deviceId,
    required String deviceName,
    required String platform,
    String? deviceFingerprint,
    String? userAgent,
  }) = _DevicePairingRequestImpl;

  factory DevicePairingRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DevicePairingRequest(
      deviceId: jsonSerialization['deviceId'] as String,
      deviceName: jsonSerialization['deviceName'] as String,
      platform: jsonSerialization['platform'] as String,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
    );
  }

  String deviceId;

  String deviceName;

  String platform;

  String? deviceFingerprint;

  String? userAgent;

  /// Returns a shallow copy of this [DevicePairingRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DevicePairingRequest copyWith({
    String? deviceId,
    String? deviceName,
    String? platform,
    String? deviceFingerprint,
    String? userAgent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DevicePairingRequest',
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (userAgent != null) 'userAgent': userAgent,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DevicePairingRequest',
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (userAgent != null) 'userAgent': userAgent,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DevicePairingRequestImpl extends DevicePairingRequest {
  _DevicePairingRequestImpl({
    required String deviceId,
    required String deviceName,
    required String platform,
    String? deviceFingerprint,
    String? userAgent,
  }) : super._(
         deviceId: deviceId,
         deviceName: deviceName,
         platform: platform,
         deviceFingerprint: deviceFingerprint,
         userAgent: userAgent,
       );

  /// Returns a shallow copy of this [DevicePairingRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DevicePairingRequest copyWith({
    String? deviceId,
    String? deviceName,
    String? platform,
    Object? deviceFingerprint = _Undefined,
    Object? userAgent = _Undefined,
  }) {
    return DevicePairingRequest(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
    );
  }
}
