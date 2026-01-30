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
import 'greetings/greeting.dart' as _i16;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i17;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i18;
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
export 'greetings/greeting.dart';
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
    if (t == _i16.Greeting) {
      return _i16.Greeting.fromJson(data) as T;
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
    if (t == _i1.getType<_i16.Greeting?>()) {
      return (data != null ? _i16.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i17.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i18.Protocol().deserialize<T>(data, t);
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
      _i16.Greeting => 'Greeting',
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
      case _i16.Greeting():
        return 'Greeting';
    }
    className = _i17.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i18.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Greeting') {
      return deserialize<_i16.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i17.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i18.Protocol().deserializeByClassName(data);
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
      return _i17.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i18.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
