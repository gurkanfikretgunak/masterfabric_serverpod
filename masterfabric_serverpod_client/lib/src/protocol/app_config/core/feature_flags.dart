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

/// Feature flags configuration
abstract class FeatureFlags implements _i1.SerializableModel {
  FeatureFlags._({
    required this.onboardingEnabled,
    required this.analyticsEnabled,
  });

  factory FeatureFlags({
    required bool onboardingEnabled,
    required bool analyticsEnabled,
  }) = _FeatureFlagsImpl;

  factory FeatureFlags.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeatureFlags(
      onboardingEnabled: jsonSerialization['onboardingEnabled'] as bool,
      analyticsEnabled: jsonSerialization['analyticsEnabled'] as bool,
    );
  }

  /// Onboarding feature enabled
  bool onboardingEnabled;

  /// Analytics feature enabled
  bool analyticsEnabled;

  /// Returns a shallow copy of this [FeatureFlags]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FeatureFlags copyWith({
    bool? onboardingEnabled,
    bool? analyticsEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeatureFlags',
      'onboardingEnabled': onboardingEnabled,
      'analyticsEnabled': analyticsEnabled,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FeatureFlagsImpl extends FeatureFlags {
  _FeatureFlagsImpl({
    required bool onboardingEnabled,
    required bool analyticsEnabled,
  }) : super._(
         onboardingEnabled: onboardingEnabled,
         analyticsEnabled: analyticsEnabled,
       );

  /// Returns a shallow copy of this [FeatureFlags]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FeatureFlags copyWith({
    bool? onboardingEnabled,
    bool? analyticsEnabled,
  }) {
    return FeatureFlags(
      onboardingEnabled: onboardingEnabled ?? this.onboardingEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }
}
