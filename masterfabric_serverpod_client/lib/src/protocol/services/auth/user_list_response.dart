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
import '../../services/auth/user_info_response.dart' as _i2;
import 'package:masterfabric_serverpod_client/src/protocol/protocol.dart'
    as _i3;

abstract class UserListResponse implements _i1.SerializableModel {
  UserListResponse._({
    required this.users,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory UserListResponse({
    required List<_i2.UserInfoResponse> users,
    required int total,
    required int page,
    required int pageSize,
  }) = _UserListResponseImpl;

  factory UserListResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserListResponse(
      users: _i3.Protocol().deserialize<List<_i2.UserInfoResponse>>(
        jsonSerialization['users'],
      ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
    );
  }

  List<_i2.UserInfoResponse> users;

  int total;

  int page;

  int pageSize;

  /// Returns a shallow copy of this [UserListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserListResponse copyWith({
    List<_i2.UserInfoResponse>? users,
    int? total,
    int? page,
    int? pageSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserListResponse',
      'users': users.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserListResponseImpl extends UserListResponse {
  _UserListResponseImpl({
    required List<_i2.UserInfoResponse> users,
    required int total,
    required int page,
    required int pageSize,
  }) : super._(
         users: users,
         total: total,
         page: page,
         pageSize: pageSize,
       );

  /// Returns a shallow copy of this [UserListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserListResponse copyWith({
    List<_i2.UserInfoResponse>? users,
    int? total,
    int? page,
    int? pageSize,
  }) {
    return UserListResponse(
      users: users ?? this.users.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
