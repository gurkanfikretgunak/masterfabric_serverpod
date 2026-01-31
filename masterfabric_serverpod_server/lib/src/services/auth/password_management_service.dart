import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../core/errors/error_types.dart';
import 'auth_helper_service.dart';

/// Password strength validation result
class PasswordStrength {
  final bool isValid;
  final int score; // 0-4 (0=weak, 4=very strong)
  final List<String> issues;

  PasswordStrength({
    required this.isValid,
    required this.score,
    required this.issues,
  });
}

/// Password management service
/// 
/// Handles password operations including validation, strength checking, and changes.
class PasswordManagementService {
  final AuthHelperService _authHelper = AuthHelperService();

  /// Validate password strength
  /// 
  /// [password] - Password to validate
  /// [minLength] - Minimum length (default: 8)
  /// [requireUppercase] - Require uppercase letters (default: true)
  /// [requireLowercase] - Require lowercase letters (default: true)
  /// [requireNumbers] - Require numbers (default: true)
  /// [requireSpecialChars] - Require special characters (default: true)
  /// 
  /// Returns PasswordStrength with validation result
  PasswordStrength validatePasswordStrength(
    String password, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
  }) {
    final issues = <String>[];
    var score = 0;

    // Length check
    if (password.length < minLength) {
      issues.add('Password must be at least $minLength characters long');
    } else {
      score++;
    }

    // Uppercase check
    if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) {
      issues.add('Password must contain at least one uppercase letter');
    } else if (requireUppercase) {
      score++;
    }

    // Lowercase check
    if (requireLowercase && !password.contains(RegExp(r'[a-z]'))) {
      issues.add('Password must contain at least one lowercase letter');
    } else if (requireLowercase) {
      score++;
    }

    // Numbers check
    if (requireNumbers && !password.contains(RegExp(r'[0-9]'))) {
      issues.add('Password must contain at least one number');
    } else if (requireNumbers) {
      score++;
    }

    // Special characters check
    if (requireSpecialChars && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      issues.add('Password must contain at least one special character');
    } else if (requireSpecialChars) {
      score++;
    }

    // Additional strength checks
    if (password.length >= 12) {
      score++;
    }
    if (password.length >= 16) {
      score++;
    }

    // Cap score at 4
    score = score.clamp(0, 4);

    return PasswordStrength(
      isValid: issues.isEmpty,
      score: score,
      issues: issues,
    );
  }

  /// Change user password
  /// 
  /// [session] - Serverpod session
  /// [currentPassword] - Current password for verification
  /// [newPassword] - New password
  /// [minLength] - Minimum password length (default: 8)
  /// [requireUppercase] - Require uppercase letters (default: true)
  /// [requireLowercase] - Require lowercase letters (default: true)
  /// [requireNumbers] - Require numbers (default: true)
  /// [requireSpecialChars] - Require special characters (default: true)
  /// 
  /// Throws ValidationError if password validation fails
  /// Throws AuthenticationError if current password is incorrect or user not authenticated
  Future<void> changePassword(
    Session session, {
    required String currentPassword,
    required String newPassword,
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
  }) async {
    // Require authentication
    final userId = await _authHelper.requireAuth(session);
    await _authHelper.requireNotBlocked(session);

    // Validate new password strength
    final strength = validatePasswordStrength(
      newPassword,
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumbers: requireNumbers,
      requireSpecialChars: requireSpecialChars,
    );

    if (!strength.isValid) {
      throw ValidationError(
        'Password does not meet requirements',
        details: {
          'issues': strength.issues,
          'score': strength.score,
        },
      );
    }

    // Check that new password is different from current
    if (currentPassword == newPassword) {
      throw ValidationError(
        'New password must be different from current password',
        details: {'field': 'newPassword'},
      );
    }

    // Verify current password and update
    // Get user's email from profile
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw AuthenticationError('Authentication required');
    }

    final profile = await authInfo.userProfile(session);
    if (profile == null || profile.email == null) {
      throw NotFoundError('User profile or email not found');
    }

    // Get the EmailIdp from AuthServices
    final emailIdp = AuthServices.instance.emailIdp;

    // Verify current password by attempting authentication
    try {
      await emailIdp.utils.authentication.authenticate(
        session,
        email: profile.email!,
        password: currentPassword,
        transaction: null,
      );
      // If authentication succeeds, password is correct
    } catch (e) {
      // If authentication fails, current password is incorrect
      throw AuthenticationError(
        'Current password is incorrect',
        details: {'field': 'currentPassword'},
      );
    }

    // Password verified, now update it using admin method
    await emailIdp.admin.setPassword(
      session,
      email: profile.email!,
      password: newPassword,
    );

    session.log(
      'Password changed successfully',
      level: LogLevel.info,
    );
  }

  /// Validate password without changing it
  /// 
  /// [password] - Password to validate
  /// [minLength] - Minimum password length (default: 8)
  /// [requireUppercase] - Require uppercase letters (default: true)
  /// [requireLowercase] - Require lowercase letters (default: true)
  /// [requireNumbers] - Require numbers (default: true)
  /// [requireSpecialChars] - Require special characters (default: true)
  /// 
  /// Returns PasswordStrength with validation result
  PasswordStrength validatePassword(
    String password, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
  }) {
    return validatePasswordStrength(
      password,
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumbers: requireNumbers,
      requireSpecialChars: requireSpecialChars,
    );
  }
}
