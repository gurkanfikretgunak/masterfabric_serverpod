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

/// Supported currencies response
abstract class SupportedCurrenciesResponse implements _i1.SerializableModel {
  SupportedCurrenciesResponse._({
    required this.success,
    required this.currencies,
    required this.count,
    required this.timestamp,
  });

  factory SupportedCurrenciesResponse({
    required bool success,
    required List<String> currencies,
    required int count,
    required DateTime timestamp,
  }) = _SupportedCurrenciesResponseImpl;

  factory SupportedCurrenciesResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SupportedCurrenciesResponse(
      success: jsonSerialization['success'] as bool,
      currencies: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['currencies'],
      ),
      count: jsonSerialization['count'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  List<String> currencies;

  int count;

  DateTime timestamp;

  /// Returns a shallow copy of this [SupportedCurrenciesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SupportedCurrenciesResponse copyWith({
    bool? success,
    List<String>? currencies,
    int? count,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportedCurrenciesResponse',
      'success': success,
      'currencies': currencies.toJson(),
      'count': count,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SupportedCurrenciesResponseImpl extends SupportedCurrenciesResponse {
  _SupportedCurrenciesResponseImpl({
    required bool success,
    required List<String> currencies,
    required int count,
    required DateTime timestamp,
  }) : super._(
         success: success,
         currencies: currencies,
         count: count,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [SupportedCurrenciesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SupportedCurrenciesResponse copyWith({
    bool? success,
    List<String>? currencies,
    int? count,
    DateTime? timestamp,
  }) {
    return SupportedCurrenciesResponse(
      success: success ?? this.success,
      currencies: currencies ?? this.currencies.map((e0) => e0).toList(),
      count: count ?? this.count,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
