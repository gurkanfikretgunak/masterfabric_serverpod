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

/// Current user information response
abstract class CurrentUserResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CurrentUserResponse._({
    required this.id,
    this.email,
    this.fullName,
    this.userName,
    this.imageUrl,
    required this.createdAt,
    required this.blocked,
    required this.emailVerified,
    this.birthDate,
    this.gender,
  });

  factory CurrentUserResponse({
    required String id,
    String? email,
    String? fullName,
    String? userName,
    String? imageUrl,
    required DateTime createdAt,
    required bool blocked,
    required bool emailVerified,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) = _CurrentUserResponseImpl;

  factory CurrentUserResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return CurrentUserResponse(
      id: jsonSerialization['id'] as String,
      email: jsonSerialization['email'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      userName: jsonSerialization['userName'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      blocked: jsonSerialization['blocked'] as bool,
      emailVerified: jsonSerialization['emailVerified'] as bool,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      gender: jsonSerialization['gender'] == null
          ? null
          : _i2.Gender.fromJson((jsonSerialization['gender'] as String)),
    );
  }

  String id;

  String? email;

  String? fullName;

  String? userName;

  String? imageUrl;

  DateTime createdAt;

  bool blocked;

  bool emailVerified;

  DateTime? birthDate;

  _i2.Gender? gender;

  /// Returns a shallow copy of this [CurrentUserResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CurrentUserResponse copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userName,
    String? imageUrl,
    DateTime? createdAt,
    bool? blocked,
    bool? emailVerified,
    DateTime? birthDate,
    _i2.Gender? gender,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CurrentUserResponse',
      'id': id,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt.toJson(),
      'blocked': blocked,
      'emailVerified': emailVerified,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (gender != null) 'gender': gender?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CurrentUserResponse',
      'id': id,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt.toJson(),
      'blocked': blocked,
      'emailVerified': emailVerified,
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

class _CurrentUserResponseImpl extends CurrentUserResponse {
  _CurrentUserResponseImpl({
    required String id,
    String? email,
    String? fullName,
    String? userName,
    String? imageUrl,
    required DateTime createdAt,
    required bool blocked,
    required bool emailVerified,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) : super._(
         id: id,
         email: email,
         fullName: fullName,
         userName: userName,
         imageUrl: imageUrl,
         createdAt: createdAt,
         blocked: blocked,
         emailVerified: emailVerified,
         birthDate: birthDate,
         gender: gender,
       );

  /// Returns a shallow copy of this [CurrentUserResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CurrentUserResponse copyWith({
    String? id,
    Object? email = _Undefined,
    Object? fullName = _Undefined,
    Object? userName = _Undefined,
    Object? imageUrl = _Undefined,
    DateTime? createdAt,
    bool? blocked,
    bool? emailVerified,
    Object? birthDate = _Undefined,
    Object? gender = _Undefined,
  }) {
    return CurrentUserResponse(
      id: id ?? this.id,
      email: email is String? ? email : this.email,
      fullName: fullName is String? ? fullName : this.fullName,
      userName: userName is String? ? userName : this.userName,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      blocked: blocked ?? this.blocked,
      emailVerified: emailVerified ?? this.emailVerified,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      gender: gender is _i2.Gender? ? gender : this.gender,
    );
  }
}
