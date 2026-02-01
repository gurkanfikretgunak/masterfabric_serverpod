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
import '../../../services/health/models/service_health_info.dart' as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Health check response model
abstract class HealthCheckResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  HealthCheckResponse._({
    required this.status,
    required this.timestamp,
    required this.services,
    required this.totalLatencyMs,
  });

  factory HealthCheckResponse({
    required String status,
    required DateTime timestamp,
    required List<_i2.ServiceHealthInfo> services,
    required int totalLatencyMs,
  }) = _HealthCheckResponseImpl;

  factory HealthCheckResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthCheckResponse(
      status: jsonSerialization['status'] as String,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      services: _i3.Protocol().deserialize<List<_i2.ServiceHealthInfo>>(
        jsonSerialization['services'],
      ),
      totalLatencyMs: jsonSerialization['totalLatencyMs'] as int,
    );
  }

  String status;

  DateTime timestamp;

  List<_i2.ServiceHealthInfo> services;

  int totalLatencyMs;

  /// Returns a shallow copy of this [HealthCheckResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HealthCheckResponse copyWith({
    String? status,
    DateTime? timestamp,
    List<_i2.ServiceHealthInfo>? services,
    int? totalLatencyMs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthCheckResponse',
      'status': status,
      'timestamp': timestamp.toJson(),
      'services': services.toJson(valueToJson: (v) => v.toJson()),
      'totalLatencyMs': totalLatencyMs,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthCheckResponse',
      'status': status,
      'timestamp': timestamp.toJson(),
      'services': services.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'totalLatencyMs': totalLatencyMs,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _HealthCheckResponseImpl extends HealthCheckResponse {
  _HealthCheckResponseImpl({
    required String status,
    required DateTime timestamp,
    required List<_i2.ServiceHealthInfo> services,
    required int totalLatencyMs,
  }) : super._(
         status: status,
         timestamp: timestamp,
         services: services,
         totalLatencyMs: totalLatencyMs,
       );

  /// Returns a shallow copy of this [HealthCheckResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HealthCheckResponse copyWith({
    String? status,
    DateTime? timestamp,
    List<_i2.ServiceHealthInfo>? services,
    int? totalLatencyMs,
  }) {
    return HealthCheckResponse(
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      services: services ?? this.services.map((e0) => e0.copyWith()).toList(),
      totalLatencyMs: totalLatencyMs ?? this.totalLatencyMs,
    );
  }
}
