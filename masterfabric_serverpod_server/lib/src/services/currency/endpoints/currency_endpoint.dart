import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:yaml/yaml.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';
import '../services/currency_service.dart';

/// Currency endpoint for money and currency operations.
///
/// Provides endpoints for:
/// - Currency conversion
/// - Exchange rate retrieval
/// - Supported currencies list
/// - Currency formatting
///
/// ## Features:
/// - Public endpoint (no authentication required)
/// - Cached exchange rates for performance
/// - Rate limited to prevent abuse
///
/// ## Usage from client:
/// ```dart
/// // Convert currency
/// final result = await client.currency.convertCurrency(
///   fromCurrency: 'USD',
///   toCurrency: 'EUR',
///   amount: 100.0,
/// );
/// print('${result.amount} ${result.fromCurrency} = ${result.convertedAmount} ${result.toCurrency}');
///
/// // Get exchange rate
/// final rate = await client.currency.getExchangeRate(
///   baseCurrency: 'USD',
///   targetCurrency: 'EUR',
/// );
/// print('1 ${rate.baseCurrency} = ${rate.rate} ${rate.targetCurrency}');
///
/// // Get supported currencies
/// final currencies = await client.currency.getSupportedCurrencies();
/// print('Supported currencies: ${currencies.currencies.join(", ")}');
/// ```
///
/// ## Role Requirements:
/// - All methods: Requires 'public' role (unauthenticated access allowed)
class CurrencyEndpoint extends MasterfabricEndpoint {
  /// Currency service for fetching exchange rates
  /// Initialized lazily with API key from config
  CurrencyService? _currencyService;

  /// Get or initialize currency service with API key from config
  CurrencyService _getCurrencyService(Session session) {
    if (_currencyService != null) {
      return _currencyService!;
    }

    // Read API key from config
    final apiKey = _getApiKeyFromConfig(session);
    _currencyService = CurrencyService(apiKey: apiKey);
    return _currencyService!;
  }

  /// Get API key from config file
  String? _getApiKeyFromConfig(Session session) {
    try {
      // Determine config file path based on environment
      final environment = Platform.environment['SERVERPOD_ENVIRONMENT'] ?? 'development';
      final configPath = 'config/$environment.yaml';
      
      final configFile = File(configPath);
      if (!configFile.existsSync()) {
        // Fallback to development.yaml
        final fallbackPath = 'config/development.yaml';
        final fallbackFile = File(fallbackPath);
        if (!fallbackFile.existsSync()) {
          return null;
        }
        final content = fallbackFile.readAsStringSync();
        final yaml = loadYaml(content) as Map;
        final currencyConfig = yaml['currency'] as Map?;
        return currencyConfig?['apiKey'] as String?;
      }

      final content = configFile.readAsStringSync();
      final yaml = loadYaml(content) as Map;
      final currencyConfig = yaml['currency'] as Map?;
      return currencyConfig?['apiKey'] as String?;
    } catch (e) {
      session.log(
        'Failed to read currency API key from config: $e',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  // ============================================================
  // PUBLIC METHODS (no authentication required)
  // ============================================================

  /// Convert currency from one to another.
  ///
  /// **Required Roles:** 'public' (unauthenticated access allowed)
  ///
  /// [session] - Serverpod session
  /// [fromCurrency] - Source currency code (ISO 4217, e.g., 'USD', 'EUR')
  /// [toCurrency] - Target currency code (ISO 4217, e.g., 'USD', 'EUR')
  /// [amount] - Amount to convert
  ///
  /// Returns [CurrencyConversionResponse] with converted amount and exchange rate.
  ///
  /// Rate limited to 60 requests per minute.
  Future<CurrencyConversionResponse> convertCurrency(
    Session session,
    String fromCurrency,
    String toCurrency,
    double amount,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'convertCurrency',
      config: EndpointMiddlewareConfig(
        skipAuth: true, // Public endpoint - no auth required
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'currency_convert',
        ),
      ),
      parameters: {
        'fromCurrency': fromCurrency,
        'toCurrency': toCurrency,
        'amount': amount,
      },
      handler: () async {
        // Normalize currency codes
        final from = fromCurrency.toUpperCase();
        final to = toCurrency.toUpperCase();

        // Validate currencies
        if (!_isValidCurrencyCode(from)) {
          throw ArgumentError('Invalid fromCurrency: $fromCurrency');
        }
        if (!_isValidCurrencyCode(to)) {
          throw ArgumentError('Invalid toCurrency: $toCurrency');
        }

        // Validate amount
        if (amount < 0) {
          throw ArgumentError('Amount must be non-negative');
        }

        // If same currency, return as-is
        if (from == to) {
          return CurrencyConversionResponse(
            success: true,
            fromCurrency: from,
            toCurrency: to,
            amount: amount,
            convertedAmount: amount,
            exchangeRate: 1.0,
            timestamp: DateTime.now(),
          );
        }

        // Get exchange rate from service (fetches from API with caching)
        final exchangeRate = await _getCurrencyService(session).getExchangeRate(session, from, to);

        // Calculate converted amount
        final convertedAmount = amount * exchangeRate;

        return CurrencyConversionResponse(
          success: true,
          fromCurrency: from,
          toCurrency: to,
          amount: amount,
          convertedAmount: convertedAmount,
          exchangeRate: exchangeRate,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  /// Get exchange rate between two currencies.
  ///
  /// **Required Roles:** 'public' (unauthenticated access allowed)
  ///
  /// [session] - Serverpod session
  /// [baseCurrency] - Base currency code (ISO 4217)
  /// [targetCurrency] - Target currency code (ISO 4217)
  ///
  /// Returns [ExchangeRateResponse] with the current exchange rate.
  ///
  /// Rate limited to 60 requests per minute.
  Future<ExchangeRateResponse> getExchangeRate(
    Session session,
    String baseCurrency,
    String targetCurrency,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getExchangeRate',
      config: EndpointMiddlewareConfig(
        skipAuth: true, // Public endpoint - no auth required
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'currency_rate',
        ),
      ),
      parameters: {
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
      },
      handler: () async {
        // Normalize currency codes
        final base = baseCurrency.toUpperCase();
        final target = targetCurrency.toUpperCase();

        // Validate currencies
        if (!_isValidCurrencyCode(base)) {
          throw ArgumentError('Invalid baseCurrency: $baseCurrency');
        }
        if (!_isValidCurrencyCode(target)) {
          throw ArgumentError('Invalid targetCurrency: $targetCurrency');
        }

        // Get exchange rate from service (fetches from API with caching)
        final rate = await _getCurrencyService(session).getExchangeRate(session, base, target);

        return ExchangeRateResponse(
          success: true,
          baseCurrency: base,
          targetCurrency: target,
          rate: rate,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  /// Get list of supported currencies.
  ///
  /// **Required Roles:** 'public' (unauthenticated access allowed)
  ///
  /// Returns [SupportedCurrenciesResponse] with all supported currency codes.
  ///
  /// Rate limited to 30 requests per minute.
  Future<SupportedCurrenciesResponse> getSupportedCurrencies(
    Session session,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getSupportedCurrencies',
      config: EndpointMiddlewareConfig(
        skipAuth: true, // Public endpoint - no auth required
        customRateLimit: RateLimitConfig(
          maxRequests: 30,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'currency_list',
        ),
      ),
      handler: () async {
        // Get supported currencies from service (fetches from API if available)
        final currencies = await _getCurrencyService(session).getSupportedCurrencies(session);

        return SupportedCurrenciesResponse(
          success: true,
          currencies: currencies,
          count: currencies.length,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  /// Format currency amount with proper symbol and formatting.
  ///
  /// **Required Roles:** 'public' (unauthenticated access allowed)
  ///
  /// [session] - Serverpod session
  /// [currency] - Currency code (ISO 4217)
  /// [amount] - Amount to format
  ///
  /// Returns [CurrencyFormatResponse] with formatted string and symbol.
  ///
  /// Rate limited to 60 requests per minute.
  Future<CurrencyFormatResponse> formatCurrency(
    Session session,
    String currency,
    double amount,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'formatCurrency',
      config: EndpointMiddlewareConfig(
        skipAuth: true, // Public endpoint - no auth required
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'currency_format',
        ),
      ),
      parameters: {
        'currency': currency,
        'amount': amount,
      },
      handler: () async {
        // Normalize currency code
        final currencyCode = currency.toUpperCase();

        // Validate currency
        if (!_isValidCurrencyCode(currencyCode)) {
          throw ArgumentError('Invalid currency: $currency');
        }

        // Get currency symbol
        final symbol = _getCurrencySymbol(currencyCode);

        // Format the amount
        final formatted = _formatAmount(amount, currencyCode, symbol);

        return CurrencyFormatResponse(
          success: true,
          currency: currencyCode,
          amount: amount,
          formatted: formatted,
          symbol: symbol,
          timestamp: DateTime.now(),
        );
      },
    );
  }

  // ============================================================
  // PRIVATE HELPER METHODS
  // ============================================================

  /// Validate currency code format (ISO 4217).
  bool _isValidCurrencyCode(String code) {
    // ISO 4217 codes are 3 uppercase letters
    return code.length == 3 &&
        code.codeUnits.every((c) => c >= 65 && c <= 90); // A-Z
  }

  /// Get currency symbol.
  String? _getCurrencySymbol(String currency) {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'BRL': 'R\$',
      'MXN': '\$',
      'KRW': '₩',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NZD': 'NZ\$',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'TRY': '₺',
      'RUB': '₽',
      'ZAR': 'R',
      'AED': 'د.إ',
      'SAR': '﷼',
    };

    return symbols[currency];
  }

  /// Format amount with currency symbol and proper formatting.
  String _formatAmount(double amount, String currency, String? symbol) {
    // Format number with 2 decimal places
    final formattedAmount = amount.toStringAsFixed(2);

    // Add thousand separators
    final parts = formattedAmount.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    // Add commas for thousands
    final formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)},',
    );

    final formatted = '$formattedInteger.$decimalPart';

    // Add symbol based on currency convention
    if (symbol != null) {
      // Some currencies put symbol before, some after
      if (currency == 'EUR' || currency == 'GBP' || currency == 'USD') {
        return '$symbol$formatted';
      } else if (currency == 'JPY' || currency == 'CNY') {
        return '$symbol$formatted';
      } else {
        return '$formatted $symbol';
      }
    }

    return '$formatted $currency';
  }
}
