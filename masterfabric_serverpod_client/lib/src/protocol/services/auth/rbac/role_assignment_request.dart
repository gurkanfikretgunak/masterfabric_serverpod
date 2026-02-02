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
import '../../../services/auth/rbac/role_assignment_action.dart' as _i2;

abstract class RoleAssignmentRequest implements _i1.SerializableModel {
  RoleAssignmentRequest._({
    required this.userId,
    required this.roleName,
    required this.action,
  });

  factory RoleAssignmentRequest({
    required String userId,
    required String roleName,
    required _i2.RoleAssignmentAction action,
  }) = _RoleAssignmentRequestImpl;

  factory RoleAssignmentRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RoleAssignmentRequest(
      userId: jsonSerialization['userId'] as String,
      roleName: jsonSerialization['roleName'] as String,
      action: _i2.RoleAssignmentAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
    );
  }

  String userId;

  String roleName;

  _i2.RoleAssignmentAction action;

  /// Returns a shallow copy of this [RoleAssignmentRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RoleAssignmentRequest copyWith({
    String? userId,
    String? roleName,
    _i2.RoleAssignmentAction? action,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoleAssignmentRequest',
      'userId': userId,
      'roleName': roleName,
      'action': action.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RoleAssignmentRequestImpl extends RoleAssignmentRequest {
  _RoleAssignmentRequestImpl({
    required String userId,
    required String roleName,
    required _i2.RoleAssignmentAction action,
  }) : super._(
         userId: userId,
         roleName: roleName,
         action: action,
       );

  /// Returns a shallow copy of this [RoleAssignmentRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RoleAssignmentRequest copyWith({
    String? userId,
    String? roleName,
    _i2.RoleAssignmentAction? action,
  }) {
    return RoleAssignmentRequest(
      userId: userId ?? this.userId,
      roleName: roleName ?? this.roleName,
      action: action ?? this.action,
    );
  }
}
