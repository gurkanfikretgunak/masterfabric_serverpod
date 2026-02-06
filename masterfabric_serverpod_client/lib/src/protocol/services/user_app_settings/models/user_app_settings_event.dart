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
import '../../../services/user_app_settings/models/user_app_settings.dart'
    as _i2;
import 'package:masterfabric_serverpod_client/src/protocol/protocol.dart'
    as _i3;

/// User app settings stream event
abstract class UserAppSettingsEvent implements _i1.SerializableModel {
  UserAppSettingsEvent._({
    required this.type,
    this.settings,
    required this.timestamp,
  });

  factory UserAppSettingsEvent({
    required String type,
    _i2.UserAppSettings? settings,
    required DateTime timestamp,
  }) = _UserAppSettingsEventImpl;

  factory UserAppSettingsEvent.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserAppSettingsEvent(
      type: jsonSerialization['type'] as String,
      settings: jsonSerialization['settings'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.UserAppSettings>(
              jsonSerialization['settings'],
            ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  String type;

  _i2.UserAppSettings? settings;

  DateTime timestamp;

  /// Returns a shallow copy of this [UserAppSettingsEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserAppSettingsEvent copyWith({
    String? type,
    _i2.UserAppSettings? settings,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAppSettingsEvent',
      'type': type,
      if (settings != null) 'settings': settings?.toJson(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAppSettingsEventImpl extends UserAppSettingsEvent {
  _UserAppSettingsEventImpl({
    required String type,
    _i2.UserAppSettings? settings,
    required DateTime timestamp,
  }) : super._(
         type: type,
         settings: settings,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [UserAppSettingsEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserAppSettingsEvent copyWith({
    String? type,
    Object? settings = _Undefined,
    DateTime? timestamp,
  }) {
    return UserAppSettingsEvent(
      type: type ?? this.type,
      settings: settings is _i2.UserAppSettings?
          ? settings
          : this.settings?.copyWith(),
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
