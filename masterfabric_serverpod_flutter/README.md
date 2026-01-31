# masterfabric_serverpod_flutter

Flutter application with Serverpod integration, featuring rate limit UI, internationalization, and modern error handling.

## Quick Start

```bash
# Ensure server is running first
flutter run
```

## Features

### Rate Limit UI Components

**RateLimitBanner** - Displayed when user exceeds rate limit:

- Live countdown timer (seconds remaining)
- Progress bar visualization
- Stats: requests made, limit, window size
- Auto-retry button when countdown finishes

**RateLimitIndicator** - Shows remaining requests:

- Color-coded: Green → Orange (≤5) → Red (≤2)
- Progress bar filling up

### Internationalization

Runtime locale switching:

```dart
// Load translations on app start
await TranslationService.loadTranslations(client);

// Use translations
Text(tr('welcome.title', args: {'name': 'John'}));

// Switch locale
await TranslationService.changeLocale(client, 'tr');
```

### Error Handling

Catch `SerializableExceptions` from the server:

```dart
try {
  final result = await client.greeting.hello(name);
  // Handle success with rate limit info
  _rateLimitRemaining = result.rateLimitRemaining;
} on RateLimitException catch (e) {
  // Show rate limit banner with countdown
  showRateLimitBanner(e);
} catch (e) {
  // Handle other errors
}
```

## Project Structure

```
lib/
├── main.dart             # App entry with bootstrap
├── screens/
│   ├── greetings_screen.dart  # Main screen
│   └── sign_in_screen.dart    # Auth screen
├── services/
│   ├── app_config_service.dart    # App config
│   └── translation_service.dart   # i18n
└── widgets/
    └── rate_limit_banner.dart     # Rate limit UI
```

## Widgets

### RateLimitBanner

```dart
RateLimitBanner(
  exception: rateLimitException,
  onRetry: () => _callApi(),
  onDismiss: () => _dismiss(),
)
```

### RateLimitIndicator

```dart
RateLimitIndicator(
  current: 5,
  limit: 20,
  remaining: 15,
)
```

### GreetingResultCard

```dart
GreetingResultCard(
  greetingResult: response,  // Shows message, author, timestamp
  errorMessage: error,       // Shows error state
)
```

## Bootstrap Flow

1. Initialize Serverpod client
2. Load app configuration
3. Load translations (auto-detect device locale)
4. Run app

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize client
  client = Client('http://localhost:8080/');
  
  // Bootstrap services
  await AppConfigService.loadConfig(client);
  await TranslationService.loadTranslations(client);
  
  runApp(const MyApp());
}
```

## Documentation

- [Serverpod Documentation](https://docs.serverpod.dev)
- [Main Project README](../README.md)
