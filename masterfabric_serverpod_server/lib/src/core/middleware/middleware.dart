/// Middleware System for MasterFabric Serverpod
///
/// Provides a comprehensive middleware/interceptor system for automatic
/// request handling including logging, rate limiting, authentication,
/// validation, metrics collection, and error handling.
///
/// ## Quick Start
///
/// ```dart
/// // In your endpoint, extend MasterfabricEndpoint
/// class MyEndpoint extends MasterfabricEndpoint {
///   Future<MyResponse> myMethod(Session session, String param) async {
///     return executeWithMiddleware(
///       session: session,
///       methodName: 'myMethod',
///       parameters: {'param': param},
///       handler: () async {
///         // Your business logic here
///         return MyResponse(success: true);
///       },
///     );
///   }
/// }
/// ```
///
/// ## RBAC Example
///
/// ```dart
/// // Use RbacEndpointMixin for role-based access
/// class AdminEndpoint extends MasterfabricEndpoint with RbacEndpointMixin {
///   @override
///   List<String> get requiredRoles => ['admin'];
///
///   @override
///   Map<String, List<String>> get methodRoles => {
///     'deleteUser': ['superadmin'],
///   };
///
///   Future<void> deleteUser(Session session, String userId) async {
///     return executeWithRbac(
///       session: session,
///       methodName: 'deleteUser',
///       handler: () async { /* ... */ },
///     );
///   }
/// }
/// ```
///
/// ## Features
///
/// - **Logging**: Automatic request/response logging with PII masking
/// - **Rate Limiting**: Distributed rate limiting with Redis
/// - **Authentication**: Auth verification and RBAC integration
/// - **Validation**: Request parameter validation
/// - **Metrics**: Request metrics and analytics collection
/// - **Error Handling**: Global error transformation and reporting
/// - **RBAC**: Role and permission-based access control

// Annotations
export 'annotations/rbac_annotations.dart';

// Base classes
export 'base/middleware_base.dart';
export 'base/middleware_chain.dart';
export 'base/middleware_config.dart';
export 'base/middleware_context.dart';
export 'base/masterfabric_endpoint.dart';

// Interceptors
export 'interceptors/logging_middleware.dart';
export 'interceptors/rate_limit_middleware.dart';
export 'interceptors/auth_middleware.dart';
export 'interceptors/validation_middleware.dart';
export 'interceptors/metrics_middleware.dart';
export 'interceptors/error_middleware.dart';

// Services
export 'services/middleware_registry.dart';
export 'services/endpoint_middleware_resolver.dart';
