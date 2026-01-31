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

/// Rate limit entry for tracking requests in cache
/// Used for distributed rate limiting across server cluster via Redis
abstract class RateLimitEntry
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RateLimitEntry._({
    required this.count,
    required this.windowStart,
  });

  factory RateLimitEntry({
    required int count,
    required int windowStart,
  }) = _RateLimitEntryImpl;

  factory RateLimitEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return RateLimitEntry(
      count: jsonSerialization['count'] as int,
      windowStart: jsonSerialization['windowStart'] as int,
    );
  }

  /// Number of requests in current window
  int count;

  /// Window start timestamp (milliseconds since epoch)
  int windowStart;

  /// Returns a shallow copy of this [RateLimitEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RateLimitEntry copyWith({
    int? count,
    int? windowStart,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RateLimitEntry',
      'count': count,
      'windowStart': windowStart,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RateLimitEntry',
      'count': count,
      'windowStart': windowStart,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RateLimitEntryImpl extends RateLimitEntry {
  _RateLimitEntryImpl({
    required int count,
    required int windowStart,
  }) : super._(
         count: count,
         windowStart: windowStart,
       );

  /// Returns a shallow copy of this [RateLimitEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RateLimitEntry copyWith({
    int? count,
    int? windowStart,
  }) {
    return RateLimitEntry(
      count: count ?? this.count,
      windowStart: windowStart ?? this.windowStart,
    );
  }
}
