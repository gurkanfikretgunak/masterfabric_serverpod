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
import 'core/exceptions/models/rate_limit_exception.dart' as _i19;
import 'core/middleware/models/middleware_error.dart' as _i20;
import 'core/middleware/models/middleware_execution_info.dart' as _i21;
import 'core/middleware/models/request_metrics.dart' as _i22;
import 'core/middleware/models/validation_error_detail.dart' as _i23;
import 'core/middleware/models/validation_exception.dart' as _i24;
import 'core/rate_limit/models/rate_limit_entry.dart' as _i25;
import 'core/real_time/notifications_center/models/cached_id_list.dart' as _i26;
import 'core/real_time/notifications_center/models/channel_list_response.dart'
    as _i27;
import 'core/real_time/notifications_center/models/channel_response.dart'
    as _i28;
import 'core/real_time/notifications_center/models/channel_subscription.dart'
    as _i29;
import 'core/real_time/notifications_center/models/channel_type.dart' as _i30;
import 'core/real_time/notifications_center/models/notification.dart' as _i31;
import 'core/real_time/notifications_center/models/notification_channel.dart'
    as _i32;
import 'core/real_time/notifications_center/models/notification_exception.dart'
    as _i33;
import 'core/real_time/notifications_center/models/notification_list_response.dart'
    as _i34;
import 'core/real_time/notifications_center/models/notification_priority.dart'
    as _i35;
import 'core/real_time/notifications_center/models/notification_response.dart'
    as _i36;
import 'core/real_time/notifications_center/models/notification_type.dart'
    as _i37;
import 'core/real_time/notifications_center/models/send_notification_request.dart'
    as _i38;
import 'services/auth/core/auth_audit_log.dart' as _i39;
import 'services/auth/password/password_strength_response.dart' as _i40;
import 'services/auth/rbac/permission.dart' as _i41;
import 'services/auth/rbac/permission_type.dart' as _i42;
import 'services/auth/rbac/role.dart' as _i43;
import 'services/auth/rbac/role_assignment_action.dart' as _i44;
import 'services/auth/rbac/role_assignment_request.dart' as _i45;
import 'services/auth/rbac/role_info.dart' as _i46;
import 'services/auth/rbac/role_type.dart' as _i47;
import 'services/auth/rbac/user_role.dart' as _i48;
import 'services/auth/rbac/user_roles_response.dart' as _i49;
import 'services/auth/session/session_info_response.dart' as _i50;
import 'services/auth/two_factor/two_factor_secret.dart' as _i51;
import 'services/auth/two_factor/two_factor_setup_response.dart' as _i52;
import 'services/auth/user/account_status_response.dart' as _i53;
import 'services/auth/user/current_user_response.dart' as _i54;
import 'services/auth/user/gender.dart' as _i55;
import 'services/auth/user/profile_update_request.dart' as _i56;
import 'services/auth/user/user_info_response.dart' as _i57;
import 'services/auth/user/user_list_response.dart' as _i58;
import 'services/auth/user/user_profile_extended.dart' as _i59;
import 'services/auth/verification/user_verification_preferences.dart' as _i60;
import 'services/auth/verification/verification_channel.dart' as _i61;
import 'services/auth/verification/verification_code.dart' as _i62;
import 'services/auth/verification/verification_response.dart' as _i63;
import 'services/currency/models/currency_conversion_response.dart' as _i64;
import 'services/currency/models/currency_format_response.dart' as _i65;
import 'services/currency/models/exchange_rate_cache.dart' as _i66;
import 'services/currency/models/exchange_rate_response.dart' as _i67;
import 'services/currency/models/supported_currencies_response.dart' as _i68;
import 'services/greetings/models/greeting.dart' as _i69;
import 'services/greetings/models/greeting_response.dart' as _i70;
import 'services/health/models/health_check_response.dart' as _i71;
import 'services/health/models/service_health_info.dart' as _i72;
import 'services/paired_device/models/device_list_response.dart' as _i73;
import 'services/paired_device/models/device_mode.dart' as _i74;
import 'services/paired_device/models/device_pairing_request.dart' as _i75;
import 'services/paired_device/models/device_pairing_response.dart' as _i76;
import 'services/paired_device/models/paired_device.dart' as _i77;
import 'services/status/models/server_status.dart' as _i78;
import 'services/translations/models/translation_entry.dart' as _i79;
import 'services/translations/models/translation_response.dart' as _i80;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/rbac/role.dart'
    as _i81;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/rbac/permission.dart'
    as _i82;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/session/session_info_response.dart'
    as _i83;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/user/gender.dart'
    as _i84;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/verification/verification_channel.dart'
    as _i85;
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
export 'services/currency/models/currency_conversion_response.dart';
export 'services/currency/models/currency_format_response.dart';
export 'services/currency/models/exchange_rate_cache.dart';
export 'services/currency/models/exchange_rate_response.dart';
export 'services/currency/models/supported_currencies_response.dart';
export 'services/greetings/models/greeting.dart';
export 'services/greetings/models/greeting_response.dart';
export 'services/health/models/health_check_response.dart';
export 'services/health/models/service_health_info.dart';
export 'services/paired_device/models/device_list_response.dart';
export 'services/paired_device/models/device_mode.dart';
export 'services/paired_device/models/device_pairing_request.dart';
export 'services/paired_device/models/device_pairing_response.dart';
export 'services/paired_device/models/paired_device.dart';
export 'services/status/models/server_status.dart';
export 'services/translations/models/translation_entry.dart';
export 'services/translations/models/translation_response.dart';

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
      name: 'paired_devices',
      dartName: 'PairedDevice',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'paired_devices_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deviceId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deviceName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'platform',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deviceFingerprint',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isTrusted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'deviceMode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DeviceMode',
        ),
        _i2.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'pairedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'metadata',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'paired_devices_pkey',
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
      name: 'user_profile_extended',
      dartName: 'UserProfileExtended',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_profile_extended_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'birthDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'gender',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:Gender?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_profile_extended_pkey',
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
        _i2.IndexDefinition(
          indexName: 'user_profile_extended_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
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
    _i2.TableDefinition(
      name: 'user_verification_preferences',
      dartName: 'UserVerificationPreferences',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'user_verification_preferences_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'preferredChannel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:VerificationChannel',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'telegramChatId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'whatsappVerified',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'telegramLinked',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'backupChannel',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:VerificationChannel?',
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
          indexName: 'user_verification_preferences_pkey',
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
        _i2.IndexDefinition(
          indexName: 'user_verification_prefs_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_verification_prefs_phone_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'phoneNumber',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_verification_prefs_telegram_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'telegramChatId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'verification_codes',
      dartName: 'VerificationCode',
      schema: 'public',
      module: 'masterfabric_serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'verification_codes_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'code',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'purpose',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'used',
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
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'verification_codes_pkey',
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
        _i2.IndexDefinition(
          indexName: 'verification_codes_user_purpose_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'purpose',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'verification_codes_expires_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'expiresAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
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
    if (t == _i20.MiddlewareError) {
      return _i20.MiddlewareError.fromJson(data) as T;
    }
    if (t == _i21.MiddlewareExecutionInfo) {
      return _i21.MiddlewareExecutionInfo.fromJson(data) as T;
    }
    if (t == _i22.RequestMetrics) {
      return _i22.RequestMetrics.fromJson(data) as T;
    }
    if (t == _i23.ValidationErrorDetail) {
      return _i23.ValidationErrorDetail.fromJson(data) as T;
    }
    if (t == _i24.ValidationException) {
      return _i24.ValidationException.fromJson(data) as T;
    }
    if (t == _i25.RateLimitEntry) {
      return _i25.RateLimitEntry.fromJson(data) as T;
    }
    if (t == _i26.CachedIdList) {
      return _i26.CachedIdList.fromJson(data) as T;
    }
    if (t == _i27.ChannelListResponse) {
      return _i27.ChannelListResponse.fromJson(data) as T;
    }
    if (t == _i28.ChannelResponse) {
      return _i28.ChannelResponse.fromJson(data) as T;
    }
    if (t == _i29.ChannelSubscription) {
      return _i29.ChannelSubscription.fromJson(data) as T;
    }
    if (t == _i30.ChannelType) {
      return _i30.ChannelType.fromJson(data) as T;
    }
    if (t == _i31.Notification) {
      return _i31.Notification.fromJson(data) as T;
    }
    if (t == _i32.NotificationChannel) {
      return _i32.NotificationChannel.fromJson(data) as T;
    }
    if (t == _i33.NotificationException) {
      return _i33.NotificationException.fromJson(data) as T;
    }
    if (t == _i34.NotificationListResponse) {
      return _i34.NotificationListResponse.fromJson(data) as T;
    }
    if (t == _i35.NotificationPriority) {
      return _i35.NotificationPriority.fromJson(data) as T;
    }
    if (t == _i36.NotificationResponse) {
      return _i36.NotificationResponse.fromJson(data) as T;
    }
    if (t == _i37.NotificationType) {
      return _i37.NotificationType.fromJson(data) as T;
    }
    if (t == _i38.SendNotificationRequest) {
      return _i38.SendNotificationRequest.fromJson(data) as T;
    }
    if (t == _i39.AuthAuditLog) {
      return _i39.AuthAuditLog.fromJson(data) as T;
    }
    if (t == _i40.PasswordStrengthResponse) {
      return _i40.PasswordStrengthResponse.fromJson(data) as T;
    }
    if (t == _i41.Permission) {
      return _i41.Permission.fromJson(data) as T;
    }
    if (t == _i42.PermissionAction) {
      return _i42.PermissionAction.fromJson(data) as T;
    }
    if (t == _i43.Role) {
      return _i43.Role.fromJson(data) as T;
    }
    if (t == _i44.RoleAssignmentAction) {
      return _i44.RoleAssignmentAction.fromJson(data) as T;
    }
    if (t == _i45.RoleAssignmentRequest) {
      return _i45.RoleAssignmentRequest.fromJson(data) as T;
    }
    if (t == _i46.RoleInfo) {
      return _i46.RoleInfo.fromJson(data) as T;
    }
    if (t == _i47.RoleType) {
      return _i47.RoleType.fromJson(data) as T;
    }
    if (t == _i48.UserRole) {
      return _i48.UserRole.fromJson(data) as T;
    }
    if (t == _i49.UserRolesResponse) {
      return _i49.UserRolesResponse.fromJson(data) as T;
    }
    if (t == _i50.SessionInfoResponse) {
      return _i50.SessionInfoResponse.fromJson(data) as T;
    }
    if (t == _i51.TwoFactorSecret) {
      return _i51.TwoFactorSecret.fromJson(data) as T;
    }
    if (t == _i52.TwoFactorSetupResponse) {
      return _i52.TwoFactorSetupResponse.fromJson(data) as T;
    }
    if (t == _i53.AccountStatusResponse) {
      return _i53.AccountStatusResponse.fromJson(data) as T;
    }
    if (t == _i54.CurrentUserResponse) {
      return _i54.CurrentUserResponse.fromJson(data) as T;
    }
    if (t == _i55.Gender) {
      return _i55.Gender.fromJson(data) as T;
    }
    if (t == _i56.ProfileUpdateRequest) {
      return _i56.ProfileUpdateRequest.fromJson(data) as T;
    }
    if (t == _i57.UserInfoResponse) {
      return _i57.UserInfoResponse.fromJson(data) as T;
    }
    if (t == _i58.UserListResponse) {
      return _i58.UserListResponse.fromJson(data) as T;
    }
    if (t == _i59.UserProfileExtended) {
      return _i59.UserProfileExtended.fromJson(data) as T;
    }
    if (t == _i60.UserVerificationPreferences) {
      return _i60.UserVerificationPreferences.fromJson(data) as T;
    }
    if (t == _i61.VerificationChannel) {
      return _i61.VerificationChannel.fromJson(data) as T;
    }
    if (t == _i62.VerificationCode) {
      return _i62.VerificationCode.fromJson(data) as T;
    }
    if (t == _i63.VerificationResponse) {
      return _i63.VerificationResponse.fromJson(data) as T;
    }
    if (t == _i64.CurrencyConversionResponse) {
      return _i64.CurrencyConversionResponse.fromJson(data) as T;
    }
    if (t == _i65.CurrencyFormatResponse) {
      return _i65.CurrencyFormatResponse.fromJson(data) as T;
    }
    if (t == _i66.ExchangeRateCache) {
      return _i66.ExchangeRateCache.fromJson(data) as T;
    }
    if (t == _i67.ExchangeRateResponse) {
      return _i67.ExchangeRateResponse.fromJson(data) as T;
    }
    if (t == _i68.SupportedCurrenciesResponse) {
      return _i68.SupportedCurrenciesResponse.fromJson(data) as T;
    }
    if (t == _i69.Greeting) {
      return _i69.Greeting.fromJson(data) as T;
    }
    if (t == _i70.GreetingResponse) {
      return _i70.GreetingResponse.fromJson(data) as T;
    }
    if (t == _i71.HealthCheckResponse) {
      return _i71.HealthCheckResponse.fromJson(data) as T;
    }
    if (t == _i72.ServiceHealthInfo) {
      return _i72.ServiceHealthInfo.fromJson(data) as T;
    }
    if (t == _i73.DeviceListResponse) {
      return _i73.DeviceListResponse.fromJson(data) as T;
    }
    if (t == _i74.DeviceMode) {
      return _i74.DeviceMode.fromJson(data) as T;
    }
    if (t == _i75.DevicePairingRequest) {
      return _i75.DevicePairingRequest.fromJson(data) as T;
    }
    if (t == _i76.DevicePairingResponse) {
      return _i76.DevicePairingResponse.fromJson(data) as T;
    }
    if (t == _i77.PairedDevice) {
      return _i77.PairedDevice.fromJson(data) as T;
    }
    if (t == _i78.ServerStatus) {
      return _i78.ServerStatus.fromJson(data) as T;
    }
    if (t == _i79.TranslationEntry) {
      return _i79.TranslationEntry.fromJson(data) as T;
    }
    if (t == _i80.TranslationResponse) {
      return _i80.TranslationResponse.fromJson(data) as T;
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
    if (t == _i1.getType<_i20.MiddlewareError?>()) {
      return (data != null ? _i20.MiddlewareError.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.MiddlewareExecutionInfo?>()) {
      return (data != null ? _i21.MiddlewareExecutionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.RequestMetrics?>()) {
      return (data != null ? _i22.RequestMetrics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.ValidationErrorDetail?>()) {
      return (data != null ? _i23.ValidationErrorDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.ValidationException?>()) {
      return (data != null ? _i24.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.RateLimitEntry?>()) {
      return (data != null ? _i25.RateLimitEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CachedIdList?>()) {
      return (data != null ? _i26.CachedIdList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ChannelListResponse?>()) {
      return (data != null ? _i27.ChannelListResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.ChannelResponse?>()) {
      return (data != null ? _i28.ChannelResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ChannelSubscription?>()) {
      return (data != null ? _i29.ChannelSubscription.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.ChannelType?>()) {
      return (data != null ? _i30.ChannelType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.Notification?>()) {
      return (data != null ? _i31.Notification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.NotificationChannel?>()) {
      return (data != null ? _i32.NotificationChannel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.NotificationException?>()) {
      return (data != null ? _i33.NotificationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.NotificationListResponse?>()) {
      return (data != null
              ? _i34.NotificationListResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i35.NotificationPriority?>()) {
      return (data != null ? _i35.NotificationPriority.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.NotificationResponse?>()) {
      return (data != null ? _i36.NotificationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.NotificationType?>()) {
      return (data != null ? _i37.NotificationType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.SendNotificationRequest?>()) {
      return (data != null ? _i38.SendNotificationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.AuthAuditLog?>()) {
      return (data != null ? _i39.AuthAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.PasswordStrengthResponse?>()) {
      return (data != null
              ? _i40.PasswordStrengthResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i41.Permission?>()) {
      return (data != null ? _i41.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.PermissionAction?>()) {
      return (data != null ? _i42.PermissionAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.Role?>()) {
      return (data != null ? _i43.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.RoleAssignmentAction?>()) {
      return (data != null ? _i44.RoleAssignmentAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.RoleAssignmentRequest?>()) {
      return (data != null ? _i45.RoleAssignmentRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.RoleInfo?>()) {
      return (data != null ? _i46.RoleInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.RoleType?>()) {
      return (data != null ? _i47.RoleType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.UserRole?>()) {
      return (data != null ? _i48.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.UserRolesResponse?>()) {
      return (data != null ? _i49.UserRolesResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.SessionInfoResponse?>()) {
      return (data != null ? _i50.SessionInfoResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.TwoFactorSecret?>()) {
      return (data != null ? _i51.TwoFactorSecret.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.TwoFactorSetupResponse?>()) {
      return (data != null ? _i52.TwoFactorSetupResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.AccountStatusResponse?>()) {
      return (data != null ? _i53.AccountStatusResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.CurrentUserResponse?>()) {
      return (data != null ? _i54.CurrentUserResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.Gender?>()) {
      return (data != null ? _i55.Gender.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.ProfileUpdateRequest?>()) {
      return (data != null ? _i56.ProfileUpdateRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.UserInfoResponse?>()) {
      return (data != null ? _i57.UserInfoResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.UserListResponse?>()) {
      return (data != null ? _i58.UserListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.UserProfileExtended?>()) {
      return (data != null ? _i59.UserProfileExtended.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.UserVerificationPreferences?>()) {
      return (data != null
              ? _i60.UserVerificationPreferences.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i61.VerificationChannel?>()) {
      return (data != null ? _i61.VerificationChannel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.VerificationCode?>()) {
      return (data != null ? _i62.VerificationCode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.VerificationResponse?>()) {
      return (data != null ? _i63.VerificationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.CurrencyConversionResponse?>()) {
      return (data != null
              ? _i64.CurrencyConversionResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i65.CurrencyFormatResponse?>()) {
      return (data != null ? _i65.CurrencyFormatResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.ExchangeRateCache?>()) {
      return (data != null ? _i66.ExchangeRateCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.ExchangeRateResponse?>()) {
      return (data != null ? _i67.ExchangeRateResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.SupportedCurrenciesResponse?>()) {
      return (data != null
              ? _i68.SupportedCurrenciesResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i69.Greeting?>()) {
      return (data != null ? _i69.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.GreetingResponse?>()) {
      return (data != null ? _i70.GreetingResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.HealthCheckResponse?>()) {
      return (data != null ? _i71.HealthCheckResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.ServiceHealthInfo?>()) {
      return (data != null ? _i72.ServiceHealthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.DeviceListResponse?>()) {
      return (data != null ? _i73.DeviceListResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i74.DeviceMode?>()) {
      return (data != null ? _i74.DeviceMode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.DevicePairingRequest?>()) {
      return (data != null ? _i75.DevicePairingRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i76.DevicePairingResponse?>()) {
      return (data != null ? _i76.DevicePairingResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.PairedDevice?>()) {
      return (data != null ? _i77.PairedDevice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.ServerStatus?>()) {
      return (data != null ? _i78.ServerStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.TranslationEntry?>()) {
      return (data != null ? _i79.TranslationEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.TranslationResponse?>()) {
      return (data != null ? _i80.TranslationResponse.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i21.MiddlewareExecutionInfo>) {
      return (data as List)
              .map((e) => deserialize<_i21.MiddlewareExecutionInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.NotificationChannel>) {
      return (data as List)
              .map((e) => deserialize<_i32.NotificationChannel>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i31.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.UserInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i57.UserInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == List<_i72.ServiceHealthInfo>) {
      return (data as List)
              .map((e) => deserialize<_i72.ServiceHealthInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i77.PairedDevice>) {
      return (data as List)
              .map((e) => deserialize<_i77.PairedDevice>(e))
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
    if (t == List<_i81.Role>) {
      return (data as List).map((e) => deserialize<_i81.Role>(e)).toList() as T;
    }
    if (t == List<_i82.Permission>) {
      return (data as List).map((e) => deserialize<_i82.Permission>(e)).toList()
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == List<_i83.SessionInfoResponse>) {
      return (data as List)
              .map((e) => deserialize<_i83.SessionInfoResponse>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.Gender>) {
      return (data as List).map((e) => deserialize<_i84.Gender>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i85.VerificationChannel>) {
      return (data as List)
              .map((e) => deserialize<_i85.VerificationChannel>(e))
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
      _i20.MiddlewareError => 'MiddlewareError',
      _i21.MiddlewareExecutionInfo => 'MiddlewareExecutionInfo',
      _i22.RequestMetrics => 'RequestMetrics',
      _i23.ValidationErrorDetail => 'ValidationErrorDetail',
      _i24.ValidationException => 'ValidationException',
      _i25.RateLimitEntry => 'RateLimitEntry',
      _i26.CachedIdList => 'CachedIdList',
      _i27.ChannelListResponse => 'ChannelListResponse',
      _i28.ChannelResponse => 'ChannelResponse',
      _i29.ChannelSubscription => 'ChannelSubscription',
      _i30.ChannelType => 'ChannelType',
      _i31.Notification => 'Notification',
      _i32.NotificationChannel => 'NotificationChannel',
      _i33.NotificationException => 'NotificationException',
      _i34.NotificationListResponse => 'NotificationListResponse',
      _i35.NotificationPriority => 'NotificationPriority',
      _i36.NotificationResponse => 'NotificationResponse',
      _i37.NotificationType => 'NotificationType',
      _i38.SendNotificationRequest => 'SendNotificationRequest',
      _i39.AuthAuditLog => 'AuthAuditLog',
      _i40.PasswordStrengthResponse => 'PasswordStrengthResponse',
      _i41.Permission => 'Permission',
      _i42.PermissionAction => 'PermissionAction',
      _i43.Role => 'Role',
      _i44.RoleAssignmentAction => 'RoleAssignmentAction',
      _i45.RoleAssignmentRequest => 'RoleAssignmentRequest',
      _i46.RoleInfo => 'RoleInfo',
      _i47.RoleType => 'RoleType',
      _i48.UserRole => 'UserRole',
      _i49.UserRolesResponse => 'UserRolesResponse',
      _i50.SessionInfoResponse => 'SessionInfoResponse',
      _i51.TwoFactorSecret => 'TwoFactorSecret',
      _i52.TwoFactorSetupResponse => 'TwoFactorSetupResponse',
      _i53.AccountStatusResponse => 'AccountStatusResponse',
      _i54.CurrentUserResponse => 'CurrentUserResponse',
      _i55.Gender => 'Gender',
      _i56.ProfileUpdateRequest => 'ProfileUpdateRequest',
      _i57.UserInfoResponse => 'UserInfoResponse',
      _i58.UserListResponse => 'UserListResponse',
      _i59.UserProfileExtended => 'UserProfileExtended',
      _i60.UserVerificationPreferences => 'UserVerificationPreferences',
      _i61.VerificationChannel => 'VerificationChannel',
      _i62.VerificationCode => 'VerificationCode',
      _i63.VerificationResponse => 'VerificationResponse',
      _i64.CurrencyConversionResponse => 'CurrencyConversionResponse',
      _i65.CurrencyFormatResponse => 'CurrencyFormatResponse',
      _i66.ExchangeRateCache => 'ExchangeRateCache',
      _i67.ExchangeRateResponse => 'ExchangeRateResponse',
      _i68.SupportedCurrenciesResponse => 'SupportedCurrenciesResponse',
      _i69.Greeting => 'Greeting',
      _i70.GreetingResponse => 'GreetingResponse',
      _i71.HealthCheckResponse => 'HealthCheckResponse',
      _i72.ServiceHealthInfo => 'ServiceHealthInfo',
      _i73.DeviceListResponse => 'DeviceListResponse',
      _i74.DeviceMode => 'DeviceMode',
      _i75.DevicePairingRequest => 'DevicePairingRequest',
      _i76.DevicePairingResponse => 'DevicePairingResponse',
      _i77.PairedDevice => 'PairedDevice',
      _i78.ServerStatus => 'ServerStatus',
      _i79.TranslationEntry => 'TranslationEntry',
      _i80.TranslationResponse => 'TranslationResponse',
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
      case _i20.MiddlewareError():
        return 'MiddlewareError';
      case _i21.MiddlewareExecutionInfo():
        return 'MiddlewareExecutionInfo';
      case _i22.RequestMetrics():
        return 'RequestMetrics';
      case _i23.ValidationErrorDetail():
        return 'ValidationErrorDetail';
      case _i24.ValidationException():
        return 'ValidationException';
      case _i25.RateLimitEntry():
        return 'RateLimitEntry';
      case _i26.CachedIdList():
        return 'CachedIdList';
      case _i27.ChannelListResponse():
        return 'ChannelListResponse';
      case _i28.ChannelResponse():
        return 'ChannelResponse';
      case _i29.ChannelSubscription():
        return 'ChannelSubscription';
      case _i30.ChannelType():
        return 'ChannelType';
      case _i31.Notification():
        return 'Notification';
      case _i32.NotificationChannel():
        return 'NotificationChannel';
      case _i33.NotificationException():
        return 'NotificationException';
      case _i34.NotificationListResponse():
        return 'NotificationListResponse';
      case _i35.NotificationPriority():
        return 'NotificationPriority';
      case _i36.NotificationResponse():
        return 'NotificationResponse';
      case _i37.NotificationType():
        return 'NotificationType';
      case _i38.SendNotificationRequest():
        return 'SendNotificationRequest';
      case _i39.AuthAuditLog():
        return 'AuthAuditLog';
      case _i40.PasswordStrengthResponse():
        return 'PasswordStrengthResponse';
      case _i41.Permission():
        return 'Permission';
      case _i42.PermissionAction():
        return 'PermissionAction';
      case _i43.Role():
        return 'Role';
      case _i44.RoleAssignmentAction():
        return 'RoleAssignmentAction';
      case _i45.RoleAssignmentRequest():
        return 'RoleAssignmentRequest';
      case _i46.RoleInfo():
        return 'RoleInfo';
      case _i47.RoleType():
        return 'RoleType';
      case _i48.UserRole():
        return 'UserRole';
      case _i49.UserRolesResponse():
        return 'UserRolesResponse';
      case _i50.SessionInfoResponse():
        return 'SessionInfoResponse';
      case _i51.TwoFactorSecret():
        return 'TwoFactorSecret';
      case _i52.TwoFactorSetupResponse():
        return 'TwoFactorSetupResponse';
      case _i53.AccountStatusResponse():
        return 'AccountStatusResponse';
      case _i54.CurrentUserResponse():
        return 'CurrentUserResponse';
      case _i55.Gender():
        return 'Gender';
      case _i56.ProfileUpdateRequest():
        return 'ProfileUpdateRequest';
      case _i57.UserInfoResponse():
        return 'UserInfoResponse';
      case _i58.UserListResponse():
        return 'UserListResponse';
      case _i59.UserProfileExtended():
        return 'UserProfileExtended';
      case _i60.UserVerificationPreferences():
        return 'UserVerificationPreferences';
      case _i61.VerificationChannel():
        return 'VerificationChannel';
      case _i62.VerificationCode():
        return 'VerificationCode';
      case _i63.VerificationResponse():
        return 'VerificationResponse';
      case _i64.CurrencyConversionResponse():
        return 'CurrencyConversionResponse';
      case _i65.CurrencyFormatResponse():
        return 'CurrencyFormatResponse';
      case _i66.ExchangeRateCache():
        return 'ExchangeRateCache';
      case _i67.ExchangeRateResponse():
        return 'ExchangeRateResponse';
      case _i68.SupportedCurrenciesResponse():
        return 'SupportedCurrenciesResponse';
      case _i69.Greeting():
        return 'Greeting';
      case _i70.GreetingResponse():
        return 'GreetingResponse';
      case _i71.HealthCheckResponse():
        return 'HealthCheckResponse';
      case _i72.ServiceHealthInfo():
        return 'ServiceHealthInfo';
      case _i73.DeviceListResponse():
        return 'DeviceListResponse';
      case _i74.DeviceMode():
        return 'DeviceMode';
      case _i75.DevicePairingRequest():
        return 'DevicePairingRequest';
      case _i76.DevicePairingResponse():
        return 'DevicePairingResponse';
      case _i77.PairedDevice():
        return 'PairedDevice';
      case _i78.ServerStatus():
        return 'ServerStatus';
      case _i79.TranslationEntry():
        return 'TranslationEntry';
      case _i80.TranslationResponse():
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
    if (dataClassName == 'MiddlewareError') {
      return deserialize<_i20.MiddlewareError>(data['data']);
    }
    if (dataClassName == 'MiddlewareExecutionInfo') {
      return deserialize<_i21.MiddlewareExecutionInfo>(data['data']);
    }
    if (dataClassName == 'RequestMetrics') {
      return deserialize<_i22.RequestMetrics>(data['data']);
    }
    if (dataClassName == 'ValidationErrorDetail') {
      return deserialize<_i23.ValidationErrorDetail>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i24.ValidationException>(data['data']);
    }
    if (dataClassName == 'RateLimitEntry') {
      return deserialize<_i25.RateLimitEntry>(data['data']);
    }
    if (dataClassName == 'CachedIdList') {
      return deserialize<_i26.CachedIdList>(data['data']);
    }
    if (dataClassName == 'ChannelListResponse') {
      return deserialize<_i27.ChannelListResponse>(data['data']);
    }
    if (dataClassName == 'ChannelResponse') {
      return deserialize<_i28.ChannelResponse>(data['data']);
    }
    if (dataClassName == 'ChannelSubscription') {
      return deserialize<_i29.ChannelSubscription>(data['data']);
    }
    if (dataClassName == 'ChannelType') {
      return deserialize<_i30.ChannelType>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_i31.Notification>(data['data']);
    }
    if (dataClassName == 'NotificationChannel') {
      return deserialize<_i32.NotificationChannel>(data['data']);
    }
    if (dataClassName == 'NotificationException') {
      return deserialize<_i33.NotificationException>(data['data']);
    }
    if (dataClassName == 'NotificationListResponse') {
      return deserialize<_i34.NotificationListResponse>(data['data']);
    }
    if (dataClassName == 'NotificationPriority') {
      return deserialize<_i35.NotificationPriority>(data['data']);
    }
    if (dataClassName == 'NotificationResponse') {
      return deserialize<_i36.NotificationResponse>(data['data']);
    }
    if (dataClassName == 'NotificationType') {
      return deserialize<_i37.NotificationType>(data['data']);
    }
    if (dataClassName == 'SendNotificationRequest') {
      return deserialize<_i38.SendNotificationRequest>(data['data']);
    }
    if (dataClassName == 'AuthAuditLog') {
      return deserialize<_i39.AuthAuditLog>(data['data']);
    }
    if (dataClassName == 'PasswordStrengthResponse') {
      return deserialize<_i40.PasswordStrengthResponse>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i41.Permission>(data['data']);
    }
    if (dataClassName == 'PermissionAction') {
      return deserialize<_i42.PermissionAction>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i43.Role>(data['data']);
    }
    if (dataClassName == 'RoleAssignmentAction') {
      return deserialize<_i44.RoleAssignmentAction>(data['data']);
    }
    if (dataClassName == 'RoleAssignmentRequest') {
      return deserialize<_i45.RoleAssignmentRequest>(data['data']);
    }
    if (dataClassName == 'RoleInfo') {
      return deserialize<_i46.RoleInfo>(data['data']);
    }
    if (dataClassName == 'RoleType') {
      return deserialize<_i47.RoleType>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i48.UserRole>(data['data']);
    }
    if (dataClassName == 'UserRolesResponse') {
      return deserialize<_i49.UserRolesResponse>(data['data']);
    }
    if (dataClassName == 'SessionInfoResponse') {
      return deserialize<_i50.SessionInfoResponse>(data['data']);
    }
    if (dataClassName == 'TwoFactorSecret') {
      return deserialize<_i51.TwoFactorSecret>(data['data']);
    }
    if (dataClassName == 'TwoFactorSetupResponse') {
      return deserialize<_i52.TwoFactorSetupResponse>(data['data']);
    }
    if (dataClassName == 'AccountStatusResponse') {
      return deserialize<_i53.AccountStatusResponse>(data['data']);
    }
    if (dataClassName == 'CurrentUserResponse') {
      return deserialize<_i54.CurrentUserResponse>(data['data']);
    }
    if (dataClassName == 'Gender') {
      return deserialize<_i55.Gender>(data['data']);
    }
    if (dataClassName == 'ProfileUpdateRequest') {
      return deserialize<_i56.ProfileUpdateRequest>(data['data']);
    }
    if (dataClassName == 'UserInfoResponse') {
      return deserialize<_i57.UserInfoResponse>(data['data']);
    }
    if (dataClassName == 'UserListResponse') {
      return deserialize<_i58.UserListResponse>(data['data']);
    }
    if (dataClassName == 'UserProfileExtended') {
      return deserialize<_i59.UserProfileExtended>(data['data']);
    }
    if (dataClassName == 'UserVerificationPreferences') {
      return deserialize<_i60.UserVerificationPreferences>(data['data']);
    }
    if (dataClassName == 'VerificationChannel') {
      return deserialize<_i61.VerificationChannel>(data['data']);
    }
    if (dataClassName == 'VerificationCode') {
      return deserialize<_i62.VerificationCode>(data['data']);
    }
    if (dataClassName == 'VerificationResponse') {
      return deserialize<_i63.VerificationResponse>(data['data']);
    }
    if (dataClassName == 'CurrencyConversionResponse') {
      return deserialize<_i64.CurrencyConversionResponse>(data['data']);
    }
    if (dataClassName == 'CurrencyFormatResponse') {
      return deserialize<_i65.CurrencyFormatResponse>(data['data']);
    }
    if (dataClassName == 'ExchangeRateCache') {
      return deserialize<_i66.ExchangeRateCache>(data['data']);
    }
    if (dataClassName == 'ExchangeRateResponse') {
      return deserialize<_i67.ExchangeRateResponse>(data['data']);
    }
    if (dataClassName == 'SupportedCurrenciesResponse') {
      return deserialize<_i68.SupportedCurrenciesResponse>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i69.Greeting>(data['data']);
    }
    if (dataClassName == 'GreetingResponse') {
      return deserialize<_i70.GreetingResponse>(data['data']);
    }
    if (dataClassName == 'HealthCheckResponse') {
      return deserialize<_i71.HealthCheckResponse>(data['data']);
    }
    if (dataClassName == 'ServiceHealthInfo') {
      return deserialize<_i72.ServiceHealthInfo>(data['data']);
    }
    if (dataClassName == 'DeviceListResponse') {
      return deserialize<_i73.DeviceListResponse>(data['data']);
    }
    if (dataClassName == 'DeviceMode') {
      return deserialize<_i74.DeviceMode>(data['data']);
    }
    if (dataClassName == 'DevicePairingRequest') {
      return deserialize<_i75.DevicePairingRequest>(data['data']);
    }
    if (dataClassName == 'DevicePairingResponse') {
      return deserialize<_i76.DevicePairingResponse>(data['data']);
    }
    if (dataClassName == 'PairedDevice') {
      return deserialize<_i77.PairedDevice>(data['data']);
    }
    if (dataClassName == 'ServerStatus') {
      return deserialize<_i78.ServerStatus>(data['data']);
    }
    if (dataClassName == 'TranslationEntry') {
      return deserialize<_i79.TranslationEntry>(data['data']);
    }
    if (dataClassName == 'TranslationResponse') {
      return deserialize<_i80.TranslationResponse>(data['data']);
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
      case _i39.AuthAuditLog:
        return _i39.AuthAuditLog.t;
      case _i41.Permission:
        return _i41.Permission.t;
      case _i43.Role:
        return _i43.Role.t;
      case _i48.UserRole:
        return _i48.UserRole.t;
      case _i51.TwoFactorSecret:
        return _i51.TwoFactorSecret.t;
      case _i59.UserProfileExtended:
        return _i59.UserProfileExtended.t;
      case _i60.UserVerificationPreferences:
        return _i60.UserVerificationPreferences.t;
      case _i62.VerificationCode:
        return _i62.VerificationCode.t;
      case _i77.PairedDevice:
        return _i77.PairedDevice.t;
      case _i79.TranslationEntry:
        return _i79.TranslationEntry.t;
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
