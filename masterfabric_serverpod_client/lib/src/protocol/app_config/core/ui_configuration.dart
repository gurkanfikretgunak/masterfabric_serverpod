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

/// UI configuration settings
abstract class UiConfiguration implements _i1.SerializableModel {
  UiConfiguration._({
    required this.themeMode,
    required this.fontScale,
    required this.devModeGrid,
    required this.devModeSpacer,
  });

  factory UiConfiguration({
    required String themeMode,
    required double fontScale,
    required bool devModeGrid,
    required bool devModeSpacer,
  }) = _UiConfigurationImpl;

  factory UiConfiguration.fromJson(Map<String, dynamic> jsonSerialization) {
    return UiConfiguration(
      themeMode: jsonSerialization['themeMode'] as String,
      fontScale: (jsonSerialization['fontScale'] as num).toDouble(),
      devModeGrid: jsonSerialization['devModeGrid'] as bool,
      devModeSpacer: jsonSerialization['devModeSpacer'] as bool,
    );
  }

  /// Theme mode (light/dark/auto)
  String themeMode;

  /// Font scale factor
  double fontScale;

  /// Show dev mode grid overlay
  bool devModeGrid;

  /// Show dev mode spacer overlay
  bool devModeSpacer;

  /// Returns a shallow copy of this [UiConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UiConfiguration copyWith({
    String? themeMode,
    double? fontScale,
    bool? devModeGrid,
    bool? devModeSpacer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UiConfiguration',
      'themeMode': themeMode,
      'fontScale': fontScale,
      'devModeGrid': devModeGrid,
      'devModeSpacer': devModeSpacer,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UiConfigurationImpl extends UiConfiguration {
  _UiConfigurationImpl({
    required String themeMode,
    required double fontScale,
    required bool devModeGrid,
    required bool devModeSpacer,
  }) : super._(
         themeMode: themeMode,
         fontScale: fontScale,
         devModeGrid: devModeGrid,
         devModeSpacer: devModeSpacer,
       );

  /// Returns a shallow copy of this [UiConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UiConfiguration copyWith({
    String? themeMode,
    double? fontScale,
    bool? devModeGrid,
    bool? devModeSpacer,
  }) {
    return UiConfiguration(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      devModeGrid: devModeGrid ?? this.devModeGrid,
      devModeSpacer: devModeSpacer ?? this.devModeSpacer,
    );
  }
}
