import 'middleware_context.dart';

/// Result of middleware execution
enum MiddlewareAction {
  /// Continue to next middleware/endpoint
  proceed,

  /// Stop chain execution (request rejected)
  reject,

  /// Skip remaining middleware but continue to endpoint
  skip,
}

/// Result returned by middleware execution
class MiddlewareResult {
  /// The action to take after this middleware
  final MiddlewareAction action;

  /// Optional message for logging/debugging
  final String? message;

  /// Optional data to pass to next middleware or response
  final Map<String, dynamic>? data;

  /// Optional error if action is reject
  final Object? error;

  /// Duration of middleware execution
  final Duration? duration;

  const MiddlewareResult({
    required this.action,
    this.message,
    this.data,
    this.error,
    this.duration,
  });

  /// Create a proceed result
  factory MiddlewareResult.proceed({String? message, Map<String, dynamic>? data}) {
    return MiddlewareResult(
      action: MiddlewareAction.proceed,
      message: message,
      data: data,
    );
  }

  /// Create a reject result
  factory MiddlewareResult.reject({
    required Object error,
    String? message,
  }) {
    return MiddlewareResult(
      action: MiddlewareAction.reject,
      message: message,
      error: error,
    );
  }

  /// Create a skip result
  factory MiddlewareResult.skip({String? message}) {
    return MiddlewareResult(
      action: MiddlewareAction.skip,
      message: message,
    );
  }

  bool get shouldProceed => action == MiddlewareAction.proceed;
  bool get shouldReject => action == MiddlewareAction.reject;
  bool get shouldSkip => action == MiddlewareAction.skip;
}

/// Base class for all middleware implementations
///
/// MiddlewareHandler follows the chain of responsibility pattern.
/// Each middleware can:
/// - Process the request before the endpoint (onRequest)
/// - Process the response after the endpoint (onResponse)
/// - Handle errors (onError)
///
/// Priority determines execution order (lower = runs first)
abstract class MiddlewareHandler {
  /// Unique name for this middleware
  String get name;

  /// Priority for execution order (lower runs first)
  /// Recommended ranges:
  /// - 0-50: Pre-processing (logging, rate limit, auth)
  /// - 50-100: Validation
  /// - 100-200: Business logic middleware
  /// - 200+: Post-processing (metrics, cleanup)
  int get priority;

  /// Whether this middleware is enabled by default
  bool get enabledByDefault => true;

  /// Called before the endpoint method is executed
  ///
  /// [context] contains request information and session
  /// Return [MiddlewareResult.proceed] to continue
  /// Return [MiddlewareResult.reject] to stop and return error
  Future<MiddlewareResult> onRequest(MiddlewareContext context);

  /// Called after the endpoint method returns successfully
  ///
  /// [context] contains request information
  /// [result] is the value returned by the endpoint
  Future<MiddlewareResult> onResponse(
    MiddlewareContext context,
    dynamic result,
  );

  /// Called when an error occurs in the endpoint or previous middleware
  ///
  /// [context] contains request information
  /// [error] is the thrown error
  /// [stackTrace] is the error stack trace
  Future<MiddlewareResult> onError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  );

  /// Check if this middleware should run for the given context
  ///
  /// Override to implement custom skip logic
  bool shouldRun(MiddlewareContext context) {
    return enabledByDefault && !context.isMiddlewareSkipped(name);
  }
}

/// Mixin for middleware that only needs onRequest
abstract class RequestOnlyMiddleware extends MiddlewareHandler {
  @override
  Future<MiddlewareResult> onResponse(
    MiddlewareContext context,
    dynamic result,
  ) async {
    return MiddlewareResult.proceed();
  }

  @override
  Future<MiddlewareResult> onError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  ) async {
    return MiddlewareResult.proceed();
  }
}

/// Mixin for middleware that only needs onResponse
abstract class ResponseOnlyMiddleware extends MiddlewareHandler {
  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    return MiddlewareResult.proceed();
  }

  @override
  Future<MiddlewareResult> onError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  ) async {
    return MiddlewareResult.proceed();
  }
}

/// Mixin for middleware that only handles errors
abstract class ErrorOnlyMiddleware extends MiddlewareHandler {
  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    return MiddlewareResult.proceed();
  }

  @override
  Future<MiddlewareResult> onResponse(
    MiddlewareContext context,
    dynamic result,
  ) async {
    return MiddlewareResult.proceed();
  }
}
