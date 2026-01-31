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

/// Individual service health info
abstract class ServiceHealthInfo implements _i1.SerializableModel {
  ServiceHealthInfo._({
    required this.name,
    required this.status,
    this.latencyMs,
    this.message,
  });

  factory ServiceHealthInfo({
    required String name,
    required String status,
    int? latencyMs,
    String? message,
  }) = _ServiceHealthInfoImpl;

  factory ServiceHealthInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceHealthInfo(
      name: jsonSerialization['name'] as String,
      status: jsonSerialization['status'] as String,
      latencyMs: jsonSerialization['latencyMs'] as int?,
      message: jsonSerialization['message'] as String?,
    );
  }

  String name;

  String status;

  int? latencyMs;

  String? message;

  /// Returns a shallow copy of this [ServiceHealthInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServiceHealthInfo copyWith({
    String? name,
    String? status,
    int? latencyMs,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceHealthInfo',
      'name': name,
      'status': status,
      if (latencyMs != null) 'latencyMs': latencyMs,
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceHealthInfoImpl extends ServiceHealthInfo {
  _ServiceHealthInfoImpl({
    required String name,
    required String status,
    int? latencyMs,
    String? message,
  }) : super._(
         name: name,
         status: status,
         latencyMs: latencyMs,
         message: message,
       );

  /// Returns a shallow copy of this [ServiceHealthInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServiceHealthInfo copyWith({
    String? name,
    String? status,
    Object? latencyMs = _Undefined,
    Object? message = _Undefined,
  }) {
    return ServiceHealthInfo(
      name: name ?? this.name,
      status: status ?? this.status,
      latencyMs: latencyMs is int? ? latencyMs : this.latencyMs,
      message: message is String? ? message : this.message,
    );
  }
}
