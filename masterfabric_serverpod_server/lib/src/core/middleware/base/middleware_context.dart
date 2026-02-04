import 'package:serverpod/serverpod.dart';
import '../../utils/client_ip_helper.dart';

/// Context object that carries request data through the middleware chain
///
/// This object is created at the start of request processing and passed
/// through all middleware. It contains:
/// - Session reference for database/cache access
/// - Request metadata (endpoint, method, parameters)
/// - Timing information
/// - Custom metadata that middleware can add/read
class MiddlewareContext {
  /// The Serverpod session
  final Session session;

  /// Name of the endpoint being called
  final String endpointName;

  /// Name of the method being called
  final String methodName;

  /// Request parameters (may be sanitized)
  final Map<String, dynamic> parameters;

  /// Timestamp when request processing started
  final DateTime startTime;

  /// Custom metadata that can be added by middleware
  final Map<String, dynamic> _metadata;

  /// Set of middleware names that should be skipped
  final Set<String> _skippedMiddleware;

  /// Client IP address (extracted from headers or connection)
  String? _clientIp;

  /// User identifier (set after auth middleware)
  String? _userId;

  /// Response data (set after endpoint execution)
  dynamic _response;

  /// Error if one occurred
  Object? _error;

  /// Stack trace if error occurred
  StackTrace? _stackTrace;

  MiddlewareContext({
    required this.session,
    required this.endpointName,
    required this.methodName,
    Map<String, dynamic>? parameters,
    DateTime? startTime,
    Map<String, dynamic>? metadata,
    Set<String>? skippedMiddleware,
  })  : parameters = parameters ?? {},
        startTime = startTime ?? DateTime.now(),
        _metadata = metadata ?? {},
        _skippedMiddleware = skippedMiddleware ?? {};

  /// Get custom metadata value
  T? getMetadata<T>(String key) {
    final value = _metadata[key];
    return value is T ? value : null;
  }

  /// Set custom metadata value
  void setMetadata(String key, dynamic value) {
    _metadata[key] = value;
  }

  /// Check if metadata key exists
  bool hasMetadata(String key) => _metadata.containsKey(key);

  /// Get all metadata
  Map<String, dynamic> get metadata => Map.unmodifiable(_metadata);

  /// Mark a middleware as skipped
  void skipMiddleware(String middlewareName) {
    _skippedMiddleware.add(middlewareName);
  }

  /// Check if a middleware should be skipped
  bool isMiddlewareSkipped(String middlewareName) {
    return _skippedMiddleware.contains(middlewareName);
  }

  /// Get client IP address
  String? get clientIp => _clientIp;

  /// Set client IP address (usually by logging middleware)
  set clientIp(String? ip) => _clientIp = ip;

  /// Get authenticated user ID
  String? get userId => _userId;

  /// Set user ID (usually by auth middleware)
  set userId(String? id) => _userId = id;

  /// Get the response (after endpoint execution)
  dynamic get response => _response;

  /// Set the response
  set response(dynamic value) => _response = value;

  /// Get error if one occurred
  Object? get error => _error;

  /// Set error
  set error(Object? err) => _error = err;

  /// Get stack trace if error occurred
  StackTrace? get stackTrace => _stackTrace;

  /// Set stack trace
  set stackTrace(StackTrace? trace) => _stackTrace = trace;

  /// Get duration since request started
  Duration get elapsed => DateTime.now().difference(startTime);

  /// Get elapsed milliseconds
  int get elapsedMs => elapsed.inMilliseconds;

  /// Full endpoint path (endpoint/method)
  String get fullPath => '$endpointName/$methodName';

  /// Check if user is authenticated
  bool get isAuthenticated => session.authenticated != null;

  /// Get authenticated user identifier from session
  String? get authenticatedUserId {
    return session.authenticated?.userIdentifier.toString();
  }

  /// Get rate limit identifier (user ID or IP-based key)
  String get rateLimitIdentifier {
    if (isAuthenticated) {
      return 'user:$authenticatedUserId';
    }
    return 'ip:${clientIp ?? 'unknown'}:$endpointName';
  }

  /// Create a copy with modified values
  MiddlewareContext copyWith({
    Session? session,
    String? endpointName,
    String? methodName,
    Map<String, dynamic>? parameters,
    DateTime? startTime,
    Map<String, dynamic>? metadata,
    Set<String>? skippedMiddleware,
  }) {
    return MiddlewareContext(
      session: session ?? this.session,
      endpointName: endpointName ?? this.endpointName,
      methodName: methodName ?? this.methodName,
      parameters: parameters ?? Map.from(this.parameters),
      startTime: startTime ?? this.startTime,
      metadata: metadata ?? Map.from(_metadata),
      skippedMiddleware: skippedMiddleware ?? Set.from(_skippedMiddleware),
    );
  }

  /// Extract client IP from session/headers
  ///
  /// Checks common headers in order:
  /// 1. CF-Connecting-IP (Cloudflare)
  /// 2. X-Forwarded-For (proxy)
  /// 3. X-Real-IP (nginx)
  /// 4. Remote address from connection
  ///
  /// **Note:** Client IP should only be used internally (logging, rate limiting)
  /// and should NOT be exposed in API responses.
  String? extractClientIp() {
    // If already extracted and stored, return it
    if (_clientIp != null) {
      return _clientIp;
    }

    // Extract using helper
    final ip = ClientIpHelper.extract(session);
    _clientIp = ip;
    return ip ?? 'unknown';
  }

  @override
  String toString() {
    return 'MiddlewareContext('
        'endpoint: $endpointName, '
        'method: $methodName, '
        'elapsed: ${elapsedMs}ms, '
        'authenticated: $isAuthenticated'
        ')';
  }
}
