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

/// Greeting response with rate limit information
abstract class GreetingResponse implements _i1.SerializableModel {
  GreetingResponse._({
    required this.message,
    required this.author,
    required this.timestamp,
    required this.rateLimitMax,
    required this.rateLimitRemaining,
    required this.rateLimitCurrent,
    required this.rateLimitWindowSeconds,
    this.rateLimitResetInSeconds,
  });

  factory GreetingResponse({
    required String message,
    required String author,
    required DateTime timestamp,
    required int rateLimitMax,
    required int rateLimitRemaining,
    required int rateLimitCurrent,
    required int rateLimitWindowSeconds,
    int? rateLimitResetInSeconds,
  }) = _GreetingResponseImpl;

  factory GreetingResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return GreetingResponse(
      message: jsonSerialization['message'] as String,
      author: jsonSerialization['author'] as String,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      rateLimitMax: jsonSerialization['rateLimitMax'] as int,
      rateLimitRemaining: jsonSerialization['rateLimitRemaining'] as int,
      rateLimitCurrent: jsonSerialization['rateLimitCurrent'] as int,
      rateLimitWindowSeconds:
          jsonSerialization['rateLimitWindowSeconds'] as int,
      rateLimitResetInSeconds:
          jsonSerialization['rateLimitResetInSeconds'] as int?,
    );
  }

  /// The greeting message.
  String message;

  /// The author of the greeting message.
  String author;

  /// The time when the message was created.
  DateTime timestamp;

  /// Rate limit - maximum requests allowed in window
  int rateLimitMax;

  /// Rate limit - remaining requests in current window
  int rateLimitRemaining;

  /// Rate limit - current request count
  int rateLimitCurrent;

  /// Rate limit - time window in seconds
  int rateLimitWindowSeconds;

  /// Rate limit - seconds until reset (null if no active window)
  int? rateLimitResetInSeconds;

  /// Returns a shallow copy of this [GreetingResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GreetingResponse copyWith({
    String? message,
    String? author,
    DateTime? timestamp,
    int? rateLimitMax,
    int? rateLimitRemaining,
    int? rateLimitCurrent,
    int? rateLimitWindowSeconds,
    int? rateLimitResetInSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GreetingResponse',
      'message': message,
      'author': author,
      'timestamp': timestamp.toJson(),
      'rateLimitMax': rateLimitMax,
      'rateLimitRemaining': rateLimitRemaining,
      'rateLimitCurrent': rateLimitCurrent,
      'rateLimitWindowSeconds': rateLimitWindowSeconds,
      if (rateLimitResetInSeconds != null)
        'rateLimitResetInSeconds': rateLimitResetInSeconds,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GreetingResponseImpl extends GreetingResponse {
  _GreetingResponseImpl({
    required String message,
    required String author,
    required DateTime timestamp,
    required int rateLimitMax,
    required int rateLimitRemaining,
    required int rateLimitCurrent,
    required int rateLimitWindowSeconds,
    int? rateLimitResetInSeconds,
  }) : super._(
         message: message,
         author: author,
         timestamp: timestamp,
         rateLimitMax: rateLimitMax,
         rateLimitRemaining: rateLimitRemaining,
         rateLimitCurrent: rateLimitCurrent,
         rateLimitWindowSeconds: rateLimitWindowSeconds,
         rateLimitResetInSeconds: rateLimitResetInSeconds,
       );

  /// Returns a shallow copy of this [GreetingResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GreetingResponse copyWith({
    String? message,
    String? author,
    DateTime? timestamp,
    int? rateLimitMax,
    int? rateLimitRemaining,
    int? rateLimitCurrent,
    int? rateLimitWindowSeconds,
    Object? rateLimitResetInSeconds = _Undefined,
  }) {
    return GreetingResponse(
      message: message ?? this.message,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      rateLimitMax: rateLimitMax ?? this.rateLimitMax,
      rateLimitRemaining: rateLimitRemaining ?? this.rateLimitRemaining,
      rateLimitCurrent: rateLimitCurrent ?? this.rateLimitCurrent,
      rateLimitWindowSeconds:
          rateLimitWindowSeconds ?? this.rateLimitWindowSeconds,
      rateLimitResetInSeconds: rateLimitResetInSeconds is int?
          ? rateLimitResetInSeconds
          : this.rateLimitResetInSeconds,
    );
  }
}
