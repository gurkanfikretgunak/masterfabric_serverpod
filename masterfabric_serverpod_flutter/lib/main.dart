import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'screens/greetings_screen.dart';
import 'services/app_config_service.dart';
import 'services/translation_service.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get app configuration if loaded
    final config = AppConfigService.getConfig();
    
    // Build theme from configuration
    final theme = _buildTheme(config);
    final title = config?.appSettings.appName ?? 'Serverpod Demo';
    final homeTitle = config?.appSettings.appName ?? 'Serverpod Example';

    return MaterialApp(
      title: title,
      theme: theme,
      home: MyHomePage(title: homeTitle),
    );
  }

  /// Build theme from app configuration
  ThemeData _buildTheme(AppConfig? config) {
    if (config == null) {
      return ThemeData(primarySwatch: Colors.blue);
    }

    // Parse primary color from hex string
    Color primaryColor = Colors.blue;
    try {
      final colorString = config.splashConfiguration.primaryColor;
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        primaryColor = Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
    } catch (e) {
      // Use default if parsing fails
      primaryColor = Colors.blue;
    }

    // Build theme based on configuration
    return ThemeData(
      primarySwatch: _colorToMaterialColor(primaryColor),
      useMaterial3: true,
      // Apply font scale if configured
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16 * (config.uiConfiguration.fontScale)),
        bodyMedium: TextStyle(fontSize: 14 * (config.uiConfiguration.fontScale)),
        bodySmall: TextStyle(fontSize: 12 * (config.uiConfiguration.fontScale)),
      ),
    );
  }

  /// Convert Color to MaterialColor
  MaterialColor _colorToMaterialColor(Color color) {
    final int red = (color.r * 255.0).round().clamp(0, 255);
    final int green = (color.g * 255.0).round().clamp(0, 255);
    final int blue = (color.b * 255.0).round().clamp(0, 255);

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.toARGB32(), shades);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const GreetingsScreen(),
      // To test authentication in this example app, uncomment the line below
      // and comment out the line above. This wraps the GreetingsScreen with a
      // SignInScreen, which automatically shows a sign-in UI when the user is
      // not authenticated and displays the GreetingsScreen once they sign in.
      //
      // body: SignInScreen(
      //   child: GreetingsScreen(
      //     onSignOut: () async {
      //       await client.auth.signOutDevice();
      //     },
      //   ),
      // ),
    );
  }
}
