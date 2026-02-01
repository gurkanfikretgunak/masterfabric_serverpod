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

abstract class Permission implements _i1.SerializableModel {
  Permission._({
    this.id,
    required this.name,
    this.description,
    required this.resource,
    required this.action,
    required this.createdAt,
  });

  factory Permission({
    int? id,
    required String name,
    String? description,
    required String resource,
    required String action,
    required DateTime createdAt,
  }) = _PermissionImpl;

  factory Permission.fromJson(Map<String, dynamic> jsonSerialization) {
    return Permission(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      resource: jsonSerialization['resource'] as String,
      action: jsonSerialization['action'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  String resource;

  String action;

  DateTime createdAt;

  /// Returns a shallow copy of this [Permission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Permission copyWith({
    int? id,
    String? name,
    String? description,
    String? resource,
    String? action,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Permission',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'resource': resource,
      'action': action,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PermissionImpl extends Permission {
  _PermissionImpl({
    int? id,
    required String name,
    String? description,
    required String resource,
    required String action,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         resource: resource,
         action: action,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Permission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Permission copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? resource,
    String? action,
    DateTime? createdAt,
  }) {
    return Permission(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      resource: resource ?? this.resource,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
