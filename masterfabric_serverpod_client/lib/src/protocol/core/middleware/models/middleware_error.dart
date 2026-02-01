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

/// Middleware error exception that can be serialized to client
abstract class MiddlewareError
    implements _i1.SerializableException, _i1.SerializableModel {
  MiddlewareError._({
    required this.message,
    required this.code,
    required this.statusCode,
    this.middleware,
    this.details,
    required this.timestamp,
  });

  factory MiddlewareError({
    required String message,
    required String code,
    required int statusCode,
    String? middleware,
    Map<String, String>? details,
    required DateTime timestamp,
  }) = _MiddlewareErrorImpl;

  factory MiddlewareError.fromJson(Map<String, dynamic> jsonSerialization) {
    return MiddlewareError(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String,
      statusCode: jsonSerialization['statusCode'] as int,
      middleware: jsonSerialization['middleware'] as String?,
      details: jsonSerialization['details'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['details'],
            ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  /// Error message
  String message;

  /// Error code for client handling
  String code;

  /// HTTP status code equivalent
  int statusCode;

  /// Middleware that caused the error
  String? middleware;

  /// Additional error details
  Map<String, String>? details;

  /// Timestamp when error occurred
  DateTime timestamp;

  /// Returns a shallow copy of this [MiddlewareError]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MiddlewareError copyWith({
    String? message,
    String? code,
    int? statusCode,
    String? middleware,
    Map<String, String>? details,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MiddlewareError',
      'message': message,
      'code': code,
      'statusCode': statusCode,
      if (middleware != null) 'middleware': middleware,
      if (details != null) 'details': details?.toJson(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return 'MiddlewareError(message: $message, code: $code, statusCode: $statusCode, middleware: $middleware, details: $details, timestamp: $timestamp)';
  }
}

class _Undefined {}

class _MiddlewareErrorImpl extends MiddlewareError {
  _MiddlewareErrorImpl({
    required String message,
    required String code,
    required int statusCode,
    String? middleware,
    Map<String, String>? details,
    required DateTime timestamp,
  }) : super._(
         message: message,
         code: code,
         statusCode: statusCode,
         middleware: middleware,
         details: details,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [MiddlewareError]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MiddlewareError copyWith({
    String? message,
    String? code,
    int? statusCode,
    Object? middleware = _Undefined,
    Object? details = _Undefined,
    DateTime? timestamp,
  }) {
    return MiddlewareError(
      message: message ?? this.message,
      code: code ?? this.code,
      statusCode: statusCode ?? this.statusCode,
      middleware: middleware is String? ? middleware : this.middleware,
      details: details is Map<String, String>?
          ? details
          : this.details?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
