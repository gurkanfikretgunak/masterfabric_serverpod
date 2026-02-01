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

abstract class TwoFactorSetupResponse implements _i1.SerializableModel {
  TwoFactorSetupResponse._({
    required this.secret,
    required this.qrCodeUri,
    required this.backupCodes,
  });

  factory TwoFactorSetupResponse({
    required String secret,
    required String qrCodeUri,
    required List<String> backupCodes,
  }) = _TwoFactorSetupResponseImpl;

  factory TwoFactorSetupResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TwoFactorSetupResponse(
      secret: jsonSerialization['secret'] as String,
      qrCodeUri: jsonSerialization['qrCodeUri'] as String,
      backupCodes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['backupCodes'],
      ),
    );
  }

  String secret;

  String qrCodeUri;

  List<String> backupCodes;

  /// Returns a shallow copy of this [TwoFactorSetupResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TwoFactorSetupResponse copyWith({
    String? secret,
    String? qrCodeUri,
    List<String>? backupCodes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TwoFactorSetupResponse',
      'secret': secret,
      'qrCodeUri': qrCodeUri,
      'backupCodes': backupCodes.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TwoFactorSetupResponseImpl extends TwoFactorSetupResponse {
  _TwoFactorSetupResponseImpl({
    required String secret,
    required String qrCodeUri,
    required List<String> backupCodes,
  }) : super._(
         secret: secret,
         qrCodeUri: qrCodeUri,
         backupCodes: backupCodes,
       );

  /// Returns a shallow copy of this [TwoFactorSetupResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TwoFactorSetupResponse copyWith({
    String? secret,
    String? qrCodeUri,
    List<String>? backupCodes,
  }) {
    return TwoFactorSetupResponse(
      secret: secret ?? this.secret,
      qrCodeUri: qrCodeUri ?? this.qrCodeUri,
      backupCodes: backupCodes ?? this.backupCodes.map((e0) => e0).toList(),
    );
  }
}
