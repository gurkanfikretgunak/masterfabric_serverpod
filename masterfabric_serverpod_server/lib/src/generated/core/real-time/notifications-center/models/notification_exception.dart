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

/// Notification exception model
/// Serializable exception for notification errors
abstract class NotificationException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  NotificationException._({
    required this.code,
    required this.message,
    this.details,
  });

  factory NotificationException({
    required String code,
    required String message,
    String? details,
  }) = _NotificationExceptionImpl;

  factory NotificationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationException(
      code: jsonSerialization['code'] as String,
      message: jsonSerialization['message'] as String,
      details: jsonSerialization['details'] as String?,
    );
  }

  String code;

  String message;

  String? details;

  /// Returns a shallow copy of this [NotificationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationException copyWith({
    String? code,
    String? message,
    String? details,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationException',
      'code': code,
      'message': message,
      if (details != null) 'details': details,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationException',
      'code': code,
      'message': message,
      if (details != null) 'details': details,
    };
  }

  @override
  String toString() {
    return 'NotificationException(code: $code, message: $message, details: $details)';
  }
}

class _Undefined {}

class _NotificationExceptionImpl extends NotificationException {
  _NotificationExceptionImpl({
    required String code,
    required String message,
    String? details,
  }) : super._(
         code: code,
         message: message,
         details: details,
       );

  /// Returns a shallow copy of this [NotificationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationException copyWith({
    String? code,
    String? message,
    Object? details = _Undefined,
  }) {
    return NotificationException(
      code: code ?? this.code,
      message: message ?? this.message,
      details: details is String? ? details : this.details,
    );
  }
}
