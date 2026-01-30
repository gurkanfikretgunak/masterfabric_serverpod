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

/// Storage configuration
abstract class StorageConfiguration
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  StorageConfiguration._({
    required this.localStorageType,
    required this.encryptionEnabled,
    required this.cacheEnabled,
  });

  factory StorageConfiguration({
    required String localStorageType,
    required bool encryptionEnabled,
    required bool cacheEnabled,
  }) = _StorageConfigurationImpl;

  factory StorageConfiguration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StorageConfiguration(
      localStorageType: jsonSerialization['localStorageType'] as String,
      encryptionEnabled: jsonSerialization['encryptionEnabled'] as bool,
      cacheEnabled: jsonSerialization['cacheEnabled'] as bool,
    );
  }

  /// Local storage type (hiveCe/sharedPreferences/etc)
  String localStorageType;

  /// Encryption enabled
  bool encryptionEnabled;

  /// Cache enabled
  bool cacheEnabled;

  /// Returns a shallow copy of this [StorageConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StorageConfiguration copyWith({
    String? localStorageType,
    bool? encryptionEnabled,
    bool? cacheEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StorageConfiguration',
      'localStorageType': localStorageType,
      'encryptionEnabled': encryptionEnabled,
      'cacheEnabled': cacheEnabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StorageConfiguration',
      'localStorageType': localStorageType,
      'encryptionEnabled': encryptionEnabled,
      'cacheEnabled': cacheEnabled,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _StorageConfigurationImpl extends StorageConfiguration {
  _StorageConfigurationImpl({
    required String localStorageType,
    required bool encryptionEnabled,
    required bool cacheEnabled,
  }) : super._(
         localStorageType: localStorageType,
         encryptionEnabled: encryptionEnabled,
         cacheEnabled: cacheEnabled,
       );

  /// Returns a shallow copy of this [StorageConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StorageConfiguration copyWith({
    String? localStorageType,
    bool? encryptionEnabled,
    bool? cacheEnabled,
  }) {
    return StorageConfiguration(
      localStorageType: localStorageType ?? this.localStorageType,
      encryptionEnabled: encryptionEnabled ?? this.encryptionEnabled,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
    );
  }
}
