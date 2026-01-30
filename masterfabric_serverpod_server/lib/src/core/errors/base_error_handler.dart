import 'package:serverpod/serverpod.dart';
import 'error_types.dart';

/// Abstract base class for error handling
/// 
/// Provides a standardized way to handle errors across the application
/// following Dart patterns and Serverpod conventions.
abstract class BaseErrorHandler {
  /// Handle an error and return a standardized error response
  /// 
  /// [session] - The current Serverpod session
  /// [error] - The error that occurred (can be Exception, Error, or any object)
  /// [stackTrace] - Optional stack trace for debugging
  /// 
  /// Returns an [ErrorResponse] with standardized error information
  Future<ErrorResponse> handleError(
    Session session,
    dynamic error,
    StackTrace? stackTrace,
  );

  /// Log the error using Serverpod's logging system
  /// 
  /// [session] - The current Serverpod session
  /// [error] - The error that occurred
  /// [stackTrace] - Optional stack trace
  /// [level] - Log level (defaults to LogLevel.error)
  Future<void> logError(
    Session session,
    dynamic error,
    StackTrace? stackTrace, {
    LogLevel level = LogLevel.error,
  }) async {
    final errorMessage = error.toString();
    final traceString = stackTrace?.toString();

    session.log(
      errorMessage,
      level: level,
      exception: error is Exception ? error : null,
      stackTrace: stackTrace,
    );

    if (traceString != null) {
      session.log(
        'Stack trace: $traceString',
        level: level,
      );
    }
  }

  /// Convert an error to an ErrorResponse
  /// 
  /// Handles different error types and converts them to standardized responses
  ErrorResponse errorToResponse(
    dynamic error,
    StackTrace? stackTrace,
  ) {
    if (error is AppException) {
      return error.toErrorResponse(stackTrace: stackTrace?.toString());
    }

    if (error is Exception) {
      return ErrorResponse(
        code: 'EXCEPTION',
        message: error.toString(),
        type: ErrorType.internalServer,
        stackTrace: stackTrace?.toString(),
      );
    }

    if (error is Exception) {
      return ErrorResponse(
        code: 'EXCEPTION',
        message: error.toString(),
        type: ErrorType.internalServer,
        stackTrace: stackTrace?.toString(),
      );
    }

    // Fallback for any other error type
    return ErrorResponse(
      code: 'UNKNOWN_ERROR',
      message: error.toString(),
      type: ErrorType.internalServer,
      stackTrace: stackTrace?.toString(),
    );
  }
}

/// Default implementation of BaseErrorHandler
class DefaultErrorHandler extends BaseErrorHandler {
  @override
  Future<ErrorResponse> handleError(
    Session session,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    // Log the error
    await logError(session, error, stackTrace);

    // Convert to standardized response
    return errorToResponse(error, stackTrace);
  }
}
