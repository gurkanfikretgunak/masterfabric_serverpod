# masterfabric_serverpod_server

Serverpod backend server with rate limiting, multi-level caching, internationalization, and authentication.

## Quick Start

```bash
# 1. Start PostgreSQL and Redis
docker compose up --build --detach

# 2. Generate Serverpod code
serverpod generate

# 3. Start the server
dart bin/main.dart
```

## Features

### Rate Limiting

Distributed rate limiting using Redis cache:

```dart
// In your endpoint
static const _rateLimitConfig = RateLimitConfig(
  maxRequests: 20,
  windowDuration: Duration(minutes: 1),
  keyPrefix: 'my_endpoint',
);

Future<MyResponse> myMethod(Session session) async {
  await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
  // ... your logic
}
```

### Multi-Level Caching

Three-tier caching strategy:

| Level | Storage | Speed | Scope |
|-------|---------|-------|-------|
| `localPrio` | Memory | Fastest | Single server |
| `local` | Memory | Fast | Single server |
| `global` | Redis | Network | Cluster-wide |

```dart
// Read from cache (try all levels)
var data = await session.caches.localPrio.get<MyModel>(key);
data ??= await session.caches.local.get<MyModel>(key);
data ??= await session.caches.global.get<MyModel>(key);

// Write to cache
await session.caches.global.put(key, data, lifetime: Duration(hours: 1));
```

### Internationalization (i18n)

Auto-seeds translations from `assets/i18n/*.json` on startup:

```
assets/i18n/
├── en.i18n.json
├── tr.i18n.json
└── de.i18n.json
```

### SerializableExceptions

Proper error responses to clients:

```dart
// Define in .spy.yaml
exception: RateLimitException
fields:
  message: String
  limit: int
  retryAfterSeconds: int

// Throw in endpoint
throw RateLimitException(
  message: 'Rate limit exceeded',
  limit: 20,
  retryAfterSeconds: 45,
);

// Client receives structured error (not "Internal Server Error")
```

## Project Structure

```
lib/src/
├── core/
│   ├── errors/           # Custom error types
│   ├── exceptions/       # SerializableExceptions (.spy.yaml)
│   ├── integrations/     # Firebase, Sentry, Mixpanel
│   ├── rate_limit/       # Rate limiting service
│   └── session/          # Session management
├── services/
│   ├── app_config/       # App configuration
│   ├── auth/             # Authentication
│   ├── greetings/        # Example endpoint
│   └── translations/     # i18n service
└── generated/            # Serverpod generated code
```

## Configuration

Server configuration in `config/development.yaml`:

```yaml
# Enable Redis (required for rate limiting & global cache)
redis:
  enabled: true
  host: localhost
  port: 8091

# Rate limiting config
emailValidation:
  rateLimiting:
    enabled: true
    maxAttemptsPerEmail: 5
    maxAttemptsPerIp: 10
    windowMinutes: 60
```

## Stopping Services

```bash
# Stop server
Ctrl-C

# Stop Docker containers
docker compose stop

# Remove volumes
docker compose down -v
```
