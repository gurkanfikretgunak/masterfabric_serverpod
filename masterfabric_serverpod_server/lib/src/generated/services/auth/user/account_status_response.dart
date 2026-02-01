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

abstract class AccountStatusResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AccountStatusResponse._({
    required this.isActive,
    required this.isBlocked,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
  });

  factory AccountStatusResponse({
    required bool isActive,
    required bool isBlocked,
    required bool isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
  }) = _AccountStatusResponseImpl;

  factory AccountStatusResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountStatusResponse(
      isActive: jsonSerialization['isActive'] as bool,
      isBlocked: jsonSerialization['isBlocked'] as bool,
      isDeleted: jsonSerialization['isDeleted'] as bool,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  bool isActive;

  bool isBlocked;

  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AccountStatusResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountStatusResponse copyWith({
    bool? isActive,
    bool? isBlocked,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountStatusResponse',
      'isActive': isActive,
      'isBlocked': isBlocked,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountStatusResponse',
      'isActive': isActive,
      'isBlocked': isBlocked,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountStatusResponseImpl extends AccountStatusResponse {
  _AccountStatusResponseImpl({
    required bool isActive,
    required bool isBlocked,
    required bool isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
  }) : super._(
         isActive: isActive,
         isBlocked: isBlocked,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountStatusResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountStatusResponse copyWith({
    bool? isActive,
    bool? isBlocked,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return AccountStatusResponse(
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
