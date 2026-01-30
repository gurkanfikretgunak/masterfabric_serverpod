import 'package:serverpod/serverpod.dart';
import 'log_formatter.dart';

/// Enhanced logging wrapper around Serverpod's logging system
/// 
/// Provides structured logging with automatic context injection
/// and convenient methods for different log levels.
class CoreLogger {
  final Session _session;

  CoreLogger(this._session);

  /// Log an info message
  /// 
  /// [message] - Log message
  /// [context] - Optional additional context
  void info(
    String message, {
    Map<String, dynamic>? context,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: context);
    final formattedMessage = LogFormatter.formatMessage(message, enrichedContext);
    
    _session.log(
      formattedMessage,
      level: LogLevel.info,
    );
  }

  /// Log a debug message
  /// 
  /// [message] - Log message
  /// [context] - Optional additional context
  void debug(
    String message, {
    Map<String, dynamic>? context,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: context);
    final formattedMessage = LogFormatter.formatMessage(message, enrichedContext);
    
    _session.log(
      formattedMessage,
      level: LogLevel.debug,
    );
  }

  /// Log a warning message
  /// 
  /// [message] - Log message
  /// [context] - Optional additional context
  /// [exception] - Optional exception
  /// [stackTrace] - Optional stack trace
  void warning(
    String message, {
    Map<String, dynamic>? context,
    Exception? exception,
    StackTrace? stackTrace,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: context);
    final formattedMessage = LogFormatter.formatMessage(message, enrichedContext);
    
    _session.log(
      formattedMessage,
      level: LogLevel.warning,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  /// 
  /// [message] - Log message
  /// [context] - Optional additional context
  /// [exception] - Optional exception
  /// [stackTrace] - Optional stack trace
  void error(
    String message, {
    Map<String, dynamic>? context,
    Exception? exception,
    StackTrace? stackTrace,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: context);
    final formattedMessage = LogFormatter.formatMessage(message, enrichedContext);
    
    _session.log(
      formattedMessage,
      level: LogLevel.error,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Log a critical error message
  /// 
  /// [message] - Log message
  /// [context] - Optional additional context
  /// [exception] - Optional exception
  /// [stackTrace] - Optional stack trace
  void critical(
    String message, {
    Map<String, dynamic>? context,
    Exception? exception,
    StackTrace? stackTrace,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: context);
    final formattedMessage = LogFormatter.formatMessage(message, enrichedContext);
    
    _session.log(
      formattedMessage,
      level: LogLevel.error,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Log with custom level
  /// 
  /// [message] - Log message
  /// [level] - Log level
  /// [context] - Optional additional context
  /// [exception] - Optional exception
  /// [stackTrace] - Optional stack trace
  void log(
    String message,
    LogLevel level, {
    Map<String, dynamic>? context,
    Exception? exception,
    StackTrace? stackTrace,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: context);
    final formattedMessage = LogFormatter.formatMessage(message, enrichedContext);
    
    _session.log(
      formattedMessage,
      level: level,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Log structured data as JSON
  /// 
  /// [message] - Log message
  /// [level] - Log level
  /// [data] - Data to log as JSON
  void logJson(
    String message,
    LogLevel level, {
    Map<String, dynamic>? data,
  }) {
    final enrichedContext = LogFormatter.enrichContext(_session, additionalContext: data);
    final jsonMessage = LogFormatter.formatJson(
      message: message,
      level: level,
      context: enrichedContext,
    );
    
    _session.log(
      jsonMessage,
      level: level,
    );
  }
}

/// Extension to easily get CoreLogger from Session
extension SessionLoggerExtension on Session {
  /// Get a CoreLogger instance for this session
  CoreLogger get logger => CoreLogger(this);
}
