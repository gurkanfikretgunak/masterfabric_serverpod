import 'package:serverpod/serverpod.dart';
import '../../core/integrations/integration_manager.dart';

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
}
