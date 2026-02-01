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

/// Verification code configuration for OTP/verification codes
class VerificationCodeConfig {
  /// Length of the verification code (default: 6 digits)
  final int codeLength;

  /// Expiration time in minutes (default: 5 minutes)
  final int expirationMinutes;

  /// Resend cooldown in seconds (default: 30 seconds)
  final int resendCooldownSeconds;

  /// Secret salt for hashing codes (should be set from environment)
  /// This adds entropy so codes can't be guessed from the hash
  final String secretSalt;

  /// Use alphanumeric codes instead of numeric only (more secure)
  final bool useAlphanumeric;

  /// Maximum verification attempts before lockout
  final int maxAttempts;

  /// Lockout duration in minutes after max attempts exceeded
  final int lockoutMinutes;

  VerificationCodeConfig({
    this.codeLength = 6,
    this.expirationMinutes = 5,
    this.resendCooldownSeconds = 30,
    this.secretSalt = 'default-verification-salt-change-in-production',
    this.useAlphanumeric = false,
    this.maxAttempts = 5,
    this.lockoutMinutes = 15,
  });

  factory VerificationCodeConfig.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return VerificationCodeConfig();
    }

    return VerificationCodeConfig(
      codeLength: map['codeLength'] as int? ?? 6,
      expirationMinutes: map['expirationMinutes'] as int? ?? 5,
      resendCooldownSeconds: map['resendCooldownSeconds'] as int? ?? 30,
      secretSalt: map['secretSalt'] as String? ??
          'default-verification-salt-change-in-production',
      useAlphanumeric: map['useAlphanumeric'] as bool? ?? false,
      maxAttempts: map['maxAttempts'] as int? ?? 5,
      lockoutMinutes: map['lockoutMinutes'] as int? ?? 15,
    );
  }
}

  /// Auth configuration
  class AuthConfig {
    final PasswordPolicy passwordPolicy;
    final SessionConfig session;
    final TwoFactorConfig twoFactor;
    final AccountVerificationConfig accountVerification;
    final VerificationCodeConfig verificationCode;

    AuthConfig({
      required this.passwordPolicy,
      required this.session,
      required this.twoFactor,
      required this.accountVerification,
      required this.verificationCode,
    });

    factory AuthConfig.fromMap(Map<String, dynamic>? map) {
      if (map == null) {
        return AuthConfig(
          passwordPolicy: PasswordPolicy(),
          session: SessionConfig(),
          twoFactor: TwoFactorConfig(),
          accountVerification: AccountVerificationConfig(),
          verificationCode: VerificationCodeConfig(),
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
        verificationCode: VerificationCodeConfig.fromMap(
          map['verificationCode'] as Map<String, dynamic>?,
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
