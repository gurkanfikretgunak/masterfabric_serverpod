import 'package:serverpod_auth_idp_server/providers/google.dart';

/// Google Sign-In endpoint
/// 
/// By extending [GoogleIdpBaseEndpoint], Google Sign-In endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// 
/// Google OAuth credentials must be configured in the server configuration.
class GoogleAuthEndpoint extends GoogleIdpBaseEndpoint {}
