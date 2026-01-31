# Create Server Service

Create a new Serverpod service with endpoint, service class, and models.

## Usage

```
/create-server-service <service_name> [options]
```

## Arguments

- `service_name` - Name of the service (e.g., `payment`, `notification`, `analytics`)

## What This Command Creates

```
masterfabric_serverpod_server/lib/src/services/<service_name>/
├── <service_name>_endpoint.dart    # API endpoint (public)
├── <service_name>_service.dart     # Business logic (internal)
└── <service_name>_response.spy.yaml # Response model
```

## Instructions

When the user runs this command, create a new service following this structure:

### 1. Create the Service Directory

Create folder at: `masterfabric_serverpod_server/lib/src/services/<service_name>/`

### 2. Create the Endpoint (`<service_name>_endpoint.dart`)

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '<service_name>_service.dart';

/// <ServiceName> endpoint - handles <description>
class <ServiceName>Endpoint extends Endpoint {
  final _service = <ServiceName>Service();

  /// Set to true if authentication is required
  @override
  bool get requireLogin => false;

  /// Main endpoint method
  /// 
  /// [session] - Serverpod session
  /// Returns: <ServiceName>Response
  Future<<ServiceName>Response> get<ServiceName>(Session session) async {
    session.log('Processing <service_name> request', level: LogLevel.info);
    
    try {
      final result = await _service.process(session);
      return result;
    } catch (e) {
      session.log('Error in <service_name>: $e', level: LogLevel.error);
      rethrow;
    }
  }
}
```

### 3. Create the Service (`<service_name>_service.dart`)

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

/// Internal service for <service_name> business logic
class <ServiceName>Service {
  /// Process <service_name> request
  Future<<ServiceName>Response> process(Session session) async {
    // TODO: Implement business logic
    
    return <ServiceName>Response(
      success: true,
      message: '<ServiceName> processed successfully',
      timestamp: DateTime.now(),
    );
  }
}
```

### 4. Create the Response Model (`<service_name>_response.spy.yaml`)

```yaml
### <ServiceName> response model
class: <ServiceName>Response
fields:
  success: bool
  message: String
  timestamp: DateTime
  data: String?
```

### 5. Generate Serverpod Code

After creating the files, run:

```bash
cd masterfabric_serverpod_server && serverpod generate
```

## Examples

### Basic Service

```
/create-server-service notification
```

Creates:
- `notification_endpoint.dart`
- `notification_service.dart`
- `notification_response.spy.yaml`

### Service with Authentication

Add `@override bool get requireLogin => true;` to the endpoint.

### Service with Rate Limiting

Add rate limiting using the existing pattern:

```dart
import '../../core/rate_limit/rate_limit_service.dart';

class MyEndpoint extends Endpoint {
  Future<MyResponse> myMethod(Session session) async {
    await RateLimitService.checkRateLimit(
      session,
      endpoint: 'my_endpoint',
      maxRequests: 100,
      windowSeconds: 60,
    );
    // ... rest of logic
  }
}
```

### Service with Caching

Use Serverpod's built-in caching:

```dart
// Local cache (in-memory)
await session.caches.local.put(key, value, lifetime: Duration(minutes: 5));
final cached = await session.caches.local.get<MyType>(key);

// Global cache (Redis)
await session.caches.global.put(key, value, lifetime: Duration(hours: 1));
```

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Directory | snake_case | `payment_gateway/` |
| Endpoint class | PascalCase + Endpoint | `PaymentGatewayEndpoint` |
| Service class | PascalCase + Service | `PaymentGatewayService` |
| Response model | PascalCase + Response | `PaymentGatewayResponse` |
| File names | snake_case | `payment_gateway_endpoint.dart` |

## Post-Creation Checklist

- [ ] Run `serverpod generate`
- [ ] Add any database models if needed
- [ ] Add integration tests
- [ ] Update README if public API
- [ ] Add rate limiting if needed
- [ ] Add caching strategy if needed
