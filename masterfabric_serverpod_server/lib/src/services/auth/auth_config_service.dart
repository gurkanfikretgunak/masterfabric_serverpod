/// Password policy configuration
class PasswordPolicy {
    final int minLength;
    final bool requireUppercase;
    final bool requireLowercase;
    final bool requireNumbers;
    final bool requireSpecialChars;
    final bool preventReuse;
    final int? maxPasswordAge; // days

    PasswordPolicy({
      this.minLength = 8,
      this.requireUppercase = true,
      this.requireLowercase = true,
      this.requireNumbers = true,
      this.requireSpecialChars = true,
      this.preventReuse = true,
      this.maxPasswordAge,
    });

    factory PasswordPolicy.fromMap(Map<String, dynamic>? map) {
      if (map == null) {
        return PasswordPolicy();
      }

      return PasswordPolicy(
        minLength: map['minLength'] as int? ?? 8,
        requireUppercase: map['requireUppercase'] as bool? ?? true,
        requireLowercase: map['requireLowercase'] as bool? ?? true,
        requireNumbers: map['requireNumbers'] as bool? ?? true,
        requireSpecialChars: map['requireSpecialChars'] as bool? ?? true,
        preventReuse: map['preventReuse'] as bool? ?? true,
        maxPasswordAge: map['maxPasswordAge'] as int?,
      );
    }
}

/// Session configuration
class SessionConfig {
    final int defaultTtl; // seconds
    final int maxSessionsPerUser;
    final bool allowConcurrentSessions;

    SessionConfig({
      this.defaultTtl = 1800,
      this.maxSessionsPerUser = 5,
      this.allowConcurrentSessions = true,
    });

    factory SessionConfig.fromMap(Map<String, dynamic>? map) {
      if (map == null) {
        return SessionConfig();
      }

      return SessionConfig(
        defaultTtl: map['defaultTtl'] as int? ?? 1800,
        maxSessionsPerUser: map['maxSessionsPerUser'] as int? ?? 5,
        allowConcurrentSessions: map['allowConcurrentSessions'] as bool? ?? true,
      );
    }
  }

  /// Two-factor configuration
  class TwoFactorConfig {
    final bool enabled;
    final bool required;

    TwoFactorConfig({
      this.enabled = true,
      this.required = false,
    });

    factory TwoFactorConfig.fromMap(Map<String, dynamic>? map) {
      if (map == null) {
        return TwoFactorConfig();
      }

      return TwoFactorConfig(
        enabled: map['enabled'] as bool? ?? true,
        required: map['required'] as bool? ?? false,
      );
    }
}

/// Account verification configuration
class AccountVerificationConfig {
    final bool emailVerificationRequired;
    final bool phoneVerificationRequired;

    AccountVerificationConfig({
      this.emailVerificationRequired = true,
      this.phoneVerificationRequired = false,
    });

    factory AccountVerificationConfig.fromMap(Map<String, dynamic>? map) {
      if (map == null) {
        return AccountVerificationConfig();
      }

      return AccountVerificationConfig(
        emailVerificationRequired:
            map['emailVerificationRequired'] as bool? ?? true,
        phoneVerificationRequired:
            map['phoneVerificationRequired'] as bool? ?? false,
      );
    }
  }

  /// Auth configuration
  class AuthConfig {
    final PasswordPolicy passwordPolicy;
    final SessionConfig session;
    final TwoFactorConfig twoFactor;
    final AccountVerificationConfig accountVerification;

    AuthConfig({
      required this.passwordPolicy,
      required this.session,
      required this.twoFactor,
      required this.accountVerification,
    });

    factory AuthConfig.fromMap(Map<String, dynamic>? map) {
      if (map == null) {
        return AuthConfig(
          passwordPolicy: PasswordPolicy(),
          session: SessionConfig(),
          twoFactor: TwoFactorConfig(),
          accountVerification: AccountVerificationConfig(),
        );
      }

      return AuthConfig(
        passwordPolicy: PasswordPolicy.fromMap(
          map['passwordPolicy'] as Map<String, dynamic>?,
        ),
        session: SessionConfig.fromMap(
          map['session'] as Map<String, dynamic>?,
        ),
        twoFactor: TwoFactorConfig.fromMap(
          map['twoFactor'] as Map<String, dynamic>?,
        ),
        accountVerification: AccountVerificationConfig.fromMap(
          map['accountVerification'] as Map<String, dynamic>?,
        ),
      );
    }
}

/// Auth configuration service
/// 
/// Loads and provides authentication configuration from YAML config files.
class AuthConfigService {
  /// Load auth configuration from config map
  /// 
  /// [config] - Configuration map from YAML
  /// 
  /// Returns AuthConfig
  static AuthConfig loadFromConfig(Map<String, dynamic> config) {
    final authConfig = config['auth'] as Map<String, dynamic>?;
    return AuthConfig.fromMap(authConfig);
  }
}
