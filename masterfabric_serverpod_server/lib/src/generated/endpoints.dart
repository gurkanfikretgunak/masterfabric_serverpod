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
import '../core/real_time/notifications_center/endpoints/notification_endpoint.dart'
    as _i2;
import '../core/real_time/notifications_center/endpoints/notification_stream_endpoint.dart'
    as _i3;
import '../services/app_config/endpoints/app_config_endpoint.dart' as _i4;
import '../services/auth/email/email_idp_endpoint.dart' as _i5;
import '../services/auth/jwt/jwt_refresh_endpoint.dart' as _i6;
import '../services/auth/oauth/apple_auth_endpoint.dart' as _i7;
import '../services/auth/oauth/google_auth_endpoint.dart' as _i8;
import '../services/auth/password/password_management_endpoint.dart' as _i9;
import '../services/auth/rbac/rbac_endpoint.dart' as _i10;
import '../services/auth/session/session_management_endpoint.dart' as _i11;
import '../services/auth/two_factor/two_factor_endpoint.dart' as _i12;
import '../services/auth/user/account_management_endpoint.dart' as _i13;
import '../services/auth/user/user_management_endpoint.dart' as _i14;
import '../services/auth/user/user_profile_endpoint.dart' as _i15;
import '../services/greetings/endpoints/greeting_endpoint.dart' as _i16;
import '../services/health/endpoints/health_endpoint.dart' as _i17;
import '../services/translations/endpoints/translation_endpoint.dart' as _i18;
import 'package:masterfabric_serverpod_server/src/generated/core/real_time/notifications_center/models/send_notification_request.dart'
    as _i19;
import 'package:masterfabric_serverpod_server/src/generated/core/real_time/notifications_center/models/channel_type.dart'
    as _i20;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/user/profile_update_request.dart'
    as _i21;
import 'package:masterfabric_serverpod_server/src/generated/services/auth/user/gender.dart'
    as _i22;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i23;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i24;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'notification': _i2.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'notificationStream': _i3.NotificationStreamEndpoint()
        ..initialize(
          server,
          'notificationStream',
          null,
        ),
      'appConfig': _i4.AppConfigEndpoint()
        ..initialize(
          server,
          'appConfig',
          null,
        ),
      'emailIdp': _i5.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i6.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'appleAuth': _i7.AppleAuthEndpoint()
        ..initialize(
          server,
          'appleAuth',
          null,
        ),
      'googleAuth': _i8.GoogleAuthEndpoint()
        ..initialize(
          server,
          'googleAuth',
          null,
        ),
      'passwordManagement': _i9.PasswordManagementEndpoint()
        ..initialize(
          server,
          'passwordManagement',
          null,
        ),
      'rbac': _i10.RbacEndpoint()
        ..initialize(
          server,
          'rbac',
          null,
        ),
      'sessionManagement': _i11.SessionManagementEndpoint()
        ..initialize(
          server,
          'sessionManagement',
          null,
        ),
      'twoFactor': _i12.TwoFactorEndpoint()
        ..initialize(
          server,
          'twoFactor',
          null,
        ),
      'accountManagement': _i13.AccountManagementEndpoint()
        ..initialize(
          server,
          'accountManagement',
          null,
        ),
      'userManagement': _i14.UserManagementEndpoint()
        ..initialize(
          server,
          'userManagement',
          null,
        ),
      'userProfile': _i15.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
      'greeting': _i16.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'health': _i17.HealthEndpoint()
        ..initialize(
          server,
          'health',
          null,
        ),
      'translation': _i18.TranslationEndpoint()
        ..initialize(
          server,
          'translation',
          null,
        ),
    };
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'send': _i1.MethodConnector(
          name: 'send',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i19.SendNotificationRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i2.NotificationEndpoint).send(
                    session,
                    params['request'],
                  ),
        ),
        'getHistory': _i1.MethodConnector(
          name: 'getHistory',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .getHistory(
                    session,
                    params['channelId'],
                    limit: params['limit'],
                  ),
        ),
        'getUserNotifications': _i1.MethodConnector(
          name: 'getUserNotifications',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .getUserNotifications(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'markAsRead': _i1.MethodConnector(
          name: 'markAsRead',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .markAsRead(
                    session,
                    params['channelId'],
                    params['notificationId'],
                  ),
        ),
        'markAllAsRead': _i1.MethodConnector(
          name: 'markAllAsRead',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .markAllAsRead(
                    session,
                    params['channelId'],
                  ),
        ),
        'deleteNotification': _i1.MethodConnector(
          name: 'deleteNotification',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .deleteNotification(
                    session,
                    params['channelId'],
                    params['notificationId'],
                  ),
        ),
        'getUnreadCount': _i1.MethodConnector(
          name: 'getUnreadCount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .getUnreadCount(session),
        ),
        'getPublicNotifications': _i1.MethodConnector(
          name: 'getPublicNotifications',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .getPublicNotifications(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'listPublicChannels': _i1.MethodConnector(
          name: 'listPublicChannels',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .listPublicChannels(session),
        ),
        'createChannel': _i1.MethodConnector(
          name: 'createChannel',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<_i20.ChannelType>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isPublic': _i1.ParameterDescription(
              name: 'isPublic',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'projectId': _i1.ParameterDescription(
              name: 'projectId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'maxSubscribers': _i1.ParameterDescription(
              name: 'maxSubscribers',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'cacheTtlSeconds': _i1.ParameterDescription(
              name: 'cacheTtlSeconds',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .createChannel(
                    session,
                    name: params['name'],
                    type: params['type'],
                    description: params['description'],
                    isPublic: params['isPublic'],
                    projectId: params['projectId'],
                    maxSubscribers: params['maxSubscribers'],
                    cacheTtlSeconds: params['cacheTtlSeconds'],
                  ),
        ),
        'getChannel': _i1.MethodConnector(
          name: 'getChannel',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .getChannel(
                    session,
                    params['channelId'],
                  ),
        ),
        'joinChannel': _i1.MethodConnector(
          name: 'joinChannel',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .joinChannel(
                    session,
                    params['channelId'],
                  ),
        ),
        'leaveChannel': _i1.MethodConnector(
          name: 'leaveChannel',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .leaveChannel(
                    session,
                    params['channelId'],
                  ),
        ),
        'updateChannel': _i1.MethodConnector(
          name: 'updateChannel',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'isPublic': _i1.ParameterDescription(
              name: 'isPublic',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .updateChannel(
                    session,
                    params['channelId'],
                    name: params['name'],
                    description: params['description'],
                    isActive: params['isActive'],
                    isPublic: params['isPublic'],
                  ),
        ),
        'getCacheStats': _i1.MethodConnector(
          name: 'getCacheStats',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i2.NotificationEndpoint)
                  .getCacheStats(
                    session,
                    params['channelId'],
                  ),
        ),
      },
    );
    connectors['notificationStream'] = _i1.EndpointConnector(
      name: 'notificationStream',
      endpoint: endpoints['notificationStream']!,
      methodConnectors: {
        'subscribe': _i1.MethodStreamConnector(
          name: 'subscribe',
          params: {
            'channelIds': _i1.ParameterDescription(
              name: 'channelIds',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['notificationStream']
                          as _i3.NotificationStreamEndpoint)
                      .subscribe(
                        session,
                        params['channelIds'],
                      ),
        ),
        'subscribeToUserNotifications': _i1.MethodStreamConnector(
          name: 'subscribeToUserNotifications',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['notificationStream']
                          as _i3.NotificationStreamEndpoint)
                      .subscribeToUserNotifications(session),
        ),
        'subscribeToProject': _i1.MethodStreamConnector(
          name: 'subscribeToProject',
          params: {
            'projectId': _i1.ParameterDescription(
              name: 'projectId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'projectChannelId': _i1.ParameterDescription(
              name: 'projectChannelId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['notificationStream']
                          as _i3.NotificationStreamEndpoint)
                      .subscribeToProject(
                        session,
                        params['projectId'],
                        params['projectChannelId'],
                      ),
        ),
        'subscribeToBroadcasts': _i1.MethodStreamConnector(
          name: 'subscribeToBroadcasts',
          params: {
            'channelIds': _i1.ParameterDescription(
              name: 'channelIds',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['notificationStream']
                          as _i3.NotificationStreamEndpoint)
                      .subscribeToBroadcasts(
                        session,
                        params['channelIds'],
                      ),
        ),
      },
    );
    connectors['appConfig'] = _i1.EndpointConnector(
      name: 'appConfig',
      endpoint: endpoints['appConfig']!,
      methodConnectors: {
        'getConfig': _i1.MethodConnector(
          name: 'getConfig',
          params: {
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appConfig'] as _i4.AppConfigEndpoint).getConfig(
                    session,
                    platform: params['platform'],
                  ),
        ),
      },
    );
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i6.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['appleAuth'] = _i1.EndpointConnector(
      name: 'appleAuth',
      endpoint: endpoints['appleAuth']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'identityToken': _i1.ParameterDescription(
              name: 'identityToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'authorizationCode': _i1.ParameterDescription(
              name: 'authorizationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isNativeApplePlatformSignIn': _i1.ParameterDescription(
              name: 'isNativeApplePlatformSignIn',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firstName': _i1.ParameterDescription(
              name: 'firstName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'lastName': _i1.ParameterDescription(
              name: 'lastName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appleAuth'] as _i7.AppleAuthEndpoint).login(
                    session,
                    identityToken: params['identityToken'],
                    authorizationCode: params['authorizationCode'],
                    isNativeApplePlatformSignIn:
                        params['isNativeApplePlatformSignIn'],
                    firstName: params['firstName'],
                    lastName: params['lastName'],
                  ),
        ),
      },
    );
    connectors['googleAuth'] = _i1.EndpointConnector(
      name: 'googleAuth',
      endpoint: endpoints['googleAuth']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessToken': _i1.ParameterDescription(
              name: 'accessToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAuth'] as _i8.GoogleAuthEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
                  ),
        ),
      },
    );
    connectors['passwordManagement'] = _i1.EndpointConnector(
      name: 'passwordManagement',
      endpoint: endpoints['passwordManagement']!,
      methodConnectors: {
        'changePassword': _i1.MethodConnector(
          name: 'changePassword',
          params: {
            'currentPassword': _i1.ParameterDescription(
              name: 'currentPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passwordManagement']
                          as _i9.PasswordManagementEndpoint)
                      .changePassword(
                        session,
                        currentPassword: params['currentPassword'],
                        newPassword: params['newPassword'],
                      ),
        ),
        'validatePasswordStrength': _i1.MethodConnector(
          name: 'validatePasswordStrength',
          params: {
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passwordManagement']
                          as _i9.PasswordManagementEndpoint)
                      .validatePasswordStrength(
                        session,
                        password: params['password'],
                      ),
        ),
      },
    );
    connectors['rbac'] = _i1.EndpointConnector(
      name: 'rbac',
      endpoint: endpoints['rbac']!,
      methodConnectors: {
        'getRoles': _i1.MethodConnector(
          name: 'getRoles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i10.RbacEndpoint).getRoles(session),
        ),
        'getPermissions': _i1.MethodConnector(
          name: 'getPermissions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i10.RbacEndpoint)
                  .getPermissions(session),
        ),
        'getUserRoles': _i1.MethodConnector(
          name: 'getUserRoles',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i10.RbacEndpoint).getUserRoles(
                session,
                userId: params['userId'],
              ),
        ),
        'getUserPermissions': _i1.MethodConnector(
          name: 'getUserPermissions',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i10.RbacEndpoint).getUserPermissions(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'assignRoleToUser': _i1.MethodConnector(
          name: 'assignRoleToUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'roleName': _i1.ParameterDescription(
              name: 'roleName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i10.RbacEndpoint).assignRoleToUser(
                    session,
                    params['userId'],
                    params['roleName'],
                  ),
        ),
        'revokeRoleFromUser': _i1.MethodConnector(
          name: 'revokeRoleFromUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'roleName': _i1.ParameterDescription(
              name: 'roleName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i10.RbacEndpoint).revokeRoleFromUser(
                    session,
                    params['userId'],
                    params['roleName'],
                  ),
        ),
      },
    );
    connectors['sessionManagement'] = _i1.EndpointConnector(
      name: 'sessionManagement',
      endpoint: endpoints['sessionManagement']!,
      methodConnectors: {
        'getCurrentSession': _i1.MethodConnector(
          name: 'getCurrentSession',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i11.SessionManagementEndpoint)
                      .getCurrentSession(session),
        ),
        'getActiveSessions': _i1.MethodConnector(
          name: 'getActiveSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i11.SessionManagementEndpoint)
                      .getActiveSessions(session),
        ),
        'getSession': _i1.MethodConnector(
          name: 'getSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i11.SessionManagementEndpoint)
                      .getSession(
                        session,
                        params['sessionId'],
                      ),
        ),
        'revokeSession': _i1.MethodConnector(
          name: 'revokeSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i11.SessionManagementEndpoint)
                      .revokeSession(
                        session,
                        params['sessionId'],
                      ),
        ),
        'revokeAllOtherSessions': _i1.MethodConnector(
          name: 'revokeAllOtherSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i11.SessionManagementEndpoint)
                      .revokeAllOtherSessions(session),
        ),
        'revokeAllSessions': _i1.MethodConnector(
          name: 'revokeAllSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i11.SessionManagementEndpoint)
                      .revokeAllSessions(session),
        ),
      },
    );
    connectors['twoFactor'] = _i1.EndpointConnector(
      name: 'twoFactor',
      endpoint: endpoints['twoFactor']!,
      methodConnectors: {
        'isTwoFactorEnabled': _i1.MethodConnector(
          name: 'isTwoFactorEnabled',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _i12.TwoFactorEndpoint)
                  .isTwoFactorEnabled(session),
        ),
        'startSetup': _i1.MethodConnector(
          name: 'startSetup',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['twoFactor'] as _i12.TwoFactorEndpoint).startSetup(
                    session,
                    params['email'],
                  ),
        ),
        'verifyAndEnable': _i1.MethodConnector(
          name: 'verifyAndEnable',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _i12.TwoFactorEndpoint)
                  .verifyAndEnable(
                    session,
                    params['code'],
                  ),
        ),
        'disable': _i1.MethodConnector(
          name: 'disable',
          params: {
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['twoFactor'] as _i12.TwoFactorEndpoint).disable(
                    session,
                    params['verificationCode'],
                  ),
        ),
        'getBackupCodes': _i1.MethodConnector(
          name: 'getBackupCodes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _i12.TwoFactorEndpoint)
                  .getBackupCodes(session),
        ),
        'regenerateBackupCodes': _i1.MethodConnector(
          name: 'regenerateBackupCodes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _i12.TwoFactorEndpoint)
                  .regenerateBackupCodes(session),
        ),
      },
    );
    connectors['accountManagement'] = _i1.EndpointConnector(
      name: 'accountManagement',
      endpoint: endpoints['accountManagement']!,
      methodConnectors: {
        'getAccountStatus': _i1.MethodConnector(
          name: 'getAccountStatus',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountManagement']
                          as _i13.AccountManagementEndpoint)
                      .getAccountStatus(
                        session,
                        userId: params['userId'],
                      ),
        ),
        'deactivateAccount': _i1.MethodConnector(
          name: 'deactivateAccount',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountManagement']
                          as _i13.AccountManagementEndpoint)
                      .deactivateAccount(
                        session,
                        userId: params['userId'],
                      ),
        ),
        'reactivateAccount': _i1.MethodConnector(
          name: 'reactivateAccount',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountManagement']
                          as _i13.AccountManagementEndpoint)
                      .reactivateAccount(
                        session,
                        params['userId'],
                      ),
        ),
        'deleteAccount': _i1.MethodConnector(
          name: 'deleteAccount',
          params: {
            'confirmation': _i1.ParameterDescription(
              name: 'confirmation',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountManagement']
                          as _i13.AccountManagementEndpoint)
                      .deleteAccount(
                        session,
                        confirmation: params['confirmation'],
                        userId: params['userId'],
                      ),
        ),
      },
    );
    connectors['userManagement'] = _i1.EndpointConnector(
      name: 'userManagement',
      endpoint: endpoints['userManagement']!,
      methodConnectors: {
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageSize': _i1.ParameterDescription(
              name: 'pageSize',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'blocked': _i1.ParameterDescription(
              name: 'blocked',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userManagement'] as _i14.UserManagementEndpoint)
                      .listUsers(
                        session,
                        page: params['page'],
                        pageSize: params['pageSize'],
                        search: params['search'],
                        blocked: params['blocked'],
                      ),
        ),
        'getUser': _i1.MethodConnector(
          name: 'getUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userManagement'] as _i14.UserManagementEndpoint)
                      .getUser(
                        session,
                        params['userId'],
                      ),
        ),
        'blockUser': _i1.MethodConnector(
          name: 'blockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'blocked': _i1.ParameterDescription(
              name: 'blocked',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userManagement'] as _i14.UserManagementEndpoint)
                      .blockUser(
                        session,
                        params['userId'],
                        params['blocked'],
                      ),
        ),
        'deleteUser': _i1.MethodConnector(
          name: 'deleteUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userManagement'] as _i14.UserManagementEndpoint)
                      .deleteUser(
                        session,
                        params['userId'],
                      ),
        ),
        'updateUserRoles': _i1.MethodConnector(
          name: 'updateUserRoles',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'roleNames': _i1.ParameterDescription(
              name: 'roleNames',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userManagement'] as _i14.UserManagementEndpoint)
                      .updateUserRoles(
                        session,
                        params['userId'],
                        params['roleNames'],
                      ),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'getGenderOptions': _i1.MethodConnector(
          name: 'getGenderOptions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .getGenderOptions(session),
        ),
        'requestProfileUpdateCode': _i1.MethodConnector(
          name: 'requestProfileUpdateCode',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .requestProfileUpdateCode(session),
        ),
        'updateProfileWithVerification': _i1.MethodConnector(
          name: 'updateProfileWithVerification',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i21.ProfileUpdateRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .updateProfileWithVerification(
                    session,
                    params['request'],
                  ),
        ),
        'getCurrentUser': _i1.MethodConnector(
          name: 'getCurrentUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .getCurrentUser(session),
        ),
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .getProfile(session),
        ),
        'updateExtendedProfile': _i1.MethodConnector(
          name: 'updateExtendedProfile',
          params: {
            'birthDate': _i1.ParameterDescription(
              name: 'birthDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'gender': _i1.ParameterDescription(
              name: 'gender',
              type: _i1.getType<_i22.Gender?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .updateExtendedProfile(
                    session,
                    birthDate: params['birthDate'],
                    gender: params['gender'],
                  ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .updateProfile(
                    session,
                    fullName: params['fullName'],
                    userName: params['userName'],
                  ),
        ),
        'uploadProfileImage': _i1.MethodConnector(
          name: 'uploadProfileImage',
          params: {
            'image': _i1.ParameterDescription(
              name: 'image',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .uploadProfileImage(
                    session,
                    params['image'],
                    params['fileName'],
                  ),
        ),
        'deleteProfileImage': _i1.MethodConnector(
          name: 'deleteProfileImage',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i15.UserProfileEndpoint)
                  .deleteProfileImage(session),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i16.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['health'] = _i1.EndpointConnector(
      name: 'health',
      endpoint: endpoints['health']!,
      methodConnectors: {
        'check': _i1.MethodConnector(
          name: 'check',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['health'] as _i17.HealthEndpoint).check(session),
        ),
        'ping': _i1.MethodConnector(
          name: 'ping',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['health'] as _i17.HealthEndpoint).ping(session),
        ),
      },
    );
    connectors['translation'] = _i1.EndpointConnector(
      name: 'translation',
      endpoint: endpoints['translation']!,
      methodConnectors: {
        'getTranslations': _i1.MethodConnector(
          name: 'getTranslations',
          params: {
            'locale': _i1.ParameterDescription(
              name: 'locale',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'namespace': _i1.ParameterDescription(
              name: 'namespace',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['translation'] as _i18.TranslationEndpoint)
                  .getTranslations(
                    session,
                    locale: params['locale'],
                    namespace: params['namespace'],
                  ),
        ),
        'saveTranslations': _i1.MethodConnector(
          name: 'saveTranslations',
          params: {
            'locale': _i1.ParameterDescription(
              name: 'locale',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'translations': _i1.ParameterDescription(
              name: 'translations',
              type: _i1.getType<Map<String, dynamic>>(),
              nullable: false,
            ),
            'namespace': _i1.ParameterDescription(
              name: 'namespace',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['translation'] as _i18.TranslationEndpoint)
                  .saveTranslations(
                    session,
                    params['locale'],
                    params['translations'],
                    namespace: params['namespace'],
                    isActive: params['isActive'],
                  ),
        ),
        'getAvailableLocales': _i1.MethodConnector(
          name: 'getAvailableLocales',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['translation'] as _i18.TranslationEndpoint)
                  .getAvailableLocales(session),
        ),
        'reseedFromAssets': _i1.MethodConnector(
          name: 'reseedFromAssets',
          params: {
            'forceReseed': _i1.ParameterDescription(
              name: 'forceReseed',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['translation'] as _i18.TranslationEndpoint)
                  .reseedFromAssets(
                    session,
                    forceReseed: params['forceReseed'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i23.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i24.Endpoints()
      ..initializeEndpoints(server);
  }
}
