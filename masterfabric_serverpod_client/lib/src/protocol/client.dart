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
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/notification_response.dart'
    as _i3;
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/send_notification_request.dart'
    as _i4;
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/notification_list_response.dart'
    as _i5;
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/channel_list_response.dart'
    as _i6;
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/channel_response.dart'
    as _i7;
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/channel_type.dart'
    as _i8;
import 'package:masterfabric_serverpod_client/src/protocol/core/real_time/notifications_center/models/notification.dart'
    as _i9;
import 'package:masterfabric_serverpod_client/src/protocol/app_config/app_config.dart'
    as _i10;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i11;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i12;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/password/password_strength_response.dart'
    as _i13;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/rbac/role.dart'
    as _i14;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/rbac/permission.dart'
    as _i15;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/session/session_info_response.dart'
    as _i16;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/two_factor/two_factor_setup_response.dart'
    as _i17;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/account_status_response.dart'
    as _i18;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/user_list_response.dart'
    as _i19;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/user_info_response.dart'
    as _i20;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/gender.dart'
    as _i21;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/verification/verification_response.dart'
    as _i22;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/current_user_response.dart'
    as _i23;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/user/profile_update_request.dart'
    as _i24;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/verification/verification_channel.dart'
    as _i25;
import 'package:masterfabric_serverpod_client/src/protocol/services/auth/verification/user_verification_preferences.dart'
    as _i26;
import 'package:masterfabric_serverpod_client/src/protocol/services/greetings/models/greeting_response.dart'
    as _i27;
import 'package:masterfabric_serverpod_client/src/protocol/services/health/models/health_check_response.dart'
    as _i28;
import 'package:masterfabric_serverpod_client/src/protocol/services/translations/models/translation_response.dart'
    as _i29;
import 'protocol.dart' as _i30;

/// Base class for MasterFabric endpoints with built-in middleware support
///
/// Extend this class instead of [Endpoint] to automatically get
/// middleware execution for all methods.
///
/// Example:
/// ```dart
/// class PaymentEndpoint extends MasterfabricEndpoint {
///   @override
///   EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
///     requiredPermissions: ['payment:read'],
///     customRateLimit: RateLimitConfig(maxRequests: 10, windowDuration: Duration(minutes: 1)),
///   );
///
///   Future<PaymentResponse> process(Session session, PaymentRequest request) async {
///     return executeWithMiddleware(
///       session: session,
///       methodName: 'process',
///       parameters: {'request': request.toJson()},
///       handler: () async {
///         // Your business logic here
///         return PaymentResponse(success: true);
///       },
///     );
///   }
/// }
/// ```
/// {@category Endpoint}
abstract class EndpointMasterfabric extends _i1.EndpointRef {
  EndpointMasterfabric(_i1.EndpointCaller caller) : super(caller);
}

/// REST API endpoint for notification operations
///
/// Provides HTTP endpoints for sending notifications, managing channels,
/// and retrieving notification history. Includes rate limiting for
/// protection against abuse.
/// {@category Endpoint}
class EndpointNotification extends _i1.EndpointRef {
  EndpointNotification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Send a notification
  ///
  /// Creates and sends a notification based on the request type.
  /// Rate limited to prevent abuse.
  ///
  /// [session] - Serverpod session
  /// [request] - Send notification request
  _i2.Future<_i3.NotificationResponse> send(
    _i4.SendNotificationRequest request,
  ) => caller.callServerEndpoint<_i3.NotificationResponse>(
    'notification',
    'send',
    {'request': request},
  );

  /// Get notification history for a channel
  ///
  /// Retrieves recent notifications from cache.
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel to get notifications for
  /// [limit] - Maximum number of notifications (default 50)
  _i2.Future<_i5.NotificationListResponse> getHistory(
    String channelId, {
    required int limit,
  }) => caller.callServerEndpoint<_i5.NotificationListResponse>(
    'notification',
    'getHistory',
    {
      'channelId': channelId,
      'limit': limit,
    },
  );

  /// Get notifications for a user across all subscribed channels
  ///
  /// [session] - Serverpod session
  /// [limit] - Maximum notifications per channel (default 20)
  _i2.Future<_i5.NotificationListResponse> getUserNotifications({
    required int limit,
  }) => caller.callServerEndpoint<_i5.NotificationListResponse>(
    'notification',
    'getUserNotifications',
    {'limit': limit},
  );

  /// Mark a notification as read
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to mark as read
  _i2.Future<_i3.NotificationResponse> markAsRead(
    String channelId,
    String notificationId,
  ) => caller.callServerEndpoint<_i3.NotificationResponse>(
    'notification',
    'markAsRead',
    {
      'channelId': channelId,
      'notificationId': notificationId,
    },
  );

  /// Mark all notifications as read for a channel
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel to mark all as read
  _i2.Future<_i3.NotificationResponse> markAllAsRead(String channelId) =>
      caller.callServerEndpoint<_i3.NotificationResponse>(
        'notification',
        'markAllAsRead',
        {'channelId': channelId},
      );

  /// Delete a notification
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel the notification belongs to
  /// [notificationId] - Notification ID to delete
  _i2.Future<_i3.NotificationResponse> deleteNotification(
    String channelId,
    String notificationId,
  ) => caller.callServerEndpoint<_i3.NotificationResponse>(
    'notification',
    'deleteNotification',
    {
      'channelId': channelId,
      'notificationId': notificationId,
    },
  );

  /// Get unread notification count for a user
  ///
  /// [session] - Serverpod session
  _i2.Future<int> getUnreadCount() => caller.callServerEndpoint<int>(
    'notification',
    'getUnreadCount',
    {},
  );

  /// Get notifications from public channels (no authentication required)
  ///
  /// [session] - Serverpod session
  /// [limit] - Maximum number of notifications (default 50)
  _i2.Future<_i5.NotificationListResponse> getPublicNotifications({
    required int limit,
  }) => caller.callServerEndpoint<_i5.NotificationListResponse>(
    'notification',
    'getPublicNotifications',
    {'limit': limit},
  );

  /// List all public channels
  ///
  /// [session] - Serverpod session
  _i2.Future<_i6.ChannelListResponse> listPublicChannels() =>
      caller.callServerEndpoint<_i6.ChannelListResponse>(
        'notification',
        'listPublicChannels',
        {},
      );

  /// Create a new notification channel
  ///
  /// [session] - Serverpod session
  /// [name] - Channel name
  /// [type] - Channel type
  /// [description] - Optional description
  /// [isPublic] - Whether channel is publicly joinable
  /// [projectId] - Optional project ID (for project channels)
  _i2.Future<_i7.ChannelResponse> createChannel({
    required String name,
    required _i8.ChannelType type,
    String? description,
    required bool isPublic,
    String? projectId,
    int? maxSubscribers,
    required int cacheTtlSeconds,
  }) => caller.callServerEndpoint<_i7.ChannelResponse>(
    'notification',
    'createChannel',
    {
      'name': name,
      'type': type,
      'description': description,
      'isPublic': isPublic,
      'projectId': projectId,
      'maxSubscribers': maxSubscribers,
      'cacheTtlSeconds': cacheTtlSeconds,
    },
  );

  /// Get a channel by ID
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel ID
  _i2.Future<_i7.ChannelResponse> getChannel(String channelId) =>
      caller.callServerEndpoint<_i7.ChannelResponse>(
        'notification',
        'getChannel',
        {'channelId': channelId},
      );

  /// Subscribe to a channel
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel to subscribe to
  _i2.Future<_i7.ChannelResponse> joinChannel(String channelId) =>
      caller.callServerEndpoint<_i7.ChannelResponse>(
        'notification',
        'joinChannel',
        {'channelId': channelId},
      );

  /// Unsubscribe from a channel
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel to unsubscribe from
  _i2.Future<_i7.ChannelResponse> leaveChannel(String channelId) =>
      caller.callServerEndpoint<_i7.ChannelResponse>(
        'notification',
        'leaveChannel',
        {'channelId': channelId},
      );

  /// Update channel settings
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel to update
  /// [name] - Optional new name
  /// [description] - Optional new description
  /// [isActive] - Optional active status
  _i2.Future<_i7.ChannelResponse> updateChannel(
    String channelId, {
    String? name,
    String? description,
    bool? isActive,
    bool? isPublic,
  }) => caller.callServerEndpoint<_i7.ChannelResponse>(
    'notification',
    'updateChannel',
    {
      'channelId': channelId,
      'name': name,
      'description': description,
      'isActive': isActive,
      'isPublic': isPublic,
    },
  );

  /// Get cache statistics for a channel
  ///
  /// [session] - Serverpod session
  /// [channelId] - Channel to get stats for
  _i2.Future<Map<String, dynamic>> getCacheStats(String channelId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'notification',
        'getCacheStats',
        {'channelId': channelId},
      );
}

/// Real-time notification streaming endpoint
///
/// Provides WebSocket-based streaming for real-time notifications.
/// Uses Serverpod's streaming methods for automatic connection management.
///
/// Clients can subscribe to multiple channels and receive notifications
/// in real-time as they are published.
/// {@category Endpoint}
class EndpointNotificationStream extends _i1.EndpointRef {
  EndpointNotificationStream(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notificationStream';

  /// Subscribe to notification channels and receive real-time updates
  ///
  /// This is the main streaming method. Clients call this to establish
  /// a WebSocket connection and receive notifications as they arrive.
  ///
  /// [session] - Serverpod session (automatically managed)
  /// [channelIds] - List of channel IDs to subscribe to
  ///
  /// Returns a stream of notifications from all subscribed channels.
  /// The stream first yields any cached notifications, then continues
  /// with real-time updates.
  _i2.Stream<_i9.Notification> subscribe(List<String> channelIds) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i9.Notification>,
        _i9.Notification
      >(
        'notificationStream',
        'subscribe',
        {'channelIds': channelIds},
        {},
      );

  /// Subscribe to a user's personal notification channel
  ///
  /// Convenience method for subscribing to the current user's notifications.
  /// Requires authentication.
  ///
  /// [session] - Serverpod session
  ///
  /// Returns a stream of notifications for the authenticated user.
  _i2.Stream<_i9.Notification> subscribeToUserNotifications() =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i9.Notification>,
        _i9.Notification
      >(
        'notificationStream',
        'subscribeToUserNotifications',
        {},
        {},
      );

  /// Subscribe to a project's notification channel
  ///
  /// [session] - Serverpod session
  /// [projectId] - Project ID to subscribe to
  /// [projectChannelId] - The project's notification channel ID
  ///
  /// Returns a stream of notifications for the project.
  _i2.Stream<_i9.Notification> subscribeToProject(
    String projectId,
    String projectChannelId,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i9.Notification>,
        _i9.Notification
      >(
        'notificationStream',
        'subscribeToProject',
        {
          'projectId': projectId,
          'projectChannelId': projectChannelId,
        },
        {},
      );

  /// Subscribe to public broadcast channels
  ///
  /// [session] - Serverpod session
  /// [channelIds] - List of public channel IDs to subscribe to
  ///
  /// Returns a stream of broadcast notifications.
  /// Only public channels can be subscribed without authentication.
  _i2.Stream<_i9.Notification> subscribeToBroadcasts(List<String> channelIds) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i9.Notification>,
        _i9.Notification
      >(
        'notificationStream',
        'subscribeToBroadcasts',
        {'channelIds': channelIds},
        {},
      );
}

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
  _i2.Future<_i10.AppConfig> getConfig({String? platform}) =>
      caller.callServerEndpoint<_i10.AppConfig>(
        'appConfig',
        'getConfig',
        {'platform': platform},
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
class EndpointEmailIdp extends _i11.EndpointEmailIdpBase {
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
  _i2.Future<_i12.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i12.AuthSuccess>(
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
  _i2.Future<_i12.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i12.AuthSuccess>(
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

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i12.EndpointRefreshJwtTokens {
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
  _i2.Future<_i12.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i12.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
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
class EndpointAppleAuth extends _i11.EndpointAppleIdpBase {
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
  _i2.Future<_i12.AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) => caller.callServerEndpoint<_i12.AuthSuccess>(
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

/// Google Sign-In endpoint
///
/// By extending [GoogleIdpBaseEndpoint], Google Sign-In endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// Google OAuth credentials must be configured in the server configuration.
/// {@category Endpoint}
class EndpointGoogleAuth extends _i11.EndpointGoogleIdpBase {
  EndpointGoogleAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleAuth';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _i2.Future<_i12.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_i12.AuthSuccess>(
    'googleAuth',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
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
  _i2.Future<_i13.PasswordStrengthResponse> validatePasswordStrength({
    required String password,
  }) => caller.callServerEndpoint<_i13.PasswordStrengthResponse>(
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
  _i2.Future<List<_i14.Role>> getRoles() =>
      caller.callServerEndpoint<List<_i14.Role>>(
        'rbac',
        'getRoles',
        {},
      );

  /// Get all permissions
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of all permissions
  _i2.Future<List<_i15.Permission>> getPermissions() =>
      caller.callServerEndpoint<List<_i15.Permission>>(
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

  /// Get current session info from JWT token
  ///
  /// Returns the current authenticated session information
  _i2.Future<_i16.SessionInfoResponse> getCurrentSession() =>
      caller.callServerEndpoint<_i16.SessionInfoResponse>(
        'sessionManagement',
        'getCurrentSession',
        {},
      );

  /// Get all active sessions for the current user
  ///
  /// Note: With JWT auth, this returns server-side sessions if any exist.
  /// If no server-side sessions, returns current JWT session info.
  _i2.Future<List<_i16.SessionInfoResponse>> getActiveSessions() =>
      caller.callServerEndpoint<List<_i16.SessionInfoResponse>>(
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
  _i2.Future<_i16.SessionInfoResponse> getSession(String sessionId) =>
      caller.callServerEndpoint<_i16.SessionInfoResponse>(
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
  _i2.Future<_i17.TwoFactorSetupResponse> startSetup(String email) =>
      caller.callServerEndpoint<_i17.TwoFactorSetupResponse>(
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
  _i2.Future<_i18.AccountStatusResponse> getAccountStatus({String? userId}) =>
      caller.callServerEndpoint<_i18.AccountStatusResponse>(
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
  _i2.Future<_i19.UserListResponse> listUsers({
    required int page,
    required int pageSize,
    String? search,
    bool? blocked,
  }) => caller.callServerEndpoint<_i19.UserListResponse>(
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
  _i2.Future<_i20.UserInfoResponse> getUser(String userId) =>
      caller.callServerEndpoint<_i20.UserInfoResponse>(
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

  /// Get available gender options
  ///
  /// Returns list of Gender enum values for UI dropdown
  _i2.Future<List<_i21.Gender>> getGenderOptions() =>
      caller.callServerEndpoint<List<_i21.Gender>>(
        'userProfile',
        'getGenderOptions',
        {},
      );

  /// Request a verification code for profile update
  ///
  /// [session] - Serverpod session
  ///
  /// Returns VerificationResponse with status and expiration
  ///
  /// The code will be sent to the user's email (logged in dev mode)
  _i2.Future<_i22.VerificationResponse> requestProfileUpdateCode() =>
      caller.callServerEndpoint<_i22.VerificationResponse>(
        'userProfile',
        'requestProfileUpdateCode',
        {},
      );

  /// Update profile with verification code
  ///
  /// [session] - Serverpod session
  /// [request] - ProfileUpdateRequest containing verification code and update data
  ///
  /// Returns updated CurrentUserResponse
  ///
  /// Throws ValidationError if verification code is invalid
  _i2.Future<_i23.CurrentUserResponse> updateProfileWithVerification(
    _i24.ProfileUpdateRequest request,
  ) => caller.callServerEndpoint<_i23.CurrentUserResponse>(
    'userProfile',
    'updateProfileWithVerification',
    {'request': request},
  );

  /// Get current user's complete information
  ///
  /// [session] - Serverpod session
  ///
  /// Returns CurrentUserResponse with all user details including createdAt
  ///
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if user not found
  _i2.Future<_i23.CurrentUserResponse> getCurrentUser() =>
      caller.callServerEndpoint<_i23.CurrentUserResponse>(
        'userProfile',
        'getCurrentUser',
        {},
      );

  /// Get current user's profile
  ///
  /// [session] - Serverpod session
  ///
  /// Returns UserProfileModel for the authenticated user
  ///
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if profile not found
  _i2.Future<_i12.UserProfileModel> getProfile() =>
      caller.callServerEndpoint<_i12.UserProfileModel>(
        'userProfile',
        'getProfile',
        {},
      );

  /// Update extended profile (birthDate, gender)
  ///
  /// [session] - Serverpod session
  /// [birthDate] - Optional birth date
  /// [gender] - Optional gender
  ///
  /// Returns updated CurrentUserResponse
  ///
  /// Throws AuthenticationError if not authenticated
  _i2.Future<_i23.CurrentUserResponse> updateExtendedProfile({
    DateTime? birthDate,
    _i21.Gender? gender,
  }) => caller.callServerEndpoint<_i23.CurrentUserResponse>(
    'userProfile',
    'updateExtendedProfile',
    {
      'birthDate': birthDate,
      'gender': gender,
    },
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
  _i2.Future<_i12.UserProfileModel> updateProfile({
    String? fullName,
    String? userName,
  }) => caller.callServerEndpoint<_i12.UserProfileModel>(
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
  _i2.Future<_i12.UserProfileModel> uploadProfileImage(
    List<int> image,
    String fileName,
  ) => caller.callServerEndpoint<_i12.UserProfileModel>(
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
  _i2.Future<_i12.UserProfileModel> deleteProfileImage() =>
      caller.callServerEndpoint<_i12.UserProfileModel>(
        'userProfile',
        'deleteProfileImage',
        {},
      );
}

/// Endpoint for managing verification channel preferences
///
/// Provides API for:
/// - Getting available verification channels
/// - Getting user's current preferences
/// - Updating verification preferences
/// - Linking Telegram account
/// - Verifying phone number for WhatsApp
/// {@category Endpoint}
class EndpointVerificationPreferences extends EndpointMasterfabric {
  EndpointVerificationPreferences(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'verificationPreferences';

  /// Get available verification channels
  ///
  /// Returns a list of channels that are currently enabled
  _i2.Future<List<_i25.VerificationChannel>> getAvailableChannels() =>
      caller.callServerEndpoint<List<_i25.VerificationChannel>>(
        'verificationPreferences',
        'getAvailableChannels',
        {},
      );

  /// Get current user's verification preferences
  ///
  /// Returns the user's current preferences or null if not set
  _i2.Future<_i26.UserVerificationPreferences?> getPreferences() =>
      caller.callServerEndpoint<_i26.UserVerificationPreferences?>(
        'verificationPreferences',
        'getPreferences',
        {},
      );

  /// Update verification preferences
  ///
  /// [preferredChannel] - Preferred channel for verification codes
  /// [backupChannel] - Optional backup channel
  /// [phoneNumber] - Phone number for Telegram/WhatsApp (E.164 format)
  ///
  /// Returns the updated preferences
  _i2.Future<_i26.UserVerificationPreferences> updatePreferences({
    required _i25.VerificationChannel preferredChannel,
    _i25.VerificationChannel? backupChannel,
    String? phoneNumber,
  }) => caller.callServerEndpoint<_i26.UserVerificationPreferences>(
    'verificationPreferences',
    'updatePreferences',
    {
      'preferredChannel': preferredChannel,
      'backupChannel': backupChannel,
      'phoneNumber': phoneNumber,
    },
  );

  /// Generate Telegram linking code
  ///
  /// Returns a one-time code that user sends to the bot to link their account
  _i2.Future<_i22.VerificationResponse> generateTelegramLinkCode() =>
      caller.callServerEndpoint<_i22.VerificationResponse>(
        'verificationPreferences',
        'generateTelegramLinkCode',
        {},
      );

  /// Link Telegram account using chat ID
  ///
  /// Called when user sends /start command with linking code to bot
  /// This would typically be called from a webhook handler
  ///
  /// [code] - The linking code user sent to the bot
  /// [chatId] - Telegram chat ID from the message
  _i2.Future<bool> linkTelegramAccount(
    String code,
    String chatId,
  ) => caller.callServerEndpoint<bool>(
    'verificationPreferences',
    'linkTelegramAccount',
    {
      'code': code,
      'chatId': chatId,
    },
  );

  /// Unlink Telegram account
  _i2.Future<bool> unlinkTelegramAccount() => caller.callServerEndpoint<bool>(
    'verificationPreferences',
    'unlinkTelegramAccount',
    {},
  );

  /// Send verification code to phone number for WhatsApp
  ///
  /// [phoneNumber] - Phone number in E.164 format
  _i2.Future<_i22.VerificationResponse> sendPhoneVerificationCode(
    String phoneNumber,
  ) => caller.callServerEndpoint<_i22.VerificationResponse>(
    'verificationPreferences',
    'sendPhoneVerificationCode',
    {'phoneNumber': phoneNumber},
  );

  /// Verify phone number with code
  ///
  /// [phoneNumber] - Phone number that was verified
  /// [code] - Verification code received via WhatsApp
  _i2.Future<bool> verifyPhoneNumber(
    String phoneNumber,
    String code,
  ) => caller.callServerEndpoint<bool>(
    'verificationPreferences',
    'verifyPhoneNumber',
    {
      'phoneNumber': phoneNumber,
      'code': code,
    },
  );

  /// Get Telegram bot info for user to link account
  ///
  /// Returns the bot username and URL for user to start conversation
  _i2.Future<Map<String, String?>> getTelegramBotInfo() =>
      caller.callServerEndpoint<Map<String, String?>>(
        'verificationPreferences',
        'getTelegramBotInfo',
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
  _i2.Future<_i27.GreetingResponse> hello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Example endpoint using the MasterFabric middleware system.
///
/// This demonstrates how to use the new middleware-based approach
/// instead of manual rate limiting and logging calls.
///
/// Key differences from the original GreetingEndpoint:
/// - Extends [MasterfabricEndpoint] instead of [Endpoint]
/// - Uses [executeWithMiddleware] to wrap method logic
/// - Rate limiting, logging, auth, and metrics are handled automatically
/// - Can customize middleware behavior via [middlewareConfig]
///
/// Usage from client:
/// ```dart
/// final response = await client.greetingV2.hello('World');
/// ```
/// {@category Endpoint}
class EndpointGreetingV2 extends EndpointMasterfabric {
  EndpointGreetingV2(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greetingV2';

  /// Returns a personalized greeting message: "Hello {name}".
  ///
  /// Middleware automatically handles:
  /// - Rate limiting (20 requests/minute)
  /// - Request/response logging
  /// - Metrics collection
  /// - Error handling
  _i2.Future<_i27.GreetingResponse> hello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV2',
        'hello',
        {'name': name},
      );

  /// Example of a public method (no authentication required).
  ///
  /// Uses per-method configuration to skip auth middleware.
  _i2.Future<_i27.GreetingResponse> helloPublic(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV2',
        'helloPublic',
        {'name': name},
      );

  /// Example of a method with strict rate limiting.
  ///
  /// Uses per-method configuration for stricter limits.
  _i2.Future<_i27.GreetingResponse> helloStrict(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV2',
        'helloStrict',
        {'name': name},
      );
}

/// Example endpoint demonstrating RBAC (Role-Based Access Control) integration.
///
/// This endpoint showcases how to use the [RbacEndpointMixin] to define
/// role and permission requirements at both endpoint and method levels.
///
/// ## Key Features:
/// - Endpoint-level role requirements (applied to all methods)
/// - Method-specific role requirements (override/add to endpoint roles)
/// - Permission-based access control
/// - Public methods that bypass authentication
/// - Admin-only methods
///
/// ## Usage from client:
/// ```dart
/// // Regular user greeting (requires 'user' role)
/// final response = await client.greetingV3.hello('World');
///
/// // Admin-only greeting (requires 'admin' role)
/// final adminResponse = await client.greetingV3.adminHello('Admin');
///
/// // Public greeting (no authentication required)
/// final publicResponse = await client.greetingV3.publicHello('Guest');
/// ```
///
/// ## Role Requirements:
/// - `publicHello`: No auth required (public)
/// - `hello`: Requires 'user' role
/// - `goodbye`: Requires 'user' role
/// - `adminHello`: Requires 'user' OR 'admin' role
/// - `moderatorHello`: Requires 'moderator' OR 'admin' role
/// - `deleteGreeting`: Requires 'user' AND 'admin' (both!)
/// - `strictHello`: Requires 'user' role + 5 req/min limit
/// {@category Endpoint}
class EndpointGreetingV3 extends EndpointMasterfabric {
  EndpointGreetingV3(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greetingV3';

  /// Returns a personalized greeting message: "Hello {name}".
  ///
  /// **Required Roles:** 'user'
  ///
  /// This method demonstrates the basic RBAC pattern where
  /// only authenticated users with the 'user' role can access it.
  _i2.Future<_i27.GreetingResponse> hello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV3',
        'hello',
        {'name': name},
      );

  /// Returns a farewell message: "Goodbye {name}".
  ///
  /// **Required Roles:** 'user'
  _i2.Future<_i27.GreetingResponse> goodbye(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV3',
        'goodbye',
        {'name': name},
      );

  /// Admin greeting with special privileges.
  ///
  /// **Required Roles:** 'user' OR 'admin' (either role grants access)
  ///
  /// This demonstrates the OR pattern where having ANY of the
  /// specified roles grants access to the method.
  _i2.Future<_i27.GreetingResponse> adminHello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV3',
        'adminHello',
        {'name': name},
      );

  /// Delete a greeting (requires both 'user' AND 'admin' roles).
  ///
  /// **Required Roles:** 'user' AND 'admin' (both roles required)
  ///
  /// This demonstrates the requireAllRoles=true pattern where
  /// the user must have ALL specified roles.
  _i2.Future<bool> deleteGreeting(String greetingId) =>
      caller.callServerEndpoint<bool>(
        'greetingV3',
        'deleteGreeting',
        {'greetingId': greetingId},
      );

  /// Moderator greeting with moderation privileges.
  ///
  /// **Required Roles:** 'moderator' OR 'admin' (either role grants access)
  ///
  /// Demonstrates allowing multiple roles where having ANY one is sufficient.
  _i2.Future<_i27.GreetingResponse> moderatorHello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV3',
        'moderatorHello',
        {'name': name},
      );

  /// Public greeting that doesn't require authentication.
  ///
  /// **Required Roles:** None (public endpoint)
  ///
  /// This demonstrates how to bypass authentication for specific methods
  /// using the [skipAuth] configuration.
  _i2.Future<_i27.GreetingResponse> publicHello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV3',
        'publicHello',
        {'name': name},
      );

  /// Greeting with strict rate limiting.
  ///
  /// **Required Roles:** 'user'
  /// **Rate Limit:** 5 requests per minute
  ///
  /// Demonstrates combining RBAC with custom rate limiting.
  _i2.Future<_i27.GreetingResponse> strictHello(String name) =>
      caller.callServerEndpoint<_i27.GreetingResponse>(
        'greetingV3',
        'strictHello',
        {'name': name},
      );
}

/// Health check endpoint for monitoring ALL service status
/// {@category Endpoint}
class EndpointHealth extends _i1.EndpointRef {
  EndpointHealth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  /// Check health of ALL services
  ///
  /// Returns health status for all infrastructure and application services
  _i2.Future<_i28.HealthCheckResponse> check() =>
      caller.callServerEndpoint<_i28.HealthCheckResponse>(
        'health',
        'check',
        {},
      );

  /// Quick ping check - minimal overhead
  _i2.Future<String> ping() => caller.callServerEndpoint<String>(
    'health',
    'ping',
    {},
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
  _i2.Future<_i29.TranslationResponse> getTranslations({
    String? locale,
    String? namespace,
  }) => caller.callServerEndpoint<_i29.TranslationResponse>(
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
  _i2.Future<_i29.TranslationResponse> saveTranslations(
    String locale,
    Map<String, dynamic> translations, {
    String? namespace,
    required bool isActive,
  }) => caller.callServerEndpoint<_i29.TranslationResponse>(
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
    serverpod_auth_idp = _i11.Caller(client);
    serverpod_auth_core = _i12.Caller(client);
  }

  late final _i11.Caller serverpod_auth_idp;

  late final _i12.Caller serverpod_auth_core;
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
         _i30.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    notification = EndpointNotification(this);
    notificationStream = EndpointNotificationStream(this);
    appConfig = EndpointAppConfig(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    appleAuth = EndpointAppleAuth(this);
    googleAuth = EndpointGoogleAuth(this);
    passwordManagement = EndpointPasswordManagement(this);
    rbac = EndpointRbac(this);
    sessionManagement = EndpointSessionManagement(this);
    twoFactor = EndpointTwoFactor(this);
    accountManagement = EndpointAccountManagement(this);
    userManagement = EndpointUserManagement(this);
    userProfile = EndpointUserProfile(this);
    verificationPreferences = EndpointVerificationPreferences(this);
    greeting = EndpointGreeting(this);
    greetingV2 = EndpointGreetingV2(this);
    greetingV3 = EndpointGreetingV3(this);
    health = EndpointHealth(this);
    translation = EndpointTranslation(this);
    modules = Modules(this);
  }

  late final EndpointNotification notification;

  late final EndpointNotificationStream notificationStream;

  late final EndpointAppConfig appConfig;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAppleAuth appleAuth;

  late final EndpointGoogleAuth googleAuth;

  late final EndpointPasswordManagement passwordManagement;

  late final EndpointRbac rbac;

  late final EndpointSessionManagement sessionManagement;

  late final EndpointTwoFactor twoFactor;

  late final EndpointAccountManagement accountManagement;

  late final EndpointUserManagement userManagement;

  late final EndpointUserProfile userProfile;

  late final EndpointVerificationPreferences verificationPreferences;

  late final EndpointGreeting greeting;

  late final EndpointGreetingV2 greetingV2;

  late final EndpointGreetingV3 greetingV3;

  late final EndpointHealth health;

  late final EndpointTranslation translation;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'notification': notification,
    'notificationStream': notificationStream,
    'appConfig': appConfig,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'appleAuth': appleAuth,
    'googleAuth': googleAuth,
    'passwordManagement': passwordManagement,
    'rbac': rbac,
    'sessionManagement': sessionManagement,
    'twoFactor': twoFactor,
    'accountManagement': accountManagement,
    'userManagement': userManagement,
    'userProfile': userProfile,
    'verificationPreferences': verificationPreferences,
    'greeting': greeting,
    'greetingV2': greetingV2,
    'greetingV3': greetingV3,
    'health': health,
    'translation': translation,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
