import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../base/middleware_base.dart';
import '../base/middleware_context.dart';

/// Middleware for collecting request metrics and analytics
///
/// Features:
/// - Request count per endpoint
/// - Response time tracking
/// - Error rate monitoring
/// - Integration with Mixpanel/Sentry
/// - Custom metric collection hooks
class MetricsMiddleware extends MiddlewareHandler {
  @override
  String get name => 'metrics';

  @override
  int get priority => 100; // Runs after most middleware

  /// Callback for sending metrics to external service
  final Future<void> Function(RequestMetrics metrics)? _metricsHandler;

  /// Callback for tracking custom events
  final Future<void> Function(String event, Map<String, dynamic> properties)?
      _eventTracker;

  /// In-memory metrics store for aggregation
  final Map<String, EndpointMetrics> _endpointMetrics = {};

  /// Whether to track detailed metrics
  final bool _trackDetailed;

  MetricsMiddleware({
    Future<void> Function(RequestMetrics metrics)? metricsHandler,
    Future<void> Function(String event, Map<String, dynamic> properties)?
        eventTracker,
    bool trackDetailed = false,
  })  : _metricsHandler = metricsHandler,
        _eventTracker = eventTracker,
        _trackDetailed = trackDetailed;

  @override
  Future<MiddlewareResult> onRequest(MiddlewareContext context) async {
    // Store metrics start time
    context.setMetadata('metricsStartTime', DateTime.now());

    // Increment request count for endpoint
    final metrics = _getOrCreateEndpointMetrics(context.fullPath);
    metrics.totalRequests++;

    return MiddlewareResult.proceed();
  }

  @override
  Future<MiddlewareResult> onResponse(
    MiddlewareContext context,
    dynamic result,
  ) async {
    await _recordMetrics(context, success: true);
    return MiddlewareResult.proceed();
  }

  @override
  Future<MiddlewareResult> onError(
    MiddlewareContext context,
    Object error,
    StackTrace stackTrace,
  ) async {
    await _recordMetrics(
      context,
      success: false,
      error: error,
      stackTrace: stackTrace,
    );
    return MiddlewareResult.proceed();
  }

  /// Record metrics for a request
  Future<void> _recordMetrics(
    MiddlewareContext context, {
    required bool success,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    final startTime = context.getMetadata<DateTime>('metricsStartTime');
    final endTime = DateTime.now();
    final durationMs = startTime != null
        ? endTime.difference(startTime).inMilliseconds
        : context.elapsedMs;

    // Update endpoint metrics
    final metrics = _getOrCreateEndpointMetrics(context.fullPath);
    metrics.totalDurationMs += durationMs;
    if (success) {
      metrics.successCount++;
    } else {
      metrics.errorCount++;
    }
    metrics.lastRequestTime = endTime;

    // Track latency buckets
    _updateLatencyBucket(metrics, durationMs);

    // Build request metrics
    final requestMetrics = RequestMetrics(
      requestId: context.getMetadata<String>('requestId') ?? 'unknown',
      endpoint: context.endpointName,
      method: context.methodName,
      totalDurationMs: durationMs,
      middlewareDurationMs: _calculateMiddlewareDuration(context),
      handlerDurationMs: durationMs - _calculateMiddlewareDuration(context),
      success: success,
      statusCode: success ? 200 : _getStatusCode(error),
      clientIp: context.clientIp,
      userId: context.userId,
      startTime: startTime ?? context.startTime,
      endTime: endTime,
      middlewareExecuted: _buildMiddlewareExecutionList(context),
      errorMessage: error?.toString(),
      errorType: error?.runtimeType.toString(),
    );

    // Send to external handler if configured
    if (_metricsHandler != null) {
      try {
        await _metricsHandler!(requestMetrics);
      } catch (e) {
        context.session.log(
          'Metrics handler error: $e',
          level: LogLevel.error,
        );
      }
    }

    // Track event if configured
    if (_eventTracker != null) {
      try {
        await _eventTracker!(
          success ? 'api_request_success' : 'api_request_error',
          {
            'endpoint': context.fullPath,
            'duration_ms': durationMs,
            'user_id': context.userId,
            if (!success) 'error_type': error?.runtimeType.toString(),
          },
        );
      } catch (e) {
        context.session.log(
          'Event tracker error: $e',
          level: LogLevel.error,
        );
      }
    }
  }

  /// Get or create metrics for an endpoint
  EndpointMetrics _getOrCreateEndpointMetrics(String endpoint) {
    return _endpointMetrics.putIfAbsent(
      endpoint,
      () => EndpointMetrics(endpoint: endpoint),
    );
  }

  /// Update latency bucket
  void _updateLatencyBucket(EndpointMetrics metrics, int durationMs) {
    if (durationMs < 50) {
      metrics.latencyBuckets['<50ms'] =
          (metrics.latencyBuckets['<50ms'] ?? 0) + 1;
    } else if (durationMs < 100) {
      metrics.latencyBuckets['50-100ms'] =
          (metrics.latencyBuckets['50-100ms'] ?? 0) + 1;
    } else if (durationMs < 250) {
      metrics.latencyBuckets['100-250ms'] =
          (metrics.latencyBuckets['100-250ms'] ?? 0) + 1;
    } else if (durationMs < 500) {
      metrics.latencyBuckets['250-500ms'] =
          (metrics.latencyBuckets['250-500ms'] ?? 0) + 1;
    } else if (durationMs < 1000) {
      metrics.latencyBuckets['500-1000ms'] =
          (metrics.latencyBuckets['500-1000ms'] ?? 0) + 1;
    } else {
      metrics.latencyBuckets['>1000ms'] =
          (metrics.latencyBuckets['>1000ms'] ?? 0) + 1;
    }
  }

  /// Calculate middleware duration from context
  int _calculateMiddlewareDuration(MiddlewareContext context) {
    // This would sum up durations from middleware execution records
    // For now, estimate as 10% of total
    return (context.elapsedMs * 0.1).round();
  }

  /// Get HTTP status code from error
  int _getStatusCode(Object? error) {
    if (error is MiddlewareError) {
      return error.statusCode;
    }
    if (error is ValidationException) {
      return 400;
    }
    if (error.toString().contains('RateLimitException')) {
      return 429;
    }
    return 500;
  }

  /// Build middleware execution list from context
  List<MiddlewareExecutionInfo> _buildMiddlewareExecutionList(
    MiddlewareContext context,
  ) {
    // This would be populated from the chain execution records
    return [];
  }

  /// Get aggregated metrics for an endpoint
  EndpointMetrics? getEndpointMetrics(String endpoint) {
    return _endpointMetrics[endpoint];
  }

  /// Get all endpoint metrics
  Map<String, EndpointMetrics> getAllMetrics() {
    return Map.unmodifiable(_endpointMetrics);
  }

  /// Reset metrics for an endpoint
  void resetEndpointMetrics(String endpoint) {
    _endpointMetrics.remove(endpoint);
  }

  /// Reset all metrics
  void resetAllMetrics() {
    _endpointMetrics.clear();
  }

  /// Get summary statistics
  MetricsSummary getSummary() {
    var totalRequests = 0;
    var totalErrors = 0;
    var totalDuration = 0;

    for (final metrics in _endpointMetrics.values) {
      totalRequests += metrics.totalRequests;
      totalErrors += metrics.errorCount;
      totalDuration += metrics.totalDurationMs;
    }

    return MetricsSummary(
      totalRequests: totalRequests,
      totalErrors: totalErrors,
      errorRate: totalRequests > 0 ? totalErrors / totalRequests : 0,
      averageLatencyMs: totalRequests > 0 ? totalDuration ~/ totalRequests : 0,
      endpointCount: _endpointMetrics.length,
    );
  }
}

/// Aggregated metrics for an endpoint
class EndpointMetrics {
  final String endpoint;
  int totalRequests = 0;
  int successCount = 0;
  int errorCount = 0;
  int totalDurationMs = 0;
  DateTime? lastRequestTime;
  final Map<String, int> latencyBuckets = {};

  EndpointMetrics({required this.endpoint});

  double get errorRate =>
      totalRequests > 0 ? errorCount / totalRequests : 0;

  int get averageLatencyMs =>
      totalRequests > 0 ? totalDurationMs ~/ totalRequests : 0;

  Map<String, dynamic> toJson() => {
        'endpoint': endpoint,
        'totalRequests': totalRequests,
        'successCount': successCount,
        'errorCount': errorCount,
        'errorRate': errorRate,
        'averageLatencyMs': averageLatencyMs,
        'lastRequestTime': lastRequestTime?.toIso8601String(),
        'latencyBuckets': latencyBuckets,
      };
}

/// Summary of all metrics
class MetricsSummary {
  final int totalRequests;
  final int totalErrors;
  final double errorRate;
  final int averageLatencyMs;
  final int endpointCount;

  const MetricsSummary({
    required this.totalRequests,
    required this.totalErrors,
    required this.errorRate,
    required this.averageLatencyMs,
    required this.endpointCount,
  });

  Map<String, dynamic> toJson() => {
        'totalRequests': totalRequests,
        'totalErrors': totalErrors,
        'errorRate': errorRate,
        'averageLatencyMs': averageLatencyMs,
        'endpointCount': endpointCount,
      };
}
