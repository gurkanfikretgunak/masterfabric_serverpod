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
import 'dart:async' as _i2;
import 'package:masterfabric_serverpod_client/src/protocol/app_config/app_config.dart'
    as _i3;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/account_status_response.dart'
    as _i4;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i5;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i6;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/password_strength_response.dart'
    as _i7;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/role.dart'
    as _i8;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/permission.dart'
    as _i9;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/session_info_response.dart'
    as _i10;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/two_factor_setup_response.dart'
    as _i11;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user_list_response.dart'
    as _i12;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user_info_response.dart'
    as _i13;
import 'package:masterfabric_serverpod_client/src/protocol/services/greetings/greeting_response.dart'
    as _i14;
import 'package:masterfabric_serverpod_client/src/protocol/services/translations/translation_response.dart'
    as _i15;
import 'protocol.dart' as _i16;

/// Endpoint for providing app configuration to mobile clients
///
/// This endpoint is called when a mobile application first launches
/// to retrieve environment-specific configuration needed for initialization.
/// {@category Endpoint}
class EndpointAppConfig extends _i1.EndpointRef {
  EndpointAppConfig(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appConfig';

  /// Get app configuration for the current environment
  ///
  /// [session] - Serverpod session
  /// [platform] - Optional platform identifier ('ios', 'android', 'web')
  ///   for platform-specific configuration overrides
  ///
  /// Returns AppConfig with all configuration needed by the mobile client
  ///
  /// Throws AppException if configuration cannot be loaded
  _i2.Future<_i3.AppConfig> getConfig({String? platform}) =>
      caller.callServerEndpoint<_i3.AppConfig>(
        'appConfig',
        'getConfig',
        {'platform': platform},
      );
}

/// Endpoint for account management
///
/// Provides endpoints for managing user accounts (deactivate, reactivate, delete).
/// {@category Endpoint}
class EndpointAccountManagement extends _i1.EndpointRef {
  EndpointAccountManagement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'accountManagement';

  /// Get account status
  ///
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  ///
  /// Returns AccountStatusResponse
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i4.AccountStatusResponse> getAccountStatus({String? userId}) =>
      caller.callServerEndpoint<_i4.AccountStatusResponse>(
        'accountManagement',
        'getAccountStatus',
        {'userId': userId},
      );

  /// Deactivate user account
  ///
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> deactivateAccount({String? userId}) =>
      caller.callServerEndpoint<void>(
        'accountManagement',
        'deactivateAccount',
        {'userId': userId},
      );

  /// Reactivate user account
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID to reactivate
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> reactivateAccount(String userId) =>
      caller.callServerEndpoint<void>(
        'accountManagement',
        'reactivateAccount',
        {'userId': userId},
      );

  /// Delete user account (soft delete)
  ///
  /// [session] - Serverpod session
  /// [confirmation] - Confirmation string (must be "DELETE" to confirm)
  /// [userId] - Optional user ID (defaults to current user)
  ///
  /// Throws ValidationError if confirmation is incorrect
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> deleteAccount({
    required String confirmation,
    String? userId,
  }) => caller.callServerEndpoint<void>(
    'accountManagement',
    'deleteAccount',
    {
      'confirmation': confirmation,
      'userId': userId,
    },
  );
}

/// Apple Sign-In endpoint
///
/// By extending [AppleIdpBaseEndpoint], Apple Sign-In endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// Apple Sign-In credentials must be configured in the server configuration.
/// {@category Endpoint}
class EndpointAppleAuth extends _i5.EndpointAppleIdpBase {
  EndpointAppleAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appleAuth';

  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  @override
  _i2.Future<_i6.AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) => caller.callServerEndpoint<_i6.AuthSuccess>(
    'appleAuth',
    'login',
    {
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
      'isNativeApplePlatformSignIn': isNativeApplePlatformSignIn,
      'firstName': firstName,
      'lastName': lastName,
    },
  );
}

/// Email identity provider endpoint with email validation
///
/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// This implementation adds email validation before allowing registration.
/// {@category Endpoint}
class EndpointEmailIdp extends _i5.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i6.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i6.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i6.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i6.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// Google Sign-In endpoint
///
/// By extending [GoogleIdpBaseEndpoint], Google Sign-In endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// Google OAuth credentials must be configured in the server configuration.
/// {@category Endpoint}
class EndpointGoogleAuth extends _i5.EndpointGoogleIdpBase {
  EndpointGoogleAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleAuth';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _i2.Future<_i6.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_i6.AuthSuccess>(
    'googleAuth',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i6.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i6.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i6.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Endpoint for password management
///
/// Provides endpoints for changing passwords and validating password strength.
/// {@category Endpoint}
class EndpointPasswordManagement extends _i1.EndpointRef {
  EndpointPasswordManagement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'passwordManagement';

  /// Change user password
  ///
  /// [session] - Serverpod session
  /// [currentPassword] - Current password for verification
  /// [newPassword] - New password
  ///
  /// Throws ValidationError if password validation fails
  /// Throws AuthenticationError if current password is incorrect
  _i2.Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'passwordManagement',
    'changePassword',
    {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );

  /// Validate password strength
  ///
  /// [session] - Serverpod session
  /// [password] - Password to validate
  ///
  /// Returns PasswordStrengthResponse with validation result
  _i2.Future<_i7.PasswordStrengthResponse> validatePasswordStrength({
    required String password,
  }) => caller.callServerEndpoint<_i7.PasswordStrengthResponse>(
    'passwordManagement',
    'validatePasswordStrength',
    {'password': password},
  );
}

/// Endpoint for RBAC (Role-Based Access Control)
///
/// Provides endpoints for managing roles, permissions, and user-role assignments.
/// {@category Endpoint}
class EndpointRbac extends _i1.EndpointRef {
  EndpointRbac(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rbac';

  /// Get all roles
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of all active roles
  _i2.Future<List<_i8.Role>> getRoles() =>
      caller.callServerEndpoint<List<_i8.Role>>(
        'rbac',
        'getRoles',
        {},
      );

  /// Get all permissions
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of all permissions
  _i2.Future<List<_i9.Permission>> getPermissions() =>
      caller.callServerEndpoint<List<_i9.Permission>>(
        'rbac',
        'getPermissions',
        {},
      );

  /// Get user's roles
  ///
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  ///
  /// Returns list of role names for the user
  _i2.Future<List<String>> getUserRoles({String? userId}) =>
      caller.callServerEndpoint<List<String>>(
        'rbac',
        'getUserRoles',
        {'userId': userId},
      );

  /// Get user's permissions
  ///
  /// [session] - Serverpod session
  /// [userId] - Optional user ID (defaults to current user)
  ///
  /// Returns set of permission names for the user
  _i2.Future<Set<String>> getUserPermissions({String? userId}) =>
      caller.callServerEndpoint<Set<String>>(
        'rbac',
        'getUserPermissions',
        {'userId': userId},
      );

  /// Assign a role to a user
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to assign
  ///
  /// Throws NotFoundError if role not found
  /// Throws ValidationError if user already has the role
  /// Throws AuthorizationError if current user doesn't have admin permission
  _i2.Future<void> assignRoleToUser(
    String userId,
    String roleName,
  ) => caller.callServerEndpoint<void>(
    'rbac',
    'assignRoleToUser',
    {
      'userId': userId,
      'roleName': roleName,
    },
  );

  /// Revoke a role from a user
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleName] - Role name to revoke
  ///
  /// Throws NotFoundError if role or assignment not found
  /// Throws AuthorizationError if current user doesn't have admin permission
  _i2.Future<void> revokeRoleFromUser(
    String userId,
    String roleName,
  ) => caller.callServerEndpoint<void>(
    'rbac',
    'revokeRoleFromUser',
    {
      'userId': userId,
      'roleName': roleName,
    },
  );
}

/// Endpoint for session management
///
/// Provides endpoints for managing user sessions (list, revoke, etc.).
/// {@category Endpoint}
class EndpointSessionManagement extends _i1.EndpointRef {
  EndpointSessionManagement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sessionManagement';

  /// Get all active sessions for the current user
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of SessionInfoResponse for all active sessions
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<List<_i10.SessionInfoResponse>> getActiveSessions() =>
      caller.callServerEndpoint<List<_i10.SessionInfoResponse>>(
        'sessionManagement',
        'getActiveSessions',
        {},
      );

  /// Get session details by session ID
  ///
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to retrieve
  ///
  /// Returns SessionInfoResponse if found
  ///
  /// Throws NotFoundError if session not found
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i10.SessionInfoResponse> getSession(String sessionId) =>
      caller.callServerEndpoint<_i10.SessionInfoResponse>(
        'sessionManagement',
        'getSession',
        {'sessionId': sessionId},
      );

  /// Revoke a specific session
  ///
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to revoke
  ///
  /// Throws NotFoundError if session not found
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> revokeSession(String sessionId) =>
      caller.callServerEndpoint<void>(
        'sessionManagement',
        'revokeSession',
        {'sessionId': sessionId},
      );

  /// Revoke all sessions except the current one
  ///
  /// [session] - Serverpod session
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> revokeAllOtherSessions() => caller.callServerEndpoint<void>(
    'sessionManagement',
    'revokeAllOtherSessions',
    {},
  );

  /// Revoke all sessions including current
  ///
  /// [session] - Serverpod session
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> revokeAllSessions() => caller.callServerEndpoint<void>(
    'sessionManagement',
    'revokeAllSessions',
    {},
  );
}

/// Endpoint for two-factor authentication
///
/// Provides endpoints for enabling, disabling, and managing 2FA.
/// {@category Endpoint}
class EndpointTwoFactor extends _i1.EndpointRef {
  EndpointTwoFactor(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'twoFactor';

  /// Check if 2FA is enabled
  ///
  /// [session] - Serverpod session
  ///
  /// Returns true if 2FA is enabled
  _i2.Future<bool> isTwoFactorEnabled() => caller.callServerEndpoint<bool>(
    'twoFactor',
    'isTwoFactorEnabled',
    {},
  );

  /// Start 2FA setup (generate secret and QR code)
  ///
  /// [session] - Serverpod session
  /// [email] - User email (for QR code label)
  ///
  /// Returns TwoFactorSetupResponse with secret, QR code URI, and backup codes
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i11.TwoFactorSetupResponse> startSetup(String email) =>
      caller.callServerEndpoint<_i11.TwoFactorSetupResponse>(
        'twoFactor',
        'startSetup',
        {'email': email},
      );

  /// Verify TOTP code and complete 2FA setup
  ///
  /// [session] - Serverpod session
  /// [code] - TOTP code from authenticator app
  ///
  /// Throws ValidationError if code is invalid
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> verifyAndEnable(String code) =>
      caller.callServerEndpoint<void>(
        'twoFactor',
        'verifyAndEnable',
        {'code': code},
      );

  /// Disable 2FA
  ///
  /// [session] - Serverpod session
  /// [verificationCode] - TOTP code or backup code for verification
  ///
  /// Throws ValidationError if verification code is invalid
  /// Throws AuthenticationError if not authenticated
  _i2.Future<void> disable(String verificationCode) =>
      caller.callServerEndpoint<void>(
        'twoFactor',
        'disable',
        {'verificationCode': verificationCode},
      );

  /// Get backup codes
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of backup codes
  ///
  /// Throws NotFoundError if 2FA is not enabled
  _i2.Future<List<String>> getBackupCodes() =>
      caller.callServerEndpoint<List<String>>(
        'twoFactor',
        'getBackupCodes',
        {},
      );

  /// Regenerate backup codes
  ///
  /// [session] - Serverpod session
  ///
  /// Returns new list of backup codes
  ///
  /// Throws NotFoundError if 2FA is not enabled
  _i2.Future<List<String>> regenerateBackupCodes() =>
      caller.callServerEndpoint<List<String>>(
        'twoFactor',
        'regenerateBackupCodes',
        {},
      );
}

/// Endpoint for user management (admin features)
///
/// Provides endpoints for listing, viewing, blocking, and managing users.
/// {@category Endpoint}
class EndpointUserManagement extends _i1.EndpointRef {
  EndpointUserManagement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userManagement';

  /// List users with pagination and filtering
  ///
  /// [session] - Serverpod session
  /// [page] - Page number (1-based)
  /// [pageSize] - Number of items per page
  /// [search] - Optional search term
  /// [blocked] - Optional filter by blocked status
  ///
  /// Returns UserListResponse with paginated users
  ///
  /// Throws AuthorizationError if user doesn't have admin permission
  _i2.Future<_i12.UserListResponse> listUsers({
    required int page,
    required int pageSize,
    String? search,
    bool? blocked,
  }) => caller.callServerEndpoint<_i12.UserListResponse>(
    'userManagement',
    'listUsers',
    {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'blocked': blocked,
    },
  );

  /// Get user by ID
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID
  ///
  /// Returns UserInfoResponse
  ///
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  _i2.Future<_i13.UserInfoResponse> getUser(String userId) =>
      caller.callServerEndpoint<_i13.UserInfoResponse>(
        'userManagement',
        'getUser',
        {'userId': userId},
      );

  /// Block or unblock a user
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [blocked] - Whether to block (true) or unblock (false)
  ///
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  _i2.Future<void> blockUser(
    String userId,
    bool blocked,
  ) => caller.callServerEndpoint<void>(
    'userManagement',
    'blockUser',
    {
      'userId': userId,
      'blocked': blocked,
    },
  );

  /// Delete a user (soft delete)
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID to delete
  ///
  /// Throws NotFoundError if user not found
  /// Throws AuthorizationError if user doesn't have admin permission
  _i2.Future<void> deleteUser(String userId) => caller.callServerEndpoint<void>(
    'userManagement',
    'deleteUser',
    {'userId': userId},
  );

  /// Update user roles
  ///
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [roleNames] - List of role names to assign
  ///
  /// Throws NotFoundError if user or role not found
  /// Throws AuthorizationError if user doesn't have admin permission
  _i2.Future<void> updateUserRoles(
    String userId,
    List<String> roleNames,
  ) => caller.callServerEndpoint<void>(
    'userManagement',
    'updateUserRoles',
    {
      'userId': userId,
      'roleNames': roleNames,
    },
  );
}

/// Endpoint for user profile management
///
/// Provides endpoints for getting, updating, and managing user profiles.
/// {@category Endpoint}
class EndpointUserProfile extends _i1.EndpointRef {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Get current user's profile
  ///
  /// [session] - Serverpod session
  ///
  /// Returns UserProfileModel for the authenticated user
  ///
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if profile not found
  _i2.Future<_i6.UserProfileModel> getProfile() =>
      caller.callServerEndpoint<_i6.UserProfileModel>(
        'userProfile',
        'getProfile',
        {},
      );

  /// Update user profile
  ///
  /// [session] - Serverpod session
  /// [fullName] - Optional full name
  /// [userName] - Optional username
  ///
  /// Returns updated UserProfileModel
  ///
  /// Throws ValidationError if validation fails
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i6.UserProfileModel> updateProfile({
    String? fullName,
    String? userName,
  }) => caller.callServerEndpoint<_i6.UserProfileModel>(
    'userProfile',
    'updateProfile',
    {
      'fullName': fullName,
      'userName': userName,
    },
  );

  /// Upload profile image
  ///
  /// [session] - Serverpod session
  /// [image] - Image file bytes
  /// [fileName] - Original file name
  ///
  /// Returns updated UserProfileModel with image URL
  ///
  /// Throws ValidationError if image is invalid
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i6.UserProfileModel> uploadProfileImage(
    List<int> image,
    String fileName,
  ) => caller.callServerEndpoint<_i6.UserProfileModel>(
    'userProfile',
    'uploadProfileImage',
    {
      'image': image,
      'fileName': fileName,
    },
  );

  /// Delete profile image
  ///
  /// [session] - Serverpod session
  ///
  /// Returns updated UserProfileModel without image
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i6.UserProfileModel> deleteProfileImage() =>
      caller.callServerEndpoint<_i6.UserProfileModel>(
        'userProfile',
        'deleteProfileImage',
        {},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
///
/// Features:
/// - Rate limited to 20 requests per minute per user/IP
/// - Returns rate limit info in every response
/// - Caches and replaces greeting with fresh timestamp each request
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  ///
  /// Rate limited to 20 requests per minute.
  /// Returns rate limit info (remaining, limit, reset time) in response.
  /// Throws RateLimitException with details if limit is exceeded.
  _i2.Future<_i14.GreetingResponse> hello(String name) =>
      caller.callServerEndpoint<_i14.GreetingResponse>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Endpoint for providing translations to clients
///
/// This endpoint provides translations in slang-compatible JSON format.
/// Locale is auto-detected from Cloudflare CF-IPCountry header if not specified.
/// {@category Endpoint}
class EndpointTranslation extends _i1.EndpointRef {
  EndpointTranslation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'translation';

  /// Get translations for a locale
  ///
  /// [session] - Serverpod session
  /// [locale] - Optional locale code (e.g., 'en', 'tr'). If not provided,
  ///   locale will be auto-detected from IP address via Cloudflare headers.
  /// [namespace] - Optional namespace identifier for organizing translations
  ///
  /// Returns TranslationResponse containing translations in slang JSON format
  ///
  /// Throws InternalServerError if translations cannot be loaded
  _i2.Future<_i15.TranslationResponse> getTranslations({
    String? locale,
    String? namespace,
  }) => caller.callServerEndpoint<_i15.TranslationResponse>(
    'translation',
    'getTranslations',
    {
      'locale': locale,
      'namespace': namespace,
    },
  );

  /// Save translations (admin method)
  ///
  /// [session] - Serverpod session
  /// [locale] - Locale code (e.g., 'en', 'tr')
  /// [translations] - Translations as `Map<String, dynamic>` (slang JSON format)
  /// [namespace] - Optional namespace identifier
  /// [isActive] - Whether this translation is active
  ///
  /// Returns TranslationResponse with saved translations
  ///
  /// Note: This should be protected by authentication/authorization in production
  _i2.Future<_i15.TranslationResponse> saveTranslations(
    String locale,
    Map<String, dynamic> translations, {
    String? namespace,
    required bool isActive,
  }) => caller.callServerEndpoint<_i15.TranslationResponse>(
    'translation',
    'saveTranslations',
    {
      'locale': locale,
      'translations': translations,
      'namespace': namespace,
      'isActive': isActive,
    },
  );

  /// Get all available locales
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of available locale codes
  _i2.Future<List<String>> getAvailableLocales() =>
      caller.callServerEndpoint<List<String>>(
        'translation',
        'getAvailableLocales',
        {},
      );

  /// Reseed translations from assets/i18n/ folder
  ///
  /// [session] - Serverpod session
  /// [forceReseed] - If true, reseed even if already seeded
  ///
  /// Returns number of locales seeded
  ///
  /// Note: This should be protected by authentication/authorization in production
  _i2.Future<int> reseedFromAssets({required bool forceReseed}) =>
      caller.callServerEndpoint<int>(
        'translation',
        'reseedFromAssets',
        {'forceReseed': forceReseed},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i5.Caller(client);
    serverpod_auth_core = _i6.Caller(client);
  }

  late final _i5.Caller serverpod_auth_idp;

  late final _i6.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i16.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    appConfig = EndpointAppConfig(this);
    accountManagement = EndpointAccountManagement(this);
    appleAuth = EndpointAppleAuth(this);
    emailIdp = EndpointEmailIdp(this);
    googleAuth = EndpointGoogleAuth(this);
    jwtRefresh = EndpointJwtRefresh(this);
    passwordManagement = EndpointPasswordManagement(this);
    rbac = EndpointRbac(this);
    sessionManagement = EndpointSessionManagement(this);
    twoFactor = EndpointTwoFactor(this);
    userManagement = EndpointUserManagement(this);
    userProfile = EndpointUserProfile(this);
    greeting = EndpointGreeting(this);
    translation = EndpointTranslation(this);
    modules = Modules(this);
  }

  late final EndpointAppConfig appConfig;

  late final EndpointAccountManagement accountManagement;

  late final EndpointAppleAuth appleAuth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointGoogleAuth googleAuth;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointPasswordManagement passwordManagement;

  late final EndpointRbac rbac;

  late final EndpointSessionManagement sessionManagement;

  late final EndpointTwoFactor twoFactor;

  late final EndpointUserManagement userManagement;

  late final EndpointUserProfile userProfile;

  late final EndpointGreeting greeting;

  late final EndpointTranslation translation;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'appConfig': appConfig,
    'accountManagement': accountManagement,
    'appleAuth': appleAuth,
    'emailIdp': emailIdp,
    'googleAuth': googleAuth,
    'jwtRefresh': jwtRefresh,
    'passwordManagement': passwordManagement,
    'rbac': rbac,
    'sessionManagement': sessionManagement,
    'twoFactor': twoFactor,
    'userManagement': userManagement,
    'userProfile': userProfile,
    'greeting': greeting,
    'translation': translation,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
