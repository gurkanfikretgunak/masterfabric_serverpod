import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/logging/core_logger.dart';

/// Service for fetching and caching currency exchange rates from external API.
///
/// Uses ExchangeRate-API.com with API key authentication.
/// Rates are cached to reduce API calls and improve performance.
class CurrencyService {
  /// Base URL for ExchangeRate-API.com v6 endpoint
  static const String _apiBaseUrl = 'https://v6.exchangerate-api.com/v6';

  /// Default base currency (USD)
  static const String _defaultBaseCurrency = 'USD';

  /// Cache TTL for exchange rates (1 hour - API updates frequently)
  static const Duration _cacheTtl = Duration(hours: 1);

  /// Cache key prefix for exchange rates
  static const String _cacheKeyPrefix = 'currency:rates:';

  /// API key for ExchangeRate-API.com
  final String? _apiKey;

  /// HTTP client for API calls
  HttpClient? _httpClient;

  CurrencyService({String? apiKey}) : _apiKey = apiKey {
    _httpClient = HttpClient();
  }

  /// Dispose HTTP client
  void dispose() {
    _httpClient?.close();
    _httpClient = null;
  }

  /// Get exchange rate between two currencies.
  ///
  /// [session] - Serverpod session
  /// [fromCurrency] - Source currency code (ISO 4217)
  /// [toCurrency] - Target currency code (ISO 4217)
  ///
  /// Returns the exchange rate (how much toCurrency equals 1 fromCurrency).
  /// Caches results to reduce API calls.
  Future<double> getExchangeRate(
    Session session,
    String fromCurrency,
    String toCurrency,
  ) async {
    final logger = CoreLogger(session);

    // Normalize currency codes
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();

    // If same currency, return 1.0
    if (from == to) {
      return 1.0;
    }

    // Try to get from cache first
    final cacheKey = '$_cacheKeyPrefix$from';
    try {
      final cached = await session.caches.global.get<ExchangeRateCache>(cacheKey);
      if (cached != null && cached.baseCurrency == from) {
        // Check if cache is still valid
        final age = DateTime.now().difference(cached.timestamp);
        if (age < _cacheTtl) {
          // Cache is valid, use it
          final rate = cached.rates[to];
          if (rate != null) {
            logger.debug('Exchange rate loaded from cache', context: {
              'from': from,
              'to': to,
              'rate': rate,
              'cacheAge': age.inMinutes,
            });
            return rate;
          }
        }
      }
    } catch (e) {
      logger.warning('Failed to load exchange rate from cache: $e');
    }

    // Cache miss or expired - fetch from API
    try {
      logger.info('Fetching exchange rates from API', context: {
        'baseCurrency': from,
      });

      final rates = await _fetchRatesFromApi(session, from);

      // Cache the rates
      await _cacheRates(session, from, rates);

      // Get the requested rate
      final rate = rates[to];
      if (rate == null) {
        logger.warning('Currency not found in API response', context: {
          'from': from,
          'to': to,
        });
        throw ArgumentError('Currency $to not found or not supported');
      }

      return rate;
    } catch (e) {
      logger.error('Failed to fetch exchange rate from API: $e');

      // Try fallback: use USD as intermediate currency
      if (from != _defaultBaseCurrency && to != _defaultBaseCurrency) {
        logger.info('Attempting fallback conversion via USD', context: {
          'from': from,
          'to': to,
        });

        try {
          final fromToUsd = await getExchangeRate(session, from, _defaultBaseCurrency);
          final usdToTo = await getExchangeRate(session, _defaultBaseCurrency, to);
          return fromToUsd * usdToTo;
        } catch (fallbackError) {
          logger.error('Fallback conversion failed: $fallbackError');
          rethrow;
        }
      }

      rethrow;
    }
  }

  /// Fetch exchange rates from external API.
  ///
  /// [session] - Serverpod session
  /// [baseCurrency] - Base currency code
  ///
  /// Returns map of currency codes to exchange rates.
  Future<Map<String, double>> _fetchRatesFromApi(
    Session session,
    String baseCurrency,
  ) async {
    if (_httpClient == null) {
      throw Exception('CurrencyService HTTP client not initialized');
    }

    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('ExchangeRate API key is required');
    }

    final logger = CoreLogger(session);
    // Use Bearer token authentication (recommended method)
    final uri = Uri.parse('$_apiBaseUrl/latest/$baseCurrency');

    try {
      final request = await _httpClient!.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      request.headers.set('User-Agent', 'MasterFabric-Serverpod/1.0');
      // Use Bearer token authentication (more secure than URL-based)
      request.headers.set('Authorization', 'Bearer $_apiKey');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        throw Exception(
          'ExchangeRate API error: ${response.statusCode} - $responseBody',
        );
      }

      final data = jsonDecode(responseBody) as Map<String, dynamic>;

      // Check for API errors
      if (data.containsKey('result') && data['result'] == 'error') {
        final errorType = data['error-type'] as String? ?? 'Unknown error';
        throw Exception('ExchangeRate API error: $errorType');
      }

      // Extract rates
      final rates = data['conversion_rates'] as Map<String, dynamic>?;
      if (rates == null) {
        throw Exception('Invalid API response: missing conversion_rates');
      }

      // Convert to Map<String, double>
      final result = <String, double>{};
      rates.forEach((key, value) {
        if (value is num) {
          result[key] = value.toDouble();
        }
      });

      logger.info('Exchange rates fetched successfully', context: {
        'baseCurrency': baseCurrency,
        'ratesCount': result.length,
      });

      return result;
    } catch (e) {
      logger.error('Failed to fetch rates from ExchangeRate API: $e');
      rethrow;
    }
  }

  /// Cache exchange rates.
  ///
  /// [session] - Serverpod session
  /// [baseCurrency] - Base currency code
  /// [rates] - Map of currency codes to exchange rates
  Future<void> _cacheRates(
    Session session,
    String baseCurrency,
    Map<String, double> rates,
  ) async {
    try {
      final cache = ExchangeRateCache(
        baseCurrency: baseCurrency,
        rates: rates,
        timestamp: DateTime.now(),
        source: 'exchangerate-api.com (v6)',
      );

      final cacheKey = '$_cacheKeyPrefix$baseCurrency';

      // Cache in global cache (Redis - shared across servers)
      await session.caches.global.put(
        cacheKey,
        cache,
        lifetime: _cacheTtl,
      );

      // Also cache in local priority cache for faster access
      await session.caches.localPrio.put(
        cacheKey,
        cache,
        lifetime: _cacheTtl,
      );
    } catch (e) {
      // Log but don't fail - caching is optional
      session.log(
        'Failed to cache exchange rates: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Get list of supported currencies from API.
  ///
  /// [session] - Serverpod session
  ///
  /// Returns list of supported currency codes.
  Future<List<String>> getSupportedCurrencies(Session session) async {
    try {
      // Fetch rates for default base currency to get all supported currencies
      final rates = await _fetchRatesFromApi(session, _defaultBaseCurrency);
      final currencies = rates.keys.toList()..add(_defaultBaseCurrency);
      currencies.sort();
      return currencies;
    } catch (e) {
      // Fallback to hardcoded list if API fails
      session.log(
        'Failed to fetch supported currencies from API, using fallback: $e',
        level: LogLevel.warning,
      );
      return _getFallbackCurrencies();
    }
  }

  /// Get fallback list of supported currencies.
  ///
  /// Used when API is unavailable.
  List<String> _getFallbackCurrencies() {
    return [
      'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'INR',
      'BRL', 'MXN', 'KRW', 'SGD', 'HKD', 'NZD', 'SEK', 'NOK', 'DKK',
      'PLN', 'TRY', 'RUB', 'ZAR', 'AED', 'SAR',
    ];
  }
}
