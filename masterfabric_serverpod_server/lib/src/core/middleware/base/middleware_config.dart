import '../../rate_limit/services/rate_limit_service.dart';

/// Global configuration for the middleware system
class MiddlewareGlobalConfig {
  /// Enable request/response logging
  final bool enableLogging;

  /// Enable rate limiting
  final bool enableRateLimit;

  /// Enable authentication checks
  final bool enableAuth;

  /// Enable request validation
  final bool enableValidation;

  /// Enable metrics collection
  final bool enableMetrics;

  /// Enable global error handling
  final bool enableErrorHandling;

  /// Default rate limit configuration
  final RateLimitConfig? defaultRateLimit;

  /// Log level for middleware logging
  final MiddlewareLogLevel logLevel;

  /// Fields to mask in logs (for PII protection)
  final List<String> maskedFields;

  /// Maximum parameter value length in logs
  final int maxLogParamLength;

  const MiddlewareGlobalConfig({
    this.enableLogging = true,
    this.enableRateLimit = true,
    this.enableAuth = true,
    this.enableValidation = true,
    this.enableMetrics = true,
    this.enableErrorHandling = true,
    this.defaultRateLimit,
    this.logLevel = MiddlewareLogLevel.info,
    this.maskedFields = const [
      'password',
      'token',
      'secret',
      'apiKey',
      'api_key',
      'accessToken',
      'access_token',
      'refreshToken',
      'refresh_token',
      'credit_card',
      'creditCard',
      'ssn',
      'socialSecurity',
    ],
    this.maxLogParamLength = 200,
  });

  /// Create a copy with modified values
  MiddlewareGlobalConfig copyWith({
    bool? enableLogging,
    bool? enableRateLimit,
    bool? enableAuth,
    bool? enableValidation,
    bool? enableMetrics,
    bool? enableErrorHandling,
    RateLimitConfig? defaultRateLimit,
    MiddlewareLogLevel? logLevel,
    List<String>? maskedFields,
    int? maxLogParamLength,
  }) {
    return MiddlewareGlobalConfig(
      enableLogging: enableLogging ?? this.enableLogging,
      enableRateLimit: enableRateLimit ?? this.enableRateLimit,
      enableAuth: enableAuth ?? this.enableAuth,
      enableValidation: enableValidation ?? this.enableValidation,
      enableMetrics: enableMetrics ?? this.enableMetrics,
      enableErrorHandling: enableErrorHandling ?? this.enableErrorHandling,
      defaultRateLimit: defaultRateLimit ?? this.defaultRateLimit,
      logLevel: logLevel ?? this.logLevel,
      maskedFields: maskedFields ?? this.maskedFields,
      maxLogParamLength: maxLogParamLength ?? this.maxLogParamLength,
    );
  }

  /// Default configuration
  static const MiddlewareGlobalConfig defaults = MiddlewareGlobalConfig();
}

/// Per-endpoint middleware configuration
///
/// Allows endpoints to customize which middleware runs and with what settings.
class EndpointMiddlewareConfig {
  /// Skip logging for this endpoint
  final bool skipLogging;

  /// Skip rate limiting for this endpoint
  final bool skipRateLimit;

  /// Skip authentication for this endpoint
  final bool skipAuth;

  /// Skip validation for this endpoint
  final bool skipValidation;

  /// Skip metrics for this endpoint
  final bool skipMetrics;

  /// Custom rate limit configuration (overrides global)
  final RateLimitConfig? customRateLimit;

  /// Required permissions for this endpoint (RBAC)
  final List<String> requiredPermissions;

  /// Required roles for this endpoint
  final List<String> requiredRoles;

  /// Custom log level for this endpoint
  final MiddlewareLogLevel? logLevel;

  /// Additional fields to mask in logs
  final List<String> additionalMaskedFields;

  /// Custom validation rules
  final Map<String, ValidationRule>? validationRules;

  /// Custom metadata for this endpoint
  final Map<String, dynamic> metadata;

  const EndpointMiddlewareConfig({
    this.skipLogging = false,
    this.skipRateLimit = false,
    this.skipAuth = false,
    this.skipValidation = false,
    this.skipMetrics = false,
    this.customRateLimit,
    this.requiredPermissions = const [],
    this.requiredRoles = const [],
    this.logLevel,
    this.additionalMaskedFields = const [],
    this.validationRules,
    this.metadata = const {},
  });

  /// Create a minimal config that skips nothing
  static const EndpointMiddlewareConfig defaults = EndpointMiddlewareConfig();

  /// Create a config for public endpoints (no auth required)
  static const EndpointMiddlewareConfig publicEndpoint = EndpointMiddlewareConfig(
    skipAuth: true,
  );

  /// Create a config for internal/admin endpoints
  static EndpointMiddlewareConfig adminEndpoint({
    List<String> requiredRoles = const ['admin'],
    RateLimitConfig? rateLimit,
  }) {
    return EndpointMiddlewareConfig(
      requiredRoles: requiredRoles,
      customRateLimit: rateLimit,
    );
  }

  /// Create a copy with modified values
  EndpointMiddlewareConfig copyWith({
    bool? skipLogging,
    bool? skipRateLimit,
    bool? skipAuth,
    bool? skipValidation,
    bool? skipMetrics,
    RateLimitConfig? customRateLimit,
    List<String>? requiredPermissions,
    List<String>? requiredRoles,
    MiddlewareLogLevel? logLevel,
    List<String>? additionalMaskedFields,
    Map<String, ValidationRule>? validationRules,
    Map<String, dynamic>? metadata,
  }) {
    return EndpointMiddlewareConfig(
      skipLogging: skipLogging ?? this.skipLogging,
      skipRateLimit: skipRateLimit ?? this.skipRateLimit,
      skipAuth: skipAuth ?? this.skipAuth,
      skipValidation: skipValidation ?? this.skipValidation,
      skipMetrics: skipMetrics ?? this.skipMetrics,
      customRateLimit: customRateLimit ?? this.customRateLimit,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      requiredRoles: requiredRoles ?? this.requiredRoles,
      logLevel: logLevel ?? this.logLevel,
      additionalMaskedFields: additionalMaskedFields ?? this.additionalMaskedFields,
      validationRules: validationRules ?? this.validationRules,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Log levels for middleware logging
enum MiddlewareLogLevel {
  /// No logging
  none,

  /// Only errors
  error,

  /// Errors and warnings
  warning,

  /// Info, warnings, and errors
  info,

  /// All levels including debug
  debug,

  /// Everything including trace
  trace,
}

/// Validation rule for request parameters
class ValidationRule {
  /// Whether the field is required
  final bool required;

  /// Minimum length (for strings)
  final int? minLength;

  /// Maximum length (for strings)
  final int? maxLength;

  /// Regex pattern for validation
  final String? pattern;

  /// Minimum value (for numbers)
  final num? minValue;

  /// Maximum value (for numbers)
  final num? maxValue;

  /// Custom validation function
  final bool Function(dynamic value)? customValidator;

  /// Error message for validation failure
  final String? errorMessage;

  const ValidationRule({
    this.required = false,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.minValue,
    this.maxValue,
    this.customValidator,
    this.errorMessage,
  });

  /// Validate a value against this rule
  ValidationResult validate(String fieldName, dynamic value) {
    // Required check
    if (required && (value == null || (value is String && value.isEmpty))) {
      return ValidationResult.failure(
        fieldName,
        errorMessage ?? '$fieldName is required',
      );
    }

    if (value == null) {
      return ValidationResult.success();
    }

    // String validations
    if (value is String) {
      if (minLength != null && value.length < minLength!) {
        return ValidationResult.failure(
          fieldName,
          errorMessage ?? '$fieldName must be at least $minLength characters',
        );
      }
      if (maxLength != null && value.length > maxLength!) {
        return ValidationResult.failure(
          fieldName,
          errorMessage ?? '$fieldName must be at most $maxLength characters',
        );
      }
      if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
        return ValidationResult.failure(
          fieldName,
          errorMessage ?? '$fieldName has invalid format',
        );
      }
    }

    // Number validations
    if (value is num) {
      if (minValue != null && value < minValue!) {
        return ValidationResult.failure(
          fieldName,
          errorMessage ?? '$fieldName must be at least $minValue',
        );
      }
      if (maxValue != null && value > maxValue!) {
        return ValidationResult.failure(
          fieldName,
          errorMessage ?? '$fieldName must be at most $maxValue',
        );
      }
    }

    // Custom validation
    if (customValidator != null && !customValidator!(value)) {
      return ValidationResult.failure(
        fieldName,
        errorMessage ?? '$fieldName is invalid',
      );
    }

    return ValidationResult.success();
  }
}

/// Result of validation
class ValidationResult {
  final bool isValid;
  final String? fieldName;
  final String? message;

  const ValidationResult._({
    required this.isValid,
    this.fieldName,
    this.message,
  });

  factory ValidationResult.success() {
    return const ValidationResult._(isValid: true);
  }

  factory ValidationResult.failure(String fieldName, String message) {
    return ValidationResult._(
      isValid: false,
      fieldName: fieldName,
      message: message,
    );
  }
}
