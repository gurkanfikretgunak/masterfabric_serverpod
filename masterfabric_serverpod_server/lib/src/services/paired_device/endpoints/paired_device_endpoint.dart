import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:yaml/yaml.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';
import '../services/paired_device_service.dart';

/// Paired device endpoint for device pairing and management.
///
/// Provides endpoints for:
/// - Device pairing/registration
/// - Device verification
/// - Device listing and management
/// - Multi-device vs single-device mode management
///
/// ## Features:
/// - Multi-device and single-device sign-in modes
/// - Device verification with codes
/// - Extended device tracking (IP, user agent, fingerprint)
/// - Rate limiting for pairing operations
///
/// ## Usage from client:
/// ```dart
/// // Pair a new device
/// final result = await client.pairedDevice.pairDevice(
///   DevicePairingRequest(
///     deviceId: 'device-123',
///     deviceName: 'iPhone 14',
///     platform: 'ios',
///   ),
/// );
///
/// // Verify device pairing
/// await client.pairedDevice.verifyDevicePairing(
///   'device-123',
///   '123456',
/// );
///
/// // Get all devices
/// final devices = await client.pairedDevice.getMyDevices();
/// ```
class PairedDeviceEndpoint extends MasterfabricEndpoint {
  final PairedDeviceService _service = PairedDeviceService();

  /// Get paired device configuration from YAML config
  Map<String, dynamic>? _getConfig(Session session) {
    try {
      final environment = Platform.environment['SERVERPOD_ENVIRONMENT'] ?? 'development';
      final configPath = 'config/$environment.yaml';
      
      final configFile = File(configPath);
      if (!configFile.existsSync()) {
        final fallbackPath = 'config/development.yaml';
        final fallbackFile = File(fallbackPath);
        if (!fallbackFile.existsSync()) {
          return null;
        }
        final content = fallbackFile.readAsStringSync();
        final yaml = loadYaml(content) as Map;
        return yaml['pairedDevice'] as Map<String, dynamic>?;
      }

      final content = configFile.readAsStringSync();
      final yaml = loadYaml(content) as Map;
      return yaml['pairedDevice'] as Map<String, dynamic>?;
    } catch (e) {
      session.log(
        'Failed to read paired device config: $e',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  /// Get default device mode from config
  DeviceMode _getDefaultMode(Map<String, dynamic>? config) {
    if (config == null) return DeviceMode.multiDevice;
    final modeStr = config['defaultMode'] as String? ?? 'multiDevice';
    return modeStr == 'singleDevice' ? DeviceMode.singleDevice : DeviceMode.multiDevice;
  }

  /// Get require verification flag from config
  bool _getRequireVerification(Map<String, dynamic>? config) {
    if (config == null) return true;
    return config['requireVerification'] as bool? ?? true;
  }

  /// Get max devices per user from config
  int _getMaxDevicesPerUser(Map<String, dynamic>? config) {
    if (config == null) return 10;
    return config['maxDevicesPerUser'] as int? ?? 10;
  }

  @override
  bool get requireLogin => true; // All methods require authentication

  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'paired_device',
        ),
      );

  /// Pair a new device
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  /// [request] - Device pairing request
  ///
  /// Returns [DevicePairingResponse] with pairing result and optional verification code.
  ///
  /// Rate limited to 5 requests per hour per user.
  Future<DevicePairingResponse> pairDevice(
    Session session,
    DevicePairingRequest request,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'pairDevice',
      config: EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 5,
          windowDuration: Duration(hours: 1),
          keyPrefix: 'paired_device_pair',
        ),
      ),
      parameters: {
        'deviceId': request.deviceId,
        'deviceName': request.deviceName,
        'platform': request.platform,
      },
      handler: () async {
        // Validate request
        if (request.deviceId.isEmpty) {
          throw ArgumentError('deviceId cannot be empty');
        }
        if (request.deviceName.isEmpty) {
          throw ArgumentError('deviceName cannot be empty');
        }
        if (request.platform.isEmpty) {
          throw ArgumentError('platform cannot be empty');
        }

        final config = _getConfig(session);
        final requireVerification = _getRequireVerification(config);
        final defaultMode = _getDefaultMode(config);
        final maxDevicesPerUser = _getMaxDevicesPerUser(config);

        return await _service.pairDevice(
          session,
          request,
          requireVerification: requireVerification,
          defaultMode: defaultMode,
          maxDevicesPerUser: maxDevicesPerUser,
        );
      },
    );
  }

  /// Verify device pairing with verification code
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  /// [deviceId] - Device ID to verify
  /// [verificationCode] - Verification code
  ///
  /// Returns [DevicePairingResponse] with verified device.
  ///
  /// Rate limited to 10 requests per hour per user.
  Future<DevicePairingResponse> verifyDevicePairing(
    Session session,
    String deviceId,
    String verificationCode,
  ) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'verifyDevicePairing',
      config: EndpointMiddlewareConfig(
        customRateLimit: RateLimitConfig(
          maxRequests: 10,
          windowDuration: Duration(hours: 1),
          keyPrefix: 'paired_device_verify',
        ),
      ),
      parameters: {
        'deviceId': deviceId,
        'verificationCode': '***', // Masked in logs
      },
      handler: () async {
        if (deviceId.isEmpty) {
          throw ArgumentError('deviceId cannot be empty');
        }
        if (verificationCode.isEmpty) {
          throw ArgumentError('verificationCode cannot be empty');
        }

        return await _service.verifyDevicePairing(
          session,
          deviceId,
          verificationCode,
        );
      },
    );
  }

  /// Get all devices for the current user
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  ///
  /// Returns [DeviceListResponse] with all paired devices.
  Future<DeviceListResponse> getMyDevices(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getMyDevices',
      parameters: {},
      handler: () async {
        return await _service.getMyDevices(session);
      },
    );
  }

  /// Get a specific device by ID
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  /// [deviceId] - Device database ID
  ///
  /// Returns [PairedDevice] if found and belongs to user.
  Future<PairedDevice> getDevice(Session session, int deviceId) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getDevice',
      parameters: {'deviceId': deviceId},
      handler: () async {
        return await _service.getDevice(session, deviceId);
      },
    );
  }

  /// Update device information
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  /// [deviceId] - Device database ID
  /// [deviceName] - New device name (optional)
  /// [deviceMode] - New device mode (optional)
  ///
  /// Returns updated [PairedDevice].
  Future<PairedDevice> updateDevice(
    Session session,
    int deviceId, {
    String? deviceName,
    DeviceMode? deviceMode,
  }) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'updateDevice',
      parameters: {
        'deviceId': deviceId,
        'deviceName': deviceName,
        'deviceMode': deviceMode?.name,
      },
      handler: () async {
        return await _service.updateDevice(
          session,
          deviceId,
          deviceName: deviceName,
          deviceMode: deviceMode,
        );
      },
    );
  }

  /// Revoke/unpair a device
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  /// [deviceId] - Device database ID
  ///
  /// Throws NotFoundError if device not found.
  Future<void> revokeDevice(Session session, int deviceId) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'revokeDevice',
      parameters: {'deviceId': deviceId},
      handler: () async {
        await _service.revokeDevice(session, deviceId);
      },
    );
  }

  /// Revoke all devices for the current user
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  Future<void> revokeAllDevices(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'revokeAllDevices',
      parameters: {},
      handler: () async {
        await _service.revokeAllDevices(session);
      },
    );
  }

  /// Set system-wide device mode for user
  ///
  /// Updates all devices to use the specified mode.
  /// In single-device mode, only the most recent device remains active.
  ///
  /// **Required:** Authentication
  ///
  /// [session] - Serverpod session
  /// [mode] - Device mode to set
  ///
  /// Returns number of devices updated.
  Future<int> setDeviceMode(Session session, DeviceMode mode) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'setDeviceMode',
      parameters: {'mode': mode.name},
      handler: () async {
        return await _service.setDeviceMode(session, mode);
      },
    );
  }
}
