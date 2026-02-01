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

/// Response for verification code request
abstract class VerificationResponse implements _i1.SerializableModel {
  VerificationResponse._({
    required this.success,
    required this.message,
    this.expiresInSeconds,
    this.resendCooldownSeconds,
  });

  factory VerificationResponse({
    required bool success,
    required String message,
    int? expiresInSeconds,
    int? resendCooldownSeconds,
  }) = _VerificationResponseImpl;

  factory VerificationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VerificationResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String,
      expiresInSeconds: jsonSerialization['expiresInSeconds'] as int?,
      resendCooldownSeconds: jsonSerialization['resendCooldownSeconds'] as int?,
    );
  }

  bool success;

  String message;

  int? expiresInSeconds;

  int? resendCooldownSeconds;

  /// Returns a shallow copy of this [VerificationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationResponse copyWith({
    bool? success,
    String? message,
    int? expiresInSeconds,
    int? resendCooldownSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationResponse',
      'success': success,
      'message': message,
      if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
      if (resendCooldownSeconds != null)
        'resendCooldownSeconds': resendCooldownSeconds,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationResponseImpl extends VerificationResponse {
  _VerificationResponseImpl({
    required bool success,
    required String message,
    int? expiresInSeconds,
    int? resendCooldownSeconds,
  }) : super._(
         success: success,
         message: message,
         expiresInSeconds: expiresInSeconds,
         resendCooldownSeconds: resendCooldownSeconds,
       );

  /// Returns a shallow copy of this [VerificationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationResponse copyWith({
    bool? success,
    String? message,
    Object? expiresInSeconds = _Undefined,
    Object? resendCooldownSeconds = _Undefined,
  }) {
    return VerificationResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      expiresInSeconds: expiresInSeconds is int?
          ? expiresInSeconds
          : this.expiresInSeconds,
      resendCooldownSeconds: resendCooldownSeconds is int?
          ? resendCooldownSeconds
          : this.resendCooldownSeconds,
    );
  }
}
