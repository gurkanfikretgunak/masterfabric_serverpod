import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/base_error_handler.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/logging/core_logger.dart';
import 'user_profile_service.dart';
import '../core/auth_helper_service.dart';
import '../verification/verification_service.dart';

/// Endpoint for user profile management
/// 
/// Provides endpoints for getting, updating, and managing user profiles.
class UserProfileEndpoint extends Endpoint {
  final UserProfileService _profileService = UserProfileService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();
  final AuthHelperService _authHelper = AuthHelperService();
  final VerificationService _verificationService = VerificationService();
  
  static const String _profileUpdatePurpose = 'profile_update';

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Get available gender options
  /// 
  /// Returns list of Gender enum values for UI dropdown
  Future<List<Gender>> getGenderOptions(Session session) async {
    return Gender.values;
  }

  /// Request a verification code for profile update
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns VerificationResponse with status and expiration
  /// 
  /// The code will be sent to the user's email (logged in dev mode)
  Future<VerificationResponse> requestProfileUpdateCode(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Profile update verification code requested');

      final userId = await _authHelper.requireAuth(session);
      
      final response = await _verificationService.requestVerificationCode(
        session,
        userId.toString(),
        _profileUpdatePurpose,
      );

      logger.info('Verification code sent', context: {
        'userId': userId.toString(),
      });

      return response;
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to request verification code: ${e.toString()}',
      );
    }
  }

  /// Update profile with verification code
  /// 
  /// [session] - Serverpod session
  /// [request] - ProfileUpdateRequest containing verification code and update data
  /// 
  /// Returns updated CurrentUserResponse
  /// 
  /// Throws ValidationError if verification code is invalid
  Future<CurrentUserResponse> updateProfileWithVerification(
    Session session,
    ProfileUpdateRequest request,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Profile update with verification requested');

      final userId = await _authHelper.requireAuth(session);

      // Verify the code first
      await _verificationService.verifyCode(
        session,
        userId.toString(),
        request.verificationCode,
        _profileUpdatePurpose,
      );

      logger.info('Verification code validated', context: {
        'userId': userId.toString(),
      });

      // Update basic profile (fullName, userName)
      if (request.fullName != null || request.userName != null) {
        await _profileService.updateProfile(
          session,
          fullName: request.fullName,
          userName: request.userName,
        );
      }

      // Update extended profile (birthDate, gender)
      if (request.birthDate != null || request.gender != null) {
        final extendedProfiles = await UserProfileExtended.db.find(
          session,
          where: (t) => t.userId.equals(userId.toString()),
          limit: 1,
        );

        if (extendedProfiles.isNotEmpty) {
          final existing = extendedProfiles.first;
          final updated = existing.copyWith(
            birthDate: request.birthDate,
            gender: request.gender,
          );
          await UserProfileExtended.db.updateRow(session, updated);
        } else {
          final newProfile = UserProfileExtended(
            userId: userId.toString(),
            birthDate: request.birthDate,
            gender: request.gender,
          );
          await UserProfileExtended.db.insertRow(session, newProfile);
        }
      }

      logger.info('Profile updated with verification', context: {
        'userId': userId.toString(),
      });

      return getCurrentUser(session);
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

  /// Get current user's complete information
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns CurrentUserResponse with all user details including createdAt
  /// 
  /// Throws AuthenticationError if not authenticated
  /// Throws NotFoundError if user not found
  Future<CurrentUserResponse> getCurrentUser(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Current user info requested');

      final userId = await _authHelper.requireAuth(session);
      
      // Get user profile
      final profile = await _profileService.getProfileByUserId(session, userId);
      if (profile == null) {
        throw NotFoundError('User profile not found');
      }

      // Get auth user for createdAt and blocked status  
      final authUsers = await AuthUser.db.find(
        session,
        where: (t) => t.id.equals(userId),
        limit: 1,
      );
      final authUser = authUsers.isNotEmpty ? authUsers.first : null;

      // Get extended profile data (birthDate, gender)
      final extendedProfiles = await UserProfileExtended.db.find(
        session,
        where: (t) => t.userId.equals(userId.toString()),
        limit: 1,
      );
      final extendedProfile = extendedProfiles.isNotEmpty ? extendedProfiles.first : null;

      logger.info('Current user info retrieved', context: {
        'userId': userId.toString(),
      });

      return CurrentUserResponse(
        id: userId.toString(),
        email: profile.email,
        fullName: profile.fullName,
        userName: profile.userName,
        imageUrl: profile.imageUrl?.toString(),
        createdAt: authUser?.createdAt ?? DateTime.now(),
        blocked: authUser?.blocked ?? false,
        emailVerified: true, // Assume verified if they can sign in
        birthDate: extendedProfile?.birthDate,
        gender: extendedProfile?.gender,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get current user: ${e.toString()}',
      );
    }
  }

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

  /// Update extended profile (birthDate, gender)
  /// 
  /// [session] - Serverpod session
  /// [birthDate] - Optional birth date
  /// [gender] - Optional gender
  /// 
  /// Returns updated CurrentUserResponse
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<CurrentUserResponse> updateExtendedProfile(
    Session session, {
    DateTime? birthDate,
    Gender? gender,
  }) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Extended profile update requested', context: {
        'fields': [
          if (birthDate != null) 'birthDate',
          if (gender != null) 'gender',
        ],
      });

      final userId = await _authHelper.requireAuth(session);
      
      // Find or create extended profile
      final extendedProfiles = await UserProfileExtended.db.find(
        session,
        where: (t) => t.userId.equals(userId.toString()),
        limit: 1,
      );

      if (extendedProfiles.isNotEmpty) {
        // Update existing
        final existing = extendedProfiles.first;
        final updated = existing.copyWith(
          birthDate: birthDate,
          gender: gender,
        );
        await UserProfileExtended.db.updateRow(session, updated);
      } else {
        // Create new
        final newProfile = UserProfileExtended(
          userId: userId.toString(),
          birthDate: birthDate,
          gender: gender,
        );
        await UserProfileExtended.db.insertRow(session, newProfile);
      }

      logger.info('Extended profile updated successfully', context: {
        'userId': userId.toString(),
      });

      // Return updated user info
      return getCurrentUser(session);
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to update extended profile: ${e.toString()}',
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
