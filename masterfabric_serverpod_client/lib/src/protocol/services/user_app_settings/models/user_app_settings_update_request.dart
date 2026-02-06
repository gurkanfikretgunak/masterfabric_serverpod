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

/// User app settings update request
abstract class UserAppSettingsUpdateRequest implements _i1.SerializableModel {
  UserAppSettingsUpdateRequest._({
    this.pushNotifications,
    this.emailNotifications,
    this.notificationSound,
    this.analytics,
    this.crashReports,
    this.twoFactorEnabled,
    this.verificationCode,
  });

  factory UserAppSettingsUpdateRequest({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    String? verificationCode,
  }) = _UserAppSettingsUpdateRequestImpl;

  factory UserAppSettingsUpdateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserAppSettingsUpdateRequest(
      pushNotifications: jsonSerialization['pushNotifications'] as bool?,
      emailNotifications: jsonSerialization['emailNotifications'] as bool?,
      notificationSound: jsonSerialization['notificationSound'] as bool?,
      analytics: jsonSerialization['analytics'] as bool?,
      crashReports: jsonSerialization['crashReports'] as bool?,
      twoFactorEnabled: jsonSerialization['twoFactorEnabled'] as bool?,
      verificationCode: jsonSerialization['verificationCode'] as String?,
    );
  }

  bool? pushNotifications;

  bool? emailNotifications;

  bool? notificationSound;

  bool? analytics;

  bool? crashReports;

  bool? twoFactorEnabled;

  String? verificationCode;

  /// Returns a shallow copy of this [UserAppSettingsUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserAppSettingsUpdateRequest copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAppSettingsUpdateRequest',
      if (pushNotifications != null) 'pushNotifications': pushNotifications,
      if (emailNotifications != null) 'emailNotifications': emailNotifications,
      if (notificationSound != null) 'notificationSound': notificationSound,
      if (analytics != null) 'analytics': analytics,
      if (crashReports != null) 'crashReports': crashReports,
      if (twoFactorEnabled != null) 'twoFactorEnabled': twoFactorEnabled,
      if (verificationCode != null) 'verificationCode': verificationCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAppSettingsUpdateRequestImpl extends UserAppSettingsUpdateRequest {
  _UserAppSettingsUpdateRequestImpl({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    String? verificationCode,
  }) : super._(
         pushNotifications: pushNotifications,
         emailNotifications: emailNotifications,
         notificationSound: notificationSound,
         analytics: analytics,
         crashReports: crashReports,
         twoFactorEnabled: twoFactorEnabled,
         verificationCode: verificationCode,
       );

  /// Returns a shallow copy of this [UserAppSettingsUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserAppSettingsUpdateRequest copyWith({
    Object? pushNotifications = _Undefined,
    Object? emailNotifications = _Undefined,
    Object? notificationSound = _Undefined,
    Object? analytics = _Undefined,
    Object? crashReports = _Undefined,
    Object? twoFactorEnabled = _Undefined,
    Object? verificationCode = _Undefined,
  }) {
    return UserAppSettingsUpdateRequest(
      pushNotifications: pushNotifications is bool?
          ? pushNotifications
          : this.pushNotifications,
      emailNotifications: emailNotifications is bool?
          ? emailNotifications
          : this.emailNotifications,
      notificationSound: notificationSound is bool?
          ? notificationSound
          : this.notificationSound,
      analytics: analytics is bool? ? analytics : this.analytics,
      crashReports: crashReports is bool? ? crashReports : this.crashReports,
      twoFactorEnabled: twoFactorEnabled is bool?
          ? twoFactorEnabled
          : this.twoFactorEnabled,
      verificationCode: verificationCode is String?
          ? verificationCode
          : this.verificationCode,
    );
  }
}
