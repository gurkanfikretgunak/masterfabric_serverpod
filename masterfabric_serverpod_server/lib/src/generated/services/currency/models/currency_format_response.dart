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

/// Currency format response
abstract class CurrencyFormatResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CurrencyFormatResponse._({
    required this.success,
    required this.currency,
    required this.amount,
    required this.formatted,
    this.symbol,
    required this.timestamp,
  });

  factory CurrencyFormatResponse({
    required bool success,
    required String currency,
    required double amount,
    required String formatted,
    String? symbol,
    required DateTime timestamp,
  }) = _CurrencyFormatResponseImpl;

  factory CurrencyFormatResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CurrencyFormatResponse(
      success: jsonSerialization['success'] as bool,
      currency: jsonSerialization['currency'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      formatted: jsonSerialization['formatted'] as String,
      symbol: jsonSerialization['symbol'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  bool success;

  String currency;

  double amount;

  String formatted;

  String? symbol;

  DateTime timestamp;

  /// Returns a shallow copy of this [CurrencyFormatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CurrencyFormatResponse copyWith({
    bool? success,
    String? currency,
    double? amount,
    String? formatted,
    String? symbol,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CurrencyFormatResponse',
      'success': success,
      'currency': currency,
      'amount': amount,
      'formatted': formatted,
      if (symbol != null) 'symbol': symbol,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CurrencyFormatResponse',
      'success': success,
      'currency': currency,
      'amount': amount,
      'formatted': formatted,
      if (symbol != null) 'symbol': symbol,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CurrencyFormatResponseImpl extends CurrencyFormatResponse {
  _CurrencyFormatResponseImpl({
    required bool success,
    required String currency,
    required double amount,
    required String formatted,
    String? symbol,
    required DateTime timestamp,
  }) : super._(
         success: success,
         currency: currency,
         amount: amount,
         formatted: formatted,
         symbol: symbol,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [CurrencyFormatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CurrencyFormatResponse copyWith({
    bool? success,
    String? currency,
    double? amount,
    String? formatted,
    Object? symbol = _Undefined,
    DateTime? timestamp,
  }) {
    return CurrencyFormatResponse(
      success: success ?? this.success,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      formatted: formatted ?? this.formatted,
      symbol: symbol is String? ? symbol : this.symbol,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
