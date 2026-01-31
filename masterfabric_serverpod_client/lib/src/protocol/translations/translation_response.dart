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

/// Translation response model
/// Wraps translations JSON string for Serverpod endpoint
abstract class TranslationResponse implements _i1.SerializableModel {
  TranslationResponse._({
    required this.translationsJson,
    required this.locale,
    this.namespace,
  });

  factory TranslationResponse({
    required String translationsJson,
    required String locale,
    String? namespace,
  }) = _TranslationResponseImpl;

  factory TranslationResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return TranslationResponse(
      translationsJson: jsonSerialization['translationsJson'] as String,
      locale: jsonSerialization['locale'] as String,
      namespace: jsonSerialization['namespace'] as String?,
    );
  }

  /// Translations as JSON string (slang format)
  String translationsJson;

  /// Locale code that was used
  String locale;

  /// Namespace identifier (if any)
  String? namespace;

  /// Returns a shallow copy of this [TranslationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TranslationResponse copyWith({
    String? translationsJson,
    String? locale,
    String? namespace,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TranslationResponse',
      'translationsJson': translationsJson,
      'locale': locale,
      if (namespace != null) 'namespace': namespace,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TranslationResponseImpl extends TranslationResponse {
  _TranslationResponseImpl({
    required String translationsJson,
    required String locale,
    String? namespace,
  }) : super._(
         translationsJson: translationsJson,
         locale: locale,
         namespace: namespace,
       );

  /// Returns a shallow copy of this [TranslationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TranslationResponse copyWith({
    String? translationsJson,
    String? locale,
    Object? namespace = _Undefined,
  }) {
    return TranslationResponse(
      translationsJson: translationsJson ?? this.translationsJson,
      locale: locale ?? this.locale,
      namespace: namespace is String? ? namespace : this.namespace,
    );
  }
}
