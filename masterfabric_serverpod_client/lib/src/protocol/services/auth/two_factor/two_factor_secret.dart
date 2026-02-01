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

abstract class TwoFactorSecret implements _i1.SerializableModel {
  TwoFactorSecret._({
    this.id,
    required this.userId,
    required this.secret,
    required this.backupCodes,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TwoFactorSecret({
    int? id,
    required String userId,
    required String secret,
    required List<String> backupCodes,
    required bool enabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TwoFactorSecretImpl;

  factory TwoFactorSecret.fromJson(Map<String, dynamic> jsonSerialization) {
    return TwoFactorSecret(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      secret: jsonSerialization['secret'] as String,
      backupCodes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['backupCodes'],
      ),
      enabled: jsonSerialization['enabled'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String secret;

  List<String> backupCodes;

  bool enabled;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [TwoFactorSecret]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TwoFactorSecret copyWith({
    int? id,
    String? userId,
    String? secret,
    List<String>? backupCodes,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TwoFactorSecret',
      if (id != null) 'id': id,
      'userId': userId,
      'secret': secret,
      'backupCodes': backupCodes.toJson(),
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TwoFactorSecretImpl extends TwoFactorSecret {
  _TwoFactorSecretImpl({
    int? id,
    required String userId,
    required String secret,
    required List<String> backupCodes,
    required bool enabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         secret: secret,
         backupCodes: backupCodes,
         enabled: enabled,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [TwoFactorSecret]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TwoFactorSecret copyWith({
    Object? id = _Undefined,
    String? userId,
    String? secret,
    List<String>? backupCodes,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TwoFactorSecret(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      secret: secret ?? this.secret,
      backupCodes: backupCodes ?? this.backupCodes.map((e0) => e0).toList(),
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
