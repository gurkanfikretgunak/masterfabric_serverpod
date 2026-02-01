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
import '../../../core/middleware/models/validation_error_detail.dart' as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Validation exception thrown when request validation fails
abstract class ValidationException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  ValidationException._({
    required this.message,
    required this.errors,
    this.endpoint,
    this.method,
  });

  factory ValidationException({
    required String message,
    required List<_i2.ValidationErrorDetail> errors,
    String? endpoint,
    String? method,
  }) = _ValidationExceptionImpl;

  factory ValidationException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ValidationException(
      message: jsonSerialization['message'] as String,
      errors: _i3.Protocol().deserialize<List<_i2.ValidationErrorDetail>>(
        jsonSerialization['errors'],
      ),
      endpoint: jsonSerialization['endpoint'] as String?,
      method: jsonSerialization['method'] as String?,
    );
  }

  /// Overall validation error message
  String message;

  /// List of validation errors
  List<_i2.ValidationErrorDetail> errors;

  /// Endpoint where validation failed
  String? endpoint;

  /// Method where validation failed
  String? method;

  /// Returns a shallow copy of this [ValidationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ValidationException copyWith({
    String? message,
    List<_i2.ValidationErrorDetail>? errors,
    String? endpoint,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ValidationException',
      'message': message,
      'errors': errors.toJson(valueToJson: (v) => v.toJson()),
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ValidationException',
      'message': message,
      'errors': errors.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
    };
  }

  @override
  String toString() {
    return 'ValidationException(message: $message, errors: $errors, endpoint: $endpoint, method: $method)';
  }
}

class _Undefined {}

class _ValidationExceptionImpl extends ValidationException {
  _ValidationExceptionImpl({
    required String message,
    required List<_i2.ValidationErrorDetail> errors,
    String? endpoint,
    String? method,
  }) : super._(
         message: message,
         errors: errors,
         endpoint: endpoint,
         method: method,
       );

  /// Returns a shallow copy of this [ValidationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ValidationException copyWith({
    String? message,
    List<_i2.ValidationErrorDetail>? errors,
    Object? endpoint = _Undefined,
    Object? method = _Undefined,
  }) {
    return ValidationException(
      message: message ?? this.message,
      errors: errors ?? this.errors.map((e0) => e0.copyWith()).toList(),
      endpoint: endpoint is String? ? endpoint : this.endpoint,
      method: method is String? ? method : this.method,
    );
  }
}
