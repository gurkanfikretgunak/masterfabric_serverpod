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

/// App configuration database table
/// Stores app configuration per environment and platform
abstract class AppConfigEntry implements _i1.SerializableModel {
  AppConfigEntry._({
    this.id,
    required this.environment,
    this.platform,
    required this.configJson,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory AppConfigEntry({
    int? id,
    required String environment,
    String? platform,
    required String configJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) = _AppConfigEntryImpl;

  factory AppConfigEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppConfigEntry(
      id: jsonSerialization['id'] as int?,
      environment: jsonSerialization['environment'] as String,
      platform: jsonSerialization['platform'] as String?,
      configJson: jsonSerialization['configJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// Unique identifier
  int? id;

  /// Environment name (development/staging/production)
  String environment;

  /// Platform identifier (ios/android/web/null for all platforms)
  String? platform;

  /// Configuration data as JSON string
  String configJson;

  /// When this configuration was created
  DateTime createdAt;

  /// When this configuration was last updated
  DateTime updatedAt;

  /// Whether this configuration is active
  bool isActive;

  /// Returns a shallow copy of this [AppConfigEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppConfigEntry copyWith({
    int? id,
    String? environment,
    String? platform,
    String? configJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppConfigEntry',
      if (id != null) 'id': id,
      'environment': environment,
      if (platform != null) 'platform': platform,
      'configJson': configJson,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppConfigEntryImpl extends AppConfigEntry {
  _AppConfigEntryImpl({
    int? id,
    required String environment,
    String? platform,
    required String configJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) : super._(
         id: id,
         environment: environment,
         platform: platform,
         configJson: configJson,
         createdAt: createdAt,
         updatedAt: updatedAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [AppConfigEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppConfigEntry copyWith({
    Object? id = _Undefined,
    String? environment,
    Object? platform = _Undefined,
    String? configJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return AppConfigEntry(
      id: id is int? ? id : this.id,
      environment: environment ?? this.environment,
      platform: platform is String? ? platform : this.platform,
      configJson: configJson ?? this.configJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
