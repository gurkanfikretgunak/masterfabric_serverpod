import 'package:serverpod/serverpod.dart';
import '../../translations/translation_service.dart';
import '../../translations/ip_locale_detector.dart';
import '../../core/logging/core_logger.dart';

/// Web route for serving translations via HTTP GET
/// 
/// Route: /api/translations/:locale
/// Example: /api/translations/tr or /api/translations/en
/// 
/// If locale is not provided in URL, it will be auto-detected from IP.
class TranslationRoute extends Route {
  final TranslationService _translationService = TranslationService();

  @override
  Future<void> handle(Request request, Response response) async {
    try {
      // Extract locale from URL path
      // Expected format: /api/translations/:locale or /api/translations/:locale/:namespace
      final pathSegments = request.pathSegments;
      
      String? locale;
      String? namespace;
      
      // Parse path segments
      // /api/translations/en -> locale = en
      // /api/translations/en/widgets -> locale = en, namespace = widgets
      if (pathSegments.length >= 3 && pathSegments[0] == 'api' && pathSegments[1] == 'translations') {
        locale = pathSegments[2];
        if (pathSegments.length >= 4) {
          namespace = pathSegments[3];
        }
      }
      
      // Auto-detect locale from IP if not in URL
      // For web routes, we can check request headers directly
      final detectedLocale = locale ?? IpLocaleDetector.detectLocale(request.session, request: request);
      
      final logger = CoreLogger(request.session);
      logger.info('Translation route accessed', context: {
        'requestedLocale': locale,
        'detectedLocale': detectedLocale,
        'namespace': namespace ?? 'default',
        'path': request.path,
      });
      
      // Get translations
      final translations = await _translationService.getTranslations(
        request.session,
        detectedLocale,
        namespace: namespace,
      );
      
      // Return as JSON
      response.statusCode = 200;
      response.headers['Content-Type'] = 'application/json; charset=utf-8';
      response.headers['Cache-Control'] = 'public, max-age=3600'; // Cache for 1 hour
      await response.writeJson(translations);
    } catch (e, stackTrace) {
      final logger = CoreLogger(request.session);
      logger.error('Error in translation route: $e', exception: e is Exception ? e : Exception(e.toString()), stackTrace: stackTrace);
      
      // Return error response
      response.statusCode = 500;
      response.headers['Content-Type'] = 'application/json; charset=utf-8';
      await response.writeJson({
        'error': 'Failed to load translations',
        'message': e.toString(),
      });
    }
  }
  
  @override
  bool matches(String path) {
    // Match /api/translations/:locale or /api/translations/:locale/:namespace
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.length >= 3 &&
           segments[0] == 'api' &&
           segments[1] == 'translations';
  }
}
