/// Paired device service for device pairing and management.
///
/// Provides endpoints for:
/// - Device pairing/registration
/// - Device verification with codes
/// - Device listing and management
/// - Multi-device vs single-device sign-in modes
///
/// ## Features:
/// - Multi-device and single-device sign-in modes
/// - Device verification with codes
/// - Extended device tracking (IP address, user agent, fingerprint)
/// - Device management (list, update, revoke)
/// - Rate limiting for pairing operations
/// - Configuration-driven behavior
///
/// Usage:
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
library paired_device;

// Endpoints
export 'endpoints/paired_device_endpoint.dart';

// Services
export 'services/paired_device_service.dart';
