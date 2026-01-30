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

/// Splash screen configuration
abstract class SplashConfiguration
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SplashConfiguration._({
    required this.style,
    required this.duration,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
    this.logoUrl,
    required this.logoWidth,
    required this.logoHeight,
    required this.showLoadingIndicator,
    required this.loadingIndicatorSize,
    required this.loadingText,
    required this.showAppVersion,
    required this.appVersion,
    required this.showCopyright,
    required this.copyrightText,
  });

  factory SplashConfiguration({
    required String style,
    required int duration,
    required String backgroundColor,
    required String textColor,
    required String primaryColor,
    String? logoUrl,
    required int logoWidth,
    required int logoHeight,
    required bool showLoadingIndicator,
    required int loadingIndicatorSize,
    required String loadingText,
    required bool showAppVersion,
    required String appVersion,
    required bool showCopyright,
    required String copyrightText,
  }) = _SplashConfigurationImpl;

  factory SplashConfiguration.fromJson(Map<String, dynamic> jsonSerialization) {
    return SplashConfiguration(
      style: jsonSerialization['style'] as String,
      duration: jsonSerialization['duration'] as int,
      backgroundColor: jsonSerialization['backgroundColor'] as String,
      textColor: jsonSerialization['textColor'] as String,
      primaryColor: jsonSerialization['primaryColor'] as String,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      logoWidth: jsonSerialization['logoWidth'] as int,
      logoHeight: jsonSerialization['logoHeight'] as int,
      showLoadingIndicator: jsonSerialization['showLoadingIndicator'] as bool,
      loadingIndicatorSize: jsonSerialization['loadingIndicatorSize'] as int,
      loadingText: jsonSerialization['loadingText'] as String,
      showAppVersion: jsonSerialization['showAppVersion'] as bool,
      appVersion: jsonSerialization['appVersion'] as String,
      showCopyright: jsonSerialization['showCopyright'] as bool,
      copyrightText: jsonSerialization['copyrightText'] as String,
    );
  }

  /// Splash style (startup/custom)
  String style;

  /// Splash duration in milliseconds
  int duration;

  /// Background color hex code
  String backgroundColor;

  /// Text color hex code
  String textColor;

  /// Primary color hex code
  String primaryColor;

  /// Logo URL
  String? logoUrl;

  /// Logo width
  int logoWidth;

  /// Logo height
  int logoHeight;

  /// Show loading indicator
  bool showLoadingIndicator;

  /// Loading indicator size
  int loadingIndicatorSize;

  /// Loading text
  String loadingText;

  /// Show app version
  bool showAppVersion;

  /// App version to display
  String appVersion;

  /// Show copyright
  bool showCopyright;

  /// Copyright text
  String copyrightText;

  /// Returns a shallow copy of this [SplashConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SplashConfiguration copyWith({
    String? style,
    int? duration,
    String? backgroundColor,
    String? textColor,
    String? primaryColor,
    String? logoUrl,
    int? logoWidth,
    int? logoHeight,
    bool? showLoadingIndicator,
    int? loadingIndicatorSize,
    String? loadingText,
    bool? showAppVersion,
    String? appVersion,
    bool? showCopyright,
    String? copyrightText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SplashConfiguration',
      'style': style,
      'duration': duration,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'primaryColor': primaryColor,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'logoWidth': logoWidth,
      'logoHeight': logoHeight,
      'showLoadingIndicator': showLoadingIndicator,
      'loadingIndicatorSize': loadingIndicatorSize,
      'loadingText': loadingText,
      'showAppVersion': showAppVersion,
      'appVersion': appVersion,
      'showCopyright': showCopyright,
      'copyrightText': copyrightText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SplashConfiguration',
      'style': style,
      'duration': duration,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'primaryColor': primaryColor,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'logoWidth': logoWidth,
      'logoHeight': logoHeight,
      'showLoadingIndicator': showLoadingIndicator,
      'loadingIndicatorSize': loadingIndicatorSize,
      'loadingText': loadingText,
      'showAppVersion': showAppVersion,
      'appVersion': appVersion,
      'showCopyright': showCopyright,
      'copyrightText': copyrightText,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SplashConfigurationImpl extends SplashConfiguration {
  _SplashConfigurationImpl({
    required String style,
    required int duration,
    required String backgroundColor,
    required String textColor,
    required String primaryColor,
    String? logoUrl,
    required int logoWidth,
    required int logoHeight,
    required bool showLoadingIndicator,
    required int loadingIndicatorSize,
    required String loadingText,
    required bool showAppVersion,
    required String appVersion,
    required bool showCopyright,
    required String copyrightText,
  }) : super._(
         style: style,
         duration: duration,
         backgroundColor: backgroundColor,
         textColor: textColor,
         primaryColor: primaryColor,
         logoUrl: logoUrl,
         logoWidth: logoWidth,
         logoHeight: logoHeight,
         showLoadingIndicator: showLoadingIndicator,
         loadingIndicatorSize: loadingIndicatorSize,
         loadingText: loadingText,
         showAppVersion: showAppVersion,
         appVersion: appVersion,
         showCopyright: showCopyright,
         copyrightText: copyrightText,
       );

  /// Returns a shallow copy of this [SplashConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SplashConfiguration copyWith({
    String? style,
    int? duration,
    String? backgroundColor,
    String? textColor,
    String? primaryColor,
    Object? logoUrl = _Undefined,
    int? logoWidth,
    int? logoHeight,
    bool? showLoadingIndicator,
    int? loadingIndicatorSize,
    String? loadingText,
    bool? showAppVersion,
    String? appVersion,
    bool? showCopyright,
    String? copyrightText,
  }) {
    return SplashConfiguration(
      style: style ?? this.style,
      duration: duration ?? this.duration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      primaryColor: primaryColor ?? this.primaryColor,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      logoWidth: logoWidth ?? this.logoWidth,
      logoHeight: logoHeight ?? this.logoHeight,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      loadingIndicatorSize: loadingIndicatorSize ?? this.loadingIndicatorSize,
      loadingText: loadingText ?? this.loadingText,
      showAppVersion: showAppVersion ?? this.showAppVersion,
      appVersion: appVersion ?? this.appVersion,
      showCopyright: showCopyright ?? this.showCopyright,
      copyrightText: copyrightText ?? this.copyrightText,
    );
  }
}
