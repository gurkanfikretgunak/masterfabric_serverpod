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
import 'core/exceptions/rate_limit_exception.dart' as _i16;
import 'core/rate_limit/rate_limit_entry.dart' as _i17;
import 'greetings/greeting.dart' as _i18;
import 'greetings/greeting_response.dart' as _i19;
import 'services/auth/account_status_response.dart' as _i20;
import 'services/auth/auth_audit_log.dart' as _i21;
import 'services/auth/password_strength_response.dart' as _i22;
import 'services/auth/permission.dart' as _i23;
import 'services/auth/role.dart' as _i24;
import 'services/auth/session_info_response.dart' as _i25;
import 'services/auth/two_factor_secret.dart' as _i26;
import 'services/auth/two_factor_setup_response.dart' as _i27;
import 'services/auth/user_info_response.dart' as _i28;
import 'services/auth/user_list_response.dart' as _i29;
import 'services/auth/user_role.dart' as _i30;
import 'translations/translation_entry.dart' as _i31;
import 'translations/translation_response.dart' as _i32;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/role.dart'
    as _i33;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/permission.dart'
    as _i34;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/session_info_response.dart'
    as _i35;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i36;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i37;
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
export 'core/exceptions/rate_limit_exception.dart';
export 'core/rate_limit/rate_limit_entry.dart';
export 'greetings/greeting.dart';
export 'greetings/greeting_response.dart';
export 'services/auth/account_status_response.dart';
export 'services/auth/auth_audit_log.dart';
export 'services/auth/password_strength_response.dart';
export 'services/auth/permission.dart';
export 'services/auth/role.dart';
export 'services/auth/session_info_response.dart';
export 'services/auth/two_factor_secret.dart';
export 'services/auth/two_factor_setup_response.dart';
export 'services/auth/user_info_response.dart';
export 'services/auth/user_list_response.dart';
export 'services/auth/user_role.dart';
export 'translations/translation_entry.dart';
export 'translations/translation_response.dart';
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
    if (t == _i18.Greeting) {
      return _i18.Greeting.fromJson(data) as T;
    }
    if (t == _i19.GreetingResponse) {
      return _i19.GreetingResponse.fromJson(data) as T;
    }
    if (t == _i20.AccountStatusResponse) {
      return _i20.AccountStatusResponse.fromJson(data) as T;
    }
    if (t == _i21.AuthAuditLog) {
      return _i21.AuthAuditLog.fromJson(data) as T;
    }
    if (t == _i22.PasswordStrengthResponse) {
      return _i22.PasswordStrengthResponse.fromJson(data) as T;
    }
    if (t == _i23.Permission) {
      return _i23.Permission.fromJson(data) as T;
    }
    if (t == _i24.Role) {
      return _i24.Role.fromJson(data) as T;
    }
    if (t == _i25.SessionInfoResponse) {
      return _i25.SessionInfoResponse.fromJson(data) as T;
    }
    if (t == _i26.TwoFactorSecret) {
      return _i26.TwoFactorSecret.fromJson(data) as T;
    }
    if (t == _i27.TwoFactorSetupResponse) {
      return _i27.TwoFactorSetupResponse.fromJson(data) as T;
    }
    if (t == _i28.UserInfoResponse) {
      return _i28.UserInfoResponse.fromJson(data) as T;
    }
    if (t == _i29.UserListResponse) {
      return _i29.UserListResponse.fromJson(data) as T;
    }
    if (t == _i30.UserRole) {
      return _i30.UserRole.fromJson(data) as T;
    }
    if (t == _i31.TranslationEntry) {
      return _i31.TranslationEntry.fromJson(data) as T;
    }
    if (t == _i32.TranslationResponse) {
      return _i32.TranslationResponse.fromJson(data) as T;
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
    if (t == _i1.getType<_i18.Greeting?>()) {
      return (data != null ? _i18.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.GreetingResponse?>()) {
      return (data != null ? _i19.GreetingResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.AccountStatusResponse?>()) {
      return (data != null ? _i20.AccountStatusResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.AuthAuditLog?>()) {
      return (data != null ? _i21.AuthAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PasswordStrengthResponse?>()) {
      return (data != null
              ? _i22.PasswordStrengthResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i23.Permission?>()) {
      return (data != null ? _i23.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Role?>()) {
      return (data != null ? _i24.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.SessionInfoResponse?>()) {
      return (data != null ? _i25.SessionInfoResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.TwoFactorSecret?>()) {
      return (data != null ? _i26.TwoFactorSecret.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.TwoFactorSetupResponse?>()) {
      return (data != null ? _i27.TwoFactorSetupResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.UserInfoResponse?>()) {
      return (data != null ? _i28.UserInfoResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.UserListResponse?>()) {
      return (data != null ? _i29.UserListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.UserRole?>()) {
      return (data != null ? _i30.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.TranslationEntry?>()) {
      return (data != null ? _i31.TranslationEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.TranslationResponse?>()) {
      return (data != null ? _i32.TranslationResponse.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i28.UserInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i28.UserInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.Role>) {
      return (data as List).map((e) => deserialize<_i33.Role>(e)).toList() as T;
    }
    if (t == List<_i34.Permission>) {
      return (data as List).map((e) => deserialize<_i34.Permission>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == List<_i35.SessionInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i35.SessionInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    try {
      return _i36.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i37.Protocol().deserialize<T>(data, t);
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
      _i18.Greeting => 'Greeting',
      _i19.GreetingResponse => 'GreetingResponse',
      _i20.AccountStatusResponse => 'AccountStatusResponse',
      _i21.AuthAuditLog => 'AuthAuditLog',
      _i22.PasswordStrengthResponse => 'PasswordStrengthResponse',
      _i23.Permission => 'Permission',
      _i24.Role => 'Role',
      _i25.SessionInfoResponse => 'SessionInfoResponse',
      _i26.TwoFactorSecret => 'TwoFactorSecret',
      _i27.TwoFactorSetupResponse => 'TwoFactorSetupResponse',
      _i28.UserInfoResponse => 'UserInfoResponse',
      _i29.UserListResponse => 'UserListResponse',
      _i30.UserRole => 'UserRole',
      _i31.TranslationEntry => 'TranslationEntry',
      _i32.TranslationResponse => 'TranslationResponse',
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
      case _i18.Greeting():
        return 'Greeting';
      case _i19.GreetingResponse():
        return 'GreetingResponse';
      case _i20.AccountStatusResponse():
        return 'AccountStatusResponse';
      case _i21.AuthAuditLog():
        return 'AuthAuditLog';
      case _i22.PasswordStrengthResponse():
        return 'PasswordStrengthResponse';
      case _i23.Permission():
        return 'Permission';
      case _i24.Role():
        return 'Role';
      case _i25.SessionInfoResponse():
        return 'SessionInfoResponse';
      case _i26.TwoFactorSecret():
        return 'TwoFactorSecret';
      case _i27.TwoFactorSetupResponse():
        return 'TwoFactorSetupResponse';
      case _i28.UserInfoResponse():
        return 'UserInfoResponse';
      case _i29.UserListResponse():
        return 'UserListResponse';
      case _i30.UserRole():
        return 'UserRole';
      case _i31.TranslationEntry():
        return 'TranslationEntry';
      case _i32.TranslationResponse():
        return 'TranslationResponse';
    }
    className = _i36.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i37.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Greeting') {
      return deserialize<_i18.Greeting>(data['data']);
    }
    if (dataClassName == 'GreetingResponse') {
      return deserialize<_i19.GreetingResponse>(data['data']);
    }
    if (dataClassName == 'AccountStatusResponse') {
      return deserialize<_i20.AccountStatusResponse>(data['data']);
    }
    if (dataClassName == 'AuthAuditLog') {
      return deserialize<_i21.AuthAuditLog>(data['data']);
    }
    if (dataClassName == 'PasswordStrengthResponse') {
      return deserialize<_i22.PasswordStrengthResponse>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i23.Permission>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i24.Role>(data['data']);
    }
    if (dataClassName == 'SessionInfoResponse') {
      return deserialize<_i25.SessionInfoResponse>(data['data']);
    }
    if (dataClassName == 'TwoFactorSecret') {
      return deserialize<_i26.TwoFactorSecret>(data['data']);
    }
    if (dataClassName == 'TwoFactorSetupResponse') {
      return deserialize<_i27.TwoFactorSetupResponse>(data['data']);
    }
    if (dataClassName == 'UserInfoResponse') {
      return deserialize<_i28.UserInfoResponse>(data['data']);
    }
    if (dataClassName == 'UserListResponse') {
      return deserialize<_i29.UserListResponse>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i30.UserRole>(data['data']);
    }
    if (dataClassName == 'TranslationEntry') {
      return deserialize<_i31.TranslationEntry>(data['data']);
    }
    if (dataClassName == 'TranslationResponse') {
      return deserialize<_i32.TranslationResponse>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i36.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i37.Protocol().deserializeByClassName(data);
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
      return _i36.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i37.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
