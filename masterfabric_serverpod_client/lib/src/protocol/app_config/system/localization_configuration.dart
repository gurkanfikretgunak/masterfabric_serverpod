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
import 'package:masterfabric_serverpod_client/src/protocol/protocol.dart'
    as _i2;

/// Localization configuration
abstract class LocalizationConfiguration implements _i1.SerializableModel {
  LocalizationConfiguration._({
    required this.defaultLocale,
    required this.supportedLocales,
  });

  factory LocalizationConfiguration({
    required String defaultLocale,
    required List<String> supportedLocales,
  }) = _LocalizationConfigurationImpl;

  factory LocalizationConfiguration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LocalizationConfiguration(
      defaultLocale: jsonSerialization['defaultLocale'] as String,
      supportedLocales: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['supportedLocales'],
      ),
    );
  }

  /// Default locale code
  String defaultLocale;

  /// Supported locales list
  List<String> supportedLocales;

  /// Returns a shallow copy of this [LocalizationConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LocalizationConfiguration copyWith({
    String? defaultLocale,
    List<String>? supportedLocales,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocalizationConfiguration',
      'defaultLocale': defaultLocale,
      'supportedLocales': supportedLocales.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _LocalizationConfigurationImpl extends LocalizationConfiguration {
  _LocalizationConfigurationImpl({
    required String defaultLocale,
    required List<String> supportedLocales,
  }) : super._(
         defaultLocale: defaultLocale,
         supportedLocales: supportedLocales,
       );

  /// Returns a shallow copy of this [LocalizationConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LocalizationConfiguration copyWith({
    String? defaultLocale,
    List<String>? supportedLocales,
  }) {
    return LocalizationConfiguration(
      defaultLocale: defaultLocale ?? this.defaultLocale,
      supportedLocales:
          supportedLocales ?? this.supportedLocales.map((e0) => e0).toList(),
    );
  }
}
