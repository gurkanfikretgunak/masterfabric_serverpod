import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';

/// Utility for extracting client IP address from Serverpod sessions.
///
/// This helper provides methods to extract client IP addresses for use
/// in services (e.g., rate limiting, logging, analytics) but should NOT
/// be exposed in public API responses for privacy/security reasons.
class ClientIpHelper {
  /// Cloudflare trace endpoint for IP detection
  static const String _cloudflareTraceUrl = 'https://www.cloudflare.com/cdn-cgi/trace';
  
  /// Cache TTL for Cloudflare IP lookup (5 minutes)
  static const Duration _cloudflareIpCacheTtl = Duration(minutes: 5);
  
  /// In-memory cache for Cloudflare IP (simple cache without SerializableModel)
  static String? _cachedCloudflareIp;
  static DateTime? _cloudflareIpCacheTime;
  
  /// HTTP client for Cloudflare requests
  static HttpClient? _httpClient;
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

  /// Extract client IP with Cloudflare fallback.
  ///
  /// First tries header-based extraction, then falls back to Cloudflare's
  /// trace endpoint if the IP is localhost or invalid.
  ///
  /// Priority order:
  /// 1. Header-based extraction (CF-Connecting-IP, X-Forwarded-For, etc.)
  /// 2. Cloudflare trace endpoint (if header IP is localhost/invalid)
  ///
  /// **Note:** This should only be used internally (logging, rate limiting, etc.)
  /// and should NOT be exposed in API responses.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> logRequest(Session session) async {
  ///   final clientIp = await ClientIpHelper.extractWithFallback(session);
  ///   session.log('Request from IP: $clientIp');
  /// }
  /// ```
  static Future<String?> extractWithFallback(Session session) async {
    // First try header-based extraction
    final headerIp = extract(session);
    
    // Check if IP is valid and not localhost
    if (headerIp != null && _isValidPublicIp(headerIp)) {
      return headerIp;
    }
    
    // If header IP is localhost or invalid, try Cloudflare
    try {
      final cloudflareIp = await _getCloudflareIp(session);
      if (cloudflareIp != null && _isValidPublicIp(cloudflareIp)) {
        return cloudflareIp;
      }
    } catch (e) {
      // Silently fail - fallback is best effort
    }
    
    // Return header IP even if localhost (better than null)
    return headerIp;
  }

  /// Check if IP is a valid public IP (not localhost).
  static bool _isValidPublicIp(String ip) {
    if (ip.isEmpty) return false;
    
    // Check for localhost variants
    final localhostPatterns = [
      '127.0.0.1',
      'localhost',
      '::1',
      '::ffff:127.0.0.1',
      '::ffff:7f00:1',  // IPv6-mapped IPv4 localhost
      '0.0.0.0',
      '::',
    ];
    
    final normalizedIp = ip.toLowerCase().trim();
    if (localhostPatterns.contains(normalizedIp)) {
      return false;
    }
    
    // Check for IPv6-mapped IPv4 localhost patterns
    if (normalizedIp.startsWith('::ffff:7f00:') || 
        normalizedIp.startsWith('::ffff:127.')) {
      return false;
    }
    
    // Check if it's a valid IP format
    return isValidIp(ip);
  }

  /// Get IP from Cloudflare trace endpoint (with in-memory caching).
  static Future<String?> _getCloudflareIp(Session session) async {
    try {
      // Check in-memory cache first
      if (_cachedCloudflareIp != null && _cloudflareIpCacheTime != null) {
        final age = DateTime.now().difference(_cloudflareIpCacheTime!);
        if (age < _cloudflareIpCacheTtl) {
          return _cachedCloudflareIp;
        }
      }
      
      // Initialize HTTP client if needed
      _httpClient ??= HttpClient();
      
      // Fetch from Cloudflare
      final uri = Uri.parse(_cloudflareTraceUrl);
      final request = await _httpClient!.getUrl(uri);
      request.headers.set('User-Agent', 'MasterFabric-Serverpod/1.0');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode != 200) {
        return null;
      }
      
      // Parse trace response (key=value format)
      final lines = responseBody.split('\n');
      String? ip;
      
      for (final line in lines) {
        if (line.startsWith('ip=')) {
          ip = line.substring(3).trim();
          break;
        }
      }
      
      // Cache the result in memory
      if (ip != null && ip.isNotEmpty) {
        _cachedCloudflareIp = ip;
        _cloudflareIpCacheTime = DateTime.now();
        return ip;
      }
      
      return null;
    } catch (e) {
      // Silently fail - Cloudflare lookup is best effort
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
