/// Common utility functions and constants
class CommonUtils {
  /// Default cache TTL (30 minutes)
  static const Duration defaultCacheTtl = Duration(minutes: 30);

  /// Default session TTL (30 minutes)
  static const Duration defaultSessionTtl = Duration(minutes: 30);

  /// Default request timeout (30 seconds)
  static const Duration defaultRequestTimeout = Duration(seconds: 30);

  /// Default connection timeout (10 seconds)
  static const Duration defaultConnectionTimeout = Duration(seconds: 10);

  /// Format a duration to a human-readable string
  /// 
  /// [duration] - Duration to format
  /// 
  /// Returns formatted string (e.g., "2h 30m", "45s")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

    return parts.join(' ');
  }

  /// Format a DateTime to a readable string
  /// 
  /// [dateTime] - DateTime to format
  /// [includeTime] - Whether to include time (default: true)
  /// 
  /// Returns formatted string (e.g., "2024-01-31 14:30:00")
  static String formatDateTime(
    DateTime dateTime, {
    bool includeTime = true,
  }) {
    final dateStr = '${dateTime.year}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}';

    if (!includeTime) {
      return dateStr;
    }

    return '$dateStr ${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// Validate email format
  /// 
  /// [email] - Email address to validate
  /// 
  /// Returns true if email format is valid
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate UUID format
  /// 
  /// [uuid] - UUID string to validate
  /// 
  /// Returns true if UUID format is valid
  static bool isValidUuid(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(uuid);
  }

  /// Truncate a string to a maximum length
  /// 
  /// [text] - Text to truncate
  /// [maxLength] - Maximum length
  /// [suffix] - Suffix to add if truncated (default: "...")
  /// 
  /// Returns truncated string
  static String truncate(
    String text,
    int maxLength, {
    String suffix = '...',
  }) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Safely parse an integer from a string
  /// 
  /// [value] - String to parse
  /// [defaultValue] - Default value if parsing fails
  /// 
  /// Returns parsed integer or default value
  static int parseInt(String value, {int defaultValue = 0}) {
    try {
      return int.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safely parse a double from a string
  /// 
  /// [value] - String to parse
  /// [defaultValue] - Default value if parsing fails
  /// 
  /// Returns parsed double or default value
  static double parseDouble(String value, {double defaultValue = 0.0}) {
    try {
      return double.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get a value from a map with a default
  /// 
  /// [map] - Map to get value from
  /// [key] - Key to look up
  /// [defaultValue] - Default value if key not found
  /// 
  /// Returns value or default
  static T getValueOrDefault<T>(
    Map<String, dynamic> map,
    String key,
    T defaultValue,
  ) {
    final value = map[key];
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  /// Deep copy a map
  /// 
  /// [map] - Map to copy
  /// 
  /// Returns a deep copy of the map
  static Map<String, dynamic> deepCopyMap(Map<String, dynamic> map) {
    final copy = <String, dynamic>{};
    for (final entry in map.entries) {
      if (entry.value is Map) {
        copy[entry.key] = deepCopyMap(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        copy[entry.key] = List.from(entry.value as List);
      } else {
        copy[entry.key] = entry.value;
      }
    }
    return copy;
  }
}

/// Extension methods for String
extension StringExtensions on String {
  /// Check if string is blank (null, empty, or whitespace only)
  bool get isBlank => trim().isEmpty;

  /// Check if string is not blank
  bool get isNotBlank => !isBlank;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Get time ago string (e.g., "2 hours ago", "3 days ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
