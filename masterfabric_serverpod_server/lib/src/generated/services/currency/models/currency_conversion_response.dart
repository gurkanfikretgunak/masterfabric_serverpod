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

/// Currency conversion response
abstract class CurrencyConversionResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CurrencyConversionResponse._({
    required this.success,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.timestamp,
  });

  factory CurrencyConversionResponse({
    required bool success,
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required double convertedAmount,
    required double exchangeRate,
    required DateTime timestamp,
  }) = _CurrencyConversionResponseImpl;

  factory CurrencyConversionResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CurrencyConversionResponse(
      success: jsonSerialization['success'] as bool,
      fromCurrency: jsonSerialization['fromCurrency'] as String,
      toCurrency: jsonSerialization['toCurrency'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      convertedAmount: (jsonSerialization['convertedAmount'] as num).toDouble(),
      exchangeRate: (jsonSerialization['exchangeRate'] as num).toDouble(),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  String fromCurrency;

  String toCurrency;

  double amount;

  double convertedAmount;

  double exchangeRate;

  DateTime timestamp;

  /// Returns a shallow copy of this [CurrencyConversionResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CurrencyConversionResponse copyWith({
    bool? success,
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? convertedAmount,
    double? exchangeRate,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CurrencyConversionResponse',
      'success': success,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'exchangeRate': exchangeRate,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CurrencyConversionResponse',
      'success': success,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'exchangeRate': exchangeRate,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CurrencyConversionResponseImpl extends CurrencyConversionResponse {
  _CurrencyConversionResponseImpl({
    required bool success,
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required double convertedAmount,
    required double exchangeRate,
    required DateTime timestamp,
  }) : super._(
         success: success,
         fromCurrency: fromCurrency,
         toCurrency: toCurrency,
         amount: amount,
         convertedAmount: convertedAmount,
         exchangeRate: exchangeRate,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [CurrencyConversionResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CurrencyConversionResponse copyWith({
    bool? success,
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? convertedAmount,
    double? exchangeRate,
    DateTime? timestamp,
  }) {
    return CurrencyConversionResponse(
      success: success ?? this.success,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
