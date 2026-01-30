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
import '../app_config/core/app_settings.dart' as _i2;
import '../app_config/core/ui_configuration.dart' as _i3;
import '../app_config/core/splash_configuration.dart' as _i4;
import '../app_config/core/feature_flags.dart' as _i5;
import '../app_config/integrations/navigation_configuration.dart' as _i6;
import '../app_config/integrations/api_configuration.dart' as _i7;
import '../app_config/system/permissions_configuration.dart' as _i8;
import '../app_config/system/localization_configuration.dart' as _i9;
import '../app_config/system/storage_configuration.dart' as _i10;
import '../app_config/integrations/push_notification_configuration.dart'
    as _i11;
import '../app_config/system/force_update_configuration.dart' as _i12;
import 'package:masterfabric_serverpod_client/src/protocol/protocol.dart'
    as _i13;

/// Main app configuration model
abstract class AppConfig implements _i1.SerializableModel {
  AppConfig._({
    required this.appSettings,
    required this.uiConfiguration,
    required this.splashConfiguration,
    required this.featureFlags,
    required this.navigationConfiguration,
    required this.apiConfiguration,
    required this.permissionsConfiguration,
    required this.localizationConfiguration,
    required this.storageConfiguration,
    required this.pushNotificationConfiguration,
    required this.forceUpdateConfiguration,
  });

  factory AppConfig({
    required _i2.AppSettings appSettings,
    required _i3.UiConfiguration uiConfiguration,
    required _i4.SplashConfiguration splashConfiguration,
    required _i5.FeatureFlags featureFlags,
    required _i6.NavigationConfiguration navigationConfiguration,
    required _i7.ApiConfiguration apiConfiguration,
    required _i8.PermissionsConfiguration permissionsConfiguration,
    required _i9.LocalizationConfiguration localizationConfiguration,
    required _i10.StorageConfiguration storageConfiguration,
    required _i11.PushNotificationConfiguration pushNotificationConfiguration,
    required _i12.ForceUpdateConfiguration forceUpdateConfiguration,
  }) = _AppConfigImpl;

  factory AppConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppConfig(
      appSettings: _i13.Protocol().deserialize<_i2.AppSettings>(
        jsonSerialization['appSettings'],
      ),
      uiConfiguration: _i13.Protocol().deserialize<_i3.UiConfiguration>(
        jsonSerialization['uiConfiguration'],
      ),
      splashConfiguration: _i13.Protocol().deserialize<_i4.SplashConfiguration>(
        jsonSerialization['splashConfiguration'],
      ),
      featureFlags: _i13.Protocol().deserialize<_i5.FeatureFlags>(
        jsonSerialization['featureFlags'],
      ),
      navigationConfiguration: _i13.Protocol()
          .deserialize<_i6.NavigationConfiguration>(
            jsonSerialization['navigationConfiguration'],
          ),
      apiConfiguration: _i13.Protocol().deserialize<_i7.ApiConfiguration>(
        jsonSerialization['apiConfiguration'],
      ),
      permissionsConfiguration: _i13.Protocol()
          .deserialize<_i8.PermissionsConfiguration>(
            jsonSerialization['permissionsConfiguration'],
          ),
      localizationConfiguration: _i13.Protocol()
          .deserialize<_i9.LocalizationConfiguration>(
            jsonSerialization['localizationConfiguration'],
          ),
      storageConfiguration: _i13.Protocol()
          .deserialize<_i10.StorageConfiguration>(
            jsonSerialization['storageConfiguration'],
          ),
      pushNotificationConfiguration: _i13.Protocol()
          .deserialize<_i11.PushNotificationConfiguration>(
            jsonSerialization['pushNotificationConfiguration'],
          ),
      forceUpdateConfiguration: _i13.Protocol()
          .deserialize<_i12.ForceUpdateConfiguration>(
            jsonSerialization['forceUpdateConfiguration'],
          ),
    );
  }

  /// App settings
  _i2.AppSettings appSettings;

  /// UI configuration
  _i3.UiConfiguration uiConfiguration;

  /// Splash screen configuration
  _i4.SplashConfiguration splashConfiguration;

  /// Feature flags
  _i5.FeatureFlags featureFlags;

  /// Navigation configuration
  _i6.NavigationConfiguration navigationConfiguration;

  /// API configuration
  _i7.ApiConfiguration apiConfiguration;

  /// Permissions configuration
  _i8.PermissionsConfiguration permissionsConfiguration;

  /// Localization configuration
  _i9.LocalizationConfiguration localizationConfiguration;

  /// Storage configuration
  _i10.StorageConfiguration storageConfiguration;

  /// Push notification configuration
  _i11.PushNotificationConfiguration pushNotificationConfiguration;

  /// Force update configuration
  _i12.ForceUpdateConfiguration forceUpdateConfiguration;

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppConfig copyWith({
    _i2.AppSettings? appSettings,
    _i3.UiConfiguration? uiConfiguration,
    _i4.SplashConfiguration? splashConfiguration,
    _i5.FeatureFlags? featureFlags,
    _i6.NavigationConfiguration? navigationConfiguration,
    _i7.ApiConfiguration? apiConfiguration,
    _i8.PermissionsConfiguration? permissionsConfiguration,
    _i9.LocalizationConfiguration? localizationConfiguration,
    _i10.StorageConfiguration? storageConfiguration,
    _i11.PushNotificationConfiguration? pushNotificationConfiguration,
    _i12.ForceUpdateConfiguration? forceUpdateConfiguration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppConfig',
      'appSettings': appSettings.toJson(),
      'uiConfiguration': uiConfiguration.toJson(),
      'splashConfiguration': splashConfiguration.toJson(),
      'featureFlags': featureFlags.toJson(),
      'navigationConfiguration': navigationConfiguration.toJson(),
      'apiConfiguration': apiConfiguration.toJson(),
      'permissionsConfiguration': permissionsConfiguration.toJson(),
      'localizationConfiguration': localizationConfiguration.toJson(),
      'storageConfiguration': storageConfiguration.toJson(),
      'pushNotificationConfiguration': pushNotificationConfiguration.toJson(),
      'forceUpdateConfiguration': forceUpdateConfiguration.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AppConfigImpl extends AppConfig {
  _AppConfigImpl({
    required _i2.AppSettings appSettings,
    required _i3.UiConfiguration uiConfiguration,
    required _i4.SplashConfiguration splashConfiguration,
    required _i5.FeatureFlags featureFlags,
    required _i6.NavigationConfiguration navigationConfiguration,
    required _i7.ApiConfiguration apiConfiguration,
    required _i8.PermissionsConfiguration permissionsConfiguration,
    required _i9.LocalizationConfiguration localizationConfiguration,
    required _i10.StorageConfiguration storageConfiguration,
    required _i11.PushNotificationConfiguration pushNotificationConfiguration,
    required _i12.ForceUpdateConfiguration forceUpdateConfiguration,
  }) : super._(
         appSettings: appSettings,
         uiConfiguration: uiConfiguration,
         splashConfiguration: splashConfiguration,
         featureFlags: featureFlags,
         navigationConfiguration: navigationConfiguration,
         apiConfiguration: apiConfiguration,
         permissionsConfiguration: permissionsConfiguration,
         localizationConfiguration: localizationConfiguration,
         storageConfiguration: storageConfiguration,
         pushNotificationConfiguration: pushNotificationConfiguration,
         forceUpdateConfiguration: forceUpdateConfiguration,
       );

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppConfig copyWith({
    _i2.AppSettings? appSettings,
    _i3.UiConfiguration? uiConfiguration,
    _i4.SplashConfiguration? splashConfiguration,
    _i5.FeatureFlags? featureFlags,
    _i6.NavigationConfiguration? navigationConfiguration,
    _i7.ApiConfiguration? apiConfiguration,
    _i8.PermissionsConfiguration? permissionsConfiguration,
    _i9.LocalizationConfiguration? localizationConfiguration,
    _i10.StorageConfiguration? storageConfiguration,
    _i11.PushNotificationConfiguration? pushNotificationConfiguration,
    _i12.ForceUpdateConfiguration? forceUpdateConfiguration,
  }) {
    return AppConfig(
      appSettings: appSettings ?? this.appSettings.copyWith(),
      uiConfiguration: uiConfiguration ?? this.uiConfiguration.copyWith(),
      splashConfiguration:
          splashConfiguration ?? this.splashConfiguration.copyWith(),
      featureFlags: featureFlags ?? this.featureFlags.copyWith(),
      navigationConfiguration:
          navigationConfiguration ?? this.navigationConfiguration.copyWith(),
      apiConfiguration: apiConfiguration ?? this.apiConfiguration.copyWith(),
      permissionsConfiguration:
          permissionsConfiguration ?? this.permissionsConfiguration.copyWith(),
      localizationConfiguration:
          localizationConfiguration ??
          this.localizationConfiguration.copyWith(),
      storageConfiguration:
          storageConfiguration ?? this.storageConfiguration.copyWith(),
      pushNotificationConfiguration:
          pushNotificationConfiguration ??
          this.pushNotificationConfiguration.copyWith(),
      forceUpdateConfiguration:
          forceUpdateConfiguration ?? this.forceUpdateConfiguration.copyWith(),
    );
  }
}
