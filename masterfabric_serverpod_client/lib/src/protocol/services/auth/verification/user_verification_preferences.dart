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
import '../../../services/auth/verification/verification_channel.dart' as _i2;

/// User verification preferences for multi-channel code delivery
abstract class UserVerificationPreferences implements _i1.SerializableModel {
  UserVerificationPreferences._({
    this.id,
    required this.userId,
    required this.preferredChannel,
    this.phoneNumber,
    this.telegramChatId,
    required this.whatsappVerified,
    required this.telegramLinked,
    this.backupChannel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserVerificationPreferences({
    int? id,
    required String userId,
    required _i2.VerificationChannel preferredChannel,
    String? phoneNumber,
    String? telegramChatId,
    required bool whatsappVerified,
    required bool telegramLinked,
    _i2.VerificationChannel? backupChannel,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserVerificationPreferencesImpl;

  factory UserVerificationPreferences.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserVerificationPreferences(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      preferredChannel: _i2.VerificationChannel.fromJson(
        (jsonSerialization['preferredChannel'] as String),
      ),
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      telegramChatId: jsonSerialization['telegramChatId'] as String?,
      whatsappVerified: jsonSerialization['whatsappVerified'] as bool,
      telegramLinked: jsonSerialization['telegramLinked'] as bool,
      backupChannel: jsonSerialization['backupChannel'] == null
          ? null
          : _i2.VerificationChannel.fromJson(
              (jsonSerialization['backupChannel'] as String),
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// User identifier (matches auth user id)
  String userId;

  /// Preferred verification channel
  _i2.VerificationChannel preferredChannel;

  /// Phone number for Telegram/WhatsApp verification (E.164 format)
  String? phoneNumber;

  /// Telegram chat ID (set when user starts conversation with bot)
  String? telegramChatId;

  /// Whether WhatsApp number has been verified
  bool whatsappVerified;

  /// Whether Telegram has been linked
  bool telegramLinked;

  /// Backup channel if primary fails
  _i2.VerificationChannel? backupChannel;

  /// Created timestamp
  DateTime createdAt;

  /// Last updated timestamp
  DateTime updatedAt;

  /// Returns a shallow copy of this [UserVerificationPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserVerificationPreferences copyWith({
    int? id,
    String? userId,
    _i2.VerificationChannel? preferredChannel,
    String? phoneNumber,
    String? telegramChatId,
    bool? whatsappVerified,
    bool? telegramLinked,
    _i2.VerificationChannel? backupChannel,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserVerificationPreferences',
      if (id != null) 'id': id,
      'userId': userId,
      'preferredChannel': preferredChannel.toJson(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (telegramChatId != null) 'telegramChatId': telegramChatId,
      'whatsappVerified': whatsappVerified,
      'telegramLinked': telegramLinked,
      if (backupChannel != null) 'backupChannel': backupChannel?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserVerificationPreferencesImpl extends UserVerificationPreferences {
  _UserVerificationPreferencesImpl({
    int? id,
    required String userId,
    required _i2.VerificationChannel preferredChannel,
    String? phoneNumber,
    String? telegramChatId,
    required bool whatsappVerified,
    required bool telegramLinked,
    _i2.VerificationChannel? backupChannel,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         preferredChannel: preferredChannel,
         phoneNumber: phoneNumber,
         telegramChatId: telegramChatId,
         whatsappVerified: whatsappVerified,
         telegramLinked: telegramLinked,
         backupChannel: backupChannel,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserVerificationPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserVerificationPreferences copyWith({
    Object? id = _Undefined,
    String? userId,
    _i2.VerificationChannel? preferredChannel,
    Object? phoneNumber = _Undefined,
    Object? telegramChatId = _Undefined,
    bool? whatsappVerified,
    bool? telegramLinked,
    Object? backupChannel = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserVerificationPreferences(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      preferredChannel: preferredChannel ?? this.preferredChannel,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      telegramChatId: telegramChatId is String?
          ? telegramChatId
          : this.telegramChatId,
      whatsappVerified: whatsappVerified ?? this.whatsappVerified,
      telegramLinked: telegramLinked ?? this.telegramLinked,
      backupChannel: backupChannel is _i2.VerificationChannel?
          ? backupChannel
          : this.backupChannel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
