import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'email_validation_service.dart';

/// Email identity provider endpoint with email validation
/// 
/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// 
/// This implementation adds email validation before allowing registration.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  EmailValidationService? _emailValidationService;

  /// Set the email validation service
  /// 
  /// This should be called during server initialization
  void setEmailValidationService(EmailValidationService? service) {
    _emailValidationService = service;
  }

  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    // Validate email before proceeding with registration
    if (_emailValidationService != null) {
      await _emailValidationService!.validateEmailForRegistration(
        email,
        session,
      );
    }

    // Call parent implementation if validation passes
    return await super.startRegistration(
      session,
      email: email,
    );
  }
}
