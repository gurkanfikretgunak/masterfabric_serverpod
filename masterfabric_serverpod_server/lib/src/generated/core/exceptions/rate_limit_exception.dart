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

/// Rate limit exception for API responses
/// This is a SerializableException that Serverpod can properly return to clients
abstract class RateLimitException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  RateLimitException._({
    required this.message,
    required this.limit,
    required this.remaining,
    required this.current,
    required this.windowSeconds,
    required this.retryAfterSeconds,
    required this.resetAt,
  });

  factory RateLimitException({
    required String message,
    required int limit,
    required int remaining,
    required int current,
    required int windowSeconds,
    required int retryAfterSeconds,
    required String resetAt,
  }) = _RateLimitExceptionImpl;

  factory RateLimitException.fromJson(Map<String, dynamic> jsonSerialization) {
    return RateLimitException(
      message: jsonSerialization['message'] as String,
      limit: jsonSerialization['limit'] as int,
      remaining: jsonSerialization['remaining'] as int,
      current: jsonSerialization['current'] as int,
      windowSeconds: jsonSerialization['windowSeconds'] as int,
      retryAfterSeconds: jsonSerialization['retryAfterSeconds'] as int,
      resetAt: jsonSerialization['resetAt'] as String,
    );
  }

  /// Error message
  String message;

  /// Maximum requests allowed in window
  int limit;

  /// Remaining requests (always 0 when this exception is thrown)
  int remaining;

  /// Current request count (exceeded limit)
  int current;

  /// Time window in seconds
  int windowSeconds;

  /// Seconds until rate limit resets
  int retryAfterSeconds;

  /// ISO8601 timestamp when rate limit resets
  String resetAt;

  /// Returns a shallow copy of this [RateLimitException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RateLimitException copyWith({
    String? message,
    int? limit,
    int? remaining,
    int? current,
    int? windowSeconds,
    int? retryAfterSeconds,
    String? resetAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RateLimitException',
      'message': message,
      'limit': limit,
      'remaining': remaining,
      'current': current,
      'windowSeconds': windowSeconds,
      'retryAfterSeconds': retryAfterSeconds,
      'resetAt': resetAt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RateLimitException',
      'message': message,
      'limit': limit,
      'remaining': remaining,
      'current': current,
      'windowSeconds': windowSeconds,
      'retryAfterSeconds': retryAfterSeconds,
      'resetAt': resetAt,
    };
  }

  @override
  String toString() {
    return 'RateLimitException(message: $message, limit: $limit, remaining: $remaining, current: $current, windowSeconds: $windowSeconds, retryAfterSeconds: $retryAfterSeconds, resetAt: $resetAt)';
  }
}

class _RateLimitExceptionImpl extends RateLimitException {
  _RateLimitExceptionImpl({
    required String message,
    required int limit,
    required int remaining,
    required int current,
    required int windowSeconds,
    required int retryAfterSeconds,
    required String resetAt,
  }) : super._(
         message: message,
         limit: limit,
         remaining: remaining,
         current: current,
         windowSeconds: windowSeconds,
         retryAfterSeconds: retryAfterSeconds,
         resetAt: resetAt,
       );

  /// Returns a shallow copy of this [RateLimitException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RateLimitException copyWith({
    String? message,
    int? limit,
    int? remaining,
    int? current,
    int? windowSeconds,
    int? retryAfterSeconds,
    String? resetAt,
  }) {
    return RateLimitException(
      message: message ?? this.message,
      limit: limit ?? this.limit,
      remaining: remaining ?? this.remaining,
      current: current ?? this.current,
      windowSeconds: windowSeconds ?? this.windowSeconds,
      retryAfterSeconds: retryAfterSeconds ?? this.retryAfterSeconds,
      resetAt: resetAt ?? this.resetAt,
    );
  }
}
