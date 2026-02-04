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

/// Exchange rate cache model for storing fetched rates
abstract class ExchangeRateCache implements _i1.SerializableModel {
  ExchangeRateCache._({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
    required this.source,
  });

  factory ExchangeRateCache({
    required String baseCurrency,
    required Map<String, double> rates,
    required DateTime timestamp,
    required String source,
  }) = _ExchangeRateCacheImpl;

  factory ExchangeRateCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExchangeRateCache(
      baseCurrency: jsonSerialization['baseCurrency'] as String,
      rates: _i2.Protocol().deserialize<Map<String, double>>(
        jsonSerialization['rates'],
      ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      source: jsonSerialization['source'] as String,
    );
  }

  String baseCurrency;

  Map<String, double> rates;

  DateTime timestamp;

  String source;

  /// Returns a shallow copy of this [ExchangeRateCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExchangeRateCache copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    DateTime? timestamp,
    String? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExchangeRateCache',
      'baseCurrency': baseCurrency,
      'rates': rates.toJson(),
      'timestamp': timestamp.toJson(),
      'source': source,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ExchangeRateCacheImpl extends ExchangeRateCache {
  _ExchangeRateCacheImpl({
    required String baseCurrency,
    required Map<String, double> rates,
    required DateTime timestamp,
    required String source,
  }) : super._(
         baseCurrency: baseCurrency,
         rates: rates,
         timestamp: timestamp,
         source: source,
       );

  /// Returns a shallow copy of this [ExchangeRateCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExchangeRateCache copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    DateTime? timestamp,
    String? source,
  }) {
    return ExchangeRateCache(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates:
          rates ??
          this.rates.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
    );
  }
}
