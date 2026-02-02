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
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i2;

abstract class RoleInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RoleInfo._({
    required this.name,
    this.description,
    required this.permissions,
    required this.isActive,
    this.userCount,
  });

  factory RoleInfo({
    required String name,
    String? description,
    required List<String> permissions,
    required bool isActive,
    int? userCount,
  }) = _RoleInfoImpl;

  factory RoleInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoleInfo(
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      permissions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['permissions'],
      ),
      isActive: jsonSerialization['isActive'] as bool,
      userCount: jsonSerialization['userCount'] as int?,
    );
  }

  String name;

  String? description;

  List<String> permissions;

  bool isActive;

  int? userCount;

  /// Returns a shallow copy of this [RoleInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RoleInfo copyWith({
    String? name,
    String? description,
    List<String>? permissions,
    bool? isActive,
    int? userCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoleInfo',
      'name': name,
      if (description != null) 'description': description,
      'permissions': permissions.toJson(),
      'isActive': isActive,
      if (userCount != null) 'userCount': userCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoleInfo',
      'name': name,
      if (description != null) 'description': description,
      'permissions': permissions.toJson(),
      'isActive': isActive,
      if (userCount != null) 'userCount': userCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoleInfoImpl extends RoleInfo {
  _RoleInfoImpl({
    required String name,
    String? description,
    required List<String> permissions,
    required bool isActive,
    int? userCount,
  }) : super._(
         name: name,
         description: description,
         permissions: permissions,
         isActive: isActive,
         userCount: userCount,
       );

  /// Returns a shallow copy of this [RoleInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RoleInfo copyWith({
    String? name,
    Object? description = _Undefined,
    List<String>? permissions,
    bool? isActive,
    Object? userCount = _Undefined,
  }) {
    return RoleInfo(
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      permissions: permissions ?? this.permissions.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      userCount: userCount is int? ? userCount : this.userCount,
    );
  }
}
