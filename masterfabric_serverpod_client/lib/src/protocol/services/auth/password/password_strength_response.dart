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

abstract class PasswordStrengthResponse implements _i1.SerializableModel {
  PasswordStrengthResponse._({
    required this.isValid,
    required this.score,
    required this.issues,
  });

  factory PasswordStrengthResponse({
    required bool isValid,
    required int score,
    required List<String> issues,
  }) = _PasswordStrengthResponseImpl;

  factory PasswordStrengthResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PasswordStrengthResponse(
      isValid: jsonSerialization['isValid'] as bool,
      score: jsonSerialization['score'] as int,
      issues: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['issues'],
      ),
    );
  }

  bool isValid;

  int score;

  List<String> issues;

  /// Returns a shallow copy of this [PasswordStrengthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasswordStrengthResponse copyWith({
    bool? isValid,
    int? score,
    List<String>? issues,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PasswordStrengthResponse',
      'isValid': isValid,
      'score': score,
      'issues': issues.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PasswordStrengthResponseImpl extends PasswordStrengthResponse {
  _PasswordStrengthResponseImpl({
    required bool isValid,
    required int score,
    required List<String> issues,
  }) : super._(
         isValid: isValid,
         score: score,
         issues: issues,
       );

  /// Returns a shallow copy of this [PasswordStrengthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasswordStrengthResponse copyWith({
    bool? isValid,
    int? score,
    List<String>? issues,
  }) {
    return PasswordStrengthResponse(
      isValid: isValid ?? this.isValid,
      score: score ?? this.score,
      issues: issues ?? this.issues.map((e0) => e0).toList(),
    );
  }
}
