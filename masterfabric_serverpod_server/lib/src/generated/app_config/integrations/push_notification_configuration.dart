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

/// Push notification configuration
abstract class PushNotificationConfiguration
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PushNotificationConfiguration._({
    required this.enabled,
    required this.defaultProvider,
    required this.autoInitialize,
    this.providersJson,
  });

  factory PushNotificationConfiguration({
    required bool enabled,
    required String defaultProvider,
    required bool autoInitialize,
    String? providersJson,
  }) = _PushNotificationConfigurationImpl;

  factory PushNotificationConfiguration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PushNotificationConfiguration(
      enabled: jsonSerialization['enabled'] as bool,
      defaultProvider: jsonSerialization['defaultProvider'] as String,
      autoInitialize: jsonSerialization['autoInitialize'] as bool,
      providersJson: jsonSerialization['providersJson'] as String?,
    );
  }

  /// Push notifications enabled
  bool enabled;

  /// Default provider (onesignal/firebase/etc)
  String defaultProvider;

  /// Auto initialize push notifications
  bool autoInitialize;

  /// Provider configurations as JSON string (will be parsed on client)
  String? providersJson;

  /// Returns a shallow copy of this [PushNotificationConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PushNotificationConfiguration copyWith({
    bool? enabled,
    String? defaultProvider,
    bool? autoInitialize,
    String? providersJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushNotificationConfiguration',
      'enabled': enabled,
      'defaultProvider': defaultProvider,
      'autoInitialize': autoInitialize,
      if (providersJson != null) 'providersJson': providersJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushNotificationConfiguration',
      'enabled': enabled,
      'defaultProvider': defaultProvider,
      'autoInitialize': autoInitialize,
      if (providersJson != null) 'providersJson': providersJson,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushNotificationConfigurationImpl extends PushNotificationConfiguration {
  _PushNotificationConfigurationImpl({
    required bool enabled,
    required String defaultProvider,
    required bool autoInitialize,
    String? providersJson,
  }) : super._(
         enabled: enabled,
         defaultProvider: defaultProvider,
         autoInitialize: autoInitialize,
         providersJson: providersJson,
       );

  /// Returns a shallow copy of this [PushNotificationConfiguration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PushNotificationConfiguration copyWith({
    bool? enabled,
    String? defaultProvider,
    bool? autoInitialize,
    Object? providersJson = _Undefined,
  }) {
    return PushNotificationConfiguration(
      enabled: enabled ?? this.enabled,
      defaultProvider: defaultProvider ?? this.defaultProvider,
      autoInitialize: autoInitialize ?? this.autoInitialize,
      providersJson: providersJson is String?
          ? providersJson
          : this.providersJson,
    );
  }
}
