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
import '../services/app_config/app_config_endpoint.dart' as _i2;
import '../services/auth/account_management_endpoint.dart' as _i3;
import '../services/auth/apple_auth_endpoint.dart' as _i4;
import '../services/auth/email_idp_endpoint.dart' as _i5;
import '../services/auth/google_auth_endpoint.dart' as _i6;
import '../services/auth/jwt_refresh_endpoint.dart' as _i7;
import '../services/auth/password_management_endpoint.dart' as _i8;
import '../services/auth/rbac_endpoint.dart' as _i9;
import '../services/auth/session_management_endpoint.dart' as _i10;
import '../services/auth/two_factor_endpoint.dart' as _i11;
import '../services/auth/user_management_endpoint.dart' as _i12;
import '../services/auth/user_profile_endpoint.dart' as _i13;
import '../services/greetings/greeting_endpoint.dart' as _i14;
import '../services/translations/translation_endpoint.dart' as _i15;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i16;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i17;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'appConfig': _i2.AppConfigEndpoint()
        ..initialize(
          server,
          'appConfig',
          null,
        ),
      'accountManagement': _i3.AccountManagementEndpoint()
        ..initialize(
          server,
          'accountManagement',
          null,
        ),
      'appleAuth': _i4.AppleAuthEndpoint()
        ..initialize(
          server,
          'appleAuth',
          null,
        ),
      'emailIdp': _i5.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'googleAuth': _i6.GoogleAuthEndpoint()
        ..initialize(
          server,
          'googleAuth',
          null,
        ),
      'jwtRefresh': _i7.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'passwordManagement': _i8.PasswordManagementEndpoint()
        ..initialize(
          server,
          'passwordManagement',
          null,
        ),
      'rbac': _i9.RbacEndpoint()
        ..initialize(
          server,
          'rbac',
          null,
        ),
      'sessionManagement': _i10.SessionManagementEndpoint()
        ..initialize(
          server,
          'sessionManagement',
          null,
        ),
      'twoFactor': _i11.TwoFactorEndpoint()
        ..initialize(
          server,
          'twoFactor',
          null,
        ),
      'userManagement': _i12.UserManagementEndpoint()
        ..initialize(
          server,
          'userManagement',
          null,
        ),
      'userProfile': _i13.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
      'greeting': _i14.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'translation': _i15.TranslationEndpoint()
        ..initialize(
          server,
          'translation',
          null,
        ),
    };
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
                  (endpoints['appConfig'] as _i2.AppConfigEndpoint).getConfig(
                    session,
                    platform: params['platform'],
                  ),
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
                          as _i3.AccountManagementEndpoint)
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
                          as _i3.AccountManagementEndpoint)
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
                          as _i3.AccountManagementEndpoint)
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
                          as _i3.AccountManagementEndpoint)
                      .deleteAccount(
                        session,
                        confirmation: params['confirmation'],
                        userId: params['userId'],
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
                  (endpoints['appleAuth'] as _i4.AppleAuthEndpoint).login(
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
                  (endpoints['googleAuth'] as _i6.GoogleAuthEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
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
              ) async => (endpoints['jwtRefresh'] as _i7.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
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
                          as _i8.PasswordManagementEndpoint)
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
                          as _i8.PasswordManagementEndpoint)
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
                  (endpoints['rbac'] as _i9.RbacEndpoint).getRoles(session),
        ),
        'getPermissions': _i1.MethodConnector(
          name: 'getPermissions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i9.RbacEndpoint).getPermissions(
                session,
              ),
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
              ) async => (endpoints['rbac'] as _i9.RbacEndpoint).getUserRoles(
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
                  (endpoints['rbac'] as _i9.RbacEndpoint).getUserPermissions(
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
                  (endpoints['rbac'] as _i9.RbacEndpoint).assignRoleToUser(
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
                  (endpoints['rbac'] as _i9.RbacEndpoint).revokeRoleFromUser(
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
        'getActiveSessions': _i1.MethodConnector(
          name: 'getActiveSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i10.SessionManagementEndpoint)
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
                          as _i10.SessionManagementEndpoint)
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
                          as _i10.SessionManagementEndpoint)
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
                          as _i10.SessionManagementEndpoint)
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
                          as _i10.SessionManagementEndpoint)
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
              ) async => (endpoints['twoFactor'] as _i11.TwoFactorEndpoint)
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
                  (endpoints['twoFactor'] as _i11.TwoFactorEndpoint).startSetup(
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
              ) async => (endpoints['twoFactor'] as _i11.TwoFactorEndpoint)
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
                  (endpoints['twoFactor'] as _i11.TwoFactorEndpoint).disable(
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
              ) async => (endpoints['twoFactor'] as _i11.TwoFactorEndpoint)
                  .getBackupCodes(session),
        ),
        'regenerateBackupCodes': _i1.MethodConnector(
          name: 'regenerateBackupCodes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _i11.TwoFactorEndpoint)
                  .regenerateBackupCodes(session),
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
                  (endpoints['userManagement'] as _i12.UserManagementEndpoint)
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
                  (endpoints['userManagement'] as _i12.UserManagementEndpoint)
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
                  (endpoints['userManagement'] as _i12.UserManagementEndpoint)
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
                  (endpoints['userManagement'] as _i12.UserManagementEndpoint)
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
                  (endpoints['userManagement'] as _i12.UserManagementEndpoint)
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
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i13.UserProfileEndpoint)
                  .getProfile(session),
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
              ) async => (endpoints['userProfile'] as _i13.UserProfileEndpoint)
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
              ) async => (endpoints['userProfile'] as _i13.UserProfileEndpoint)
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
              ) async => (endpoints['userProfile'] as _i13.UserProfileEndpoint)
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
              ) async => (endpoints['greeting'] as _i14.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
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
              ) async => (endpoints['translation'] as _i15.TranslationEndpoint)
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
              ) async => (endpoints['translation'] as _i15.TranslationEndpoint)
                  .saveTranslations(
                    session,
                    params['locale'],
                    params['translations'],
                    namespace: params['namespace'],
                    isActive: params['isActive'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i16.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i17.Endpoints()
      ..initializeEndpoints(server);
  }
}
