import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../../core/utils/common_utils.dart';
import '../../../core/errors/error_types.dart';
import '../core/auth_helper_service.dart';

/// User profile service
/// 
/// Handles user profile operations including validation, updates, and image management.
class UserProfileService {
  final AuthHelperService _authHelper = AuthHelperService();

  /// Get user profile by user ID
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// 
  /// Returns UserProfileModel if found, null otherwise
  Future<UserProfileModel?> getProfileByUserId(
    Session session,
    UuidValue userId,
  ) async {
    return await AuthServices.instance.userProfiles.maybeFindUserProfileByUserId(
      session,
      userId,
    );
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
    // Require authentication
    final userId = await _authHelper.requireAuth(session);
    await _authHelper.requireNotBlocked(session);

    // Get current profile
    final currentProfile = await AuthServices.instance.userProfiles.maybeFindUserProfileByUserId(
      session,
      userId,
    );

    if (currentProfile == null) {
      throw NotFoundError('User profile not found');
    }

    // Validate inputs
    if (fullName != null && fullName.trim().isEmpty) {
      throw ValidationError(
        'Full name cannot be empty',
        details: {'field': 'fullName'},
      );
    }

    if (userName != null) {
      final trimmedUserName = userName.trim();
      if (trimmedUserName.isEmpty) {
        throw ValidationError(
          'Username cannot be empty',
          details: {'field': 'userName'},
        );
      }

      // Validate username format (alphanumeric, underscore, hyphen, 3-30 chars)
      if (!RegExp(r'^[a-zA-Z0-9_-]{3,30}$').hasMatch(trimmedUserName)) {
        throw ValidationError(
          'Username must be 3-30 characters and contain only letters, numbers, underscores, and hyphens',
          details: {'field': 'userName'},
        );
      }
    }

    UserProfileModel result = currentProfile;

    // Update full name if provided
    if (fullName != null) {
      result = await AuthServices.instance.userProfiles.changeFullName(
        session,
        userId,
        fullName,
      );
    }

    // Update user name if provided
    if (userName != null) {
      result = await AuthServices.instance.userProfiles.changeUserName(
        session,
        userId,
        userName,
      );
    }

    session.log(
      'User profile updated - userId: ${userId.toString()}',
      level: LogLevel.info,
    );

    return result;
  }

  /// Upload profile image
  /// 
  /// [session] - Serverpod session
  /// [imageBytes] - Image file bytes
  /// [fileName] - Original file name
  /// 
  /// Returns updated UserProfileModel with image URL
  /// 
  /// Throws ValidationError if image is invalid
  /// Throws AuthenticationError if not authenticated
  Future<UserProfileModel> uploadProfileImage(
    Session session,
    List<int> imageBytes,
    String fileName,
  ) async {
    // Require authentication
    final userId = await _authHelper.requireAuth(session);
    await _authHelper.requireNotBlocked(session);

    // Validate image size (max 5MB)
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (imageBytes.length > maxSize) {
      throw ValidationError(
        'Image size exceeds maximum allowed size of 5MB',
        details: {'field': 'image', 'maxSize': maxSize},
      );
    }

    // Validate file extension
    final extension = fileName.split('.').last.toLowerCase();
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    if (!allowedExtensions.contains(extension)) {
      throw ValidationError(
        'Invalid image format. Allowed formats: ${allowedExtensions.join(", ")}',
        details: {'field': 'image', 'extension': extension},
      );
    }

    // Use the UserProfiles API to set the image
    final result = await AuthServices.instance.userProfiles.setUserImageFromBytes(
      session,
      userId,
      Uint8List.fromList(imageBytes),
    );

    session.log(
      'Profile image uploaded - userId: ${userId.toString()}',
      level: LogLevel.info,
    );

    return result;
  }

  /// Delete profile image
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns updated UserProfileModel without image
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<UserProfileModel> deleteProfileImage(Session session) async {
    // Require authentication
    final userId = await _authHelper.requireAuth(session);
    await _authHelper.requireNotBlocked(session);

    final result = await AuthServices.instance.userProfiles.removeUserImage(
      session,
      userId,
    );

    session.log(
      'Profile image deleted - userId: ${userId.toString()}',
      level: LogLevel.info,
    );

    return result;
  }
}
