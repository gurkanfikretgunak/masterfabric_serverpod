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
import '../../../services/paired_device/models/device_mode.dart' as _i2;

/// Paired device model - stores device pairing information
abstract class PairedDevice implements _i1.SerializableModel {
  PairedDevice._({
    this.id,
    required this.userId,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    this.deviceFingerprint,
    this.ipAddress,
    this.userAgent,
    required this.isActive,
    required this.isTrusted,
    required this.deviceMode,
    required this.lastSeenAt,
    required this.pairedAt,
    this.metadata,
  });

  factory PairedDevice({
    int? id,
    required String userId,
    required String deviceId,
    required String deviceName,
    required String platform,
    String? deviceFingerprint,
    String? ipAddress,
    String? userAgent,
    required bool isActive,
    required bool isTrusted,
    required _i2.DeviceMode deviceMode,
    required DateTime lastSeenAt,
    required DateTime pairedAt,
    String? metadata,
  }) = _PairedDeviceImpl;

  factory PairedDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return PairedDevice(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      deviceId: jsonSerialization['deviceId'] as String,
      deviceName: jsonSerialization['deviceName'] as String,
      platform: jsonSerialization['platform'] as String,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      isTrusted: jsonSerialization['isTrusted'] as bool,
      deviceMode: _i2.DeviceMode.fromJson(
        (jsonSerialization['deviceMode'] as String),
      ),
      lastSeenAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
      pairedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['pairedAt'],
      ),
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String deviceId;

  String deviceName;

  String platform;

  String? deviceFingerprint;

  String? ipAddress;

  String? userAgent;

  bool isActive;

  bool isTrusted;

  _i2.DeviceMode deviceMode;

  DateTime lastSeenAt;

  DateTime pairedAt;

  String? metadata;

  /// Returns a shallow copy of this [PairedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PairedDevice copyWith({
    int? id,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? platform,
    String? deviceFingerprint,
    String? ipAddress,
    String? userAgent,
    bool? isActive,
    bool? isTrusted,
    _i2.DeviceMode? deviceMode,
    DateTime? lastSeenAt,
    DateTime? pairedAt,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PairedDevice',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'isActive': isActive,
      'isTrusted': isTrusted,
      'deviceMode': deviceMode.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
      'pairedAt': pairedAt.toJson(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PairedDeviceImpl extends PairedDevice {
  _PairedDeviceImpl({
    int? id,
    required String userId,
    required String deviceId,
    required String deviceName,
    required String platform,
    String? deviceFingerprint,
    String? ipAddress,
    String? userAgent,
    required bool isActive,
    required bool isTrusted,
    required _i2.DeviceMode deviceMode,
    required DateTime lastSeenAt,
    required DateTime pairedAt,
    String? metadata,
  }) : super._(
         id: id,
         userId: userId,
         deviceId: deviceId,
         deviceName: deviceName,
         platform: platform,
         deviceFingerprint: deviceFingerprint,
         ipAddress: ipAddress,
         userAgent: userAgent,
         isActive: isActive,
         isTrusted: isTrusted,
         deviceMode: deviceMode,
         lastSeenAt: lastSeenAt,
         pairedAt: pairedAt,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [PairedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PairedDevice copyWith({
    Object? id = _Undefined,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? platform,
    Object? deviceFingerprint = _Undefined,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    bool? isActive,
    bool? isTrusted,
    _i2.DeviceMode? deviceMode,
    DateTime? lastSeenAt,
    DateTime? pairedAt,
    Object? metadata = _Undefined,
  }) {
    return PairedDevice(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      isActive: isActive ?? this.isActive,
      isTrusted: isTrusted ?? this.isTrusted,
      deviceMode: deviceMode ?? this.deviceMode,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      pairedAt: pairedAt ?? this.pairedAt,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}
