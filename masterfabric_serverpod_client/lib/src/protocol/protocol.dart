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
import 'core/middleware/models/middleware_error.dart' as _i17;
import 'core/middleware/models/middleware_execution_info.dart' as _i18;
import 'core/middleware/models/request_metrics.dart' as _i19;
import 'core/middleware/models/validation_error_detail.dart' as _i20;
import 'core/middleware/models/validation_exception.dart' as _i21;
import 'core/rate_limit/models/rate_limit_entry.dart' as _i22;
import 'core/real_time/notifications_center/models/cached_id_list.dart' as _i23;
import 'core/real_time/notifications_center/models/channel_list_response.dart'
    as _i24;
import 'core/real_time/notifications_center/models/channel_response.dart'
    as _i25;
import 'core/real_time/notifications_center/models/channel_subscription.dart'
    as _i26;
import 'core/real_time/notifications_center/models/channel_type.dart' as _i27;
import 'core/real_time/notifications_center/models/notification.dart' as _i28;
import 'core/real_time/notifications_center/models/notification_channel.dart'
    as _i29;
import 'core/real_time/notifications_center/models/notification_exception.dart'
    as _i30;
import 'core/real_time/notifications_center/models/notification_list_response.dart'
    as _i31;
import 'core/real_time/notifications_center/models/notification_priority.dart'
    as _i32;
import 'core/real_time/notifications_center/models/notification_response.dart'
    as _i33;
import 'core/real_time/notifications_center/models/notification_type.dart'
    as _i34;
import 'core/real_time/notifications_center/models/send_notification_request.dart'
    as _i35;
import 'services/auth/core/auth_audit_log.dart' as _i36;
import 'services/auth/password/password_strength_response.dart' as _i37;
import 'services/auth/rbac/permission.dart' as _i38;
import 'services/auth/rbac/permission_type.dart' as _i39;
import 'services/auth/rbac/role.dart' as _i40;
import 'services/auth/rbac/role_assignment_action.dart' as _i41;
import 'services/auth/rbac/role_assignment_request.dart' as _i42;
import 'services/auth/rbac/role_info.dart' as _i43;
import 'services/auth/rbac/role_type.dart' as _i44;
import 'services/auth/rbac/user_role.dart' as _i45;
import 'services/auth/rbac/user_roles_response.dart' as _i46;
import 'services/auth/session/session_info_response.dart' as _i47;
import 'services/auth/two_factor/two_factor_secret.dart' as _i48;
import 'services/auth/two_factor/two_factor_setup_response.dart' as _i49;
import 'services/auth/user/account_status_response.dart' as _i50;
import 'services/auth/user/current_user_response.dart' as _i51;
import 'services/auth/user/gender.dart' as _i52;
import 'services/auth/user/profile_update_request.dart' as _i53;
import 'services/auth/user/user_info_response.dart' as _i54;
import 'services/auth/user/user_list_response.dart' as _i55;
import 'services/auth/user/user_profile_extended.dart' as _i56;
import 'services/auth/verification/user_verification_preferences.dart' as _i57;
import 'services/auth/verification/verification_channel.dart' as _i58;
import 'services/auth/verification/verification_code.dart' as _i59;
import 'services/auth/verification/verification_response.dart' as _i60;
import 'services/greetings/models/greeting.dart' as _i61;
import 'services/greetings/models/greeting_response.dart' as _i62;
import 'services/health/models/health_check_response.dart' as _i63;
import 'services/health/models/service_health_info.dart' as _i64;
import 'services/status/models/server_status.dart' as _i65;
import 'services/translations/models/translation_entry.dart' as _i66;
import 'services/translations/models/translation_response.dart' as _i67;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/rbac/role.dart'
    as _i68;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/rbac/permission.dart'
    as _i69;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/session/session_info_response.dart'
    as _i70;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/gender.dart'
    as _i71;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/verification/verification_channel.dart'
    as _i72;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i73;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i74;
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
export 'core/middleware/models/middleware_error.dart';
export 'core/middleware/models/middleware_execution_info.dart';
export 'core/middleware/models/request_metrics.dart';
export 'core/middleware/models/validation_error_detail.dart';
export 'core/middleware/models/validation_exception.dart';
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
export 'services/auth/rbac/permission_type.dart';
export 'services/auth/rbac/role.dart';
export 'services/auth/rbac/role_assignment_action.dart';
export 'services/auth/rbac/role_assignment_request.dart';
export 'services/auth/rbac/role_info.dart';
export 'services/auth/rbac/role_type.dart';
export 'services/auth/rbac/user_role.dart';
export 'services/auth/rbac/user_roles_response.dart';
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
export 'services/auth/verification/user_verification_preferences.dart';
export 'services/auth/verification/verification_channel.dart';
export 'services/auth/verification/verification_code.dart';
export 'services/auth/verification/verification_response.dart';
export 'services/greetings/models/greeting.dart';
export 'services/greetings/models/greeting_response.dart';
export 'services/health/models/health_check_response.dart';
export 'services/health/models/service_health_info.dart';
export 'services/status/models/server_status.dart';
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
    if (t == _i17.MiddlewareError) {
      return _i17.MiddlewareError.fromJson(data) as T;
    }
    if (t == _i18.MiddlewareExecutionInfo) {
      return _i18.MiddlewareExecutionInfo.fromJson(data) as T;
    }
    if (t == _i19.RequestMetrics) {
      return _i19.RequestMetrics.fromJson(data) as T;
    }
    if (t == _i20.ValidationErrorDetail) {
      return _i20.ValidationErrorDetail.fromJson(data) as T;
    }
    if (t == _i21.ValidationException) {
      return _i21.ValidationException.fromJson(data) as T;
    }
    if (t == _i22.RateLimitEntry) {
      return _i22.RateLimitEntry.fromJson(data) as T;
    }
    if (t == _i23.CachedIdList) {
      return _i23.CachedIdList.fromJson(data) as T;
    }
    if (t == _i24.ChannelListResponse) {
      return _i24.ChannelListResponse.fromJson(data) as T;
    }
    if (t == _i25.ChannelResponse) {
      return _i25.ChannelResponse.fromJson(data) as T;
    }
    if (t == _i26.ChannelSubscription) {
      return _i26.ChannelSubscription.fromJson(data) as T;
    }
    if (t == _i27.ChannelType) {
      return _i27.ChannelType.fromJson(data) as T;
    }
    if (t == _i28.Notification) {
      return _i28.Notification.fromJson(data) as T;
    }
    if (t == _i29.NotificationChannel) {
      return _i29.NotificationChannel.fromJson(data) as T;
    }
    if (t == _i30.NotificationException) {
      return _i30.NotificationException.fromJson(data) as T;
    }
    if (t == _i31.NotificationListResponse) {
      return _i31.NotificationListResponse.fromJson(data) as T;
    }
    if (t == _i32.NotificationPriority) {
      return _i32.NotificationPriority.fromJson(data) as T;
    }
    if (t == _i33.NotificationResponse) {
      return _i33.NotificationResponse.fromJson(data) as T;
    }
    if (t == _i34.NotificationType) {
      return _i34.NotificationType.fromJson(data) as T;
    }
    if (t == _i35.SendNotificationRequest) {
      return _i35.SendNotificationRequest.fromJson(data) as T;
    }
    if (t == _i36.AuthAuditLog) {
      return _i36.AuthAuditLog.fromJson(data) as T;
    }
    if (t == _i37.PasswordStrengthResponse) {
      return _i37.PasswordStrengthResponse.fromJson(data) as T;
    }
    if (t == _i38.Permission) {
      return _i38.Permission.fromJson(data) as T;
    }
    if (t == _i39.PermissionAction) {
      return _i39.PermissionAction.fromJson(data) as T;
    }
    if (t == _i40.Role) {
      return _i40.Role.fromJson(data) as T;
    }
    if (t == _i41.RoleAssignmentAction) {
      return _i41.RoleAssignmentAction.fromJson(data) as T;
    }
    if (t == _i42.RoleAssignmentRequest) {
      return _i42.RoleAssignmentRequest.fromJson(data) as T;
    }
    if (t == _i43.RoleInfo) {
      return _i43.RoleInfo.fromJson(data) as T;
    }
    if (t == _i44.RoleType) {
      return _i44.RoleType.fromJson(data) as T;
    }
    if (t == _i45.UserRole) {
      return _i45.UserRole.fromJson(data) as T;
    }
    if (t == _i46.UserRolesResponse) {
      return _i46.UserRolesResponse.fromJson(data) as T;
    }
    if (t == _i47.SessionInfoResponse) {
      return _i47.SessionInfoResponse.fromJson(data) as T;
    }
    if (t == _i48.TwoFactorSecret) {
      return _i48.TwoFactorSecret.fromJson(data) as T;
    }
    if (t == _i49.TwoFactorSetupResponse) {
      return _i49.TwoFactorSetupResponse.fromJson(data) as T;
    }
    if (t == _i50.AccountStatusResponse) {
      return _i50.AccountStatusResponse.fromJson(data) as T;
    }
    if (t == _i51.CurrentUserResponse) {
      return _i51.CurrentUserResponse.fromJson(data) as T;
    }
    if (t == _i52.Gender) {
      return _i52.Gender.fromJson(data) as T;
    }
    if (t == _i53.ProfileUpdateRequest) {
      return _i53.ProfileUpdateRequest.fromJson(data) as T;
    }
    if (t == _i54.UserInfoResponse) {
      return _i54.UserInfoResponse.fromJson(data) as T;
    }
    if (t == _i55.UserListResponse) {
      return _i55.UserListResponse.fromJson(data) as T;
    }
    if (t == _i56.UserProfileExtended) {
      return _i56.UserProfileExtended.fromJson(data) as T;
    }
    if (t == _i57.UserVerificationPreferences) {
      return _i57.UserVerificationPreferences.fromJson(data) as T;
    }
    if (t == _i58.VerificationChannel) {
      return _i58.VerificationChannel.fromJson(data) as T;
    }
    if (t == _i59.VerificationCode) {
      return _i59.VerificationCode.fromJson(data) as T;
    }
    if (t == _i60.VerificationResponse) {
      return _i60.VerificationResponse.fromJson(data) as T;
    }
    if (t == _i61.Greeting) {
      return _i61.Greeting.fromJson(data) as T;
    }
    if (t == _i62.GreetingResponse) {
      return _i62.GreetingResponse.fromJson(data) as T;
    }
    if (t == _i63.HealthCheckResponse) {
      return _i63.HealthCheckResponse.fromJson(data) as T;
    }
    if (t == _i64.ServiceHealthInfo) {
      return _i64.ServiceHealthInfo.fromJson(data) as T;
    }
    if (t == _i65.ServerStatus) {
      return _i65.ServerStatus.fromJson(data) as T;
    }
    if (t == _i66.TranslationEntry) {
      return _i66.TranslationEntry.fromJson(data) as T;
    }
    if (t == _i67.TranslationResponse) {
      return _i67.TranslationResponse.fromJson(data) as T;
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
    if (t == _i1.getType<_i17.MiddlewareError?>()) {
      return (data != null ? _i17.MiddlewareError.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.MiddlewareExecutionInfo?>()) {
      return (data != null ? _i18.MiddlewareExecutionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.RequestMetrics?>()) {
      return (data != null ? _i19.RequestMetrics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ValidationErrorDetail?>()) {
      return (data != null ? _i20.ValidationErrorDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.ValidationException?>()) {
      return (data != null ? _i21.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.RateLimitEntry?>()) {
      return (data != null ? _i22.RateLimitEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CachedIdList?>()) {
      return (data != null ? _i23.CachedIdList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.ChannelListResponse?>()) {
      return (data != null ? _i24.ChannelListResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.ChannelResponse?>()) {
      return (data != null ? _i25.ChannelResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ChannelSubscription?>()) {
      return (data != null ? _i26.ChannelSubscription.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.ChannelType?>()) {
      return (data != null ? _i27.ChannelType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.Notification?>()) {
      return (data != null ? _i28.Notification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.NotificationChannel?>()) {
      return (data != null ? _i29.NotificationChannel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.NotificationException?>()) {
      return (data != null ? _i30.NotificationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.NotificationListResponse?>()) {
      return (data != null
              ? _i31.NotificationListResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i32.NotificationPriority?>()) {
      return (data != null ? _i32.NotificationPriority.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.NotificationResponse?>()) {
      return (data != null ? _i33.NotificationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.NotificationType?>()) {
      return (data != null ? _i34.NotificationType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.SendNotificationRequest?>()) {
      return (data != null ? _i35.SendNotificationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.AuthAuditLog?>()) {
      return (data != null ? _i36.AuthAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.PasswordStrengthResponse?>()) {
      return (data != null
              ? _i37.PasswordStrengthResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i38.Permission?>()) {
      return (data != null ? _i38.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.PermissionAction?>()) {
      return (data != null ? _i39.PermissionAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.Role?>()) {
      return (data != null ? _i40.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.RoleAssignmentAction?>()) {
      return (data != null ? _i41.RoleAssignmentAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.RoleAssignmentRequest?>()) {
      return (data != null ? _i42.RoleAssignmentRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.RoleInfo?>()) {
      return (data != null ? _i43.RoleInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.RoleType?>()) {
      return (data != null ? _i44.RoleType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.UserRole?>()) {
      return (data != null ? _i45.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.UserRolesResponse?>()) {
      return (data != null ? _i46.UserRolesResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.SessionInfoResponse?>()) {
      return (data != null ? _i47.SessionInfoResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.TwoFactorSecret?>()) {
      return (data != null ? _i48.TwoFactorSecret.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.TwoFactorSetupResponse?>()) {
      return (data != null ? _i49.TwoFactorSetupResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.AccountStatusResponse?>()) {
      return (data != null ? _i50.AccountStatusResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.CurrentUserResponse?>()) {
      return (data != null ? _i51.CurrentUserResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.Gender?>()) {
      return (data != null ? _i52.Gender.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.ProfileUpdateRequest?>()) {
      return (data != null ? _i53.ProfileUpdateRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.UserInfoResponse?>()) {
      return (data != null ? _i54.UserInfoResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.UserListResponse?>()) {
      return (data != null ? _i55.UserListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.UserProfileExtended?>()) {
      return (data != null ? _i56.UserProfileExtended.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.UserVerificationPreferences?>()) {
      return (data != null
              ? _i57.UserVerificationPreferences.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i58.VerificationChannel?>()) {
      return (data != null ? _i58.VerificationChannel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.VerificationCode?>()) {
      return (data != null ? _i59.VerificationCode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.VerificationResponse?>()) {
      return (data != null ? _i60.VerificationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.Greeting?>()) {
      return (data != null ? _i61.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.GreetingResponse?>()) {
      return (data != null ? _i62.GreetingResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.HealthCheckResponse?>()) {
      return (data != null ? _i63.HealthCheckResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.ServiceHealthInfo?>()) {
      return (data != null ? _i64.ServiceHealthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.ServerStatus?>()) {
      return (data != null ? _i65.ServerStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.TranslationEntry?>()) {
      return (data != null ? _i66.TranslationEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.TranslationResponse?>()) {
      return (data != null ? _i67.TranslationResponse.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i18.MiddlewareExecutionInfo>) {
      return (data as List)
              .map((e) => deserialize<_i18.MiddlewareExecutionInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.NotificationChannel>) {
      return (data as List)
              .map((e) => deserialize<_i29.NotificationChannel>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i28.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_i54.UserInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i54.UserInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.ServiceHealthInfo>) {
      return (data as List)
              .map((e) => deserialize<_i64.ServiceHealthInfo>(e))
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
    if (t == List<_i68.Role>) {
      return (data as List).map((e) => deserialize<_i68.Role>(e)).toList() as T;
    }
    if (t == List<_i69.Permission>) {
      return (data as List).map((e) => deserialize<_i69.Permission>(e)).toList()
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == List<_i70.SessionInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i70.SessionInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i71.Gender>) {
      return (data as List).map((e) => deserialize<_i71.Gender>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i72.VerificationChannel>) {
      return (data as List)
              .map((e) => deserialize<_i72.VerificationChannel>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    try {
      return _i73.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i74.Protocol().deserialize<T>(data, t);
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
      _i17.MiddlewareError => 'MiddlewareError',
      _i18.MiddlewareExecutionInfo => 'MiddlewareExecutionInfo',
      _i19.RequestMetrics => 'RequestMetrics',
      _i20.ValidationErrorDetail => 'ValidationErrorDetail',
      _i21.ValidationException => 'ValidationException',
      _i22.RateLimitEntry => 'RateLimitEntry',
      _i23.CachedIdList => 'CachedIdList',
      _i24.ChannelListResponse => 'ChannelListResponse',
      _i25.ChannelResponse => 'ChannelResponse',
      _i26.ChannelSubscription => 'ChannelSubscription',
      _i27.ChannelType => 'ChannelType',
      _i28.Notification => 'Notification',
      _i29.NotificationChannel => 'NotificationChannel',
      _i30.NotificationException => 'NotificationException',
      _i31.NotificationListResponse => 'NotificationListResponse',
      _i32.NotificationPriority => 'NotificationPriority',
      _i33.NotificationResponse => 'NotificationResponse',
      _i34.NotificationType => 'NotificationType',
      _i35.SendNotificationRequest => 'SendNotificationRequest',
      _i36.AuthAuditLog => 'AuthAuditLog',
      _i37.PasswordStrengthResponse => 'PasswordStrengthResponse',
      _i38.Permission => 'Permission',
      _i39.PermissionAction => 'PermissionAction',
      _i40.Role => 'Role',
      _i41.RoleAssignmentAction => 'RoleAssignmentAction',
      _i42.RoleAssignmentRequest => 'RoleAssignmentRequest',
      _i43.RoleInfo => 'RoleInfo',
      _i44.RoleType => 'RoleType',
      _i45.UserRole => 'UserRole',
      _i46.UserRolesResponse => 'UserRolesResponse',
      _i47.SessionInfoResponse => 'SessionInfoResponse',
      _i48.TwoFactorSecret => 'TwoFactorSecret',
      _i49.TwoFactorSetupResponse => 'TwoFactorSetupResponse',
      _i50.AccountStatusResponse => 'AccountStatusResponse',
      _i51.CurrentUserResponse => 'CurrentUserResponse',
      _i52.Gender => 'Gender',
      _i53.ProfileUpdateRequest => 'ProfileUpdateRequest',
      _i54.UserInfoResponse => 'UserInfoResponse',
      _i55.UserListResponse => 'UserListResponse',
      _i56.UserProfileExtended => 'UserProfileExtended',
      _i57.UserVerificationPreferences => 'UserVerificationPreferences',
      _i58.VerificationChannel => 'VerificationChannel',
      _i59.VerificationCode => 'VerificationCode',
      _i60.VerificationResponse => 'VerificationResponse',
      _i61.Greeting => 'Greeting',
      _i62.GreetingResponse => 'GreetingResponse',
      _i63.HealthCheckResponse => 'HealthCheckResponse',
      _i64.ServiceHealthInfo => 'ServiceHealthInfo',
      _i65.ServerStatus => 'ServerStatus',
      _i66.TranslationEntry => 'TranslationEntry',
      _i67.TranslationResponse => 'TranslationResponse',
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
      case _i17.MiddlewareError():
        return 'MiddlewareError';
      case _i18.MiddlewareExecutionInfo():
        return 'MiddlewareExecutionInfo';
      case _i19.RequestMetrics():
        return 'RequestMetrics';
      case _i20.ValidationErrorDetail():
        return 'ValidationErrorDetail';
      case _i21.ValidationException():
        return 'ValidationException';
      case _i22.RateLimitEntry():
        return 'RateLimitEntry';
      case _i23.CachedIdList():
        return 'CachedIdList';
      case _i24.ChannelListResponse():
        return 'ChannelListResponse';
      case _i25.ChannelResponse():
        return 'ChannelResponse';
      case _i26.ChannelSubscription():
        return 'ChannelSubscription';
      case _i27.ChannelType():
        return 'ChannelType';
      case _i28.Notification():
        return 'Notification';
      case _i29.NotificationChannel():
        return 'NotificationChannel';
      case _i30.NotificationException():
        return 'NotificationException';
      case _i31.NotificationListResponse():
        return 'NotificationListResponse';
      case _i32.NotificationPriority():
        return 'NotificationPriority';
      case _i33.NotificationResponse():
        return 'NotificationResponse';
      case _i34.NotificationType():
        return 'NotificationType';
      case _i35.SendNotificationRequest():
        return 'SendNotificationRequest';
      case _i36.AuthAuditLog():
        return 'AuthAuditLog';
      case _i37.PasswordStrengthResponse():
        return 'PasswordStrengthResponse';
      case _i38.Permission():
        return 'Permission';
      case _i39.PermissionAction():
        return 'PermissionAction';
      case _i40.Role():
        return 'Role';
      case _i41.RoleAssignmentAction():
        return 'RoleAssignmentAction';
      case _i42.RoleAssignmentRequest():
        return 'RoleAssignmentRequest';
      case _i43.RoleInfo():
        return 'RoleInfo';
      case _i44.RoleType():
        return 'RoleType';
      case _i45.UserRole():
        return 'UserRole';
      case _i46.UserRolesResponse():
        return 'UserRolesResponse';
      case _i47.SessionInfoResponse():
        return 'SessionInfoResponse';
      case _i48.TwoFactorSecret():
        return 'TwoFactorSecret';
      case _i49.TwoFactorSetupResponse():
        return 'TwoFactorSetupResponse';
      case _i50.AccountStatusResponse():
        return 'AccountStatusResponse';
      case _i51.CurrentUserResponse():
        return 'CurrentUserResponse';
      case _i52.Gender():
        return 'Gender';
      case _i53.ProfileUpdateRequest():
        return 'ProfileUpdateRequest';
      case _i54.UserInfoResponse():
        return 'UserInfoResponse';
      case _i55.UserListResponse():
        return 'UserListResponse';
      case _i56.UserProfileExtended():
        return 'UserProfileExtended';
      case _i57.UserVerificationPreferences():
        return 'UserVerificationPreferences';
      case _i58.VerificationChannel():
        return 'VerificationChannel';
      case _i59.VerificationCode():
        return 'VerificationCode';
      case _i60.VerificationResponse():
        return 'VerificationResponse';
      case _i61.Greeting():
        return 'Greeting';
      case _i62.GreetingResponse():
        return 'GreetingResponse';
      case _i63.HealthCheckResponse():
        return 'HealthCheckResponse';
      case _i64.ServiceHealthInfo():
        return 'ServiceHealthInfo';
      case _i65.ServerStatus():
        return 'ServerStatus';
      case _i66.TranslationEntry():
        return 'TranslationEntry';
      case _i67.TranslationResponse():
        return 'TranslationResponse';
    }
    className = _i73.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i74.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'MiddlewareError') {
      return deserialize<_i17.MiddlewareError>(data['data']);
    }
    if (dataClassName == 'MiddlewareExecutionInfo') {
      return deserialize<_i18.MiddlewareExecutionInfo>(data['data']);
    }
    if (dataClassName == 'RequestMetrics') {
      return deserialize<_i19.RequestMetrics>(data['data']);
    }
    if (dataClassName == 'ValidationErrorDetail') {
      return deserialize<_i20.ValidationErrorDetail>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i21.ValidationException>(data['data']);
    }
    if (dataClassName == 'RateLimitEntry') {
      return deserialize<_i22.RateLimitEntry>(data['data']);
    }
    if (dataClassName == 'CachedIdList') {
      return deserialize<_i23.CachedIdList>(data['data']);
    }
    if (dataClassName == 'ChannelListResponse') {
      return deserialize<_i24.ChannelListResponse>(data['data']);
    }
    if (dataClassName == 'ChannelResponse') {
      return deserialize<_i25.ChannelResponse>(data['data']);
    }
    if (dataClassName == 'ChannelSubscription') {
      return deserialize<_i26.ChannelSubscription>(data['data']);
    }
    if (dataClassName == 'ChannelType') {
      return deserialize<_i27.ChannelType>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_i28.Notification>(data['data']);
    }
    if (dataClassName == 'NotificationChannel') {
      return deserialize<_i29.NotificationChannel>(data['data']);
    }
    if (dataClassName == 'NotificationException') {
      return deserialize<_i30.NotificationException>(data['data']);
    }
    if (dataClassName == 'NotificationListResponse') {
      return deserialize<_i31.NotificationListResponse>(data['data']);
    }
    if (dataClassName == 'NotificationPriority') {
      return deserialize<_i32.NotificationPriority>(data['data']);
    }
    if (dataClassName == 'NotificationResponse') {
      return deserialize<_i33.NotificationResponse>(data['data']);
    }
    if (dataClassName == 'NotificationType') {
      return deserialize<_i34.NotificationType>(data['data']);
    }
    if (dataClassName == 'SendNotificationRequest') {
      return deserialize<_i35.SendNotificationRequest>(data['data']);
    }
    if (dataClassName == 'AuthAuditLog') {
      return deserialize<_i36.AuthAuditLog>(data['data']);
    }
    if (dataClassName == 'PasswordStrengthResponse') {
      return deserialize<_i37.PasswordStrengthResponse>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i38.Permission>(data['data']);
    }
    if (dataClassName == 'PermissionAction') {
      return deserialize<_i39.PermissionAction>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i40.Role>(data['data']);
    }
    if (dataClassName == 'RoleAssignmentAction') {
      return deserialize<_i41.RoleAssignmentAction>(data['data']);
    }
    if (dataClassName == 'RoleAssignmentRequest') {
      return deserialize<_i42.RoleAssignmentRequest>(data['data']);
    }
    if (dataClassName == 'RoleInfo') {
      return deserialize<_i43.RoleInfo>(data['data']);
    }
    if (dataClassName == 'RoleType') {
      return deserialize<_i44.RoleType>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i45.UserRole>(data['data']);
    }
    if (dataClassName == 'UserRolesResponse') {
      return deserialize<_i46.UserRolesResponse>(data['data']);
    }
    if (dataClassName == 'SessionInfoResponse') {
      return deserialize<_i47.SessionInfoResponse>(data['data']);
    }
    if (dataClassName == 'TwoFactorSecret') {
      return deserialize<_i48.TwoFactorSecret>(data['data']);
    }
    if (dataClassName == 'TwoFactorSetupResponse') {
      return deserialize<_i49.TwoFactorSetupResponse>(data['data']);
    }
    if (dataClassName == 'AccountStatusResponse') {
      return deserialize<_i50.AccountStatusResponse>(data['data']);
    }
    if (dataClassName == 'CurrentUserResponse') {
      return deserialize<_i51.CurrentUserResponse>(data['data']);
    }
    if (dataClassName == 'Gender') {
      return deserialize<_i52.Gender>(data['data']);
    }
    if (dataClassName == 'ProfileUpdateRequest') {
      return deserialize<_i53.ProfileUpdateRequest>(data['data']);
    }
    if (dataClassName == 'UserInfoResponse') {
      return deserialize<_i54.UserInfoResponse>(data['data']);
    }
    if (dataClassName == 'UserListResponse') {
      return deserialize<_i55.UserListResponse>(data['data']);
    }
    if (dataClassName == 'UserProfileExtended') {
      return deserialize<_i56.UserProfileExtended>(data['data']);
    }
    if (dataClassName == 'UserVerificationPreferences') {
      return deserialize<_i57.UserVerificationPreferences>(data['data']);
    }
    if (dataClassName == 'VerificationChannel') {
      return deserialize<_i58.VerificationChannel>(data['data']);
    }
    if (dataClassName == 'VerificationCode') {
      return deserialize<_i59.VerificationCode>(data['data']);
    }
    if (dataClassName == 'VerificationResponse') {
      return deserialize<_i60.VerificationResponse>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i61.Greeting>(data['data']);
    }
    if (dataClassName == 'GreetingResponse') {
      return deserialize<_i62.GreetingResponse>(data['data']);
    }
    if (dataClassName == 'HealthCheckResponse') {
      return deserialize<_i63.HealthCheckResponse>(data['data']);
    }
    if (dataClassName == 'ServiceHealthInfo') {
      return deserialize<_i64.ServiceHealthInfo>(data['data']);
    }
    if (dataClassName == 'ServerStatus') {
      return deserialize<_i65.ServerStatus>(data['data']);
    }
    if (dataClassName == 'TranslationEntry') {
      return deserialize<_i66.TranslationEntry>(data['data']);
    }
    if (dataClassName == 'TranslationResponse') {
      return deserialize<_i67.TranslationResponse>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i73.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i74.Protocol().deserializeByClassName(data);
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
      return _i73.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i74.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
