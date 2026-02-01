import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../base/middleware_base.dart';
import '../base/middleware_context.dart';
import '../base/middleware_config.dart';

/// Middleware for request parameter validation
///
/// Features:
/// - Validates request parameters against rules
/// - Schema validation for complex objects
/// - Custom validation rules per endpoint
/// - Returns structured validation errors
class ValidationMiddleware extends RequestOnlyMiddleware {
  @override
  String get name => 'validation';

  @override
  int get priority => 40; // After auth, before business logic

  /// Per-endpoint validation rules
  final Map<String, Map<String, ValidationRule>> _endpointRules;

  /// Global validation rules (applied to all endpoints)
  final Map<String, ValidationRule> _globalRules;

  ValidationMiddleware({
    Map<String, Map<String, ValidationRule>>? endpointRules,
    Map<String, ValidationRule>? globalRules,
  })  : _endpointRules = endpointRules ?? {},
        _globalRules = globalRules ?? {};

  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    final errors = <ValidationErrorDetail>[];

    // Get rules for this endpoint
    final rules = _getRulesForEndpoint(context);

    if (rules.isEmpty) {
      return MiddlewareResult.proceed();
    }

    // Validate each parameter
    for (final entry in rules.entries) {
      final fieldName = entry.key;
      final rule = entry.value;
      final value = context.parameters[fieldName];

      final result = rule.validate(fieldName, value);
      if (!result.isValid) {
        errors.add(ValidationErrorDetail(
          field: result.fieldName!,
          message: result.message!,
          value: _sanitizeValue(value),
          rule: _getRuleName(rule),
        ));
      }
    }

    // Check for unknown required parameters
    for (final param in context.parameters.keys) {
      if (!rules.containsKey(param) && _globalRules.containsKey(param)) {
        final rule = _globalRules[param]!;
        final result = rule.validate(param, context.parameters[param]);
        if (!result.isValid) {
          errors.add(ValidationErrorDetail(
            field: result.fieldName!,
            message: result.message!,
            value: _sanitizeValue(context.parameters[param]),
            rule: _getRuleName(rule),
          ));
        }
      }
    }

    if (errors.isNotEmpty) {
      context.session.log(
        'VALIDATION FAILED | '
        'endpoint=${context.fullPath} | '
        'errors=${errors.length} | '
        'fields=${errors.map((e) => e.field).join(', ')}',
        level: LogLevel.warning,
      );

      return MiddlewareResult.reject(
        error: ValidationException(
          message: 'Validation failed for ${errors.length} field(s)',
          errors: errors,
          endpoint: context.endpointName,
          method: context.methodName,
        ),
        message: 'Validation failed',
      );
    }

    return MiddlewareResult.proceed();
  }

  /// Get validation rules for an endpoint
  Map<String, ValidationRule> _getRulesForEndpoint(MiddlewareContext context) {
    final rules = <String, ValidationRule>{};

    // Add global rules
    rules.addAll(_globalRules);

    // Override with endpoint-specific rules
    final endpointKey = context.fullPath;
    if (_endpointRules.containsKey(endpointKey)) {
      rules.addAll(_endpointRules[endpointKey]!);
    } else if (_endpointRules.containsKey(context.endpointName)) {
      rules.addAll(_endpointRules[context.endpointName]!);
    }

    // Check context for custom rules
    final customRules =
        context.getMetadata<Map<String, ValidationRule>>('validationRules');
    if (customRules != null) {
      rules.addAll(customRules);
    }

    return rules;
  }

  /// Sanitize value for error response
  String? _sanitizeValue(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    if (str.length > 50) {
      return '${str.substring(0, 50)}...';
    }
    return str;
  }

  /// Get a descriptive name for the rule
  String? _getRuleName(ValidationRule rule) {
    final parts = <String>[];
    if (rule.required) parts.add('required');
    if (rule.minLength != null) parts.add('minLength:${rule.minLength}');
    if (rule.maxLength != null) parts.add('maxLength:${rule.maxLength}');
    if (rule.pattern != null) parts.add('pattern');
    if (rule.minValue != null) parts.add('min:${rule.minValue}');
    if (rule.maxValue != null) parts.add('max:${rule.maxValue}');
    if (rule.customValidator != null) parts.add('custom');
    return parts.isEmpty ? null : parts.join(',');
  }

  /// Register validation rules for an endpoint
  void registerEndpointRules(
    String endpoint,
    Map<String, ValidationRule> rules,
  ) {
    _endpointRules[endpoint] = rules;
  }

  /// Register a global validation rule
  void registerGlobalRule(String fieldName, ValidationRule rule) {
    _globalRules[fieldName] = rule;
  }

  /// Remove validation rules for an endpoint
  void removeEndpointRules(String endpoint) {
    _endpointRules.remove(endpoint);
  }
}

/// Common validation rules
class CommonValidationRules {
  /// Email validation rule
  static final ValidationRule email = ValidationRule(
    required: true,
    pattern: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    errorMessage: 'Invalid email format',
  );

  /// Password validation rule (min 8 chars, mixed case, number)
  static final ValidationRule password = ValidationRule(
    required: true,
    minLength: 8,
    maxLength: 128,
    pattern: r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$',
    errorMessage:
        'Password must be at least 8 characters with uppercase, lowercase, and number',
  );

  /// Username validation rule
  static final ValidationRule username = ValidationRule(
    required: true,
    minLength: 3,
    maxLength: 30,
    pattern: r'^[a-zA-Z0-9_-]+$',
    errorMessage: 'Username must be 3-30 characters, alphanumeric with _ or -',
  );

  /// UUID validation rule
  static final ValidationRule uuid = ValidationRule(
    required: true,
    pattern:
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    errorMessage: 'Invalid UUID format',
  );

  /// Positive integer validation rule
  static final ValidationRule positiveInt = ValidationRule(
    required: true,
    minValue: 1,
    errorMessage: 'Must be a positive integer',
  );

  /// Non-empty string validation rule
  static final ValidationRule nonEmpty = ValidationRule(
    required: true,
    minLength: 1,
    errorMessage: 'Cannot be empty',
  );

  /// URL validation rule
  static final ValidationRule url = ValidationRule(
    pattern: r'^https?:\/\/.+',
    errorMessage: 'Invalid URL format',
  );

  /// Phone number validation rule
  static final ValidationRule phone = ValidationRule(
    pattern: r'^\+?[1-9]\d{1,14}$',
    errorMessage: 'Invalid phone number format',
  );
}
