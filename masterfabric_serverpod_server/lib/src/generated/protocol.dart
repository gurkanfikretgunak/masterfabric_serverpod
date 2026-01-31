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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'app_config/app_config.dart' as _i5;
import 'app_config/app_config_table.dart' as _i6;
import 'app_config/core/app_settings.dart' as _i7;
import 'app_config/core/feature_flags.dart' as _i8;
import 'app_config/core/splash_configuration.dart' as _i9;
import 'app_config/core/ui_configuration.dart' as _i10;
import 'app_config/integrations/api_configuration.dart' as _i11;
import 'app_config/integrations/navigation_configuration.dart' as _i12;
import 'app_config/integrations/push_notification_configuration.dart' as _i13;
import 'app_config/system/force_update_configuration.dart' as _i14;
import 'app_config/system/localization_configuration.dart' as _i15;
import 'app_config/system/permissions_configuration.dart' as _i16;
import 'app_config/system/storage_configuration.dart' as _i17;
import 'app_config/system/store_url.dart' as _i18;
import 'core/exceptions/rate_limit_exception.dart' as _i19;
import 'core/rate_limit/rate_limit_entry.dart' as _i20;
import 'greetings/greeting.dart' as _i21;
import 'greetings/greeting_response.dart' as _i22;
import 'services/auth/account_status_response.dart' as _i23;
import 'services/auth/auth_audit_log.dart' as _i24;
import 'services/auth/password_strength_response.dart' as _i25;
import 'services/auth/permission.dart' as _i26;
import 'services/auth/role.dart' as _i27;
import 'services/auth/session_info_response.dart' as _i28;
import 'services/auth/two_factor_secret.dart' as _i29;
import 'services/auth/two_factor_setup_response.dart' as _i30;
import 'services/auth/user_info_response.dart' as _i31;
import 'services/auth/user_list_response.dart' as _i32;
import 'services/auth/user_role.dart' as _i33;
import 'translations/translation_entry.dart' as _i34;
import 'translations/translation_response.dart' as _i35;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/role.dart'
    as _i36;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/permission.dart'
    as _i37;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/session_info_response.dart'
    as _i38;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'app_config_entry',
      dartName: 'AppConfigEntry',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'app_config_entry_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'environment',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'platform',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'configJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'app_config_entry_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auth_audit_log',
      dartName: 'AuthAuditLog',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auth_audit_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'eventType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'eventData',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userAgent',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auth_audit_log_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'permission',
      dartName: 'Permission',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'permission_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'resource',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'action',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'permission_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'role',
      dartName: 'Role',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'role_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'permissions',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'role_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'translation_entry',
      dartName: 'TranslationEntry',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'translation_entry_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'locale',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'namespace',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'translationsJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'translation_entry_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'two_factor_secret',
      dartName: 'TwoFactorSecret',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'two_factor_secret_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'secret',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'backupCodes',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'enabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'two_factor_secret_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_role',
      dartName: 'UserRole',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_role_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'roleId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'assignedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'assignedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_role_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.AppConfig) {
      return _i5.AppConfig.fromJson(data) as T;
    }
    if (t == _i6.AppConfigEntry) {
      return _i6.AppConfigEntry.fromJson(data) as T;
    }
    if (t == _i7.AppSettings) {
      return _i7.AppSettings.fromJson(data) as T;
    }
    if (t == _i8.FeatureFlags) {
      return _i8.FeatureFlags.fromJson(data) as T;
    }
    if (t == _i9.SplashConfiguration) {
      return _i9.SplashConfiguration.fromJson(data) as T;
    }
    if (t == _i10.UiConfiguration) {
      return _i10.UiConfiguration.fromJson(data) as T;
    }
    if (t == _i11.ApiConfiguration) {
      return _i11.ApiConfiguration.fromJson(data) as T;
    }
    if (t == _i12.NavigationConfiguration) {
      return _i12.NavigationConfiguration.fromJson(data) as T;
    }
    if (t == _i13.PushNotificationConfiguration) {
      return _i13.PushNotificationConfiguration.fromJson(data) as T;
    }
    if (t == _i14.ForceUpdateConfiguration) {
      return _i14.ForceUpdateConfiguration.fromJson(data) as T;
    }
    if (t == _i15.LocalizationConfiguration) {
      return _i15.LocalizationConfiguration.fromJson(data) as T;
    }
    if (t == _i16.PermissionsConfiguration) {
      return _i16.PermissionsConfiguration.fromJson(data) as T;
    }
    if (t == _i17.StorageConfiguration) {
      return _i17.StorageConfiguration.fromJson(data) as T;
    }
    if (t == _i18.StoreUrl) {
      return _i18.StoreUrl.fromJson(data) as T;
    }
    if (t == _i19.RateLimitException) {
      return _i19.RateLimitException.fromJson(data) as T;
    }
    if (t == _i20.RateLimitEntry) {
      return _i20.RateLimitEntry.fromJson(data) as T;
    }
    if (t == _i21.Greeting) {
      return _i21.Greeting.fromJson(data) as T;
    }
    if (t == _i22.GreetingResponse) {
      return _i22.GreetingResponse.fromJson(data) as T;
    }
    if (t == _i23.AccountStatusResponse) {
      return _i23.AccountStatusResponse.fromJson(data) as T;
    }
    if (t == _i24.AuthAuditLog) {
      return _i24.AuthAuditLog.fromJson(data) as T;
    }
    if (t == _i25.PasswordStrengthResponse) {
      return _i25.PasswordStrengthResponse.fromJson(data) as T;
    }
    if (t == _i26.Permission) {
      return _i26.Permission.fromJson(data) as T;
    }
    if (t == _i27.Role) {
      return _i27.Role.fromJson(data) as T;
    }
    if (t == _i28.SessionInfoResponse) {
      return _i28.SessionInfoResponse.fromJson(data) as T;
    }
    if (t == _i29.TwoFactorSecret) {
      return _i29.TwoFactorSecret.fromJson(data) as T;
    }
    if (t == _i30.TwoFactorSetupResponse) {
      return _i30.TwoFactorSetupResponse.fromJson(data) as T;
    }
    if (t == _i31.UserInfoResponse) {
      return _i31.UserInfoResponse.fromJson(data) as T;
    }
    if (t == _i32.UserListResponse) {
      return _i32.UserListResponse.fromJson(data) as T;
    }
    if (t == _i33.UserRole) {
      return _i33.UserRole.fromJson(data) as T;
    }
    if (t == _i34.TranslationEntry) {
      return _i34.TranslationEntry.fromJson(data) as T;
    }
    if (t == _i35.TranslationResponse) {
      return _i35.TranslationResponse.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.AppConfig?>()) {
      return (data != null ? _i5.AppConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AppConfigEntry?>()) {
      return (data != null ? _i6.AppConfigEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AppSettings?>()) {
      return (data != null ? _i7.AppSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.FeatureFlags?>()) {
      return (data != null ? _i8.FeatureFlags.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.SplashConfiguration?>()) {
      return (data != null ? _i9.SplashConfiguration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.UiConfiguration?>()) {
      return (data != null ? _i10.UiConfiguration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ApiConfiguration?>()) {
      return (data != null ? _i11.ApiConfiguration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.NavigationConfiguration?>()) {
      return (data != null ? _i12.NavigationConfiguration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.PushNotificationConfiguration?>()) {
      return (data != null
              ? _i13.PushNotificationConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.ForceUpdateConfiguration?>()) {
      return (data != null
              ? _i14.ForceUpdateConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.LocalizationConfiguration?>()) {
      return (data != null
              ? _i15.LocalizationConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.PermissionsConfiguration?>()) {
      return (data != null
              ? _i16.PermissionsConfiguration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i17.StorageConfiguration?>()) {
      return (data != null ? _i17.StorageConfiguration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.StoreUrl?>()) {
      return (data != null ? _i18.StoreUrl.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.RateLimitException?>()) {
      return (data != null ? _i19.RateLimitException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.RateLimitEntry?>()) {
      return (data != null ? _i20.RateLimitEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Greeting?>()) {
      return (data != null ? _i21.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.GreetingResponse?>()) {
      return (data != null ? _i22.GreetingResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.AccountStatusResponse?>()) {
      return (data != null ? _i23.AccountStatusResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.AuthAuditLog?>()) {
      return (data != null ? _i24.AuthAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.PasswordStrengthResponse?>()) {
      return (data != null
              ? _i25.PasswordStrengthResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i26.Permission?>()) {
      return (data != null ? _i26.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.Role?>()) {
      return (data != null ? _i27.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.SessionInfoResponse?>()) {
      return (data != null ? _i28.SessionInfoResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.TwoFactorSecret?>()) {
      return (data != null ? _i29.TwoFactorSecret.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.TwoFactorSetupResponse?>()) {
      return (data != null ? _i30.TwoFactorSetupResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.UserInfoResponse?>()) {
      return (data != null ? _i31.UserInfoResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.UserListResponse?>()) {
      return (data != null ? _i32.UserListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.UserRole?>()) {
      return (data != null ? _i33.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.TranslationEntry?>()) {
      return (data != null ? _i34.TranslationEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.TranslationResponse?>()) {
      return (data != null ? _i35.TranslationResponse.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i31.UserInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i31.UserInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.Role>) {
      return (data as List).map((e) => deserialize<_i36.Role>(e)).toList() as T;
    }
    if (t == List<_i37.Permission>) {
      return (data as List).map((e) => deserialize<_i37.Permission>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == List<_i38.SessionInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i38.SessionInfoResponse>(e))
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
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.AppConfig => 'AppConfig',
      _i6.AppConfigEntry => 'AppConfigEntry',
      _i7.AppSettings => 'AppSettings',
      _i8.FeatureFlags => 'FeatureFlags',
      _i9.SplashConfiguration => 'SplashConfiguration',
      _i10.UiConfiguration => 'UiConfiguration',
      _i11.ApiConfiguration => 'ApiConfiguration',
      _i12.NavigationConfiguration => 'NavigationConfiguration',
      _i13.PushNotificationConfiguration => 'PushNotificationConfiguration',
      _i14.ForceUpdateConfiguration => 'ForceUpdateConfiguration',
      _i15.LocalizationConfiguration => 'LocalizationConfiguration',
      _i16.PermissionsConfiguration => 'PermissionsConfiguration',
      _i17.StorageConfiguration => 'StorageConfiguration',
      _i18.StoreUrl => 'StoreUrl',
      _i19.RateLimitException => 'RateLimitException',
      _i20.RateLimitEntry => 'RateLimitEntry',
      _i21.Greeting => 'Greeting',
      _i22.GreetingResponse => 'GreetingResponse',
      _i23.AccountStatusResponse => 'AccountStatusResponse',
      _i24.AuthAuditLog => 'AuthAuditLog',
      _i25.PasswordStrengthResponse => 'PasswordStrengthResponse',
      _i26.Permission => 'Permission',
      _i27.Role => 'Role',
      _i28.SessionInfoResponse => 'SessionInfoResponse',
      _i29.TwoFactorSecret => 'TwoFactorSecret',
      _i30.TwoFactorSetupResponse => 'TwoFactorSetupResponse',
      _i31.UserInfoResponse => 'UserInfoResponse',
      _i32.UserListResponse => 'UserListResponse',
      _i33.UserRole => 'UserRole',
      _i34.TranslationEntry => 'TranslationEntry',
      _i35.TranslationResponse => 'TranslationResponse',
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
      case _i5.AppConfig():
        return 'AppConfig';
      case _i6.AppConfigEntry():
        return 'AppConfigEntry';
      case _i7.AppSettings():
        return 'AppSettings';
      case _i8.FeatureFlags():
        return 'FeatureFlags';
      case _i9.SplashConfiguration():
        return 'SplashConfiguration';
      case _i10.UiConfiguration():
        return 'UiConfiguration';
      case _i11.ApiConfiguration():
        return 'ApiConfiguration';
      case _i12.NavigationConfiguration():
        return 'NavigationConfiguration';
      case _i13.PushNotificationConfiguration():
        return 'PushNotificationConfiguration';
      case _i14.ForceUpdateConfiguration():
        return 'ForceUpdateConfiguration';
      case _i15.LocalizationConfiguration():
        return 'LocalizationConfiguration';
      case _i16.PermissionsConfiguration():
        return 'PermissionsConfiguration';
      case _i17.StorageConfiguration():
        return 'StorageConfiguration';
      case _i18.StoreUrl():
        return 'StoreUrl';
      case _i19.RateLimitException():
        return 'RateLimitException';
      case _i20.RateLimitEntry():
        return 'RateLimitEntry';
      case _i21.Greeting():
        return 'Greeting';
      case _i22.GreetingResponse():
        return 'GreetingResponse';
      case _i23.AccountStatusResponse():
        return 'AccountStatusResponse';
      case _i24.AuthAuditLog():
        return 'AuthAuditLog';
      case _i25.PasswordStrengthResponse():
        return 'PasswordStrengthResponse';
      case _i26.Permission():
        return 'Permission';
      case _i27.Role():
        return 'Role';
      case _i28.SessionInfoResponse():
        return 'SessionInfoResponse';
      case _i29.TwoFactorSecret():
        return 'TwoFactorSecret';
      case _i30.TwoFactorSetupResponse():
        return 'TwoFactorSetupResponse';
      case _i31.UserInfoResponse():
        return 'UserInfoResponse';
      case _i32.UserListResponse():
        return 'UserListResponse';
      case _i33.UserRole():
        return 'UserRole';
      case _i34.TranslationEntry():
        return 'TranslationEntry';
      case _i35.TranslationResponse():
        return 'TranslationResponse';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.AppConfig>(data['data']);
    }
    if (dataClassName == 'AppConfigEntry') {
      return deserialize<_i6.AppConfigEntry>(data['data']);
    }
    if (dataClassName == 'AppSettings') {
      return deserialize<_i7.AppSettings>(data['data']);
    }
    if (dataClassName == 'FeatureFlags') {
      return deserialize<_i8.FeatureFlags>(data['data']);
    }
    if (dataClassName == 'SplashConfiguration') {
      return deserialize<_i9.SplashConfiguration>(data['data']);
    }
    if (dataClassName == 'UiConfiguration') {
      return deserialize<_i10.UiConfiguration>(data['data']);
    }
    if (dataClassName == 'ApiConfiguration') {
      return deserialize<_i11.ApiConfiguration>(data['data']);
    }
    if (dataClassName == 'NavigationConfiguration') {
      return deserialize<_i12.NavigationConfiguration>(data['data']);
    }
    if (dataClassName == 'PushNotificationConfiguration') {
      return deserialize<_i13.PushNotificationConfiguration>(data['data']);
    }
    if (dataClassName == 'ForceUpdateConfiguration') {
      return deserialize<_i14.ForceUpdateConfiguration>(data['data']);
    }
    if (dataClassName == 'LocalizationConfiguration') {
      return deserialize<_i15.LocalizationConfiguration>(data['data']);
    }
    if (dataClassName == 'PermissionsConfiguration') {
      return deserialize<_i16.PermissionsConfiguration>(data['data']);
    }
    if (dataClassName == 'StorageConfiguration') {
      return deserialize<_i17.StorageConfiguration>(data['data']);
    }
    if (dataClassName == 'StoreUrl') {
      return deserialize<_i18.StoreUrl>(data['data']);
    }
    if (dataClassName == 'RateLimitException') {
      return deserialize<_i19.RateLimitException>(data['data']);
    }
    if (dataClassName == 'RateLimitEntry') {
      return deserialize<_i20.RateLimitEntry>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i21.Greeting>(data['data']);
    }
    if (dataClassName == 'GreetingResponse') {
      return deserialize<_i22.GreetingResponse>(data['data']);
    }
    if (dataClassName == 'AccountStatusResponse') {
      return deserialize<_i23.AccountStatusResponse>(data['data']);
    }
    if (dataClassName == 'AuthAuditLog') {
      return deserialize<_i24.AuthAuditLog>(data['data']);
    }
    if (dataClassName == 'PasswordStrengthResponse') {
      return deserialize<_i25.PasswordStrengthResponse>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i26.Permission>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i27.Role>(data['data']);
    }
    if (dataClassName == 'SessionInfoResponse') {
      return deserialize<_i28.SessionInfoResponse>(data['data']);
    }
    if (dataClassName == 'TwoFactorSecret') {
      return deserialize<_i29.TwoFactorSecret>(data['data']);
    }
    if (dataClassName == 'TwoFactorSetupResponse') {
      return deserialize<_i30.TwoFactorSetupResponse>(data['data']);
    }
    if (dataClassName == 'UserInfoResponse') {
      return deserialize<_i31.UserInfoResponse>(data['data']);
    }
    if (dataClassName == 'UserListResponse') {
      return deserialize<_i32.UserListResponse>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i33.UserRole>(data['data']);
    }
    if (dataClassName == 'TranslationEntry') {
      return deserialize<_i34.TranslationEntry>(data['data']);
    }
    if (dataClassName == 'TranslationResponse') {
      return deserialize<_i35.TranslationResponse>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i6.AppConfigEntry:
        return _i6.AppConfigEntry.t;
      case _i24.AuthAuditLog:
        return _i24.AuthAuditLog.t;
      case _i26.Permission:
        return _i26.Permission.t;
      case _i27.Role:
        return _i27.Role.t;
      case _i29.TwoFactorSecret:
        return _i29.TwoFactorSecret.t;
      case _i33.UserRole:
        return _i33.UserRole.t;
      case _i34.TranslationEntry:
        return _i34.TranslationEntry.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'masterfabric_serverpod';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
