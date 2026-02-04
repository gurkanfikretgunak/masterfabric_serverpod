/// Currency service for money and currency operations.
///
/// Provides endpoints for:
/// - Currency conversion between different currencies
/// - Exchange rate retrieval (fetched from free API with caching)
/// - Supported currencies list
/// - Currency formatting with proper symbols
///
/// ## Features:
/// - Real-time exchange rates from ExchangeRate-API.com (free, no API key)
/// - Automatic caching (1 hour TTL) to reduce API calls
/// - Fallback to cached rates if API is unavailable
///
/// Usage:
/// ```dart
/// // Convert currency
/// final result = await client.currency.convertCurrency(
///   'USD',  // fromCurrency
///   'EUR',  // toCurrency
///   100.0,  // amount
/// );
///
/// // Get exchange rate
/// final rate = await client.currency.getExchangeRate(
///   'USD',  // baseCurrency
///   'EUR',  // targetCurrency
/// );
///
/// // Get supported currencies
/// final currencies = await client.currency.getSupportedCurrencies();
///
/// // Format currency
/// final formatted = await client.currency.formatCurrency(
///   'USD',  // currency
///   1234.56,  // amount
/// );
/// ```
library currency;

export 'endpoints/currency_endpoint.dart';
export 'services/currency_service.dart';
