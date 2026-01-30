import 'package:serverpod/serverpod.dart';

/// Utility functions for formatting log messages
class LogFormatter {
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
      'sessionId': session.sessionId?.toString(),
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
