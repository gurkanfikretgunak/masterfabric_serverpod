import 'package:serverpod/serverpod.dart';

import 'middleware_base.dart';
import 'middleware_context.dart';
import 'middleware_config.dart';

/// Execution result for the entire middleware chain
class ChainExecutionResult {
  /// Whether the chain completed successfully
  final bool success;

  /// The final result (response or error)
  final dynamic result;

  /// Individual middleware results
  final List<MiddlewareExecutionRecord> records;

  /// Total execution time
  final Duration totalDuration;

  /// Error if chain failed
  final Object? error;

  /// Stack trace if error occurred
  final StackTrace? stackTrace;

  const ChainExecutionResult({
    required this.success,
    this.result,
    required this.records,
    required this.totalDuration,
    this.error,
    this.stackTrace,
  });
}

/// Record of a single middleware execution
class MiddlewareExecutionRecord {
  final String middlewareName;
  final MiddlewareResult result;
  final Duration duration;
  final String phase; // 'request', 'response', 'error'

  const MiddlewareExecutionRecord({
    required this.middlewareName,
    required this.result,
    required this.duration,
    required this.phase,
  });
}

/// Manages the middleware chain and execution order
///
/// Implements the chain of responsibility pattern where each
/// middleware can process the request/response and decide
/// whether to continue or halt the chain.
class MiddlewareChain {
  /// List of middleware sorted by priority
  final List<MiddlewareHandler> _middleware;

  /// Global configuration
  final MiddlewareGlobalConfig _config;

  /// Execution records for debugging/metrics
  final List<MiddlewareExecutionRecord> _records = [];

  MiddlewareChain({
    required List<MiddlewareHandler> middleware,
    required MiddlewareGlobalConfig config,
  })  : _middleware = List.from(middleware)..sort((a, b) => a.priority.compareTo(b.priority)),
        _config = config;

  /// Get all registered middleware
  List<MiddlewareHandler> get middleware => List.unmodifiable(_middleware);

  /// Get execution records
  List<MiddlewareExecutionRecord> get records => List.unmodifiable(_records);

  /// Execute pre-request middleware chain
  ///
  /// Runs all middleware onRequest methods in priority order.
  /// Stops if any middleware returns reject or skip.
  Future<MiddlewareResult> executePreRequest(MiddlewareContext context) async {
    for (final mw in _middleware) {
      if (!mw.shouldRun(context)) {
        continue;
      }

      if (!_isMiddlewareEnabled(mw.name)) {
        continue;
      }

      final stopwatch = Stopwatch()..start();
      try {
        final result = await mw.onRequest(context);
        stopwatch.stop();

        _records.add(MiddlewareExecutionRecord(
          middlewareName: mw.name,
          result: result,
          duration: stopwatch.elapsed,
          phase: 'request',
        ));

        if (result.shouldReject) {
          return result;
        }

        if (result.shouldSkip) {
          // Skip remaining middleware but don't reject
          break;
        }
      } catch (e) {
        stopwatch.stop();
        context.session.log(
          'Middleware ${mw.name} threw exception in onRequest: $e',
          level: LogLevel.error,
        );

        return MiddlewareResult.reject(
          error: e,
          message: 'Middleware ${mw.name} failed: $e',
        );
      }
    }

    return MiddlewareResult.proceed();
  }

  /// Execute post-response middleware chain
  ///
  /// Runs all middleware onResponse methods in reverse priority order.
  Future<MiddlewareResult> executePostResponse(
    MiddlewareContext context,
    dynamic result,
  ) async {
    context.response = result;

    // Run in reverse order for response
    for (final mw in _middleware.reversed) {
      if (!mw.shouldRun(context)) {
        continue;
      }

      if (!_isMiddlewareEnabled(mw.name)) {
        continue;
      }

      final stopwatch = Stopwatch()..start();
      try {
        final mwResult = await mw.onResponse(context, result);
        stopwatch.stop();

        _records.add(MiddlewareExecutionRecord(
          middlewareName: mw.name,
          result: mwResult,
          duration: stopwatch.elapsed,
          phase: 'response',
        ));

        // Update result if middleware modified it
        if (mwResult.data != null && mwResult.data!.containsKey('modifiedResult')) {
          result = mwResult.data!['modifiedResult'];
          context.response = result;
        }
      } catch (e) {
        stopwatch.stop();
        context.session.log(
          'Middleware ${mw.name} threw exception in onResponse: $e',
          level: LogLevel.error,
        );
        // Don't fail the response, just log
      }
    }

    return MiddlewareResult.proceed();
  }

  /// Execute error handling middleware chain
  ///
  /// Runs all middleware onError methods in reverse priority order.
  Future<MiddlewareResult> executeOnError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  ) async {
    context.error = error;
    context.stackTrace = stackTrace;

    MiddlewareResult? transformedResult;

    // Run in reverse order for errors
    for (final mw in _middleware.reversed) {
      if (!mw.shouldRun(context)) {
        continue;
      }

      if (!_isMiddlewareEnabled(mw.name)) {
        continue;
      }

      final stopwatch = Stopwatch()..start();
      try {
        final result = await mw.onError(context, error, stackTrace);
        stopwatch.stop();

        _records.add(MiddlewareExecutionRecord(
          middlewareName: mw.name,
          result: result,
          duration: stopwatch.elapsed,
          phase: 'error',
        ));

        // If middleware transformed the error, use that
        if (result.data != null && result.data!.containsKey('transformedError')) {
          transformedResult = result;
          error = result.data!['transformedError'];
        }
      } catch (e) {
        stopwatch.stop();
        context.session.log(
          'Middleware ${mw.name} threw exception in onError: $e',
          level: LogLevel.error,
        );
      }
    }

    return transformedResult ?? MiddlewareResult.proceed();
  }

  /// Execute the full chain with a handler
  ///
  /// This is the main entry point for middleware execution.
  /// It runs pre-request middleware, executes the handler, then runs
  /// post-response or error middleware.
  Future<ChainExecutionResult> execute<T>(
    MiddlewareContext context,
    Future<T> Function() handler,
  ) async {
    final chainStopwatch = Stopwatch()..start();
    _records.clear();

    try {
      // Pre-request phase
      final preResult = await executePreRequest(context);
      if (preResult.shouldReject) {
        chainStopwatch.stop();
        return ChainExecutionResult(
          success: false,
          error: preResult.error,
          records: List.from(_records),
          totalDuration: chainStopwatch.elapsed,
        );
      }

      // Execute handler
      final result = await handler();
      context.response = result;

      // Post-response phase
      await executePostResponse(context, result);

      chainStopwatch.stop();
      return ChainExecutionResult(
        success: true,
        result: context.response,
        records: List.from(_records),
        totalDuration: chainStopwatch.elapsed,
      );
    } catch (e, st) {
      // Error phase
      await executeOnError(context, e, st);

      chainStopwatch.stop();
      return ChainExecutionResult(
        success: false,
        error: e,
        stackTrace: st,
        records: List.from(_records),
        totalDuration: chainStopwatch.elapsed,
      );
    }
  }

  /// Check if a middleware is enabled globally
  bool _isMiddlewareEnabled(String name) {
    switch (name) {
      case 'logging':
        return _config.enableLogging;
      case 'rate_limit':
        return _config.enableRateLimit;
      case 'auth':
        return _config.enableAuth;
      case 'validation':
        return _config.enableValidation;
      case 'metrics':
        return _config.enableMetrics;
      case 'error':
        return _config.enableErrorHandling;
      default:
        return true;
    }
  }

  /// Create a chain from a registry for a specific endpoint
  static MiddlewareChain forEndpoint({
    required List<MiddlewareHandler> middleware,
    required MiddlewareGlobalConfig globalConfig,
    EndpointMiddlewareConfig? endpointConfig,
  }) {
    // Filter middleware based on endpoint config
    final filteredMiddleware = middleware.where((mw) {
      if (endpointConfig == null) return true;

      switch (mw.name) {
        case 'logging':
          return !endpointConfig.skipLogging;
        case 'rate_limit':
          return !endpointConfig.skipRateLimit;
        case 'auth':
          return !endpointConfig.skipAuth;
        case 'validation':
          return !endpointConfig.skipValidation;
        case 'metrics':
          return !endpointConfig.skipMetrics;
        default:
          return true;
      }
    }).toList();

    return MiddlewareChain(
      middleware: filteredMiddleware,
      config: globalConfig,
    );
  }
}
