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

abstract class ServerStatus implements _i1.SerializableModel {
  ServerStatus._({
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.serverTime,
    required this.serverStartTime,
    required this.uptime,
    this.clientIp,
    this.locale,
    required this.debugMode,
    required this.maintenanceMode,
  });

  factory ServerStatus({
    required String appName,
    required String appVersion,
    required String environment,
    required DateTime serverTime,
    required DateTime serverStartTime,
    required String uptime,
    String? clientIp,
    String? locale,
    required bool debugMode,
    required bool maintenanceMode,
  }) = _ServerStatusImpl;

  factory ServerStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerStatus(
      appName: jsonSerialization['appName'] as String,
      appVersion: jsonSerialization['appVersion'] as String,
      environment: jsonSerialization['environment'] as String,
      serverTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      serverStartTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverStartTime'],
      ),
      uptime: jsonSerialization['uptime'] as String,
      clientIp: jsonSerialization['clientIp'] as String?,
      locale: jsonSerialization['locale'] as String?,
      debugMode: jsonSerialization['debugMode'] as bool,
      maintenanceMode: jsonSerialization['maintenanceMode'] as bool,
    );
  }

  String appName;

  String appVersion;

  String environment;

  DateTime serverTime;

  DateTime serverStartTime;

  String uptime;

  String? clientIp;

  String? locale;

  bool debugMode;

  bool maintenanceMode;

  /// Returns a shallow copy of this [ServerStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerStatus copyWith({
    String? appName,
    String? appVersion,
    String? environment,
    DateTime? serverTime,
    DateTime? serverStartTime,
    String? uptime,
    String? clientIp,
    String? locale,
    bool? debugMode,
    bool? maintenanceMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServerStatus',
      'appName': appName,
      'appVersion': appVersion,
      'environment': environment,
      'serverTime': serverTime.toJson(),
      'serverStartTime': serverStartTime.toJson(),
      'uptime': uptime,
      if (clientIp != null) 'clientIp': clientIp,
      if (locale != null) 'locale': locale,
      'debugMode': debugMode,
      'maintenanceMode': maintenanceMode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerStatusImpl extends ServerStatus {
  _ServerStatusImpl({
    required String appName,
    required String appVersion,
    required String environment,
    required DateTime serverTime,
    required DateTime serverStartTime,
    required String uptime,
    String? clientIp,
    String? locale,
    required bool debugMode,
    required bool maintenanceMode,
  }) : super._(
         appName: appName,
         appVersion: appVersion,
         environment: environment,
         serverTime: serverTime,
         serverStartTime: serverStartTime,
         uptime: uptime,
         clientIp: clientIp,
         locale: locale,
         debugMode: debugMode,
         maintenanceMode: maintenanceMode,
       );

  /// Returns a shallow copy of this [ServerStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerStatus copyWith({
    String? appName,
    String? appVersion,
    String? environment,
    DateTime? serverTime,
    DateTime? serverStartTime,
    String? uptime,
    Object? clientIp = _Undefined,
    Object? locale = _Undefined,
    bool? debugMode,
    bool? maintenanceMode,
  }) {
    return ServerStatus(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      environment: environment ?? this.environment,
      serverTime: serverTime ?? this.serverTime,
      serverStartTime: serverStartTime ?? this.serverStartTime,
      uptime: uptime ?? this.uptime,
      clientIp: clientIp is String? ? clientIp : this.clientIp,
      locale: locale is String? ? locale : this.locale,
      debugMode: debugMode ?? this.debugMode,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
    );
  }
}
