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
import '../../../services/auth/user/gender.dart' as _i2;

/// Extended user profile data (stored in database)
abstract class UserProfileExtended implements _i1.SerializableModel {
  UserProfileExtended._({
    this.id,
    required this.userId,
    this.birthDate,
    this.gender,
  });

  factory UserProfileExtended({
    int? id,
    required String userId,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) = _UserProfileExtendedImpl;

  factory UserProfileExtended.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileExtended(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      gender: jsonSerialization['gender'] == null
          ? null
          : _i2.Gender.fromJson((jsonSerialization['gender'] as String)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  DateTime? birthDate;

  _i2.Gender? gender;

  /// Returns a shallow copy of this [UserProfileExtended]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileExtended copyWith({
    int? id,
    String? userId,
    DateTime? birthDate,
    _i2.Gender? gender,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfileExtended',
      if (id != null) 'id': id,
      'userId': userId,
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

class _UserProfileExtendedImpl extends UserProfileExtended {
  _UserProfileExtendedImpl({
    int? id,
    required String userId,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) : super._(
         id: id,
         userId: userId,
         birthDate: birthDate,
         gender: gender,
       );

  /// Returns a shallow copy of this [UserProfileExtended]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileExtended copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? birthDate = _Undefined,
    Object? gender = _Undefined,
  }) {
    return UserProfileExtended(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      gender: gender is _i2.Gender? ? gender : this.gender,
    );
  }
}
