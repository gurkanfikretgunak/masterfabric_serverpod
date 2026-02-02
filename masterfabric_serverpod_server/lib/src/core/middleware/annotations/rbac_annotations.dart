/// RBAC (Role-Based Access Control) Annotations
///
/// Provides annotation classes for declarative role and permission
/// requirements on endpoints and methods.
///
/// Example usage:
/// ```dart
/// class PaymentEndpoint extends MasterfabricEndpoint {
///   @RequireRoles(['admin', 'finance'])
///   Future<void> processRefund(Session session) async { ... }
///
///   @RequirePermissions(['payment:read'])
///   Future<PaymentInfo> getPayment(Session session) async { ... }
///
///   @Public()
///   Future<List<String>> getPaymentMethods(Session session) async { ... }
/// }
/// ```
library rbac_annotations;

/// Annotation to require specific roles for an endpoint or method.
///
/// When applied to a class (endpoint), all methods in that endpoint
/// will require the specified roles.
///
/// When applied to a method, only that method requires the specified roles.
///
/// Example:
/// ```dart
/// // Require at least one of admin or moderator roles
/// @RequireRoles(['admin', 'moderator'])
/// Future<void> deleteUser(Session session) async { ... }
///
/// // Require ALL of the specified roles
/// @RequireRoles(['admin', 'superuser'], requireAll: true)
/// Future<void> dangerousAction(Session session) async { ... }
/// ```
class RequireRoles {
  /// List of role names required.
  ///
  /// By default (requireAll = false), user needs at least ONE of these roles.
  /// If requireAll = true, user needs ALL of these roles.
  final List<String> roles;

  /// If true, user must have ALL specified roles.
  /// If false (default), user must have at least ONE of the specified roles.
  final bool requireAll;

  /// Creates a role requirement annotation.
  ///
  /// [roles] - List of role names to require
  /// [requireAll] - Whether all roles are required (AND) or just one (OR)
  const RequireRoles(this.roles, {this.requireAll = false});

  /// Create a role requirement that requires ALL specified roles.
  const RequireRoles.all(this.roles) : requireAll = true;

  /// Create a role requirement that requires ANY of the specified roles.
  const RequireRoles.any(this.roles) : requireAll = false;
}

/// Annotation to require specific permissions for an endpoint or method.
///
/// Permissions are more granular than roles and allow fine-grained
/// access control based on specific actions.
///
/// Example:
/// ```dart
/// @RequirePermissions(['user:read', 'user:write'])
/// Future<void> updateUser(Session session, UserUpdate data) async { ... }
/// ```
class RequirePermissions {
  /// List of permission names required.
  ///
  /// By default (requireAll = false), user needs at least ONE of these permissions.
  /// If requireAll = true, user needs ALL of these permissions.
  final List<String> permissions;

  /// If true, user must have ALL specified permissions.
  /// If false (default), user must have at least ONE of the specified permissions.
  final bool requireAll;

  /// Creates a permission requirement annotation.
  ///
  /// [permissions] - List of permission names to require
  /// [requireAll] - Whether all permissions are required (AND) or just one (OR)
  const RequirePermissions(this.permissions, {this.requireAll = false});

  /// Create a permission requirement that requires ALL specified permissions.
  const RequirePermissions.all(this.permissions) : requireAll = true;

  /// Create a permission requirement that requires ANY of the specified permissions.
  const RequirePermissions.any(this.permissions) : requireAll = false;
}

/// Annotation to mark an endpoint or method as public (no authentication required).
///
/// This overrides any class-level authentication requirements.
///
/// Example:
/// ```dart
/// class UserEndpoint extends MasterfabricEndpoint {
///   @override
///   bool get requireLogin => true; // All methods require login by default
///
///   @Public() // This method is public
///   Future<bool> checkEmailExists(Session session, String email) async { ... }
/// }
/// ```
class Public {
  /// Optional description for why this endpoint is public
  final String? reason;

  /// Creates a public annotation.
  ///
  /// [reason] - Optional documentation for why this is public
  const Public([this.reason]);
}

/// Convenient constant for @Public() annotation
const public_ = Public();

/// Annotation to mark an endpoint or method as requiring authentication
/// but no specific roles or permissions.
///
/// This is useful when you want to override a class-level @Public annotation
/// or explicitly document that authentication is required.
///
/// Example:
/// ```dart
/// @Authenticated()
/// Future<UserProfile> getProfile(Session session) async { ... }
/// ```
class Authenticated {
  /// Optional description
  final String? reason;

  /// Creates an authenticated annotation.
  const Authenticated([this.reason]);
}

/// Convenient constant for @Authenticated() annotation
const authenticated = Authenticated();

/// Annotation for admin-only endpoints or methods.
///
/// Shorthand for @RequireRoles(['admin'])
///
/// Example:
/// ```dart
/// @AdminOnly()
/// Future<void> deleteAllUsers(Session session) async { ... }
/// ```
class AdminOnly {
  /// Creates an admin-only annotation.
  const AdminOnly();
}

/// Convenient constant for @AdminOnly() annotation
const adminOnly = AdminOnly();

/// Annotation to specify custom authorization logic for an endpoint or method.
///
/// Allows for complex authorization scenarios that can't be expressed
/// with simple role/permission lists.
///
/// Note: The actual authorization function must be registered separately
/// in the middleware configuration using the [authorizerId] as the key.
///
/// Example:
/// ```dart
/// @CustomAuthorization('ownerOrAdmin')
/// Future<void> updateResource(Session session, String resourceId) async { ... }
/// ```
class CustomAuthorization {
  /// Identifier for the custom authorizer function
  final String authorizerId;

  /// Creates a custom authorization annotation.
  ///
  /// [authorizerId] - Key to look up the authorization function
  const CustomAuthorization(this.authorizerId);
}

/// Configuration class for RBAC requirements that can be used programmatically.
///
/// This provides a way to specify RBAC requirements at runtime,
/// complementing the annotation-based approach.
///
/// Example:
/// ```dart
/// final config = RbacConfig(
///   requiredRoles: ['user'],
///   requiredPermissions: ['read'],
///   requireAllRoles: false,
/// );
/// ```
class RbacConfig {
  /// Required roles
  final List<String> requiredRoles;

  /// Required permissions
  final List<String> requiredPermissions;

  /// Whether all roles are required (AND) or just one (OR)
  final bool requireAllRoles;

  /// Whether all permissions are required (AND) or just one (OR)
  final bool requireAllPermissions;

  /// Whether this is a public endpoint (no auth required)
  final bool isPublic;

  /// Custom authorizer ID (if any)
  final String? customAuthorizerId;

  /// Creates an RBAC configuration.
  const RbacConfig({
    this.requiredRoles = const [],
    this.requiredPermissions = const [],
    this.requireAllRoles = false,
    this.requireAllPermissions = false,
    this.isPublic = false,
    this.customAuthorizerId,
  });

  /// Create a public configuration
  static const RbacConfig publicEndpoint = RbacConfig(isPublic: true);

  /// Create an admin-only configuration
  static const RbacConfig adminOnly = RbacConfig(
    requiredRoles: ['admin'],
  );

  /// Create a user-only configuration
  static const RbacConfig userOnly = RbacConfig(
    requiredRoles: ['user'],
  );

  /// Check if this config requires any roles
  bool get hasRoleRequirements => requiredRoles.isNotEmpty;

  /// Check if this config requires any permissions
  bool get hasPermissionRequirements => requiredPermissions.isNotEmpty;

  /// Check if this config requires any authorization
  bool get hasAuthRequirements =>
      !isPublic && (hasRoleRequirements || hasPermissionRequirements);

  /// Convert to a map for middleware context
  Map<String, dynamic> toMap() => {
        'requiredRoles': requiredRoles,
        'requiredPermissions': requiredPermissions,
        'requireAllRoles': requireAllRoles,
        'requireAllPermissions': requireAllPermissions,
        'isPublic': isPublic,
        if (customAuthorizerId != null) 'customAuthorizerId': customAuthorizerId,
      };

  /// Create from a map
  factory RbacConfig.fromMap(Map<String, dynamic> map) {
    return RbacConfig(
      requiredRoles: List<String>.from(map['requiredRoles'] ?? []),
      requiredPermissions: List<String>.from(map['requiredPermissions'] ?? []),
      requireAllRoles: map['requireAllRoles'] ?? false,
      requireAllPermissions: map['requireAllPermissions'] ?? false,
      isPublic: map['isPublic'] ?? false,
      customAuthorizerId: map['customAuthorizerId'],
    );
  }

  @override
  String toString() => 'RbacConfig('
      'roles: $requiredRoles, '
      'permissions: $requiredPermissions, '
      'requireAllRoles: $requireAllRoles, '
      'requireAllPermissions: $requireAllPermissions, '
      'isPublic: $isPublic)';
}
