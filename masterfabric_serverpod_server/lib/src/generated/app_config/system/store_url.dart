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

/// Store URLs for app store links
abstract class StoreUrl
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  StoreUrl._({
    this.ios,
    this.android,
  });

  factory StoreUrl({
    String? ios,
    String? android,
  }) = _StoreUrlImpl;

  factory StoreUrl.fromJson(Map<String, dynamic> jsonSerialization) {
    return StoreUrl(
      ios: jsonSerialization['ios'] as String?,
      android: jsonSerialization['android'] as String?,
    );
  }

  /// iOS App Store URL
  String? ios;

  /// Android Play Store URL
  String? android;

  /// Returns a shallow copy of this [StoreUrl]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StoreUrl copyWith({
    String? ios,
    String? android,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StoreUrl',
      if (ios != null) 'ios': ios,
      if (android != null) 'android': android,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StoreUrl',
      if (ios != null) 'ios': ios,
      if (android != null) 'android': android,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StoreUrlImpl extends StoreUrl {
  _StoreUrlImpl({
    String? ios,
    String? android,
  }) : super._(
         ios: ios,
         android: android,
       );

  /// Returns a shallow copy of this [StoreUrl]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StoreUrl copyWith({
    Object? ios = _Undefined,
    Object? android = _Undefined,
  }) {
    return StoreUrl(
      ios: ios is String? ? ios : this.ios,
      android: android is String? ? android : this.android,
    );
  }
}
