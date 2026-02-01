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

/// Verification code for profile updates
abstract class VerificationCode implements _i1.SerializableModel {
  VerificationCode._({
    this.id,
    required this.userId,
    required this.code,
    required this.purpose,
    required this.expiresAt,
    required this.used,
    required this.createdAt,
  });

  factory VerificationCode({
    int? id,
    required String userId,
    required String code,
    required String purpose,
    required DateTime expiresAt,
    required bool used,
    required DateTime createdAt,
  }) = _VerificationCodeImpl;

  factory VerificationCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationCode(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      code: jsonSerialization['code'] as String,
      purpose: jsonSerialization['purpose'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      used: jsonSerialization['used'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String code;

  String purpose;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  /// Returns a shallow copy of this [VerificationCode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationCode copyWith({
    int? id,
    String? userId,
    String? code,
    String? purpose,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationCode',
      if (id != null) 'id': id,
      'userId': userId,
      'code': code,
      'purpose': purpose,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationCodeImpl extends VerificationCode {
  _VerificationCodeImpl({
    int? id,
    required String userId,
    required String code,
    required String purpose,
    required DateTime expiresAt,
    required bool used,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         code: code,
         purpose: purpose,
         expiresAt: expiresAt,
         used: used,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VerificationCode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationCode copyWith({
    Object? id = _Undefined,
    String? userId,
    String? code,
    String? purpose,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  }) {
    return VerificationCode(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      purpose: purpose ?? this.purpose,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
