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
import 'app_config/app_config.dart' as _i2;
import 'app_config/app_config_table.dart' as _i3;
import 'app_config/core/app_settings.dart' as _i4;
import 'app_config/core/feature_flags.dart' as _i5;
import 'app_config/core/splash_configuration.dart' as _i6;
import 'app_config/core/ui_configuration.dart' as _i7;
import 'app_config/integrations/api_configuration.dart' as _i8;
import 'app_config/integrations/navigation_configuration.dart' as _i9;
import 'app_config/integrations/push_notification_configuration.dart' as _i10;
import 'app_config/system/force_update_configuration.dart' as _i11;
import 'app_config/system/localization_configuration.dart' as _i12;
import 'app_config/system/permissions_configuration.dart' as _i13;
import 'app_config/system/storage_configuration.dart' as _i14;
import 'app_config/system/store_url.dart' as _i15;
import 'core/exceptions/models/rate_limit_exception.dart' as _i16;
import 'core/rate_limit/models/rate_limit_entry.dart' as _i17;
import 'core/real_time/notifications_center/models/cached_id_list.dart' as _i18;
import 'core/real_time/notifications_center/models/channel_list_response.dart'
    as _i19;
import 'core/real_time/notifications_center/models/channel_response.dart'
    as _i20;
import 'core/real_time/notifications_center/models/channel_subscription.dart'
    as _i21;
import 'core/real_time/notifications_center/models/channel_type.dart' as _i22;
import 'core/real_time/notifications_center/models/notification.dart' as _i23;
import 'core/real_time/notifications_center/models/notification_channel.dart'
    as _i24;
import 'core/real_time/notifications_center/models/notification_exception.dart'
    as _i25;
import 'core/real_time/notifications_center/models/notification_list_response.dart'
    as _i26;
import 'core/real_time/notifications_center/models/notification_priority.dart'
    as _i27;
import 'core/real_time/notifications_center/models/notification_response.dart'
    as _i28;
import 'core/real_time/notifications_center/models/notification_type.dart'
    as _i29;
import 'core/real_time/notifications_center/models/send_notification_request.dart'
    as _i30;
import 'services/auth/core/auth_audit_log.dart' as _i31;
import 'services/auth/password/password_strength_response.dart' as _i32;
import 'services/auth/rbac/permission.dart' as _i33;
import 'services/auth/rbac/role.dart' as _i34;
import 'services/auth/rbac/user_role.dart' as _i35;
import 'services/auth/session/session_info_response.dart' as _i36;
import 'services/auth/two_factor/two_factor_secret.dart' as _i37;
import 'services/auth/two_factor/two_factor_setup_response.dart' as _i38;
import 'services/auth/user/account_status_response.dart' as _i39;
import 'services/auth/user/current_user_response.dart' as _i40;
import 'services/auth/user/gender.dart' as _i41;
import 'services/auth/user/profile_update_request.dart' as _i42;
import 'services/auth/user/user_info_response.dart' as _i43;
import 'services/auth/user/user_list_response.dart' as _i44;
import 'services/auth/user/user_profile_extended.dart' as _i45;
import 'services/auth/verification/verification_code.dart' as _i46;
import 'services/auth/verification/verification_response.dart' as _i47;
import 'services/greetings/models/greeting.dart' as _i48;
import 'services/greetings/models/greeting_response.dart' as _i49;
import 'services/health/models/health_check_response.dart' as _i50;
import 'services/health/models/service_health_info.dart' as _i51;
import 'services/translations/models/translation_entry.dart' as _i52;
import 'services/translations/models/translation_response.dart' as _i53;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/rbac/role.dart'
    as _i54;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/rbac/permission.dart'
    as _i55;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/session/session_info_response.dart'
    as _i56;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/gender.dart'
    as _i57;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i58;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i59;
export 'app_config/app_config.dart';
export 'app_config/app_config_table.dart';
export 'app_config/core/app_settings.dart';
export 'app_config/core/feature_flags.dart';
export 'app_config/core/splash_configuration.dart';
export 'app_config/core/ui_configuration.dart';
export 'app_config/integrations/api_configuration.dart';
export 'app_config/integrations/navigation_configuration.dart';
export 'app_config/integrations/push_notification_configuration.dart';
export 'app_config/system/force_update_configuration.dart';
export 'app_config/system/localization_configuration.dart';
export 'app_config/system/permissions_configuration.dart';
export 'app_config/system/storage_configuration.dart';
export 'app_config/system/store_url.dart';
export 'core/exceptions/models/rate_limit_exception.dart';
export 'core/rate_limit/models/rate_limit_entry.dart';
export 'core/real_time/notifications_center/models/cached_id_list.dart';
export 'core/real_time/notifications_center/models/channel_list_response.dart';
export 'core/real_time/notifications_center/models/channel_response.dart';
export 'core/real_time/notifications_center/models/channel_subscription.dart';
export 'core/real_time/notifications_center/models/channel_type.dart';
export 'core/real_time/notifications_center/models/notification.dart';
export 'core/real_time/notifications_center/models/notification_channel.dart';
export 'core/real_time/notifications_center/models/notification_exception.dart';
export 'core/real_time/notifications_center/models/notification_list_response.dart';
export 'core/real_time/notifications_center/models/notification_priority.dart';
export 'core/real_time/notifications_center/models/notification_response.dart';
export 'core/real_time/notifications_center/models/notification_type.dart';
export 'core/real_time/notifications_center/models/send_notification_request.dart';
export 'services/auth/core/auth_audit_log.dart';
export 'services/auth/password/password_strength_response.dart';
export 'services/auth/rbac/permission.dart';
export 'services/auth/rbac/role.dart';
export 'services/auth/rbac/user_role.dart';
export 'services/auth/session/session_info_response.dart';
export 'services/auth/two_factor/two_factor_secret.dart';
export 'services/auth/two_factor/two_factor_setup_response.dart';
export 'services/auth/user/account_status_response.dart';
export 'services/auth/user/current_user_response.dart';
export 'services/auth/user/gender.dart';
export 'services/auth/user/profile_update_request.dart';
export 'services/auth/user/user_info_response.dart';
export 'services/auth/user/user_list_response.dart';
export 'services/auth/user/user_profile_extended.dart';
export 'services/auth/verification/verification_code.dart';
export 'services/auth/verification/verification_response.dart';
export 'services/greetings/models/greeting.dart';
export 'services/greetings/models/greeting_response.dart';
export 'services/health/models/health_check_response.dart';
export 'services/health/models/service_health_info.dart';
export 'services/translations/models/translation_entry.dart';
export 'services/translations/models/translation_response.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AppConfig) {
      return _i2.AppConfig.fromJson(data) as T;
    }
    if (t == _i3.AppConfigEntry) {
      return _i3.AppConfigEntry.fromJson(data) as T;
    }
    if (t == _i4.AppSettings) {
      return _i4.AppSettings.fromJson(data) as T;
    }
    if (t == _i5.FeatureFlags) {
      return _i5.FeatureFlags.fromJson(data) as T;
    }
    if (t == _i6.SplashConfiguration) {
      return _i6.SplashConfiguration.fromJson(data) as T;
    }
    if (t == _i7.UiConfiguration) {
      return _i7.UiConfiguration.fromJson(data) as T;
    }
    if (t == _i8.ApiConfiguration) {
      return _i8.ApiConfiguration.fromJson(data) as T;
    }
    if (t == _i9.NavigationConfiguration) {
      return _i9.NavigationConfiguration.fromJson(data) as T;
    }
    if (t == _i10.PushNotificationConfiguration) {
      return _i10.PushNotificationConfiguration.fromJson(data) as T;
    }
    if (t == _i11.ForceUpdateConfiguration) {
      return _i11.ForceUpdateConfiguration.fromJson(data) as T;
    }
    if (t == _i12.LocalizationConfiguration) {
      return _i12.LocalizationConfiguration.fromJson(data) as T;
    }
    if (t == _i13.PermissionsConfiguration) {
      return _i13.PermissionsConfiguration.fromJson(data) as T;
    }
    if (t == _i14.StorageConfiguration) {
      return _i14.StorageConfiguration.fromJson(data) as T;
    }
    if (t == _i15.StoreUrl) {
      return _i15.StoreUrl.fromJson(data) as T;
    }
    if (t == _i16.RateLimitException) {
      return _i16.RateLimitException.fromJson(data) as T;
    }
    if (t == _i17.RateLimitEntry) {
      return _i17.RateLimitEntry.fromJson(data) as T;
    }
    if (t == _i18.CachedIdList) {
      return _i18.CachedIdList.fromJson(data) as T;
    }
    if (t == _i19.ChannelListResponse) {
      return _i19.ChannelListResponse.fromJson(data) as T;
    }
    if (t == _i20.ChannelResponse) {
      return _i20.ChannelResponse.fromJson(data) as T;
    }
    if (t == _i21.ChannelSubscription) {
      return _i21.ChannelSubscription.fromJson(data) as T;
    }
    if (t == _i22.ChannelType) {
      return _i22.ChannelType.fromJson(data) as T;
    }
    if (t == _i23.Notification) {
      return _i23.Notification.fromJson(data) as T;
    }
    if (t == _i24.NotificationChannel) {
      return _i24.NotificationChannel.fromJson(data) as T;
    }
    if (t == _i25.NotificationException) {
      return _i25.NotificationException.fromJson(data) as T;
    }
    if (t == _i26.NotificationListResponse) {
      return _i26.NotificationListResponse.fromJson(data) as T;
    }
    if (t == _i27.NotificationPriority) {
      return _i27.NotificationPriority.fromJson(data) as T;
    }
    if (t == _i28.NotificationResponse) {
      return _i28.NotificationResponse.fromJson(data) as T;
    }
    if (t == _i29.NotificationType) {
      return _i29.NotificationType.fromJson(data) as T;
    }
    if (t == _i30.SendNotificationRequest) {
      return _i30.SendNotificationRequest.fromJson(data) as T;
    }
    if (t == _i31.AuthAuditLog) {
      return _i31.AuthAuditLog.fromJson(data) as T;
    }
    if (t == _i32.PasswordStrengthResponse) {
      return _i32.PasswordStrengthResponse.fromJson(data) as T;
    }
    if (t == _i33.Permission) {
      return _i33.Permission.fromJson(data) as T;
    }
    if (t == _i34.Role) {
      return _i34.Role.fromJson(data) as T;
    }
    if (t == _i35.UserRole) {
      return _i35.UserRole.fromJson(data) as T;
    }
    if (t == _i36.SessionInfoResponse) {
      return _i36.SessionInfoResponse.fromJson(data) as T;
    }
    if (t == _i37.TwoFactorSecret) {
      return _i37.TwoFactorSecret.fromJson(data) as T;
    }
    if (t == _i38.TwoFactorSetupResponse) {
      return _i38.TwoFactorSetupResponse.fromJson(data) as T;
    }
    if (t == _i39.AccountStatusResponse) {
      return _i39.AccountStatusResponse.fromJson(data) as T;
    }
    if (t == _i40.CurrentUserResponse) {
      return _i40.CurrentUserResponse.fromJson(data) as T;
    }
    if (t == _i41.Gender) {
      return _i41.Gender.fromJson(data) as T;
    }
    if (t == _i42.ProfileUpdateRequest) {
      return _i42.ProfileUpdateRequest.fromJson(data) as T;
    }
    if (t == _i43.UserInfoResponse) {
      return _i43.UserInfoResponse.fromJson(data) as T;
    }
    if (t == _i44.UserListResponse) {
      return _i44.UserListResponse.fromJson(data) as T;
    }
    if (t == _i45.UserProfileExtended) {
      return _i45.UserProfileExtended.fromJson(data) as T;
    }
    if (t == _i46.VerificationCode) {
      return _i46.VerificationCode.fromJson(data) as T;
    }
    if (t == _i47.VerificationResponse) {
      return _i47.VerificationResponse.fromJson(data) as T;
    }
    if (t == _i48.Greeting) {
      return _i48.Greeting.fromJson(data) as T;
    }
    if (t == _i49.GreetingResponse) {
      return _i49.GreetingResponse.fromJson(data) as T;
    }
    if (t == _i50.HealthCheckResponse) {
      return _i50.HealthCheckResponse.fromJson(data) as T;
    }
    if (t == _i51.ServiceHealthInfo) {
      return _i51.ServiceHealthInfo.fromJson(data) as T;
    }
    if (t == _i52.TranslationEntry) {
      return _i52.TranslationEntry.fromJson(data) as T;
    }
    if (t == _i53.TranslationResponse) {
      return _i53.TranslationResponse.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AppConfig?>()) {
      return (data != null ? _i2.AppConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppConfigEntry?>()) {
      return (data != null ? _i3.AppConfigEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AppSettings?>()) {
      return (data != null ? _i4.AppSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.FeatureFlags?>()) {
      return (data != null ? _i5.FeatureFlags.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.SplashConfiguration?>()) {
      return (data != null ? _i6.SplashConfiguration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.UiConfiguration?>()) {
      return (data != null ? _i7.UiConfiguration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ApiConfiguration?>()) {
      return (data != null ? _i8.ApiConfiguration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.NavigationConfiguration?>()) {
      return (data != null ? _i9.NavigationConfiguration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.PushNotificationConfiguration?>()) {
      return (data != null
              ? _i10.PushNotificationConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.ForceUpdateConfiguration?>()) {
      return (data != null
              ? _i11.ForceUpdateConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.LocalizationConfiguration?>()) {
      return (data != null
              ? _i12.LocalizationConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.PermissionsConfiguration?>()) {
      return (data != null
              ? _i13.PermissionsConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.StorageConfiguration?>()) {
      return (data != null ? _i14.StorageConfiguration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.StoreUrl?>()) {
      return (data != null ? _i15.StoreUrl.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.RateLimitException?>()) {
      return (data != null ? _i16.RateLimitException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.RateLimitEntry?>()) {
      return (data != null ? _i17.RateLimitEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CachedIdList?>()) {
      return (data != null ? _i18.CachedIdList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.ChannelListResponse?>()) {
      return (data != null ? _i19.ChannelListResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.ChannelResponse?>()) {
      return (data != null ? _i20.ChannelResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ChannelSubscription?>()) {
      return (data != null ? _i21.ChannelSubscription.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.ChannelType?>()) {
      return (data != null ? _i22.ChannelType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Notification?>()) {
      return (data != null ? _i23.Notification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.NotificationChannel?>()) {
      return (data != null ? _i24.NotificationChannel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.NotificationException?>()) {
      return (data != null ? _i25.NotificationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.NotificationListResponse?>()) {
      return (data != null
              ? _i26.NotificationListResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i27.NotificationPriority?>()) {
      return (data != null ? _i27.NotificationPriority.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.NotificationResponse?>()) {
      return (data != null ? _i28.NotificationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.NotificationType?>()) {
      return (data != null ? _i29.NotificationType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.SendNotificationRequest?>()) {
      return (data != null ? _i30.SendNotificationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.AuthAuditLog?>()) {
      return (data != null ? _i31.AuthAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.PasswordStrengthResponse?>()) {
      return (data != null
              ? _i32.PasswordStrengthResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.Permission?>()) {
      return (data != null ? _i33.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.Role?>()) {
      return (data != null ? _i34.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.UserRole?>()) {
      return (data != null ? _i35.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.SessionInfoResponse?>()) {
      return (data != null ? _i36.SessionInfoResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.TwoFactorSecret?>()) {
      return (data != null ? _i37.TwoFactorSecret.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.TwoFactorSetupResponse?>()) {
      return (data != null ? _i38.TwoFactorSetupResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.AccountStatusResponse?>()) {
      return (data != null ? _i39.AccountStatusResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.CurrentUserResponse?>()) {
      return (data != null ? _i40.CurrentUserResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.Gender?>()) {
      return (data != null ? _i41.Gender.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.ProfileUpdateRequest?>()) {
      return (data != null ? _i42.ProfileUpdateRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.UserInfoResponse?>()) {
      return (data != null ? _i43.UserInfoResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.UserListResponse?>()) {
      return (data != null ? _i44.UserListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.UserProfileExtended?>()) {
      return (data != null ? _i45.UserProfileExtended.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.VerificationCode?>()) {
      return (data != null ? _i46.VerificationCode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.VerificationResponse?>()) {
      return (data != null ? _i47.VerificationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.Greeting?>()) {
      return (data != null ? _i48.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.GreetingResponse?>()) {
      return (data != null ? _i49.GreetingResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.HealthCheckResponse?>()) {
      return (data != null ? _i50.HealthCheckResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.ServiceHealthInfo?>()) {
      return (data != null ? _i51.ServiceHealthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.TranslationEntry?>()) {
      return (data != null ? _i52.TranslationEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.TranslationResponse?>()) {
      return (data != null ? _i53.TranslationResponse.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i24.NotificationChannel>) {
      return (data as List)
              .map((e) => deserialize<_i24.NotificationChannel>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i23.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.UserInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i43.UserInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i51.ServiceHealthInfo>) {
      return (data as List)
              .map((e) => deserialize<_i51.ServiceHealthInfo>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i54.Role>) {
      return (data as List).map((e) => deserialize<_i54.Role>(e)).toList() as T;
    }
    if (t == List<_i55.Permission>) {
      return (data as List).map((e) => deserialize<_i55.Permission>(e)).toList()
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == List<_i56.SessionInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i56.SessionInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.Gender>) {
      return (data as List).map((e) => deserialize<_i57.Gender>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _i58.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i59.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AppConfig => 'AppConfig',
      _i3.AppConfigEntry => 'AppConfigEntry',
      _i4.AppSettings => 'AppSettings',
      _i5.FeatureFlags => 'FeatureFlags',
      _i6.SplashConfiguration => 'SplashConfiguration',
      _i7.UiConfiguration => 'UiConfiguration',
      _i8.ApiConfiguration => 'ApiConfiguration',
      _i9.NavigationConfiguration => 'NavigationConfiguration',
      _i10.PushNotificationConfiguration => 'PushNotificationConfiguration',
      _i11.ForceUpdateConfiguration => 'ForceUpdateConfiguration',
      _i12.LocalizationConfiguration => 'LocalizationConfiguration',
      _i13.PermissionsConfiguration => 'PermissionsConfiguration',
      _i14.StorageConfiguration => 'StorageConfiguration',
      _i15.StoreUrl => 'StoreUrl',
      _i16.RateLimitException => 'RateLimitException',
      _i17.RateLimitEntry => 'RateLimitEntry',
      _i18.CachedIdList => 'CachedIdList',
      _i19.ChannelListResponse => 'ChannelListResponse',
      _i20.ChannelResponse => 'ChannelResponse',
      _i21.ChannelSubscription => 'ChannelSubscription',
      _i22.ChannelType => 'ChannelType',
      _i23.Notification => 'Notification',
      _i24.NotificationChannel => 'NotificationChannel',
      _i25.NotificationException => 'NotificationException',
      _i26.NotificationListResponse => 'NotificationListResponse',
      _i27.NotificationPriority => 'NotificationPriority',
      _i28.NotificationResponse => 'NotificationResponse',
      _i29.NotificationType => 'NotificationType',
      _i30.SendNotificationRequest => 'SendNotificationRequest',
      _i31.AuthAuditLog => 'AuthAuditLog',
      _i32.PasswordStrengthResponse => 'PasswordStrengthResponse',
      _i33.Permission => 'Permission',
      _i34.Role => 'Role',
      _i35.UserRole => 'UserRole',
      _i36.SessionInfoResponse => 'SessionInfoResponse',
      _i37.TwoFactorSecret => 'TwoFactorSecret',
      _i38.TwoFactorSetupResponse => 'TwoFactorSetupResponse',
      _i39.AccountStatusResponse => 'AccountStatusResponse',
      _i40.CurrentUserResponse => 'CurrentUserResponse',
      _i41.Gender => 'Gender',
      _i42.ProfileUpdateRequest => 'ProfileUpdateRequest',
      _i43.UserInfoResponse => 'UserInfoResponse',
      _i44.UserListResponse => 'UserListResponse',
      _i45.UserProfileExtended => 'UserProfileExtended',
      _i46.VerificationCode => 'VerificationCode',
      _i47.VerificationResponse => 'VerificationResponse',
      _i48.Greeting => 'Greeting',
      _i49.GreetingResponse => 'GreetingResponse',
      _i50.HealthCheckResponse => 'HealthCheckResponse',
      _i51.ServiceHealthInfo => 'ServiceHealthInfo',
      _i52.TranslationEntry => 'TranslationEntry',
      _i53.TranslationResponse => 'TranslationResponse',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'masterfabric_serverpod.',
        '',
      );
    }

    switch (data) {
      case _i2.AppConfig():
        return 'AppConfig';
      case _i3.AppConfigEntry():
        return 'AppConfigEntry';
      case _i4.AppSettings():
        return 'AppSettings';
      case _i5.FeatureFlags():
        return 'FeatureFlags';
      case _i6.SplashConfiguration():
        return 'SplashConfiguration';
      case _i7.UiConfiguration():
        return 'UiConfiguration';
      case _i8.ApiConfiguration():
        return 'ApiConfiguration';
      case _i9.NavigationConfiguration():
        return 'NavigationConfiguration';
      case _i10.PushNotificationConfiguration():
        return 'PushNotificationConfiguration';
      case _i11.ForceUpdateConfiguration():
        return 'ForceUpdateConfiguration';
      case _i12.LocalizationConfiguration():
        return 'LocalizationConfiguration';
      case _i13.PermissionsConfiguration():
        return 'PermissionsConfiguration';
      case _i14.StorageConfiguration():
        return 'StorageConfiguration';
      case _i15.StoreUrl():
        return 'StoreUrl';
      case _i16.RateLimitException():
        return 'RateLimitException';
      case _i17.RateLimitEntry():
        return 'RateLimitEntry';
      case _i18.CachedIdList():
        return 'CachedIdList';
      case _i19.ChannelListResponse():
        return 'ChannelListResponse';
      case _i20.ChannelResponse():
        return 'ChannelResponse';
      case _i21.ChannelSubscription():
        return 'ChannelSubscription';
      case _i22.ChannelType():
        return 'ChannelType';
      case _i23.Notification():
        return 'Notification';
      case _i24.NotificationChannel():
        return 'NotificationChannel';
      case _i25.NotificationException():
        return 'NotificationException';
      case _i26.NotificationListResponse():
        return 'NotificationListResponse';
      case _i27.NotificationPriority():
        return 'NotificationPriority';
      case _i28.NotificationResponse():
        return 'NotificationResponse';
      case _i29.NotificationType():
        return 'NotificationType';
      case _i30.SendNotificationRequest():
        return 'SendNotificationRequest';
      case _i31.AuthAuditLog():
        return 'AuthAuditLog';
      case _i32.PasswordStrengthResponse():
        return 'PasswordStrengthResponse';
      case _i33.Permission():
        return 'Permission';
      case _i34.Role():
        return 'Role';
      case _i35.UserRole():
        return 'UserRole';
      case _i36.SessionInfoResponse():
        return 'SessionInfoResponse';
      case _i37.TwoFactorSecret():
        return 'TwoFactorSecret';
      case _i38.TwoFactorSetupResponse():
        return 'TwoFactorSetupResponse';
      case _i39.AccountStatusResponse():
        return 'AccountStatusResponse';
      case _i40.CurrentUserResponse():
        return 'CurrentUserResponse';
      case _i41.Gender():
        return 'Gender';
      case _i42.ProfileUpdateRequest():
        return 'ProfileUpdateRequest';
      case _i43.UserInfoResponse():
        return 'UserInfoResponse';
      case _i44.UserListResponse():
        return 'UserListResponse';
      case _i45.UserProfileExtended():
        return 'UserProfileExtended';
      case _i46.VerificationCode():
        return 'VerificationCode';
      case _i47.VerificationResponse():
        return 'VerificationResponse';
      case _i48.Greeting():
        return 'Greeting';
      case _i49.GreetingResponse():
        return 'GreetingResponse';
      case _i50.HealthCheckResponse():
        return 'HealthCheckResponse';
      case _i51.ServiceHealthInfo():
        return 'ServiceHealthInfo';
      case _i52.TranslationEntry():
        return 'TranslationEntry';
      case _i53.TranslationResponse():
        return 'TranslationResponse';
    }
    className = _i58.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i59.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppConfig') {
      return deserialize<_i2.AppConfig>(data['data']);
    }
    if (dataClassName == 'AppConfigEntry') {
      return deserialize<_i3.AppConfigEntry>(data['data']);
    }
    if (dataClassName == 'AppSettings') {
      return deserialize<_i4.AppSettings>(data['data']);
    }
    if (dataClassName == 'FeatureFlags') {
      return deserialize<_i5.FeatureFlags>(data['data']);
    }
    if (dataClassName == 'SplashConfiguration') {
      return deserialize<_i6.SplashConfiguration>(data['data']);
    }
    if (dataClassName == 'UiConfiguration') {
      return deserialize<_i7.UiConfiguration>(data['data']);
    }
    if (dataClassName == 'ApiConfiguration') {
      return deserialize<_i8.ApiConfiguration>(data['data']);
    }
    if (dataClassName == 'NavigationConfiguration') {
      return deserialize<_i9.NavigationConfiguration>(data['data']);
    }
    if (dataClassName == 'PushNotificationConfiguration') {
      return deserialize<_i10.PushNotificationConfiguration>(data['data']);
    }
    if (dataClassName == 'ForceUpdateConfiguration') {
      return deserialize<_i11.ForceUpdateConfiguration>(data['data']);
    }
    if (dataClassName == 'LocalizationConfiguration') {
      return deserialize<_i12.LocalizationConfiguration>(data['data']);
    }
    if (dataClassName == 'PermissionsConfiguration') {
      return deserialize<_i13.PermissionsConfiguration>(data['data']);
    }
    if (dataClassName == 'StorageConfiguration') {
      return deserialize<_i14.StorageConfiguration>(data['data']);
    }
    if (dataClassName == 'StoreUrl') {
      return deserialize<_i15.StoreUrl>(data['data']);
    }
    if (dataClassName == 'RateLimitException') {
      return deserialize<_i16.RateLimitException>(data['data']);
    }
    if (dataClassName == 'RateLimitEntry') {
      return deserialize<_i17.RateLimitEntry>(data['data']);
    }
    if (dataClassName == 'CachedIdList') {
      return deserialize<_i18.CachedIdList>(data['data']);
    }
    if (dataClassName == 'ChannelListResponse') {
      return deserialize<_i19.ChannelListResponse>(data['data']);
    }
    if (dataClassName == 'ChannelResponse') {
      return deserialize<_i20.ChannelResponse>(data['data']);
    }
    if (dataClassName == 'ChannelSubscription') {
      return deserialize<_i21.ChannelSubscription>(data['data']);
    }
    if (dataClassName == 'ChannelType') {
      return deserialize<_i22.ChannelType>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_i23.Notification>(data['data']);
    }
    if (dataClassName == 'NotificationChannel') {
      return deserialize<_i24.NotificationChannel>(data['data']);
    }
    if (dataClassName == 'NotificationException') {
      return deserialize<_i25.NotificationException>(data['data']);
    }
    if (dataClassName == 'NotificationListResponse') {
      return deserialize<_i26.NotificationListResponse>(data['data']);
    }
    if (dataClassName == 'NotificationPriority') {
      return deserialize<_i27.NotificationPriority>(data['data']);
    }
    if (dataClassName == 'NotificationResponse') {
      return deserialize<_i28.NotificationResponse>(data['data']);
    }
    if (dataClassName == 'NotificationType') {
      return deserialize<_i29.NotificationType>(data['data']);
    }
    if (dataClassName == 'SendNotificationRequest') {
      return deserialize<_i30.SendNotificationRequest>(data['data']);
    }
    if (dataClassName == 'AuthAuditLog') {
      return deserialize<_i31.AuthAuditLog>(data['data']);
    }
    if (dataClassName == 'PasswordStrengthResponse') {
      return deserialize<_i32.PasswordStrengthResponse>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i33.Permission>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i34.Role>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i35.UserRole>(data['data']);
    }
    if (dataClassName == 'SessionInfoResponse') {
      return deserialize<_i36.SessionInfoResponse>(data['data']);
    }
    if (dataClassName == 'TwoFactorSecret') {
      return deserialize<_i37.TwoFactorSecret>(data['data']);
    }
    if (dataClassName == 'TwoFactorSetupResponse') {
      return deserialize<_i38.TwoFactorSetupResponse>(data['data']);
    }
    if (dataClassName == 'AccountStatusResponse') {
      return deserialize<_i39.AccountStatusResponse>(data['data']);
    }
    if (dataClassName == 'CurrentUserResponse') {
      return deserialize<_i40.CurrentUserResponse>(data['data']);
    }
    if (dataClassName == 'Gender') {
      return deserialize<_i41.Gender>(data['data']);
    }
    if (dataClassName == 'ProfileUpdateRequest') {
      return deserialize<_i42.ProfileUpdateRequest>(data['data']);
    }
    if (dataClassName == 'UserInfoResponse') {
      return deserialize<_i43.UserInfoResponse>(data['data']);
    }
    if (dataClassName == 'UserListResponse') {
      return deserialize<_i44.UserListResponse>(data['data']);
    }
    if (dataClassName == 'UserProfileExtended') {
      return deserialize<_i45.UserProfileExtended>(data['data']);
    }
    if (dataClassName == 'VerificationCode') {
      return deserialize<_i46.VerificationCode>(data['data']);
    }
    if (dataClassName == 'VerificationResponse') {
      return deserialize<_i47.VerificationResponse>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i48.Greeting>(data['data']);
    }
    if (dataClassName == 'GreetingResponse') {
      return deserialize<_i49.GreetingResponse>(data['data']);
    }
    if (dataClassName == 'HealthCheckResponse') {
      return deserialize<_i50.HealthCheckResponse>(data['data']);
    }
    if (dataClassName == 'ServiceHealthInfo') {
      return deserialize<_i51.ServiceHealthInfo>(data['data']);
    }
    if (dataClassName == 'TranslationEntry') {
      return deserialize<_i52.TranslationEntry>(data['data']);
    }
    if (dataClassName == 'TranslationResponse') {
      return deserialize<_i53.TranslationResponse>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i58.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i59.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i58.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i59.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
