import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../core/errors/base_error_handler.dart';
import '../../core/errors/error_types.dart';
import '../../core/logging/core_logger.dart';
import 'user_profile_service.dart';
import 'auth_helper_service.dart';

/// Endpoint for user profile management
/// 
/// Provides endpoints for getting, updating, and managing user profiles.
class UserProfileEndpoint extends Endpoint {
  final UserProfileService _profileService = UserProfileService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();
  final AuthHelperService _authHelper = AuthHelperService();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Get current user's profile
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns UserProfileModel for the authenticated user
  /// 
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if profile not found
  Future<UserProfileModel> getProfile(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Profile requested');

      final userId = await _authHelper.requireAuth(session);
      final profile = await _profileService.getProfileByUserId(
        session,
        userId,
      );

      if (profile == null) {
        throw NotFoundError('User profile not found');
      }

      logger.info('Profile retrieved successfully', context: {
        'userId': profile.authUserId.toString(),
      });

      return profile;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get profile: ${e.toString()}',
      );
    }
  }

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
  Future<UserProfileModel> updateProfile(
    Session session, {
    String? fullName,
    String? userName,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Profile update requested', context: {
        'fields': [
          if (fullName != null) 'fullName',
          if (userName != null) 'userName',
        ],
      });

      final updatedProfile = await _profileService.updateProfile(
        session,
        fullName: fullName,
        userName: userName,
      );

      logger.info('Profile updated successfully', context: {
        'userId': updatedProfile.authUserId.toString(),
      });

      return updatedProfile;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to update profile: ${e.toString()}',
      );
    }
  }

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
  Future<UserProfileModel> uploadProfileImage(
    Session session,
    List<int> image,
    String fileName,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Profile image upload requested', context: {
        'fileName': fileName,
        'size': image.length,
      });

      final updatedProfile = await _profileService.uploadProfileImage(
        session,
        image,
        fileName,
      );

      logger.info('Profile image uploaded successfully', context: {
        'userId': updatedProfile.authUserId.toString(),
      });

      return updatedProfile;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to upload profile image: ${e.toString()}',
      );
    }
  }

  /// Delete profile image
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns updated UserProfileModel without image
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<UserProfileModel> deleteProfileImage(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Profile image deletion requested');

      final updatedProfile = await _profileService.deleteProfileImage(session);

      logger.info('Profile image deleted successfully', context: {
        'userId': updatedProfile.authUserId.toString(),
      });

      return updatedProfile;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to delete profile image: ${e.toString()}',
      );
    }
  }
}
