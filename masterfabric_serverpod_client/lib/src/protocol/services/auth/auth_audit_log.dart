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

abstract class AuthAuditLog implements _i1.SerializableModel {
  AuthAuditLog._({
    this.id,
    this.userId,
    required this.eventType,
    required this.eventData,
    this.ipAddress,
    this.userAgent,
    required this.timestamp,
  });

  factory AuthAuditLog({
    int? id,
    String? userId,
    required String eventType,
    required String eventData,
    String? ipAddress,
    String? userAgent,
    required DateTime timestamp,
  }) = _AuthAuditLogImpl;

  factory AuthAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthAuditLog(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      eventType: jsonSerialization['eventType'] as String,
      eventData: jsonSerialization['eventData'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? userId;

  String eventType;

  String eventData;

  String? ipAddress;

  String? userAgent;

  DateTime timestamp;

  /// Returns a shallow copy of this [AuthAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthAuditLog copyWith({
    int? id,
    String? userId,
    String? eventType,
    String? eventData,
    String? ipAddress,
    String? userAgent,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthAuditLog',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'eventType': eventType,
      'eventData': eventData,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthAuditLogImpl extends AuthAuditLog {
  _AuthAuditLogImpl({
    int? id,
    String? userId,
    required String eventType,
    required String eventData,
    String? ipAddress,
    String? userAgent,
    required DateTime timestamp,
  }) : super._(
         id: id,
         userId: userId,
         eventType: eventType,
         eventData: eventData,
         ipAddress: ipAddress,
         userAgent: userAgent,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [AuthAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthAuditLog copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    String? eventType,
    String? eventData,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    DateTime? timestamp,
  }) {
    return AuthAuditLog(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      eventType: eventType ?? this.eventType,
      eventData: eventData ?? this.eventData,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
