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

/// App settings configuration
abstract class AppSettings
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AppSettings._({
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.debugMode,
    required this.maintenanceMode,
  });

  factory AppSettings({
    required String appName,
    required String appVersion,
    required String environment,
    required bool debugMode,
    required bool maintenanceMode,
  }) = _AppSettingsImpl;

  factory AppSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppSettings(
      appName: jsonSerialization['appName'] as String,
      appVersion: jsonSerialization['appVersion'] as String,
      environment: jsonSerialization['environment'] as String,
      debugMode: jsonSerialization['debugMode'] as bool,
      maintenanceMode: jsonSerialization['maintenanceMode'] as bool,
    );
  }

  /// Application name
  String appName;

  /// Application version
  String appVersion;

  /// Environment (development/staging/production)
  String environment;

  /// Debug mode enabled
  bool debugMode;

  /// Maintenance mode enabled
  bool maintenanceMode;

  /// Returns a shallow copy of this [AppSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppSettings copyWith({
    String? appName,
    String? appVersion,
    String? environment,
    bool? debugMode,
    bool? maintenanceMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppSettings',
      'appName': appName,
      'appVersion': appVersion,
      'environment': environment,
      'debugMode': debugMode,
      'maintenanceMode': maintenanceMode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppSettings',
      'appName': appName,
      'appVersion': appVersion,
      'environment': environment,
      'debugMode': debugMode,
      'maintenanceMode': maintenanceMode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AppSettingsImpl extends AppSettings {
  _AppSettingsImpl({
    required String appName,
    required String appVersion,
    required String environment,
    required bool debugMode,
    required bool maintenanceMode,
  }) : super._(
         appName: appName,
         appVersion: appVersion,
         environment: environment,
         debugMode: debugMode,
         maintenanceMode: maintenanceMode,
       );

  /// Returns a shallow copy of this [AppSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppSettings copyWith({
    String? appName,
    String? appVersion,
    String? environment,
    bool? debugMode,
    bool? maintenanceMode,
  }) {
    return AppSettings(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      environment: environment ?? this.environment,
      debugMode: debugMode ?? this.debugMode,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
    );
  }
}
