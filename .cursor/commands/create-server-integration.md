# Create Server Integration

Create a new external service integration with REST API client for MasterFabric Serverpod.

## Usage

```
/create-server-integration <integration_name> [options]
```

## Arguments

- `integration_name` - Name of the integration (e.g., `stripe`, `twilio`, `sendgrid`, `slack`)

## What This Command Creates

```
masterfabric_serverpod_server/lib/src/core/integrations/
├── <integration_name>_integration.dart    # Main integration class
└── <integration_name>_client.dart         # REST API client (optional)
```

## Instructions

### Step 1: Create the Integration Class

**File:** `lib/src/core/integrations/<integration_name>_integration.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_integration.dart';

/// <IntegrationName> integration for <description>
class <IntegrationName>Integration extends BaseIntegration {
  final bool _enabled;
  final String? _apiKey;
  final String? _baseUrl;
  final Map<String, dynamic> _config;
  
  // HTTP client for API calls
  final http.Client _httpClient;

  <IntegrationName>Integration({
    required bool enabled,
    String? apiKey,
    String? baseUrl,
    Map<String, dynamic>? additionalConfig,
    http.Client? httpClient,
  })  : _enabled = enabled,
        _apiKey = apiKey,
        _baseUrl = baseUrl ?? 'https://api.<integration>.com/v1',
        _config = additionalConfig ?? {},
        _httpClient = httpClient ?? http.Client();

  @override
  bool get enabled => _enabled;

  @override
  String get name => '<integration_name>';

  @override
  Map<String, dynamic> getConfig() {
    return {
      'enabled': _enabled,
      'hasApiKey': _apiKey != null,
      'baseUrl': _baseUrl,
      ..._config,
    };
  }

  @override
  Future<void> initialize() async {
    if (!_enabled) return;

    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('<IntegrationName> API key is required when enabled');
    }

    // Validate connection
    final healthy = await isHealthy();
    if (!healthy) {
      throw Exception('Failed to connect to <IntegrationName> API');
    }
  }

  @override
  Future<void> dispose() async {
    _httpClient.close();
  }

  @override
  Future<bool> isHealthy() async {
    if (!_enabled) return true;

    try {
      final response = await _get('/health'); // or appropriate endpoint
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // HTTP HELPERS
  // ============================================================

  /// Common headers for all requests
  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET request
  Future<http.Response> _get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);
    return await _httpClient.get(uri, headers: _headers);
  }

  /// POST request
  Future<http.Response> _post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return await _httpClient.post(
      uri,
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// PUT request
  Future<http.Response> _put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return await _httpClient.put(
      uri,
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// DELETE request
  Future<http.Response> _delete(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return await _httpClient.delete(uri, headers: _headers);
  }

  /// Parse JSON response
  Map<String, dynamic> _parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw <IntegrationName>ApiException(
      statusCode: response.statusCode,
      message: response.body,
    );
  }

  // ============================================================
  // PUBLIC API METHODS
  // ============================================================

  /// Example: Get resource
  Future<Map<String, dynamic>> getResource(String id) async {
    if (!_enabled) throw Exception('<IntegrationName> is not enabled');
    
    final response = await _get('/resources/$id');
    return _parseResponse(response);
  }

  /// Example: Create resource
  Future<Map<String, dynamic>> createResource(Map<String, dynamic> data) async {
    if (!_enabled) throw Exception('<IntegrationName> is not enabled');
    
    final response = await _post('/resources', body: data);
    return _parseResponse(response);
  }

  /// Example: List resources
  Future<List<Map<String, dynamic>>> listResources({
    int page = 1,
    int limit = 20,
  }) async {
    if (!_enabled) throw Exception('<IntegrationName> is not enabled');
    
    final response = await _get('/resources', queryParams: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    
    final data = _parseResponse(response);
    return (data['items'] as List).cast<Map<String, dynamic>>();
  }
}

/// Custom exception for <IntegrationName> API errors
class <IntegrationName>ApiException implements Exception {
  final int statusCode;
  final String message;

  <IntegrationName>ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => '<IntegrationName>ApiException($statusCode): $message';
}
```

### Step 2: Register in IntegrationManager

**Update:** `lib/src/core/integrations/integration_manager.dart`

```dart
// Add import
import '<integration_name>_integration.dart';

// Add to initializeFromConfig method:
if (integrationsConfig.containsKey('<integration_name>')) {
  final config = integrationsConfig['<integration_name>'] as Map<String, dynamic>;
  final integration = <IntegrationName>Integration(
    enabled: config['enabled'] as bool? ?? false,
    apiKey: config['apiKey'] as String?,
    baseUrl: config['baseUrl'] as String?,
    additionalConfig: config,
  );
  
  if (integration.enabled) {
    await integration.initialize();
    _integrations.add(integration);
  }
}

// Add getter:
<IntegrationName>Integration? get <integrationName> => 
    getIntegration<<IntegrationName>Integration>('<integration_name>');
```

### Step 3: Add Configuration

**Update:** `config/development.yaml` (or appropriate config file)

```yaml
integrations:
  <integration_name>:
    enabled: true
    apiKey: ${<INTEGRATION_NAME>_API_KEY}
    baseUrl: https://api.<integration>.com/v1
```

### Step 4: Add Environment Variable

```bash
# .env or environment
<INTEGRATION_NAME>_API_KEY=your_api_key_here
```

## Advanced Patterns

### Retry Logic

```dart
/// Execute with retry
Future<T> _withRetry<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (true) {
    try {
      return await operation();
    } catch (e) {
      attempts++;
      if (attempts >= maxRetries) rethrow;
      await Future.delayed(delay * attempts);
    }
  }
}

// Usage:
final result = await _withRetry(() => _get('/resource'));
```

### Rate Limiting

```dart
final _rateLimiter = RateLimiter(
  maxRequests: 100,
  window: Duration(minutes: 1),
);

Future<http.Response> _rateLimitedGet(String endpoint) async {
  await _rateLimiter.acquire();
  return await _get(endpoint);
}
```

### Caching Responses

```dart
final _cache = <String, CacheEntry>{};

Future<Map<String, dynamic>> getCachedResource(String id) async {
  final cacheKey = 'resource:$id';
  
  if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
    return _cache[cacheKey]!.data;
  }
  
  final data = await getResource(id);
  _cache[cacheKey] = CacheEntry(data, expiry: Duration(minutes: 5));
  return data;
}
```

### Webhook Handling

```dart
/// Verify webhook signature
bool verifyWebhookSignature(String payload, String signature) {
  final expectedSignature = _computeHmac(payload, _webhookSecret!);
  return signature == expectedSignature;
}

/// Process webhook event
Future<void> handleWebhook(String eventType, Map<String, dynamic> data) async {
  switch (eventType) {
    case 'resource.created':
      await _onResourceCreated(data);
      break;
    case 'resource.updated':
      await _onResourceUpdated(data);
      break;
    default:
      // Unknown event type
      break;
  }
}
```

## Integration Types

### Analytics Integration (e.g., Mixpanel, Amplitude)

```dart
Future<void> track(String event, {Map<String, dynamic>? properties});
Future<void> identify(String userId, {Map<String, dynamic>? traits});
Future<void> setUserProperty(String userId, String key, dynamic value);
```

### Payment Integration (e.g., Stripe, PayPal)

```dart
Future<PaymentIntent> createPaymentIntent(int amount, String currency);
Future<Customer> createCustomer(String email);
Future<Subscription> createSubscription(String customerId, String priceId);
Future<void> handleWebhook(String payload, String signature);
```

### Communication Integration (e.g., Twilio, SendGrid)

```dart
Future<void> sendSms(String to, String message);
Future<void> sendEmail(String to, String subject, String body);
Future<void> sendPushNotification(String token, String title, String body);
```

### Storage Integration (e.g., S3, Cloudinary)

```dart
Future<String> uploadFile(String path, List<int> bytes);
Future<List<int>> downloadFile(String path);
Future<void> deleteFile(String path);
Future<String> getSignedUrl(String path, Duration expiry);
```

## Testing Integration

```dart
// test/integrations/<integration_name>_test.dart

import 'package:test/test.dart';
import 'package:http/testing.dart';

void main() {
  group('<IntegrationName>Integration', () {
    late <IntegrationName>Integration integration;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        if (request.url.path == '/health') {
          return http.Response('{"status": "ok"}', 200);
        }
        return http.Response('Not Found', 404);
      });

      integration = <IntegrationName>Integration(
        enabled: true,
        apiKey: 'test_key',
        httpClient: mockClient,
      );
    });

    test('isHealthy returns true when API responds', () async {
      expect(await integration.isHealthy(), isTrue);
    });
  });
}
```

## Checklist

- [ ] Create integration class extending `BaseIntegration`
- [ ] Implement all abstract methods (`initialize`, `dispose`, `isHealthy`, `getConfig`)
- [ ] Add HTTP helper methods (`_get`, `_post`, `_put`, `_delete`)
- [ ] Create custom exception class
- [ ] Register in `IntegrationManager`
- [ ] Add configuration to YAML config
- [ ] Add environment variable for API key
- [ ] Add to health check endpoint (optional)
- [ ] Write unit tests with mock HTTP client
- [ ] Update README documentation

## Existing Integrations

| Integration | File | Purpose |
|-------------|------|---------|
| Firebase | `firebase_integration.dart` | Push notifications, analytics |
| Sentry | `sentry_integration.dart` | Error tracking |
| Mixpanel | `mixpanel_integration.dart` | Product analytics |
| Email | `email_integration.dart` | SMTP email sending |
