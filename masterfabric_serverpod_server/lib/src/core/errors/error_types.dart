/// Enumeration of error types for categorization
enum ErrorType {
  /// Validation errors (e.g., invalid input)
  validation,
  
  /// Authentication errors (e.g., invalid credentials)
  authentication,
  
  /// Authorization errors (e.g., insufficient permissions)
  authorization,
  
  /// Resource not found errors
  notFound,
  
  /// Internal server errors
  internalServer,
  
  /// External service errors (e.g., third-party API failures)
  externalService,
  
  /// Rate limiting errors
  rateLimit,
  
  /// Bad request errors
  badRequest,
}

/// Standardized error response structure
class ErrorResponse {
  /// Error code (e.g., 'VALIDATION_ERROR', 'AUTH_FAILED')
  final String code;
  
  /// Human-readable error message
  final String message;
  
  /// Error type category
  final ErrorType type;
  
  /// Timestamp when error occurred
  final DateTime timestamp;
  
  /// Optional additional details
  final Map<String, dynamic>? details;
  
  /// Optional stack trace (for debugging)
  final String? stackTrace;

  ErrorResponse({
    required this.code,
    required this.message,
    required this.type,
    DateTime? timestamp,
    this.details,
    this.stackTrace,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      if (details != null) 'details': details,
      if (stackTrace != null) 'stackTrace': stackTrace,
    };
  }
}

/// Base exception class for application errors
abstract class AppException implements Exception {
  final String? message;
  final ErrorType errorType;
  final String errorCode;
  final Map<String, dynamic>? details;

  AppException(
    this.message, {
    required this.errorType,
    required this.errorCode,
    this.details,
  });

  ErrorResponse toErrorResponse({String? stackTrace}) {
    return ErrorResponse(
      code: errorCode,
      message: message ?? 'An error occurred',
      type: errorType,
      details: details,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => message ?? 'An error occurred';
}

/// Validation error exception
class ValidationError extends AppException {
  ValidationError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.validation,
          errorCode: 'VALIDATION_ERROR',
          details: details,
        );
}

/// Authentication error exception
class AuthenticationError extends AppException {
  AuthenticationError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.authentication,
          errorCode: 'AUTHENTICATION_ERROR',
          details: details,
        );
}

/// Authorization error exception
class AuthorizationError extends AppException {
  AuthorizationError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.authorization,
          errorCode: 'AUTHORIZATION_ERROR',
          details: details,
        );
}

/// Not found error exception
class NotFoundError extends AppException {
  NotFoundError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.notFound,
          errorCode: 'NOT_FOUND',
          details: details,
        );
}

/// Internal server error exception
class InternalServerError extends AppException {
  InternalServerError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.internalServer,
          errorCode: 'INTERNAL_SERVER_ERROR',
          details: details,
        );
}

/// External service error exception
class ExternalServiceError extends AppException {
  ExternalServiceError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.externalService,
          errorCode: 'EXTERNAL_SERVICE_ERROR',
          details: details,
        );
}

/// Rate limit error exception
class RateLimitError extends AppException {
  RateLimitError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.rateLimit,
          errorCode: 'RATE_LIMIT_EXCEEDED',
          details: details,
        );
}

/// Bad request error exception
class BadRequestError extends AppException {
  BadRequestError(
    super.message, {
    Map<String, dynamic>? details,
  }) : super(
          errorType: ErrorType.badRequest,
          errorCode: 'BAD_REQUEST',
          details: details,
        );
}
