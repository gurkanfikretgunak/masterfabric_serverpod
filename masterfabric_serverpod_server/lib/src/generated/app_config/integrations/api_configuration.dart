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

/// API configuration
abstract class ApiConfiguration
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ApiConfiguration._({
    required this.baseUrl,
    required this.timeout,
    required this.retryCount,
  });

  factory ApiConfiguration({
    required String baseUrl,
    required int timeout,
    required int retryCount,
  }) = _ApiConfigurationImpl;

  factory ApiConfiguration.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiConfiguration(
      baseUrl: jsonSerialization['baseUrl'] as String,
      timeout: jsonSerialization['timeout'] as int,
      retryCount: jsonSerialization['retryCount'] as int,
    );
  }

  /// API base URL
  String baseUrl;

  /// Request timeout in milliseconds
  int timeout;

  /// Retry count for failed requests
  int retryCount;

  /// Returns a shallow copy of this [ApiConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiConfiguration copyWith({
    String? baseUrl,
    int? timeout,
    int? retryCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiConfiguration',
      'baseUrl': baseUrl,
      'timeout': timeout,
      'retryCount': retryCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiConfiguration',
      'baseUrl': baseUrl,
      'timeout': timeout,
      'retryCount': retryCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ApiConfigurationImpl extends ApiConfiguration {
  _ApiConfigurationImpl({
    required String baseUrl,
    required int timeout,
    required int retryCount,
  }) : super._(
         baseUrl: baseUrl,
         timeout: timeout,
         retryCount: retryCount,
       );

  /// Returns a shallow copy of this [ApiConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiConfiguration copyWith({
    String? baseUrl,
    int? timeout,
    int? retryCount,
  }) {
    return ApiConfiguration(
      baseUrl: baseUrl ?? this.baseUrl,
      timeout: timeout ?? this.timeout,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
