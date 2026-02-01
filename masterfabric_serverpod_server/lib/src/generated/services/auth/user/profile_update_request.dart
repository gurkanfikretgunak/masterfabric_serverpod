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
import '../../../services/auth/user/gender.dart' as _i2;

/// Request for profile update with verification
abstract class ProfileUpdateRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProfileUpdateRequest._({
    required this.verificationCode,
    this.fullName,
    this.userName,
    this.birthDate,
    this.gender,
  });

  factory ProfileUpdateRequest({
    required String verificationCode,
    String? fullName,
    String? userName,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) = _ProfileUpdateRequestImpl;

  factory ProfileUpdateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProfileUpdateRequest(
      verificationCode: jsonSerialization['verificationCode'] as String,
      fullName: jsonSerialization['fullName'] as String?,
      userName: jsonSerialization['userName'] as String?,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      gender: jsonSerialization['gender'] == null
          ? null
          : _i2.Gender.fromJson((jsonSerialization['gender'] as String)),
    );
  }

  String verificationCode;

  String? fullName;

  String? userName;

  DateTime? birthDate;

  _i2.Gender? gender;

  /// Returns a shallow copy of this [ProfileUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProfileUpdateRequest copyWith({
    String? verificationCode,
    String? fullName,
    String? userName,
    DateTime? birthDate,
    _i2.Gender? gender,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProfileUpdateRequest',
      'verificationCode': verificationCode,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (gender != null) 'gender': gender?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProfileUpdateRequest',
      'verificationCode': verificationCode,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (gender != null) 'gender': gender?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProfileUpdateRequestImpl extends ProfileUpdateRequest {
  _ProfileUpdateRequestImpl({
    required String verificationCode,
    String? fullName,
    String? userName,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) : super._(
         verificationCode: verificationCode,
         fullName: fullName,
         userName: userName,
         birthDate: birthDate,
         gender: gender,
       );

  /// Returns a shallow copy of this [ProfileUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProfileUpdateRequest copyWith({
    String? verificationCode,
    Object? fullName = _Undefined,
    Object? userName = _Undefined,
    Object? birthDate = _Undefined,
    Object? gender = _Undefined,
  }) {
    return ProfileUpdateRequest(
      verificationCode: verificationCode ?? this.verificationCode,
      fullName: fullName is String? ? fullName : this.fullName,
      userName: userName is String? ? userName : this.userName,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      gender: gender is _i2.Gender? ? gender : this.gender,
    );
  }
}
