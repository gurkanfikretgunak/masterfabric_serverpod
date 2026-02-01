import 'package:serverpod/serverpod.dart';

import '../base/middleware_base.dart';
import '../base/middleware_context.dart';
import '../base/middleware_config.dart';

/// Middleware for automatic request/response logging
///
/// Features:
/// - Logs request start with endpoint, method, and sanitized parameters
/// - Logs response with duration and status
/// - Logs errors with stack traces
/// - PII masking for sensitive fields
/// - Configurable log levels
class LoggingMiddleware extends MiddlewareHandler {
  @override
  String get name => 'logging';

  @override
  int get priority => 10; // Runs first to capture all timing

  /// Fields to mask in logs
  final List<String> _maskedFields;

  /// Maximum parameter value length in logs
  final int _maxParamLength;

  /// Log level
  final MiddlewareLogLevel _logLevel;

  LoggingMiddleware({
    List<String>? maskedFields,
    int maxParamLength = 200,
    MiddlewareLogLevel logLevel = MiddlewareLogLevel.info,
  })  : _maskedFields = maskedFields ?? _defaultMaskedFields,
        _maxParamLength = maxParamLength,
        _logLevel = logLevel;

  static const List<String> _defaultMaskedFields = [
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
    'pin',
    'cvv',
  ];

  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    if (_logLevel == MiddlewareLogLevel.none) {
      return MiddlewareResult.proceed();
    }

    final sanitizedParams = _sanitizeParameters(context.parameters);
    final requestId = _generateRequestId();
    
    // Store request ID in context for correlation
    context.setMetadata('requestId', requestId);
    context.setMetadata('logStartTime', DateTime.now());

    // Extract and store client IP
    context.clientIp = context.extractClientIp();

    if (_shouldLog(MiddlewareLogLevel.info)) {
      context.session.log(
        'REQUEST START | '
        'id=$requestId | '
        'endpoint=${context.endpointName} | '
        'method=${context.methodName} | '
        'ip=${context.clientIp} | '
        'authenticated=${context.isAuthenticated} | '
        'params=$sanitizedParams',
        level: LogLevel.info,
      );
    }

    if (_shouldLog(MiddlewareLogLevel.debug)) {
      context.session.log(
        'REQUEST DETAILS | '
        'id=$requestId | '
        'userId=${context.authenticatedUserId ?? 'anonymous'}',
        level: LogLevel.debug,
      );
    }

    return MiddlewareResult.proceed(
      data: {'requestId': requestId},
    );
  }

  @override
  Future<MiddlewareResult> onResponse(
    MiddlewareContext context,
    dynamic result,
  ) async {
    if (_logLevel == MiddlewareLogLevel.none) {
      return MiddlewareResult.proceed();
    }

    final requestId = context.getMetadata<String>('requestId') ?? 'unknown';
    final durationMs = context.elapsedMs;

    if (_shouldLog(MiddlewareLogLevel.info)) {
      context.session.log(
        'REQUEST SUCCESS | '
        'id=$requestId | '
        'endpoint=${context.fullPath} | '
        'duration=${durationMs}ms | '
        'userId=${context.authenticatedUserId ?? 'anonymous'}',
        level: LogLevel.info,
      );
    }

    if (_shouldLog(MiddlewareLogLevel.debug)) {
      final responsePreview = _truncateValue(result?.toString() ?? 'null', 500);
      context.session.log(
        'RESPONSE DETAILS | '
        'id=$requestId | '
        'preview=$responsePreview',
        level: LogLevel.debug,
      );
    }

    return MiddlewareResult.proceed();
  }

  @override
  Future<MiddlewareResult> onError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  ) async {
    final requestId = context.getMetadata<String>('requestId') ?? 'unknown';
    final durationMs = context.elapsedMs;

    context.session.log(
      'REQUEST ERROR | '
      'id=$requestId | '
      'endpoint=${context.fullPath} | '
      'duration=${durationMs}ms | '
      'error=${error.runtimeType}: $error',
      level: LogLevel.error,
    );

    if (_shouldLog(MiddlewareLogLevel.debug)) {
      context.session.log(
        'ERROR STACK | id=$requestId | stack=$stackTrace',
        level: LogLevel.debug,
      );
    }

    return MiddlewareResult.proceed();
  }

  /// Sanitize parameters by masking sensitive fields
  Map<String, dynamic> _sanitizeParameters(Map<String, dynamic> params) {
    final sanitized = <String, dynamic>{};

    for (final entry in params.entries) {
      if (_isSensitiveField(entry.key)) {
        sanitized[entry.key] = '***MASKED***';
      } else if (entry.value is Map) {
        sanitized[entry.key] = _sanitizeParameters(
          Map<String, dynamic>.from(entry.value as Map),
        );
      } else if (entry.value is List) {
        sanitized[entry.key] = _sanitizeList(entry.value as List);
      } else {
        sanitized[entry.key] = _truncateValue(entry.value?.toString(), _maxParamLength);
      }
    }

    return sanitized;
  }

  /// Sanitize a list of values
  List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) {
        return _sanitizeParameters(Map<String, dynamic>.from(item));
      } else if (item is List) {
        return _sanitizeList(item);
      } else {
        return _truncateValue(item?.toString(), _maxParamLength);
      }
    }).toList();
  }

  /// Check if a field name is sensitive
  bool _isSensitiveField(String fieldName) {
    final lowerName = fieldName.toLowerCase();
    return _maskedFields.any((masked) => lowerName.contains(masked.toLowerCase()));
  }

  /// Truncate a value to max length
  String? _truncateValue(String? value, int maxLength) {
    if (value == null) return null;
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}...[truncated]';
  }

  /// Generate a unique request ID
  String _generateRequestId() {
    final now = DateTime.now();
    final random = now.microsecondsSinceEpoch.toString().substring(6);
    return '${now.millisecondsSinceEpoch}-$random';
  }

  /// Check if we should log at this level
  bool _shouldLog(MiddlewareLogLevel level) {
    return level.index <= _logLevel.index;
  }
}
