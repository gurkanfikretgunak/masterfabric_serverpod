import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../base/middleware_base.dart';
import '../base/middleware_context.dart';

/// Middleware for global error handling and transformation
///
/// Features:
/// - Catches and transforms all errors
/// - Consistent error response format
/// - Error logging with context
/// - Sentry integration for error reporting
/// - Custom error mappers
class ErrorMiddleware extends ErrorOnlyMiddleware {
  @override
  String get name => 'error';

  @override
  int get priority => 999; // Runs last in error chain

  /// Custom error transformers
  final Map<Type, Object Function(Object error, MiddlewareContext context)>
      _errorTransformers;

  /// Callback for reporting errors to external service (e.g., Sentry)
  final Future<void> Function(
    Object error,
    StackTrace stackTrace,
    Map<String, dynamic> context,
  )? _errorReporter;

  /// Whether to include stack traces in error responses
  final bool _includeStackTrace;

  /// Whether to include detailed error info (for development)
  final bool _includeDetails;

  ErrorMiddleware({
    Map<Type, Object Function(Object error, MiddlewareContext context)>?
        errorTransformers,
    Future<void> Function(
      Object error,
      StackTrace stackTrace,
      Map<String, dynamic> context,
    )?
        errorReporter,
    bool includeStackTrace = false,
    bool includeDetails = false,
  })  : _errorTransformers = errorTransformers ?? {},
        _errorReporter = errorReporter,
        _includeStackTrace = includeStackTrace,
        _includeDetails = includeDetails;

  @override
  Future<MiddlewareResult> onError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  ) async {
    // Log the error
    context.session.log(
      'ERROR HANDLER | '
      'endpoint=${context.fullPath} | '
      'error=${error.runtimeType}: $error',
      level: LogLevel.error,
    );

    // Report to external service
    if (_errorReporter != null) {
      try {
        await _errorReporter!(
          error,
          stackTrace,
          _buildErrorContext(context),
        );
      } catch (e) {
        context.session.log(
          'Error reporter failed: $e',
          level: LogLevel.error,
        );
      }
    }

    // Transform error if transformer exists
    final transformedError = _transformError(error, context);

    // Build standardized error response
    final standardError = _buildStandardError(
      transformedError,
      context,
      stackTrace,
    );

    return MiddlewareResult.proceed(
      data: {
        'transformedError': standardError,
        'originalError': error,
      },
    );
  }

  /// Transform error using registered transformer
  Object _transformError(Object error, MiddlewareContext context) {
    final transformer = _errorTransformers[error.runtimeType];
    if (transformer != null) {
      return transformer(error, context);
    }
    return error;
  }

  /// Build error context for reporting
  Map<String, dynamic> _buildErrorContext(MiddlewareContext context) {
    return {
      'endpoint': context.endpointName,
      'method': context.methodName,
      'userId': context.userId,
      'clientIp': context.clientIp,
      'requestId': context.getMetadata<String>('requestId'),
      'elapsed_ms': context.elapsedMs,
      'authenticated': context.isAuthenticated,
    };
  }

  /// Build standardized error object
  Object _buildStandardError(
    Object error,
    MiddlewareContext context,
    StackTrace stackTrace,
  ) {
    // If already a MiddlewareError, return as-is
    if (error is MiddlewareError) {
      return error;
    }

    // If already a ValidationException, return as-is
    if (error is ValidationException) {
      return error;
    }

    // If already a RateLimitException, return as-is
    if (error is RateLimitException) {
      return error;
    }

    // Build a generic MiddlewareError
    final code = _getErrorCode(error);
    final statusCode = _getStatusCode(error);
    final message = _getErrorMessage(error);

    final details = <String, String>{};
    if (_includeDetails) {
      details['type'] = error.runtimeType.toString();
      details['endpoint'] = context.fullPath;
      if (context.getMetadata<String>('requestId') != null) {
        details['requestId'] = context.getMetadata<String>('requestId')!;
      }
    }
    if (_includeStackTrace) {
      details['stackTrace'] = stackTrace.toString().substring(
            0,
            stackTrace.toString().length.clamp(0, 1000),
          );
    }

    return MiddlewareError(
      message: message,
      code: code,
      statusCode: statusCode,
      middleware: name,
      details: details.isEmpty ? null : details,
      timestamp: DateTime.now(),
    );
  }

  /// Get error code from error type
  String _getErrorCode(Object error) {
    final typeName = error.runtimeType.toString();

    // Map common error types to codes
    if (typeName.contains('NotFound')) return 'NOT_FOUND';
    if (typeName.contains('Unauthorized') ||
        typeName.contains('Authentication')) {
      return 'UNAUTHORIZED';
    }
    if (typeName.contains('Forbidden') || typeName.contains('Permission')) {
      return 'FORBIDDEN';
    }
    if (typeName.contains('Validation')) return 'VALIDATION_ERROR';
    if (typeName.contains('RateLimit')) return 'RATE_LIMITED';
    if (typeName.contains('Timeout')) return 'TIMEOUT';
    if (typeName.contains('Connection')) return 'CONNECTION_ERROR';

    return 'INTERNAL_ERROR';
  }

  /// Get HTTP status code from error
  int _getStatusCode(Object error) {
    final typeName = error.runtimeType.toString();

    if (typeName.contains('NotFound')) return 404;
    if (typeName.contains('Unauthorized') ||
        typeName.contains('Authentication')) {
      return 401;
    }
    if (typeName.contains('Forbidden') || typeName.contains('Permission')) {
      return 403;
    }
    if (typeName.contains('Validation')) return 400;
    if (typeName.contains('RateLimit')) return 429;
    if (typeName.contains('Timeout')) return 408;
    if (typeName.contains('BadRequest')) return 400;

    return 500;
  }

  /// Get error message from error
  String _getErrorMessage(Object error) {
    // Try to get message from common properties
    try {
      final dynamic err = error;
      if (err is Exception) {
        return err.toString().replaceFirst('Exception: ', '');
      }
    } catch (_) {}

    return error.toString();
  }

  /// Register a custom error transformer
  void registerTransformer<T>(
    Object Function(T error, MiddlewareContext context) transformer,
  ) {
    _errorTransformers[T] = (error, context) =>
        transformer(error as T, context);
  }

  /// Create an error middleware for production
  static ErrorMiddleware production({
    Future<void> Function(
      Object error,
      StackTrace stackTrace,
      Map<String, dynamic> context,
    )?
        sentryReporter,
  }) {
    return ErrorMiddleware(
      errorReporter: sentryReporter,
      includeStackTrace: false,
      includeDetails: false,
    );
  }

  /// Create an error middleware for development
  static ErrorMiddleware development() {
    return ErrorMiddleware(
      includeStackTrace: true,
      includeDetails: true,
    );
  }
}
