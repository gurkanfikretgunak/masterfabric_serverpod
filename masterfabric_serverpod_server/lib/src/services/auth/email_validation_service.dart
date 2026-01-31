import 'package:serverpod/serverpod.dart';
import '../../core/errors/error_types.dart';
import '../../core/utils/common_utils.dart';

/// Email validation service for registration restrictions
/// 
/// Provides email validation with domain whitelist/blacklist, email blacklist,
/// and rate limiting to prevent spam and abuse.
class EmailValidationService {
  final bool _enabled;
  final List<String> _domainWhitelist;
  final List<String> _domainBlacklist;
  final List<String> _emailBlacklist;
  final bool _rateLimitingEnabled;
  final int _maxAttemptsPerEmail;
  final int _maxAttemptsPerIp;
  final int _windowMinutes;

  // In-memory rate limiting cache (key: email/IP, value: list of attempt timestamps)
  final Map<String, List<DateTime>> _rateLimitCache = {};

  EmailValidationService({
    required bool enabled,
    List<String>? domainWhitelist,
    List<String>? domainBlacklist,
    List<String>? emailBlacklist,
    bool rateLimitingEnabled = true,
    int maxAttemptsPerEmail = 5,
    int maxAttemptsPerIp = 10,
    int windowMinutes = 60,
  })  : _enabled = enabled,
        _domainWhitelist = domainWhitelist ?? [],
        _domainBlacklist = domainBlacklist ?? [],
        _emailBlacklist = emailBlacklist ?? [],
        _rateLimitingEnabled = rateLimitingEnabled,
        _maxAttemptsPerEmail = maxAttemptsPerEmail,
        _maxAttemptsPerIp = maxAttemptsPerIp,
        _windowMinutes = windowMinutes;

  /// Validate email for registration
  /// 
  /// [email] - Email address to validate
  /// [session] - Serverpod session (for logging and IP detection)
  /// 
  /// Throws ValidationError or RateLimitError if validation fails
  Future<void> validateEmailForRegistration(
    String email,
    Session session,
  ) async {
    if (!_enabled) {
      return; // Skip validation if disabled
    }

    // Normalize email (lowercase)
    final normalizedEmail = email.toLowerCase().trim();

    // 1. Validate email format
    if (!CommonUtils.isValidEmail(normalizedEmail)) {
      throw ValidationError(
        'Invalid email format',
        details: {'email': normalizedEmail},
      );
    }

    // 2. Check email blacklist
    if (_isEmailBlocked(normalizedEmail)) {
      session.log(
        'Registration blocked: Email is blacklisted',
        level: LogLevel.warning,
      );
      throw ValidationError(
        'This email address is not allowed',
        details: {'email': normalizedEmail},
      );
    }

    // 3. Extract domain
    final domain = _extractDomain(normalizedEmail);
    if (domain == null) {
      throw ValidationError(
        'Invalid email domain',
        details: {'email': normalizedEmail},
      );
    }

    // 4. Check domain whitelist (if configured)
    if (_domainWhitelist.isNotEmpty && !_isDomainAllowed(domain)) {
      session.log(
        'Registration blocked: Domain not in whitelist',
        level: LogLevel.warning,
      );
      throw ValidationError(
        'Email domain is not allowed. Please use an allowed email domain.',
        details: {
          'email': normalizedEmail,
          'domain': domain,
          'allowedDomains': _domainWhitelist,
        },
      );
    }

    // 5. Check domain blacklist
    if (_isDomainBlocked(domain)) {
      session.log(
        'Registration blocked: Domain is blacklisted',
        level: LogLevel.warning,
      );
      throw ValidationError(
        'This email domain is not allowed',
        details: {
          'email': normalizedEmail,
          'domain': domain,
        },
      );
    }

    // 6. Check rate limiting
    if (_rateLimitingEnabled) {
      await _checkRateLimit(normalizedEmail, session);
    }

    // All validations passed
    session.log(
      'Email validation passed: $normalizedEmail',
      level: LogLevel.debug,
    );
  }

  /// Check if domain is allowed (whitelist check)
  bool _isDomainAllowed(String domain) {
    if (_domainWhitelist.isEmpty) {
      return true; // Empty whitelist means all domains are allowed
    }

    // Check if domain matches any whitelist entry
    // Supports both "@domain.com" and "domain.com" formats
    for (final allowedDomain in _domainWhitelist) {
      final normalizedAllowed = allowedDomain.startsWith('@')
          ? allowedDomain.substring(1).toLowerCase()
          : allowedDomain.toLowerCase();
      
      if (domain.toLowerCase() == normalizedAllowed) {
        return true;
      }
    }

    return false;
  }

  /// Check if domain is blocked (blacklist check)
  bool _isDomainBlocked(String domain) {
    // Check if domain matches any blacklist entry
    // Supports both "@domain.com" and "domain.com" formats
    for (final blockedDomain in _domainBlacklist) {
      final normalizedBlocked = blockedDomain.startsWith('@')
          ? blockedDomain.substring(1).toLowerCase()
          : blockedDomain.toLowerCase();
      
      if (domain.toLowerCase() == normalizedBlocked) {
        return true;
      }
    }

    return false;
  }

  /// Check if email is blocked
  bool _isEmailBlocked(String email) {
    return _emailBlacklist.contains(email.toLowerCase());
  }

  /// Extract domain from email address
  String? _extractDomain(String email) {
    final parts = email.split('@');
    if (parts.length != 2) {
      return null;
    }
    return parts[1];
  }

  /// Check rate limiting for email and IP
  Future<void> _checkRateLimit(String email, Session session) async {
    final now = DateTime.now();
    final windowStart = now.subtract(Duration(minutes: _windowMinutes));

    // Get client IP (try multiple methods)
    String? clientIp;
    try {
      // Note: Session doesn't directly expose httpRequest in endpoints
      // IP detection would need to be passed separately or accessed differently
      // For now, we'll leave it as null
    } catch (e) {
      // Ignore if httpRequest is not available
    }

    // Check rate limit per email
    final emailKey = 'email:$email';
    final emailAttempts = _rateLimitCache[emailKey] ?? [];
    final recentEmailAttempts = emailAttempts
        .where((timestamp) => timestamp.isAfter(windowStart))
        .toList();

    if (recentEmailAttempts.length >= _maxAttemptsPerEmail) {
      session.log(
        'Rate limit exceeded for email: $email',
        level: LogLevel.warning,
      );
      throw RateLimitError(
        'Too many registration attempts for this email. Please try again later.',
        details: {
          'email': email,
          'maxAttempts': _maxAttemptsPerEmail,
          'windowMinutes': _windowMinutes,
          'retryAfter': _windowMinutes,
        },
      );
    }

    // Check rate limit per IP (if IP is available)
    if (clientIp != null && clientIp.isNotEmpty) {
      final ipKey = 'ip:$clientIp';
      final ipAttempts = _rateLimitCache[ipKey] ?? [];
      final recentIpAttempts = ipAttempts
          .where((timestamp) => timestamp.isAfter(windowStart))
          .toList();

      if (recentIpAttempts.length >= _maxAttemptsPerIp) {
        session.log(
          'Rate limit exceeded for IP: $clientIp',
          level: LogLevel.warning,
        );
        throw RateLimitError(
          'Too many registration attempts from this IP address. Please try again later.',
          details: {
            'ip': clientIp,
            'maxAttempts': _maxAttemptsPerIp,
            'windowMinutes': _windowMinutes,
            'retryAfter': _windowMinutes,
          },
        );
      }

      // Record IP attempt
      recentIpAttempts.add(now);
      _rateLimitCache[ipKey] = recentIpAttempts;
    }

    // Record email attempt
    recentEmailAttempts.add(now);
    _rateLimitCache[emailKey] = recentEmailAttempts;

    // Clean up old entries periodically (simple cleanup)
    _cleanupRateLimitCache();
  }

  /// Clean up old rate limit cache entries
  void _cleanupRateLimitCache() {
    // Clean up every 100th call (simple optimization)
    if (_rateLimitCache.length % 100 == 0) {
      final now = DateTime.now();
      final windowStart = now.subtract(Duration(minutes: _windowMinutes));

      _rateLimitCache.removeWhere((key, attempts) {
        final recentAttempts = attempts
            .where((timestamp) => timestamp.isAfter(windowStart))
            .toList();
        
        if (recentAttempts.isEmpty) {
          return true; // Remove entry with no recent attempts
        }
        
        // Update with only recent attempts
        _rateLimitCache[key] = recentAttempts;
        return false;
      });
    }
  }

  /// Get validation configuration summary
  Map<String, dynamic> getConfig() {
    return {
      'enabled': _enabled,
      'domainWhitelist': _domainWhitelist,
      'domainBlacklist': _domainBlacklist,
      'emailBlacklistCount': _emailBlacklist.length,
      'rateLimiting': {
        'enabled': _rateLimitingEnabled,
        'maxAttemptsPerEmail': _maxAttemptsPerEmail,
        'maxAttemptsPerIp': _maxAttemptsPerIp,
        'windowMinutes': _windowMinutes,
      },
    };
  }
}
