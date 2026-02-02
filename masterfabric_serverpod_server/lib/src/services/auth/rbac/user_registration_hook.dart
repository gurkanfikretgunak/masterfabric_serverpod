import 'package:serverpod/serverpod.dart';
import 'rbac_service.dart';

/// Hook for user registration events
///
/// This class provides methods to be called after user registration
/// to set up the user's initial roles and permissions.
///
/// ## Usage
///
/// Call [onUserRegistered] after a user successfully signs up:
///
/// ```dart
/// // In your registration flow
/// final userId = await registerUser(session, email, password);
/// await UserRegistrationHook.onUserRegistered(session, userId);
/// ```
///
/// Or configure it to be called automatically by setting up the
/// [AuthConfig] with a callback.
class UserRegistrationHook {
  static final RbacService _rbacService = RbacService();

  /// Called when a new user has been registered
  ///
  /// This method:
  /// 1. Assigns the default 'user' role to the new user
  /// 2. Logs the registration event
  ///
  /// [session] - Serverpod session
  /// [userId] - The newly registered user's ID
  static Future<void> onUserRegistered(
    Session session,
    UuidValue userId,
  ) async {
    session.log(
      'UserRegistrationHook: Processing new user ${userId.toString()}',
      level: LogLevel.info,
    );

    // Assign default role
    await _rbacService.assignDefaultRoleToUser(session, userId);

    session.log(
      'UserRegistrationHook: User ${userId.toString()} setup complete',
      level: LogLevel.info,
    );
  }

  /// Called when a new user has been registered (string userId version)
  ///
  /// Convenience method that accepts string userId.
  static Future<void> onUserRegisteredString(
    Session session,
    String userId,
  ) async {
    await onUserRegistered(session, UuidValue.fromString(userId));
  }

  /// Initialize the RBAC system
  ///
  /// This should be called once during server startup to:
  /// 1. Seed default roles into the database
  ///
  /// [session] - Serverpod session
  /// [force] - If true, update existing roles with default configurations
  static Future<void> initialize(Session session, {bool force = false}) async {
    session.log(
      'UserRegistrationHook: Initializing RBAC system...',
      level: LogLevel.info,
    );

    await _rbacService.seedDefaultRoles(session, force: force);

    session.log(
      'UserRegistrationHook: RBAC system initialized',
      level: LogLevel.info,
    );
  }

  /// Callback function type for user registration
  ///
  /// Use this with auth providers that support registration callbacks.
  static Future<void> Function(Session, UuidValue) get registrationCallback {
    return onUserRegistered;
  }
}

/// Extension on Session to easily access RBAC initialization
extension SessionRbacExtension on Session {
  /// Initialize RBAC for the session
  ///
  /// This seeds default roles if they don't exist.
  Future<void> initializeRbac({bool force = false}) async {
    await UserRegistrationHook.initialize(this, force: force);
  }

  /// Assign default role to a user
  Future<void> assignDefaultRoleToUser(UuidValue userId) async {
    await UserRegistrationHook.onUserRegistered(this, userId);
  }
}
