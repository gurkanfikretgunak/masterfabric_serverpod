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

/// User app settings model (stored per user in database)
abstract class UserAppSettings implements _i1.SerializableModel {
  UserAppSettings._({
    this.id,
    required this.userId,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.notificationSound,
    required this.analytics,
    required this.crashReports,
    required this.twoFactorEnabled,
    this.accountDeletionRequested,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAppSettings({
    int? id,
    required String userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool notificationSound,
    required bool analytics,
    required bool crashReports,
    required bool twoFactorEnabled,
    bool? accountDeletionRequested,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserAppSettingsImpl;

  factory UserAppSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAppSettings(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      pushNotifications: jsonSerialization['pushNotifications'] as bool,
      emailNotifications: jsonSerialization['emailNotifications'] as bool,
      notificationSound: jsonSerialization['notificationSound'] as bool,
      analytics: jsonSerialization['analytics'] as bool,
      crashReports: jsonSerialization['crashReports'] as bool,
      twoFactorEnabled: jsonSerialization['twoFactorEnabled'] as bool,
      accountDeletionRequested:
          jsonSerialization['accountDeletionRequested'] as bool?,
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

  String userId;

  bool pushNotifications;

  bool emailNotifications;

  bool notificationSound;

  bool analytics;

  bool crashReports;

  bool twoFactorEnabled;

  bool? accountDeletionRequested;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserAppSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserAppSettings copyWith({
    int? id,
    String? userId,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    bool? accountDeletionRequested,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAppSettings',
      if (id != null) 'id': id,
      'userId': userId,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'notificationSound': notificationSound,
      'analytics': analytics,
      'crashReports': crashReports,
      'twoFactorEnabled': twoFactorEnabled,
      if (accountDeletionRequested != null)
        'accountDeletionRequested': accountDeletionRequested,
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

class _UserAppSettingsImpl extends UserAppSettings {
  _UserAppSettingsImpl({
    int? id,
    required String userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool notificationSound,
    required bool analytics,
    required bool crashReports,
    required bool twoFactorEnabled,
    bool? accountDeletionRequested,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         pushNotifications: pushNotifications,
         emailNotifications: emailNotifications,
         notificationSound: notificationSound,
         analytics: analytics,
         crashReports: crashReports,
         twoFactorEnabled: twoFactorEnabled,
         accountDeletionRequested: accountDeletionRequested,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserAppSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserAppSettings copyWith({
    Object? id = _Undefined,
    String? userId,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    Object? accountDeletionRequested = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAppSettings(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      notificationSound: notificationSound ?? this.notificationSound,
      analytics: analytics ?? this.analytics,
      crashReports: crashReports ?? this.crashReports,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      accountDeletionRequested: accountDeletionRequested is bool?
          ? accountDeletionRequested
          : this.accountDeletionRequested,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
