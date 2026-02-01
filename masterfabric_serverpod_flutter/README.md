# masterfabric_serverpod_flutter

Flutter application with Serverpod integration, featuring real-time notifications, rate limit UI, internationalization, and modern error handling.

## Quick Start

```bash
# Ensure server is running first
flutter run
```

## Features

### Real-Time Notifications

WebSocket-based notification center with filtering and real-time updates:

```dart
// Initialize notification service
final notificationService = NotificationService();
await notificationService.initialize(client);

// Subscribe to broadcast channels
await notificationService.subscribeToBroadcasts(channelIds);

// Listen for changes
notificationService.addListener(() {
  final notifications = notificationService.notifications;
  final unreadCount = notificationService.unreadCount;
  // Update UI
});
```

**NotificationCenterScreen** features:
- Real-time notification updates via WebSocket
- Filter by type (all, unread, high priority)
- Connection status indicator
- Mark as read/unread
- Pull to refresh
- Loading history on scroll

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
├── main.dart                     # App entry with bootstrap
├── screens/
│   ├── home_screen.dart              # Dashboard with health status
│   ├── greetings_screen.dart         # Greeting screen with rate limit UI
│   ├── sign_in_screen.dart           # Email authentication screen
│   ├── profile_screen.dart           # User profile screen
│   ├── service_test_screen.dart      # Service testing UI
│   └── notifications/                # Notification screens
│       ├── notifications.dart            # Barrel export
│       ├── notification_center_screen.dart   # Main notification UI
│       └── notification_item_widget.dart     # Notification list item
├── services/
│   ├── app_config_service.dart       # App config client
│   ├── health_service.dart           # Health monitoring
│   ├── notification_service.dart     # Real-time notifications
│   └── translation_service.dart      # i18n client
└── widgets/
    ├── health_status_bar.dart        # Health indicator
    ├── notification_badge.dart       # Notification count badge
    └── rate_limit_banner.dart        # Rate limit UI
```

## Widgets

### NotificationBadge

```dart
NotificationBadge(
  count: unreadCount,
  child: Icon(Icons.notifications),
)
```

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

## Services

### NotificationService

ChangeNotifier-based service for real-time notifications:

```dart
class NotificationService extends ChangeNotifier {
  List<Notification> get notifications;
  int get unreadCount;
  bool get isConnected;
  
  Future<void> initialize(Client client);
  Future<void> subscribeToBroadcasts(List<String> channelIds);
  Future<void> subscribeToUserNotifications();
  Future<void> loadHistory({int limit = 50});
  Future<void> markAsRead(String notificationId);
  void dispose();
}
```

### HealthService

ChangeNotifier-based service for health monitoring:

```dart
class HealthService extends ChangeNotifier {
  HealthStatus get status;
  int get latencyMs;
  bool get isAutoCheckEnabled;
  
  Future<void> checkHealth();
  void setAutoCheck(bool enabled, {Duration? interval});
}
```

## Bootstrap Flow

1. Initialize Serverpod client
2. Load app configuration
3. Load translations (auto-detect device locale)
4. Initialize notification service
5. Run app

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize client
  client = Client('http://localhost:8080/');
  
  // Bootstrap services
  await AppConfigService.loadConfig(client);
  await TranslationService.loadTranslations(client);
  
  // Initialize notifications (optional, can be done after login)
  final notificationService = NotificationService();
  await notificationService.initialize(client);
  
  runApp(const MyApp());
}
```

## Screens

### NotificationCenterScreen

Full-featured notification center:

- **Connection indicator**: Shows WebSocket connection status
- **Filter chips**: All, Unread, High Priority
- **Notification list**: Grouped by date, with priority indicators
- **Actions**: Mark as read, refresh, clear all
- **Real-time updates**: New notifications appear instantly

### HomeScreen

Dashboard with:
- Health status card with auto-refresh
- Service status indicators
- Navigation to service testing
- Notification badge in app bar

### ServiceTestScreen

Developer tools with tabs:
- **Health**: Health status, auto-check toggle
- **API**: Test greeting, translation, config endpoints
- **Auth**: Check auth status, sessions
- **Rate Limit**: Bulk request testing, stats

## Documentation

- [Serverpod Documentation](https://docs.serverpod.dev)
- [Main Project README](../README.md)

---

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

**Copyright (C) 2026 MASTERFABRIC Bilişim Teknolojileri A.Ş. (MASTERFABRIC Information Technologies Inc.)**

- **Owner:** Gürkan Fikret Günak (@gurkanfikretgunak)
- **Website:** https://masterfabric.co
- **License Contact:** license@masterfabric.co

For full license terms, see the [LICENSE](../LICENSE) file.
