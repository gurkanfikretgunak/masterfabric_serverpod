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

/// Exchange rate response
abstract class ExchangeRateResponse implements _i1.SerializableModel {
  ExchangeRateResponse._({
    required this.success,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.timestamp,
  });

  factory ExchangeRateResponse({
    required bool success,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    required DateTime timestamp,
  }) = _ExchangeRateResponseImpl;

  factory ExchangeRateResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ExchangeRateResponse(
      success: jsonSerialization['success'] as bool,
      baseCurrency: jsonSerialization['baseCurrency'] as String,
      targetCurrency: jsonSerialization['targetCurrency'] as String,
      rate: (jsonSerialization['rate'] as num).toDouble(),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  String baseCurrency;

  String targetCurrency;

  double rate;

  DateTime timestamp;

  /// Returns a shallow copy of this [ExchangeRateResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExchangeRateResponse copyWith({
    bool? success,
    String? baseCurrency,
    String? targetCurrency,
    double? rate,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExchangeRateResponse',
      'success': success,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'rate': rate,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ExchangeRateResponseImpl extends ExchangeRateResponse {
  _ExchangeRateResponseImpl({
    required bool success,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    required DateTime timestamp,
  }) : super._(
         success: success,
         baseCurrency: baseCurrency,
         targetCurrency: targetCurrency,
         rate: rate,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [ExchangeRateResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExchangeRateResponse copyWith({
    bool? success,
    String? baseCurrency,
    String? targetCurrency,
    double? rate,
    DateTime? timestamp,
  }) {
    return ExchangeRateResponse(
      success: success ?? this.success,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      rate: rate ?? this.rate,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
