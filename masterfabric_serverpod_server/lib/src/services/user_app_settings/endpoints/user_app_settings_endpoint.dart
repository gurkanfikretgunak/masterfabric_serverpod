import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/logging/core_logger.dart';
import '../services/user_app_settings_service.dart';
import '../services/user_app_settings_stream_service.dart';
import '../../auth/core/auth_helper_service.dart';
import '../../auth/verification/verification_service.dart';

/// User app settings endpoint with RBAC (Role-Based Access Control).
///
/// ## Role Requirements:
/// - All methods: Requires 'user' role
///
/// ## Hard Settings (require verification code):
/// - `twoFactorEnabled`: Requires verification code to enable/disable
///
/// Usage from client:
/// ```dart
/// // Get settings
/// final response = await client.userAppSettings.get();
///
/// // Update settings
/// final updateResponse = await client.userAppSettings.update(
///   UserAppSettingsUpdateRequest(
///     pushNotifications: true,
///     emailNotifications: false,
///   ),
/// );
///
/// // Update hard setting (requires verification code)
/// final hardUpdateResponse = await client.userAppSettings.update(
///   UserAppSettingsUpdateRequest(
///     twoFactorEnabled: true,
///     verificationCode: '123456',
///   ),
/// );
/// ```
class UserAppSettingsEndpoint extends MasterfabricEndpoint with RbacEndpointMixin {
  final UserAppSettingsService _settingsService = UserAppSettingsService();
  final AuthHelperService _authHelper = AuthHelperService();
  final VerificationService _verificationService = VerificationService();

  static const String _settingsUpdatePurpose = 'settings_update';

  /// Endpoint-level role requirements.
  ///
  /// All methods require 'user' role by default.
  @override
  List<String> get requiredRoles => ['user'];

  /// Middleware configuration for this endpoint.
  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'user_app_settings',
        ),
      );

  // ============================================================
  // USER-LEVEL METHODS (require 'user' role)
  // ============================================================

  /// Get current user's app settings.
  ///
  /// **Required Roles:** 'user'
  ///
  /// Returns user's app settings, creating default if not exists.
  Future<UserAppSettingsResponse> get(Session session) async {
    return executeWithRbac(
      session: session,
      methodName: 'get',
      parameters: {},
      handler: () async {
        final logger = CoreLogger(session);
        final userId = await _authHelper.requireAuth(session);

        logger.info('Settings requested', context: {'userId': userId.toString()});

        final settings = await _settingsService.getOrCreateSettings(
          session,
          userId.toString(),
        );

        return UserAppSettingsResponse(
          success: true,
          message: 'Settings retrieved successfully',
          settings: settings,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  /// Update user's app settings.
  ///
  /// **Required Roles:** 'user'
  ///
  /// For hard settings (like twoFactorEnabled), a verification code is required.
  ///
  /// [request] - Update request with new values
  ///
  /// Returns updated settings
  Future<UserAppSettingsResponse> update(
    Session session,
    UserAppSettingsUpdateRequest request,
  ) async {
    return executeWithRbac(
      session: session,
      methodName: 'update',
      parameters: {'request': request.toJson()},
      handler: () async {
        final logger = CoreLogger(session);
        final userId = await _authHelper.requireAuth(session);

        logger.info('Settings update requested', context: {
          'userId': userId.toString(),
        });

        // Check if updating hard settings
        final isUpdatingHardSetting = request.twoFactorEnabled != null;

        if (isUpdatingHardSetting) {
          // Verify code is provided
          if (request.verificationCode == null || request.verificationCode!.isEmpty) {
            throw ValidationError(
              'Verification code is required for changing hard settings',
              details: {'field': 'verificationCode', 'reason': 'required_for_hard_setting'},
            );
          }

          // Verify the code
          await _verificationService.verifyCode(
            session,
            userId.toString(),
            request.verificationCode!,
            _settingsUpdatePurpose,
          );

          logger.info('Verification code validated for hard setting update', context: {
            'userId': userId.toString(),
          });
        }

        // Update settings
        final updated = await _settingsService.updateSettings(
          session,
          userId.toString(),
          request,
        );

        // Broadcast update event to stream listeners
        await _broadcastSettingsUpdate(session, userId.toString(), updated);

        return UserAppSettingsResponse(
          success: true,
          message: 'Settings updated successfully',
          settings: updated,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  /// Request verification code for updating hard settings.
  ///
  /// **Required Roles:** 'user'
  ///
  /// Returns VerificationResponse with status and expiration.
  Future<VerificationResponse> requestVerificationCode(Session session) async {
    return executeWithRbac(
      session: session,
      methodName: 'requestVerificationCode',
      parameters: {},
      handler: () async {
        final logger = CoreLogger(session);
        final userId = await _authHelper.requireAuth(session);

        logger.info('Verification code requested for settings update', context: {
          'userId': userId.toString(),
        });

        final response = await _verificationService.requestVerificationCode(
          session,
          userId.toString(),
          _settingsUpdatePurpose,
        );

        return response;
      },
    );
  }

  /// Delete user's app settings (for account deletion).
  ///
  /// **Required Roles:** 'user'
  ///
  /// This is a hard operation and should require additional verification.
  Future<UserAppSettingsResponse> delete(Session session) async {
    return executeWithRbac(
      session: session,
      methodName: 'delete',
      parameters: {},
      handler: () async {
        final logger = CoreLogger(session);
        final userId = await _authHelper.requireAuth(session);

        logger.info('Settings deletion requested', context: {
          'userId': userId.toString(),
        });

        await _settingsService.deleteSettings(session, userId.toString());

        // Broadcast deletion event
        await _broadcastSettingsDelete(session, userId.toString());

        return UserAppSettingsResponse(
          success: true,
          message: 'Settings deleted successfully',
          settings: null,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  /// Broadcast settings update to stream listeners
  Future<void> _broadcastSettingsUpdate(
    Session session,
    String userId,
    UserAppSettings settings,
  ) async {
    try {
      final streamService = UserAppSettingsStreamService.instance;
      streamService.broadcastUpdate(session, userId, settings);
    } catch (e) {
      session.log(
        'Failed to broadcast settings update: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Broadcast settings deletion to stream listeners
  Future<void> _broadcastSettingsDelete(Session session, String userId) async {
    try {
      final streamService = UserAppSettingsStreamService.instance;
      streamService.broadcastDelete(session, userId);
    } catch (e) {
      session.log(
        'Failed to broadcast settings deletion: $e',
        level: LogLevel.warning,
      );
    }
  }
}
