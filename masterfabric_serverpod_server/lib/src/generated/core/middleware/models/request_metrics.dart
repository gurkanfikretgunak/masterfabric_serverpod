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
import '../../../core/middleware/models/middleware_execution_info.dart' as _i2;
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i3;

/// Request metrics collected by middleware
abstract class RequestMetrics
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RequestMetrics._({
    required this.requestId,
    required this.endpoint,
    required this.method,
    required this.totalDurationMs,
    required this.middlewareDurationMs,
    required this.handlerDurationMs,
    required this.success,
    required this.statusCode,
    this.clientIp,
    this.userId,
    required this.startTime,
    required this.endTime,
    required this.middlewareExecuted,
    this.errorMessage,
    this.errorType,
  });

  factory RequestMetrics({
    required String requestId,
    required String endpoint,
    required String method,
    required int totalDurationMs,
    required int middlewareDurationMs,
    required int handlerDurationMs,
    required bool success,
    required int statusCode,
    String? clientIp,
    String? userId,
    required DateTime startTime,
    required DateTime endTime,
    required List<_i2.MiddlewareExecutionInfo> middlewareExecuted,
    String? errorMessage,
    String? errorType,
  }) = _RequestMetricsImpl;

  factory RequestMetrics.fromJson(Map<String, dynamic> jsonSerialization) {
    return RequestMetrics(
      requestId: jsonSerialization['requestId'] as String,
      endpoint: jsonSerialization['endpoint'] as String,
      method: jsonSerialization['method'] as String,
      totalDurationMs: jsonSerialization['totalDurationMs'] as int,
      middlewareDurationMs: jsonSerialization['middlewareDurationMs'] as int,
      handlerDurationMs: jsonSerialization['handlerDurationMs'] as int,
      success: jsonSerialization['success'] as bool,
      statusCode: jsonSerialization['statusCode'] as int,
      clientIp: jsonSerialization['clientIp'] as String?,
      userId: jsonSerialization['userId'] as String?,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      middlewareExecuted: _i3.Protocol()
          .deserialize<List<_i2.MiddlewareExecutionInfo>>(
            jsonSerialization['middlewareExecuted'],
          ),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      errorType: jsonSerialization['errorType'] as String?,
    );
  }

  /// Unique request ID
  String requestId;

  /// Endpoint name
  String endpoint;

  /// Method name
  String method;

  /// Total request duration in milliseconds
  int totalDurationMs;

  /// Middleware execution duration in milliseconds
  int middlewareDurationMs;

  /// Handler execution duration in milliseconds
  int handlerDurationMs;

  /// Whether request was successful
  bool success;

  /// HTTP status code equivalent
  int statusCode;

  /// Client IP address
  String? clientIp;

  /// User ID if authenticated
  String? userId;

  /// Timestamp when request started
  DateTime startTime;

  /// Timestamp when request completed
  DateTime endTime;

  /// List of middleware that executed
  List<_i2.MiddlewareExecutionInfo> middlewareExecuted;

  /// Error message if request failed
  String? errorMessage;

  /// Error type if request failed
  String? errorType;

  /// Returns a shallow copy of this [RequestMetrics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RequestMetrics copyWith({
    String? requestId,
    String? endpoint,
    String? method,
    int? totalDurationMs,
    int? middlewareDurationMs,
    int? handlerDurationMs,
    bool? success,
    int? statusCode,
    String? clientIp,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    List<_i2.MiddlewareExecutionInfo>? middlewareExecuted,
    String? errorMessage,
    String? errorType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RequestMetrics',
      'requestId': requestId,
      'endpoint': endpoint,
      'method': method,
      'totalDurationMs': totalDurationMs,
      'middlewareDurationMs': middlewareDurationMs,
      'handlerDurationMs': handlerDurationMs,
      'success': success,
      'statusCode': statusCode,
      if (clientIp != null) 'clientIp': clientIp,
      if (userId != null) 'userId': userId,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'middlewareExecuted': middlewareExecuted.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (errorType != null) 'errorType': errorType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RequestMetrics',
      'requestId': requestId,
      'endpoint': endpoint,
      'method': method,
      'totalDurationMs': totalDurationMs,
      'middlewareDurationMs': middlewareDurationMs,
      'handlerDurationMs': handlerDurationMs,
      'success': success,
      'statusCode': statusCode,
      if (clientIp != null) 'clientIp': clientIp,
      if (userId != null) 'userId': userId,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'middlewareExecuted': middlewareExecuted.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (errorType != null) 'errorType': errorType,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RequestMetricsImpl extends RequestMetrics {
  _RequestMetricsImpl({
    required String requestId,
    required String endpoint,
    required String method,
    required int totalDurationMs,
    required int middlewareDurationMs,
    required int handlerDurationMs,
    required bool success,
    required int statusCode,
    String? clientIp,
    String? userId,
    required DateTime startTime,
    required DateTime endTime,
    required List<_i2.MiddlewareExecutionInfo> middlewareExecuted,
    String? errorMessage,
    String? errorType,
  }) : super._(
         requestId: requestId,
         endpoint: endpoint,
         method: method,
         totalDurationMs: totalDurationMs,
         middlewareDurationMs: middlewareDurationMs,
         handlerDurationMs: handlerDurationMs,
         success: success,
         statusCode: statusCode,
         clientIp: clientIp,
         userId: userId,
         startTime: startTime,
         endTime: endTime,
         middlewareExecuted: middlewareExecuted,
         errorMessage: errorMessage,
         errorType: errorType,
       );

  /// Returns a shallow copy of this [RequestMetrics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RequestMetrics copyWith({
    String? requestId,
    String? endpoint,
    String? method,
    int? totalDurationMs,
    int? middlewareDurationMs,
    int? handlerDurationMs,
    bool? success,
    int? statusCode,
    Object? clientIp = _Undefined,
    Object? userId = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    List<_i2.MiddlewareExecutionInfo>? middlewareExecuted,
    Object? errorMessage = _Undefined,
    Object? errorType = _Undefined,
  }) {
    return RequestMetrics(
      requestId: requestId ?? this.requestId,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
      middlewareDurationMs: middlewareDurationMs ?? this.middlewareDurationMs,
      handlerDurationMs: handlerDurationMs ?? this.handlerDurationMs,
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      clientIp: clientIp is String? ? clientIp : this.clientIp,
      userId: userId is String? ? userId : this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      middlewareExecuted:
          middlewareExecuted ??
          this.middlewareExecuted.map((e0) => e0.copyWith()).toList(),
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      errorType: errorType is String? ? errorType : this.errorType,
    );
  }
}
