/// Authentication Service Module
///
/// Comprehensive authentication system including:
/// - Email/password authentication
/// - OAuth (Google, Apple)
/// - Two-factor authentication
/// - Session management
/// - Role-based access control (RBAC)
/// - User profile management

// Config
export 'config/auth_config_service.dart';

// Core
export 'core/auth_audit_service.dart';
export 'core/auth_helper_service.dart';

// Email Authentication
export 'email/email_idp_endpoint.dart';
export 'email/email_service.dart';
export 'email/email_validation_service.dart';

// JWT
export 'jwt/jwt_refresh_endpoint.dart';

// OAuth
export 'oauth/apple_auth_endpoint.dart';
export 'oauth/google_auth_endpoint.dart';

// Password Management
export 'password/password_management_endpoint.dart';
export 'password/password_management_service.dart';

// RBAC (Role-Based Access Control)
export 'rbac/rbac_endpoint.dart';
export 'rbac/rbac_service.dart';

// Session Management
export 'session/session_management_endpoint.dart';
export 'session/session_management_service.dart';

// Two-Factor Authentication
export 'two_factor/two_factor_endpoint.dart';
export 'two_factor/two_factor_service.dart';

// User Management
export 'user/account_management_endpoint.dart';
export 'user/account_management_service.dart';
export 'user/user_management_endpoint.dart';
export 'user/user_management_service.dart';
export 'user/user_profile_endpoint.dart';
export 'user/user_profile_service.dart';

// Verification
export 'verification/verification_service.dart';
