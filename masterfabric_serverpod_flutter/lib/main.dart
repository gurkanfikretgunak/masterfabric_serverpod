import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'services/app_config_service.dart';
import 'services/translation_service.dart';
import 'services/health_service.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
late final Client client;

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // When you are running the app on a physical device, you need to set the
  // server URL to the IP address of your computer. You can find the IP
  // address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
  //
  // You can set the variable when running or building your app like this:
  // E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`.
  //
  // Otherwise, the server URL is fetched from the assets/config.json file or
  // defaults to http://$localhost:8080/ if not found.
  final serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  // Load app configuration from server on first launch
  try {
    await AppConfigService.loadConfig(client);
    debugPrint('App configuration loaded successfully');
  } catch (e) {
    // Log error but continue app startup
    // App will use default configuration
    debugPrint('Warning: Failed to load app configuration: $e');
    debugPrint('App will continue with default settings');
  }

  // Load translations from server
  // Translations are auto-detected based on device locale
  try {
    await TranslationService.loadTranslations(client);
    await TranslationService.loadAvailableLocales(client);
    debugPrint('Translations loaded successfully for locale: ${TranslationService.currentLocale}');
  } catch (e) {
    // Log error but continue app startup
    // App will use translation keys as fallback
    debugPrint('Warning: Failed to load translations: $e');
    debugPrint('App will continue with fallback translations');
  }

  // Initialize health service and start monitoring
  HealthService.instance.initialize(client);
  HealthService.instance.startAutoCheck(interval: const Duration(seconds: 60));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfigService.getConfig();
    final title = config?.appSettings.appName ?? 'MasterFabric';

    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      home: SignInScreen(
        child: HomeScreen(
          onSignOut: () async {
            await client.auth.signOutDevice();
          },
        ),
      ),
    );
  }
}

