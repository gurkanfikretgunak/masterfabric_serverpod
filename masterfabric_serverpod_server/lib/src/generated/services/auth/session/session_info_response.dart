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

abstract class SessionInfoResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SessionInfoResponse._({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.lastUsedAt,
    this.expiresAt,
    required this.method,
    this.metadataJson,
  });

  factory SessionInfoResponse({
    required String id,
    required String userId,
    required DateTime createdAt,
    required DateTime lastUsedAt,
    DateTime? expiresAt,
    required String method,
    String? metadataJson,
  }) = _SessionInfoResponseImpl;

  factory SessionInfoResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionInfoResponse(
      id: jsonSerialization['id'] as String,
      userId: jsonSerialization['userId'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastUsedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUsedAt'],
      ),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      method: jsonSerialization['method'] as String,
      metadataJson: jsonSerialization['metadataJson'] as String?,
    );
  }

  String id;

  String userId;

  DateTime createdAt;

  DateTime lastUsedAt;

  DateTime? expiresAt;

  String method;

  String? metadataJson;

  /// Returns a shallow copy of this [SessionInfoResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionInfoResponse copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    String? method,
    String? metadataJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionInfoResponse',
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toJson(),
      'lastUsedAt': lastUsedAt.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'method': method,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionInfoResponse',
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toJson(),
      'lastUsedAt': lastUsedAt.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'method': method,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionInfoResponseImpl extends SessionInfoResponse {
  _SessionInfoResponseImpl({
    required String id,
    required String userId,
    required DateTime createdAt,
    required DateTime lastUsedAt,
    DateTime? expiresAt,
    required String method,
    String? metadataJson,
  }) : super._(
         id: id,
         userId: userId,
         createdAt: createdAt,
         lastUsedAt: lastUsedAt,
         expiresAt: expiresAt,
         method: method,
         metadataJson: metadataJson,
       );

  /// Returns a shallow copy of this [SessionInfoResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionInfoResponse copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    Object? expiresAt = _Undefined,
    String? method,
    Object? metadataJson = _Undefined,
  }) {
    return SessionInfoResponse(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      method: method ?? this.method,
      metadataJson: metadataJson is String? ? metadataJson : this.metadataJson,
    );
  }
}
