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

/// Validation error detail for a single field
abstract class ValidationErrorDetail implements _i1.SerializableModel {
  ValidationErrorDetail._({
    required this.field,
    required this.message,
    this.value,
    this.rule,
  });

  factory ValidationErrorDetail({
    required String field,
    required String message,
    String? value,
    String? rule,
  }) = _ValidationErrorDetailImpl;

  factory ValidationErrorDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ValidationErrorDetail(
      field: jsonSerialization['field'] as String,
      message: jsonSerialization['message'] as String,
      value: jsonSerialization['value'] as String?,
      rule: jsonSerialization['rule'] as String?,
    );
  }

  /// Name of the field that failed validation
  String field;

  /// Error message describing the validation failure
  String message;

  /// The invalid value (sanitized)
  String? value;

  /// Validation rule that failed
  String? rule;

  /// Returns a shallow copy of this [ValidationErrorDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ValidationErrorDetail copyWith({
    String? field,
    String? message,
    String? value,
    String? rule,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ValidationErrorDetail',
      'field': field,
      'message': message,
      if (value != null) 'value': value,
      if (rule != null) 'rule': rule,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ValidationErrorDetailImpl extends ValidationErrorDetail {
  _ValidationErrorDetailImpl({
    required String field,
    required String message,
    String? value,
    String? rule,
  }) : super._(
         field: field,
         message: message,
         value: value,
         rule: rule,
       );

  /// Returns a shallow copy of this [ValidationErrorDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ValidationErrorDetail copyWith({
    String? field,
    String? message,
    Object? value = _Undefined,
    Object? rule = _Undefined,
  }) {
    return ValidationErrorDetail(
      field: field ?? this.field,
      message: message ?? this.message,
      value: value is String? ? value : this.value,
      rule: rule is String? ? rule : this.rule,
    );
  }
}
