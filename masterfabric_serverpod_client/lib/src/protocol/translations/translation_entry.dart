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

/// Translation database table
/// Stores translations per locale and namespace
abstract class TranslationEntry implements _i1.SerializableModel {
  TranslationEntry._({
    this.id,
    required this.locale,
    this.namespace,
    required this.translationsJson,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory TranslationEntry({
    int? id,
    required String locale,
    String? namespace,
    required String translationsJson,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) = _TranslationEntryImpl;

  factory TranslationEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TranslationEntry(
      id: jsonSerialization['id'] as int?,
      locale: jsonSerialization['locale'] as String,
      namespace: jsonSerialization['namespace'] as String?,
      translationsJson: jsonSerialization['translationsJson'] as String,
      version: jsonSerialization['version'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// Unique identifier
  int? id;

  /// Locale code (e.g., 'en', 'tr', 'de')
  String locale;

  /// Namespace identifier (optional, for organizing translations)
  String? namespace;

  /// Translations data as JSON string (slang format)
  String translationsJson;

  /// Version number for cache invalidation
  int version;

  /// When this translation was created
  DateTime createdAt;

  /// When this translation was last updated
  DateTime updatedAt;

  /// Whether this translation is active
  bool isActive;

  /// Returns a shallow copy of this [TranslationEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TranslationEntry copyWith({
    int? id,
    String? locale,
    String? namespace,
    String? translationsJson,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TranslationEntry',
      if (id != null) 'id': id,
      'locale': locale,
      if (namespace != null) 'namespace': namespace,
      'translationsJson': translationsJson,
      'version': version,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TranslationEntryImpl extends TranslationEntry {
  _TranslationEntryImpl({
    int? id,
    required String locale,
    String? namespace,
    required String translationsJson,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) : super._(
         id: id,
         locale: locale,
         namespace: namespace,
         translationsJson: translationsJson,
         version: version,
         createdAt: createdAt,
         updatedAt: updatedAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [TranslationEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TranslationEntry copyWith({
    Object? id = _Undefined,
    String? locale,
    Object? namespace = _Undefined,
    String? translationsJson,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return TranslationEntry(
      id: id is int? ? id : this.id,
      locale: locale ?? this.locale,
      namespace: namespace is String? ? namespace : this.namespace,
      translationsJson: translationsJson ?? this.translationsJson,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
