import 'package:serverpod/serverpod.dart';
import '../../../core/integrations/integration_manager.dart';

/// Email service for sending authentication-related emails
/// 
/// Provides high-level methods for sending verification codes and other
/// authentication emails using the email integration.
class EmailService {
  final IntegrationManager? _integrationManager;

  EmailService(this._integrationManager);

  /// Send registration verification code email
  /// 
  /// [email] - Recipient email address
  /// [verificationCode] - Verification code to send
  /// [session] - Serverpod session for logging
  Future<void> sendRegistrationVerificationCode({
    required String email,
    required String verificationCode,
    required Session session,
  }) async {
    final emailIntegration = _integrationManager?.getIntegration('email');
    
    if (emailIntegration == null || !emailIntegration.enabled) {
      // Fallback to logging if email integration is not available
      session.log(
        '[EmailService] Registration verification code ($email): $verificationCode',
        level: LogLevel.info,
      );
      return;
    }

    final emailIntegrationTyped = emailIntegration as dynamic;
    
    final subject = 'Verify Your Email Address';
    final body = _buildRegistrationEmailBody(verificationCode);
    final htmlBody = _buildRegistrationEmailHtmlBody(verificationCode);

    try {
      await emailIntegrationTyped.sendEmail(
        to: email,
        subject: subject,
        body: body,
        htmlBody: htmlBody,
      );

      session.log(
        'Registration verification email sent to: $email',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to send registration verification email to $email: $e',
        level: LogLevel.error,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      // Don't throw - allow registration to continue even if email fails
      // The verification code is still logged for development
      session.log(
        '[EmailService] Registration verification code ($email): $verificationCode',
        level: LogLevel.info,
      );
    }
  }

  /// Send password reset verification code email
  /// 
  /// [email] - Recipient email address
  /// [verificationCode] - Verification code to send
  /// [session] - Serverpod session for logging
  Future<void> sendPasswordResetVerificationCode({
    required String email,
    required String verificationCode,
    required Session session,
  }) async {
    final emailIntegration = _integrationManager?.getIntegration('email');
    
    if (emailIntegration == null || !emailIntegration.enabled) {
      // Fallback to logging if email integration is not available
      session.log(
        '[EmailService] Password reset verification code ($email): $verificationCode',
        level: LogLevel.info,
      );
      return;
    }

    final emailIntegrationTyped = emailIntegration as dynamic;
    
    final subject = 'Reset Your Password';
    final body = _buildPasswordResetEmailBody(verificationCode);
    final htmlBody = _buildPasswordResetEmailHtmlBody(verificationCode);

    try {
      await emailIntegrationTyped.sendEmail(
        to: email,
        subject: subject,
        body: body,
        htmlBody: htmlBody,
      );

      session.log(
        'Password reset verification email sent to: $email',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to send password reset verification email to $email: $e',
        level: LogLevel.error,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      // Don't throw - allow password reset to continue even if email fails
      // The verification code is still logged for development
      session.log(
        '[EmailService] Password reset verification code ($email): $verificationCode',
        level: LogLevel.info,
      );
    }
  }

  /// Build plain text registration email body
  String _buildRegistrationEmailBody(String verificationCode) {
    return '''
Hello,

Thank you for registering! Please use the following verification code to complete your registration:

Verification Code: $verificationCode

This code will expire in 10 minutes.

If you did not request this verification code, please ignore this email.

Best regards,
The Team
''';
  }

  /// Build HTML registration email body
  String _buildRegistrationEmailHtmlBody(String verificationCode) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .code { font-size: 24px; font-weight: bold; color: #0066ff; padding: 10px; background: #f0f0f0; text-align: center; margin: 20px 0; }
    .footer { margin-top: 30px; font-size: 12px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <h2>Verify Your Email Address</h2>
    <p>Hello,</p>
    <p>Thank you for registering! Please use the following verification code to complete your registration:</p>
    <div class="code">$verificationCode</div>
    <p>This code will expire in 10 minutes.</p>
    <p>If you did not request this verification code, please ignore this email.</p>
    <div class="footer">
      <p>Best regards,<br>The Team</p>
    </div>
  </div>
</body>
</html>
''';
  }

  /// Build plain text password reset email body
  String _buildPasswordResetEmailBody(String verificationCode) {
    return '''
Hello,

You requested to reset your password. Please use the following verification code:

Verification Code: $verificationCode

This code will expire in 10 minutes.

If you did not request a password reset, please ignore this email and your password will remain unchanged.

Best regards,
The Team
''';
  }

  /// Build HTML password reset email body
  String _buildPasswordResetEmailHtmlBody(String verificationCode) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .code { font-size: 24px; font-weight: bold; color: #0066ff; padding: 10px; background: #f0f0f0; text-align: center; margin: 20px 0; }
    .footer { margin-top: 30px; font-size: 12px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <h2>Reset Your Password</h2>
    <p>Hello,</p>
    <p>You requested to reset your password. Please use the following verification code:</p>
    <div class="code">$verificationCode</div>
    <p>This code will expire in 10 minutes.</p>
    <p>If you did not request a password reset, please ignore this email and your password will remain unchanged.</p>
    <div class="footer">
      <p>Best regards,<br>The Team</p>
    </div>
  </div>
</body>
</html>
''';
  }

  /// Send generic verification code email
  /// 
  /// [session] - Serverpod session
  /// [to] - Recipient email address
  /// [code] - Verification code to send
  /// [purpose] - Purpose of verification (e.g., 'profile_update', 'login')
  /// [expiresInMinutes] - Code expiration time
  Future<void> sendVerificationCode(
    Session session, {
    required String to,
    required String code,
    required String purpose,
    int expiresInMinutes = 5,
  }) async {
    final emailIntegration = _integrationManager?.getIntegration('email');
    
    if (emailIntegration == null || !emailIntegration.enabled) {
      // Fallback to logging if email integration is not available
      session.log(
        '[EmailService] Verification code ($to, $purpose): $code',
        level: LogLevel.info,
      );
      return;
    }

    final emailIntegrationTyped = emailIntegration as dynamic;
    
    final subject = _getSubjectForPurpose(purpose);
    final body = _buildGenericEmailBody(code, purpose, expiresInMinutes);
    final htmlBody = _buildGenericEmailHtmlBody(code, purpose, expiresInMinutes);

    try {
      await emailIntegrationTyped.sendEmail(
        to: to,
        subject: subject,
        body: body,
        htmlBody: htmlBody,
      );

      session.log(
        'Verification email sent to: $to for purpose: $purpose',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to send verification email to $to: $e',
        level: LogLevel.error,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      // Fallback to logging
      session.log(
        '[EmailService] Verification code ($to, $purpose): $code',
        level: LogLevel.info,
      );
    }
  }

  /// Get email subject based on purpose
  String _getSubjectForPurpose(String purpose) {
    switch (purpose) {
      case 'login':
        return 'Your Login Verification Code';
      case 'profile_update':
        return 'Verify Your Profile Update';
      case 'password_reset':
        return 'Reset Your Password';
      case 'phone_verification':
        return 'Verify Your Phone Number';
      case 'registration':
        return 'Complete Your Registration';
      default:
        return 'Your Verification Code';
    }
  }

  /// Get human-readable purpose text
  String _getPurposeText(String purpose) {
    switch (purpose) {
      case 'login':
        return 'logging in';
      case 'profile_update':
        return 'updating your profile';
      case 'password_reset':
        return 'resetting your password';
      case 'phone_verification':
        return 'verifying your phone number';
      case 'registration':
        return 'completing your registration';
      default:
        return 'your request';
    }
  }

  /// Build plain text generic email body
  String _buildGenericEmailBody(String code, String purpose, int expiresInMinutes) {
    final purposeText = _getPurposeText(purpose);
    return '''
Hello,

Your verification code for $purposeText is: $code

This code will expire in $expiresInMinutes minutes.

If you did not request this code, please ignore this email.

Best regards,
The MasterFabric Team
''';
  }

  /// Build HTML generic email body
  String _buildGenericEmailHtmlBody(String code, String purpose, int expiresInMinutes) {
    final purposeText = _getPurposeText(purpose);
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { text-align: center; margin-bottom: 30px; }
    .code-box { background: #f5f5f5; border-radius: 8px; padding: 20px; text-align: center; margin: 20px 0; }
    .code { font-size: 32px; font-weight: bold; letter-spacing: 4px; color: #2563eb; font-family: monospace; }
    .footer { text-align: center; font-size: 12px; color: #666; margin-top: 30px; }
    .warning { font-size: 14px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>🔐 Verification Code</h2>
    </div>
    <p>Your verification code for <strong>$purposeText</strong> is:</p>
    <div class="code-box">
      <span class="code">$code</span>
    </div>
    <p class="warning">⏱ This code will expire in <strong>$expiresInMinutes minutes</strong>.</p>
    <p class="warning">⚠️ Do not share this code with anyone.</p>
    <div class="footer">
      <p>If you did not request this code, please ignore this email.</p>
      <p>Best regards,<br>The MasterFabric Team</p>
    </div>
  </div>
</body>
</html>
''';
  }
}
