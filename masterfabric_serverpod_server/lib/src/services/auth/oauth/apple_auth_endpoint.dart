import 'package:serverpod_auth_idp_server/providers/apple.dart';

/// Apple Sign-In endpoint
/// 
/// By extending [AppleIdpBaseEndpoint], Apple Sign-In endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// 
/// Apple Sign-In credentials must be configured in the server configuration.
class AppleAuthEndpoint extends AppleIdpBaseEndpoint {}
