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

/// Navigation configuration
abstract class NavigationConfiguration implements _i1.SerializableModel {
  NavigationConfiguration._({
    required this.defaultRoute,
    required this.deepLinkingEnabled,
  });

  factory NavigationConfiguration({
    required String defaultRoute,
    required bool deepLinkingEnabled,
  }) = _NavigationConfigurationImpl;

  factory NavigationConfiguration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NavigationConfiguration(
      defaultRoute: jsonSerialization['defaultRoute'] as String,
      deepLinkingEnabled: jsonSerialization['deepLinkingEnabled'] as bool,
    );
  }

  /// Default route path
  String defaultRoute;

  /// Deep linking enabled
  bool deepLinkingEnabled;

  /// Returns a shallow copy of this [NavigationConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NavigationConfiguration copyWith({
    String? defaultRoute,
    bool? deepLinkingEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NavigationConfiguration',
      'defaultRoute': defaultRoute,
      'deepLinkingEnabled': deepLinkingEnabled,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _NavigationConfigurationImpl extends NavigationConfiguration {
  _NavigationConfigurationImpl({
    required String defaultRoute,
    required bool deepLinkingEnabled,
  }) : super._(
         defaultRoute: defaultRoute,
         deepLinkingEnabled: deepLinkingEnabled,
       );

  /// Returns a shallow copy of this [NavigationConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NavigationConfiguration copyWith({
    String? defaultRoute,
    bool? deepLinkingEnabled,
  }) {
    return NavigationConfiguration(
      defaultRoute: defaultRoute ?? this.defaultRoute,
      deepLinkingEnabled: deepLinkingEnabled ?? this.deepLinkingEnabled,
    );
  }
}
