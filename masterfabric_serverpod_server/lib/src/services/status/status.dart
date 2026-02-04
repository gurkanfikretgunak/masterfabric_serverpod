/// Status service for public server information.
///
/// Provides a public endpoint to retrieve server status including:
/// - App name and version
/// - Environment (development/staging/production)
/// - Server time
/// - Client IP and locale detection
///
/// Usage:
/// ```dart
/// final status = await client.status.getStatus();
/// ```
library status;

export 'endpoints/status_endpoint.dart';
