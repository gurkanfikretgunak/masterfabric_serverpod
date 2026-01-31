import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../core/errors/error_types.dart';

/// Authentication helper service
/// 
/// Provides common authentication utilities and helpers for endpoints.
class AuthHelperService {
  /// Get the current authenticated user's ID
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns the user identifier (UuidValue) if authenticated, null otherwise
  /// 
  /// Throws AuthenticationError if user is not authenticated
  Future<UuidValue> requireAuth(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw AuthenticationError(
        'Authentication required',
        details: {'endpoint': session.endpoint},
      );
    }
    // userIdentifier might be UuidValue or String, handle both
    if (authInfo.userIdentifier is UuidValue) {
      return authInfo.userIdentifier as UuidValue;
    }
    return UuidValue.fromString(authInfo.userIdentifier.toString());
  }

  /// Get the current authenticated user's ID (nullable)
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns the user identifier if authenticated, null otherwise
  Future<UuidValue?> getCurrentUserId(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    
    if (authInfo.userIdentifier is UuidValue) {
      return authInfo.userIdentifier as UuidValue;
    }
    return UuidValue.fromString(authInfo.userIdentifier.toString());
  }

  /// Check if the current session is authenticated
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns true if user is authenticated, false otherwise
  Future<bool> isAuthenticated(Session session) async {
    final authInfo = session.authenticated;
    return authInfo != null;
  }

  /// Get the current user's profile
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns UserProfile if authenticated, null otherwise
  /// 
  /// Throws AuthenticationError if user is not authenticated
  Future<UserProfile> requireUserProfile(Session session) async {
    final userId = await requireAuth(session);
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw AuthenticationError('Authentication required');
    }

    final userProfile = await authInfo.userProfile(session);
    if (userProfile == null) {
      throw NotFoundError(
        'User profile not found',
        details: {'userId': userId.toString()},
      );
    }

    // UserProfileModel from serverpod_auth_core_server is compatible with UserProfile
    return userProfile as UserProfile;
  }

  /// Get the current user's profile (nullable)
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns UserProfile if authenticated and profile exists, null otherwise
  Future<UserProfile?> getUserProfile(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) {
      return null;
    }

    final profileModel = await authInfo.userProfile(session);
    return profileModel as UserProfile?;
  }

  /// Get the current authenticated user (AuthUser)
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns AuthUser if authenticated, null otherwise
  /// 
  /// Throws AuthenticationError if user is not authenticated
  Future<AuthUser> requireAuthUser(Session session) async {
    final userId = await requireAuth(session);
    
    final authUser = await AuthUser.db.findById(session, userId);

    if (authUser == null) {
      throw NotFoundError(
        'User not found',
        details: {'userId': userId.toString()},
      );
    }

    return authUser;
  }

  /// Check if user is blocked
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns true if user is blocked, false otherwise
  /// 
  /// Throws AuthenticationError if user is not authenticated
  Future<bool> isUserBlocked(Session session) async {
    final authUser = await requireAuthUser(session);
    return authUser.blocked;
  }

  /// Require that the user is not blocked
  /// 
  /// [session] - Serverpod session
  /// 
  /// Throws AuthenticationError if user is blocked
  Future<void> requireNotBlocked(Session session) async {
    final isBlocked = await isUserBlocked(session);
    if (isBlocked) {
      throw AuthenticationError(
        'Your account has been blocked',
        details: {'reason': 'account_blocked'},
      );
    }
  }
}
