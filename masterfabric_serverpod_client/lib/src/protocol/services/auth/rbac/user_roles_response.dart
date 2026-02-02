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

abstract class UserRolesResponse implements _i1.SerializableModel {
  UserRolesResponse._({
    required this.userId,
    required this.roles,
    required this.permissions,
    this.primaryRole,
    this.assignedAt,
  });

  factory UserRolesResponse({
    required String userId,
    required List<String> roles,
    required List<String> permissions,
    String? primaryRole,
    DateTime? assignedAt,
  }) = _UserRolesResponseImpl;

  factory UserRolesResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRolesResponse(
      userId: jsonSerialization['userId'] as String,
      roles: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['roles'],
      ),
      permissions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['permissions'],
      ),
      primaryRole: jsonSerialization['primaryRole'] as String?,
      assignedAt: jsonSerialization['assignedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['assignedAt']),
    );
  }

  String userId;

  List<String> roles;

  List<String> permissions;

  String? primaryRole;

  DateTime? assignedAt;

  /// Returns a shallow copy of this [UserRolesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRolesResponse copyWith({
    String? userId,
    List<String>? roles,
    List<String>? permissions,
    String? primaryRole,
    DateTime? assignedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserRolesResponse',
      'userId': userId,
      'roles': roles.toJson(),
      'permissions': permissions.toJson(),
      if (primaryRole != null) 'primaryRole': primaryRole,
      if (assignedAt != null) 'assignedAt': assignedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRolesResponseImpl extends UserRolesResponse {
  _UserRolesResponseImpl({
    required String userId,
    required List<String> roles,
    required List<String> permissions,
    String? primaryRole,
    DateTime? assignedAt,
  }) : super._(
         userId: userId,
         roles: roles,
         permissions: permissions,
         primaryRole: primaryRole,
         assignedAt: assignedAt,
       );

  /// Returns a shallow copy of this [UserRolesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRolesResponse copyWith({
    String? userId,
    List<String>? roles,
    List<String>? permissions,
    Object? primaryRole = _Undefined,
    Object? assignedAt = _Undefined,
  }) {
    return UserRolesResponse(
      userId: userId ?? this.userId,
      roles: roles ?? this.roles.map((e0) => e0).toList(),
      permissions: permissions ?? this.permissions.map((e0) => e0).toList(),
      primaryRole: primaryRole is String? ? primaryRole : this.primaryRole,
      assignedAt: assignedAt is DateTime? ? assignedAt : this.assignedAt,
    );
  }
}
