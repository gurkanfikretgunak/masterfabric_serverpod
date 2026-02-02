/// Default roles for the RBAC system
///
/// These roles are seeded automatically when the server starts.

/// Default role names
abstract class DefaultRoles {
  /// Public role - for unauthenticated access or public endpoints
  static const String public = 'public';

  /// User role - default role for all authenticated users
  static const String user = 'user';

  /// Admin role - full system access
  static const String admin = 'admin';

  /// Moderator role - content moderation access
  static const String moderator = 'moderator';

  /// All default roles
  static const List<String> all = [public, user, admin, moderator];

  /// The default role assigned to new users on signup
  static const String defaultUserRole = user;
}

/// Default role configurations with their permissions
class DefaultRoleConfig {
  final String name;
  final String description;
  final List<String> permissions;
  final bool isActive;

  const DefaultRoleConfig({
    required this.name,
    required this.description,
    this.permissions = const [],
    this.isActive = true,
  });

  /// Default role configurations
  static const List<DefaultRoleConfig> defaults = [
    DefaultRoleConfig(
      name: DefaultRoles.public,
      description: 'Public access - no authentication required',
      permissions: [
        'public:read',
      ],
    ),
    DefaultRoleConfig(
      name: DefaultRoles.user,
      description: 'Standard authenticated user',
      permissions: [
        'user:read',
        'user:write',
        'profile:read',
        'profile:write',
      ],
    ),
    DefaultRoleConfig(
      name: DefaultRoles.moderator,
      description: 'Content moderator with elevated permissions',
      permissions: [
        'user:read',
        'user:write',
        'profile:read',
        'profile:write',
        'content:moderate',
        'content:delete',
        'user:ban',
      ],
    ),
    DefaultRoleConfig(
      name: DefaultRoles.admin,
      description: 'System administrator with full access',
      permissions: [
        'user:read',
        'user:write',
        'user:delete',
        'profile:read',
        'profile:write',
        'content:read',
        'content:write',
        'content:delete',
        'content:moderate',
        'admin:read',
        'admin:write',
        'admin:manage_users',
        'admin:manage_roles',
        'system:configure',
      ],
    ),
  ];
}
