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

abstract class UserInfoResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserInfoResponse._({
    required this.id,
    required this.createdAt,
    required this.blocked,
    this.email,
    this.fullName,
    this.userName,
  });

  factory UserInfoResponse({
    required String id,
    required DateTime createdAt,
    required bool blocked,
    String? email,
    String? fullName,
    String? userName,
  }) = _UserInfoResponseImpl;

  factory UserInfoResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserInfoResponse(
      id: jsonSerialization['id'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      blocked: jsonSerialization['blocked'] as bool,
      email: jsonSerialization['email'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      userName: jsonSerialization['userName'] as String?,
    );
  }

  String id;

  DateTime createdAt;

  bool blocked;

  String? email;

  String? fullName;

  String? userName;

  /// Returns a shallow copy of this [UserInfoResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserInfoResponse copyWith({
    String? id,
    DateTime? createdAt,
    bool? blocked,
    String? email,
    String? fullName,
    String? userName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserInfoResponse',
      'id': id,
      'createdAt': createdAt.toJson(),
      'blocked': blocked,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserInfoResponse',
      'id': id,
      'createdAt': createdAt.toJson(),
      'blocked': blocked,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserInfoResponseImpl extends UserInfoResponse {
  _UserInfoResponseImpl({
    required String id,
    required DateTime createdAt,
    required bool blocked,
    String? email,
    String? fullName,
    String? userName,
  }) : super._(
         id: id,
         createdAt: createdAt,
         blocked: blocked,
         email: email,
         fullName: fullName,
         userName: userName,
       );

  /// Returns a shallow copy of this [UserInfoResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserInfoResponse copyWith({
    String? id,
    DateTime? createdAt,
    bool? blocked,
    Object? email = _Undefined,
    Object? fullName = _Undefined,
    Object? userName = _Undefined,
  }) {
    return UserInfoResponse(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      blocked: blocked ?? this.blocked,
      email: email is String? ? email : this.email,
      fullName: fullName is String? ? fullName : this.fullName,
      userName: userName is String? ? userName : this.userName,
    );
  }
}
