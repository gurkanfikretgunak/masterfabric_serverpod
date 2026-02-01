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

/// Middleware execution information for metrics/logging
abstract class MiddlewareExecutionInfo implements _i1.SerializableModel {
  MiddlewareExecutionInfo._({
    required this.middlewareName,
    required this.phase,
    required this.durationMs,
    required this.success,
    this.message,
    required this.timestamp,
  });

  factory MiddlewareExecutionInfo({
    required String middlewareName,
    required String phase,
    required int durationMs,
    required bool success,
    String? message,
    required DateTime timestamp,
  }) = _MiddlewareExecutionInfoImpl;

  factory MiddlewareExecutionInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MiddlewareExecutionInfo(
      middlewareName: jsonSerialization['middlewareName'] as String,
      phase: jsonSerialization['phase'] as String,
      durationMs: jsonSerialization['durationMs'] as int,
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  /// Name of the middleware that executed
  String middlewareName;

  /// Phase of execution (request, response, error)
  String phase;

  /// Duration in milliseconds
  int durationMs;

  /// Whether execution was successful
  bool success;

  /// Optional message from middleware
  String? message;

  /// Timestamp of execution
  DateTime timestamp;

  /// Returns a shallow copy of this [MiddlewareExecutionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MiddlewareExecutionInfo copyWith({
    String? middlewareName,
    String? phase,
    int? durationMs,
    bool? success,
    String? message,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MiddlewareExecutionInfo',
      'middlewareName': middlewareName,
      'phase': phase,
      'durationMs': durationMs,
      'success': success,
      if (message != null) 'message': message,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MiddlewareExecutionInfoImpl extends MiddlewareExecutionInfo {
  _MiddlewareExecutionInfoImpl({
    required String middlewareName,
    required String phase,
    required int durationMs,
    required bool success,
    String? message,
    required DateTime timestamp,
  }) : super._(
         middlewareName: middlewareName,
         phase: phase,
         durationMs: durationMs,
         success: success,
         message: message,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [MiddlewareExecutionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MiddlewareExecutionInfo copyWith({
    String? middlewareName,
    String? phase,
    int? durationMs,
    bool? success,
    Object? message = _Undefined,
    DateTime? timestamp,
  }) {
    return MiddlewareExecutionInfo(
      middlewareName: middlewareName ?? this.middlewareName,
      phase: phase ?? this.phase,
      durationMs: durationMs ?? this.durationMs,
      success: success ?? this.success,
      message: message is String? ? message : this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
