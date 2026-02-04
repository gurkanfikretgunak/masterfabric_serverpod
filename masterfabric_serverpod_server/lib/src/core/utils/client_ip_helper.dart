import 'package:serverpod/serverpod.dart';

/// Utility for extracting client IP address from Serverpod sessions.
///
/// This helper provides methods to extract client IP addresses for use
/// in services (e.g., rate limiting, logging, analytics) but should NOT
/// be exposed in public API responses for privacy/security reasons.
class ClientIpHelper {
  /// Extract client IP from session with header priority.
  ///
  /// Priority order:
  /// 1. CF-Connecting-IP (Cloudflare)
  /// 2. X-Forwarded-For (proxy/load balancer)
  /// 3. X-Real-IP (nginx)
  /// 4. Remote address from connection (Serverpod's built-in)
  ///
  /// **Note:** This should only be used internally (logging, rate limiting, etc.)
  /// and should NOT be exposed in API responses.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> logRequest(Session session) async {
  ///   final clientIp = ClientIpHelper.extract(session);
  ///   session.log('Request from IP: $clientIp');
  /// }
  /// ```
  static String? extract(Session session) {
    try {
      if (session is MethodCallSession) {
        final request = session.request;

        // Check Cloudflare header first
        final cfIpHeader = request.headers['cf-connecting-ip'];
        if (cfIpHeader != null && cfIpHeader.isNotEmpty) {
          return cfIpHeader.first;
        }

        // Check X-Forwarded-For header
        final forwardedForHeader = request.headers['x-forwarded-for'];
        if (forwardedForHeader != null && forwardedForHeader.isNotEmpty) {
          // X-Forwarded-For can contain multiple IPs: "client, proxy1, proxy2"
          // The first one is usually the original client IP
          final forwardedFor = forwardedForHeader.first;
          return forwardedFor.split(',').first.trim();
        }

        // Check X-Real-IP header (nginx)
        final realIpHeader = request.headers['x-real-ip'];
        if (realIpHeader != null && realIpHeader.isNotEmpty) {
          return realIpHeader.first;
        }

        // Fallback to remoteInfo extension (handles proxies automatically)
        try {
          final remoteInfo = request.remoteInfo;
          if (remoteInfo.isNotEmpty) {
            return remoteInfo;
          }
        } catch (_) {
          // remoteInfo extension not available, try connectionInfo
          try {
            final connectionInfo = request.connectionInfo;
            // Try to extract IP from connectionInfo
            // Note: ConnectionInfo structure may vary by Serverpod version
            final remoteAddress = (connectionInfo as dynamic).remoteAddress;
            if (remoteAddress != null) {
              return remoteAddress.address?.toString() ?? remoteAddress.toString();
            }
          } catch (_) {
            // Connection info access failed
          }
        }

        return null;
      }
      return null;
    } catch (e) {
      // Silently fail - IP extraction is best effort
      return null;
    }
  }

  /// Extract client IP using Serverpod's built-in method only.
  ///
  /// This is simpler but may not handle all proxy scenarios.
  /// Use [extract] for better proxy support.
  static String? extractSimple(Session session) {
    try {
      if (session is MethodCallSession) {
        final request = session.request;
        // Use remoteInfo extension which handles proxies automatically
        try {
          final remoteInfo = request.remoteInfo;
          if (remoteInfo.isNotEmpty) {
            return remoteInfo;
          }
        } catch (_) {
          // remoteInfo not available
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if an IP address is valid format.
  static bool isValidIp(String? ip) {
    if (ip == null || ip.isEmpty) return false;

    // IPv4 pattern
    final ipv4Pattern = RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
    );

    // IPv6 pattern (simplified)
    final ipv6Pattern = RegExp(
      r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^::1$|^::$',
    );

    return ipv4Pattern.hasMatch(ip) || ipv6Pattern.hasMatch(ip);
  }

  /// Sanitize IP address for logging (mask last octet for privacy).
  ///
  /// Example: "192.168.1.100" -> "192.168.1.xxx"
  static String sanitizeForLogging(String? ip) {
    if (ip == null || ip.isEmpty) return 'unknown';

    // For IPv4, mask last octet
    final parts = ip.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.${parts[1]}.${parts[2]}.xxx';
    }

    // For IPv6, mask last segment
    final ipv6Parts = ip.split(':');
    if (ipv6Parts.length > 1) {
      return '${ipv6Parts.take(ipv6Parts.length - 1).join(':')}:xxxx';
    }

    return ip;
  }
}
