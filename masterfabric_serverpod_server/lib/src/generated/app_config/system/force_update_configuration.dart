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
import '../../app_config/system/store_url.dart' as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Force update configuration
abstract class ForceUpdateConfiguration
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ForceUpdateConfiguration._({
    required this.latestVersion,
    required this.minimumVersion,
    required this.releaseNotes,
    required this.features,
    this.storeUrl,
    required this.customMessage,
  });

  factory ForceUpdateConfiguration({
    required String latestVersion,
    required String minimumVersion,
    required String releaseNotes,
    required List<String> features,
    _i2.StoreUrl? storeUrl,
    required String customMessage,
  }) = _ForceUpdateConfigurationImpl;

  factory ForceUpdateConfiguration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ForceUpdateConfiguration(
      latestVersion: jsonSerialization['latestVersion'] as String,
      minimumVersion: jsonSerialization['minimumVersion'] as String,
      releaseNotes: jsonSerialization['releaseNotes'] as String,
      features: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['features'],
      ),
      storeUrl: jsonSerialization['storeUrl'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.StoreUrl>(
              jsonSerialization['storeUrl'],
            ),
      customMessage: jsonSerialization['customMessage'] as String,
    );
  }

  /// Latest app version
  String latestVersion;

  /// Minimum required version
  String minimumVersion;

  /// Release notes
  String releaseNotes;

  /// New features list
  List<String> features;

  /// Store URLs
  _i2.StoreUrl? storeUrl;

  /// Custom update message
  String customMessage;

  /// Returns a shallow copy of this [ForceUpdateConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ForceUpdateConfiguration copyWith({
    String? latestVersion,
    String? minimumVersion,
    String? releaseNotes,
    List<String>? features,
    _i2.StoreUrl? storeUrl,
    String? customMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ForceUpdateConfiguration',
      'latestVersion': latestVersion,
      'minimumVersion': minimumVersion,
      'releaseNotes': releaseNotes,
      'features': features.toJson(),
      if (storeUrl != null) 'storeUrl': storeUrl?.toJson(),
      'customMessage': customMessage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ForceUpdateConfiguration',
      'latestVersion': latestVersion,
      'minimumVersion': minimumVersion,
      'releaseNotes': releaseNotes,
      'features': features.toJson(),
      if (storeUrl != null) 'storeUrl': storeUrl?.toJsonForProtocol(),
      'customMessage': customMessage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ForceUpdateConfigurationImpl extends ForceUpdateConfiguration {
  _ForceUpdateConfigurationImpl({
    required String latestVersion,
    required String minimumVersion,
    required String releaseNotes,
    required List<String> features,
    _i2.StoreUrl? storeUrl,
    required String customMessage,
  }) : super._(
         latestVersion: latestVersion,
         minimumVersion: minimumVersion,
         releaseNotes: releaseNotes,
         features: features,
         storeUrl: storeUrl,
         customMessage: customMessage,
       );

  /// Returns a shallow copy of this [ForceUpdateConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ForceUpdateConfiguration copyWith({
    String? latestVersion,
    String? minimumVersion,
    String? releaseNotes,
    List<String>? features,
    Object? storeUrl = _Undefined,
    String? customMessage,
  }) {
    return ForceUpdateConfiguration(
      latestVersion: latestVersion ?? this.latestVersion,
      minimumVersion: minimumVersion ?? this.minimumVersion,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      features: features ?? this.features.map((e0) => e0).toList(),
      storeUrl: storeUrl is _i2.StoreUrl?
          ? storeUrl
          : this.storeUrl?.copyWith(),
      customMessage: customMessage ?? this.customMessage,
    );
  }
}
