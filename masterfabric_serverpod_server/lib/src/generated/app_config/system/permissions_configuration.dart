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
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i2;

/// Permissions configuration
abstract class PermissionsConfiguration
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PermissionsConfiguration._({
    required this.required,
    required this.optional,
  });

  factory PermissionsConfiguration({
    required List<String> required,
    required List<String> optional,
  }) = _PermissionsConfigurationImpl;

  factory PermissionsConfiguration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PermissionsConfiguration(
      required: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['required'],
      ),
      optional: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['optional'],
      ),
    );
  }

  /// Required permissions list
  List<String> required;

  /// Optional permissions list
  List<String> optional;

  /// Returns a shallow copy of this [PermissionsConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PermissionsConfiguration copyWith({
    List<String>? required,
    List<String>? optional,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PermissionsConfiguration',
      'required': required.toJson(),
      'optional': optional.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PermissionsConfiguration',
      'required': required.toJson(),
      'optional': optional.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PermissionsConfigurationImpl extends PermissionsConfiguration {
  _PermissionsConfigurationImpl({
    required List<String> required,
    required List<String> optional,
  }) : super._(
         required: required,
         optional: optional,
       );

  /// Returns a shallow copy of this [PermissionsConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PermissionsConfiguration copyWith({
    List<String>? required,
    List<String>? optional,
  }) {
    return PermissionsConfiguration(
      required: required ?? this.required.map((e0) => e0).toList(),
      optional: optional ?? this.optional.map((e0) => e0).toList(),
    );
  }
}
