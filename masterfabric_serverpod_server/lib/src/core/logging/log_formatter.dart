import 'package:serverpod/serverpod.dart';

/// Utility functions for formatting log messages
/// 
/// Provides consistent, readable log formatting across the codebase.
class LogFormatter {
  /// Unicode box characters for visual formatting
  static const String boxH = '─';
  static const String boxV = '│';
  static const String boxTL = '┌';
  static const String boxTR = '┐';
  static const String boxBL = '└';
  static const String boxBR = '┘';
  
  /// Status icons
  static const String iconSuccess = '✓';
  static const String iconError = '✗';
  static const String iconWarning = '⚠';
  static const String iconInfo = 'ℹ';
  static const String iconRateLimit = '⚡';
  static const String iconCache = '💾';
  static const String iconAuth = '🔐';
  static const String iconTime = '⏱';

  /// Format log message with context
  /// 
  /// [message] - Base log message
  /// [context] - Additional context map
  /// 
  /// Returns formatted message string
  static String formatMessage(
    String message,
    Map<String, dynamic>? context,
  ) {
    if (context == null || context.isEmpty) {
      return message;
    }

    final contextString = context.entries
        .map((e) => '${e.key}=${e.value}')
        .join(', ');

    return '$message | $contextString';
  }
  
  /// Format a structured log line with separator
  /// 
  /// Example: "⚡ RATE LIMITED │ greeting/hello │ 21/20 requests"
  static String formatStructured(String icon, List<String> parts) {
    return '$icon ${parts.join(' $boxV ')}';
  }
  
  /// Format rate limit log message
  static String formatRateLimit({
    required String endpoint,
    required int current,
    required int limit,
    required int retryAfterSeconds,
    String? resetTime,
  }) {
    final parts = <String>[
      'RATE LIMITED',
      endpoint,
      '$current/$limit requests',
      'retry in ${retryAfterSeconds}s',
    ];
    if (resetTime != null) {
      parts.add('reset at $resetTime');
    }
    return formatStructured(iconRateLimit, parts);
  }
  
  /// Format cache operation log message
  static String formatCacheOp({
    required String operation, // hit, miss, put, invalidate
    required String key,
    String? ttl,
  }) {
    final op = operation.toUpperCase();
    final parts = <String>['CACHE $op', key];
    if (ttl != null) {
      parts.add('ttl=$ttl');
    }
    return formatStructured(iconCache, parts);
  }
  
  /// Format authentication log message
  static String formatAuth({
    required String event, // login, logout, failed, 2fa
    String? userId,
    String? email,
    String? reason,
  }) {
    final parts = <String>['AUTH ${event.toUpperCase()}'];
    if (userId != null) parts.add('user=$userId');
    if (email != null) parts.add('email=$email');
    if (reason != null) parts.add('reason=$reason');
    return formatStructured(iconAuth, parts);
  }
  
  /// Format timing/performance log message  
  static String formatTiming({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metrics,
  }) {
    final ms = duration.inMilliseconds;
    final parts = <String>[operation, '${ms}ms'];
    if (metrics != null) {
      for (final entry in metrics.entries) {
        parts.add('${entry.key}=${entry.value}');
      }
    }
    return formatStructured(iconTime, parts);
  }

  /// Format log message as JSON
  /// 
  /// [message] - Base log message
  /// [level] - Log level
  /// [context] - Additional context map
  /// [timestamp] - Timestamp (defaults to now)
  /// 
  /// Returns JSON string
  static String formatJson({
    required String message,
    required LogLevel level,
    Map<String, dynamic>? context,
    DateTime? timestamp,
  }) {
    final json = <String, dynamic>{
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
      'level': level.name,
      'message': message,
      if (context != null && context.isNotEmpty) 'context': context,
    };

    return json.toString();
  }

  /// Enrich context with common fields
  /// 
  /// [session] - Serverpod session
  /// [additionalContext] - Additional context to merge
  /// 
  /// Returns enriched context map
  static Map<String, dynamic> enrichContext(
    Session session, {
    Map<String, dynamic>? additionalContext,
  }) {
    final context = <String, dynamic>{
      'sessionId': session.sessionId.toString(),
    };

    if (additionalContext != null) {
      context.addAll(additionalContext);
    }

    return context;
  }

  /// Extract endpoint name from session
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns endpoint name or 'unknown'
  static String getEndpointName(Session session) {
    // Endpoint name extraction would need to be implemented based on your routing
    return 'unknown';
  }

  /// Extract user ID from session
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns user ID or null
  static String? getUserId(Session session) {
    // Try to get from authenticated user info
    // This depends on your auth setup
    return null;
  }
}
