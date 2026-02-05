import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/utils/client_ip_helper.dart';
import '../../auth/core/auth_helper_service.dart';

/// Service for managing paired devices
/// 
/// Handles device pairing, verification, and management with support for
/// multi-device and single-device sign-in modes.
class PairedDeviceService {
  final AuthHelperService _authHelper = AuthHelperService();
  final Random _random = Random.secure();

  /// Generate a verification code for device pairing
  String _generateVerificationCode() {
    // Generate 6-digit numeric code
    return List.generate(6, (_) => _random.nextInt(10)).join();
  }

  /// Hash device fingerprint for secure storage
  String? _hashFingerprint(String? fingerprint) {
    if (fingerprint == null || fingerprint.isEmpty) return null;
    final bytes = utf8.encode(fingerprint);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Extract user agent from session
  String? _extractUserAgent(Session session) {
    try {
      if (session is MethodCallSession) {
        final request = session.request;
        return request.headers['user-agent']?.first;
      }
    } catch (_) {
      // Silently fail
    }
    return null;
  }

  /// Pair a new device for the user
  /// 
  /// [session] - Serverpod session
  /// [request] - Device pairing request
  /// [requireVerification] - Whether verification is required (from config)
  /// [defaultMode] - Default device mode (from config)
  /// [maxDevicesPerUser] - Maximum devices per user (from config)
  /// 
  /// Returns DevicePairingResponse with pairing result
  Future<DevicePairingResponse> pairDevice(
    Session session,
    DevicePairingRequest request, {
    required bool requireVerification,
    required DeviceMode defaultMode,
    required int maxDevicesPerUser,
  }) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    // Check if device already exists for this user
    final existingDevice = await PairedDevice.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userIdStr) & t.deviceId.equals(request.deviceId),
    );

    if (existingDevice != null) {
      // Device already paired - reactivate it
      final updated = existingDevice.copyWith(
        isActive: true,
        lastSeenAt: DateTime.now(),
        ipAddress: ClientIpHelper.extractSimple(session),
        userAgent: _extractUserAgent(session),
      );
      await PairedDevice.db.updateRow(session, updated);

      return DevicePairingResponse(
        success: true,
        message: 'Device reactivated successfully',
        device: updated,
        requiresVerification: false,
        verificationCode: null,
      );
    }

    // Check device limit
    final userDevices = await PairedDevice.db.find(
      session,
      where: (t) => t.userId.equals(userIdStr),
    );

    if (userDevices.length >= maxDevicesPerUser) {
      throw ValidationError(
        'Maximum number of devices reached. Please revoke an existing device first.',
        details: {'maxDevices': maxDevicesPerUser},
      );
    }

    // Handle single-device mode: revoke other active devices
    if (defaultMode == DeviceMode.singleDevice) {
      final activeDevices = userDevices.where((d) => d.isActive).toList();
      for (final device in activeDevices) {
        final revoked = device.copyWith(isActive: false);
        await PairedDevice.db.updateRow(session, revoked);
      }
    }

    // Generate verification code if required
    String? verificationCode;
    if (requireVerification) {
      verificationCode = _generateVerificationCode();
      // In production, this would be sent via email/push notification
      session.log(
        'Device pairing verification code (DEV ONLY): $verificationCode',
        level: LogLevel.warning,
      );
    }

    // Hash device fingerprint if provided
    final hashedFingerprint = _hashFingerprint(request.deviceFingerprint);

    // Extract IP and user agent
    final ipAddress = ClientIpHelper.extractSimple(session);
    final userAgent = _extractUserAgent(session) ?? request.userAgent;

    // Create new paired device
    final now = DateTime.now();
    final pairedDevice = PairedDevice(
      userId: userIdStr,
      deviceId: request.deviceId,
      deviceName: request.deviceName,
      platform: request.platform,
      deviceFingerprint: hashedFingerprint,
      ipAddress: ipAddress,
      userAgent: userAgent,
      isActive: !requireVerification, // Active immediately if no verification needed
      isTrusted: false,
      deviceMode: defaultMode,
      lastSeenAt: now,
      pairedAt: now,
      metadata: null,
    );

    await PairedDevice.db.insertRow(session, pairedDevice);

    session.log(
      'Device paired - userId: $userIdStr, deviceId: ${request.deviceId}, platform: ${request.platform}',
      level: LogLevel.info,
    );

    return DevicePairingResponse(
      success: true,
      message: requireVerification
          ? 'Device pairing initiated. Please verify with the code sent to your registered contact.'
          : 'Device paired successfully',
      device: pairedDevice,
      requiresVerification: requireVerification,
      verificationCode: verificationCode,
    );
  }

  /// Verify device pairing with verification code
  /// 
  /// [session] - Serverpod session
  /// [deviceId] - Device ID to verify
  /// [verificationCode] - Verification code
  /// 
  /// Returns DevicePairingResponse
  Future<DevicePairingResponse> verifyDevicePairing(
    Session session,
    String deviceId,
    String verificationCode,
  ) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    // Find device
    final device = await PairedDevice.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userIdStr) & t.deviceId.equals(deviceId),
    );

    if (device == null) {
      throw NotFoundError(
        'Device not found',
        details: {'deviceId': deviceId},
      );
    }

    // In production, verify the code against stored verification codes
    // For now, accept any 6-digit code in development
    if (verificationCode.length != 6 || !verificationCode.contains(RegExp(r'^\d+$'))) {
      throw ValidationError(
        'Invalid verification code format',
        details: {'field': 'verificationCode'},
      );
    }

    // Activate device
    final updated = device.copyWith(
      isActive: true,
      isTrusted: true,
      lastSeenAt: DateTime.now(),
    );

    await PairedDevice.db.updateRow(session, updated);

    session.log(
      'Device verified and activated - userId: $userIdStr, deviceId: $deviceId',
      level: LogLevel.info,
    );

    return DevicePairingResponse(
      success: true,
      message: 'Device verified and activated successfully',
      device: updated,
      requiresVerification: false,
      verificationCode: null,
    );
  }

  /// Get all devices for the current user
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns DeviceListResponse
  Future<DeviceListResponse> getMyDevices(Session session) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    final devices = await PairedDevice.db.find(
      session,
      where: (t) => t.userId.equals(userIdStr),
      orderBy: (t) => t.lastSeenAt,
      orderDescending: true,
    );

    final activeCount = devices.where((d) => d.isActive).length;

    return DeviceListResponse(
      success: true,
      devices: devices,
      totalCount: devices.length,
      activeCount: activeCount,
    );
  }

  /// Get a specific device by ID
  /// 
  /// [session] - Serverpod session
  /// [deviceId] - Device database ID
  /// 
  /// Returns PairedDevice
  /// 
  /// Throws NotFoundError if device not found or doesn't belong to user
  Future<PairedDevice> getDevice(Session session, int deviceId) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    final device = await PairedDevice.db.findById(session, deviceId);

    if (device == null) {
      throw NotFoundError(
        'Device not found',
        details: {'deviceId': deviceId},
      );
    }

    if (device.userId != userIdStr) {
      throw AuthenticationError(
        'Device does not belong to current user',
        details: {'deviceId': deviceId},
      );
    }

    return device;
  }

  /// Update device information
  /// 
  /// [session] - Serverpod session
  /// [deviceId] - Device database ID
  /// [deviceName] - New device name (optional)
  /// [deviceMode] - New device mode (optional)
  /// 
  /// Returns updated PairedDevice
  Future<PairedDevice> updateDevice(
    Session session,
    int deviceId, {
    String? deviceName,
    DeviceMode? deviceMode,
  }) async {
    final device = await getDevice(session, deviceId);

    final updated = device.copyWith(
      deviceName: deviceName ?? device.deviceName,
      deviceMode: deviceMode ?? device.deviceMode,
      lastSeenAt: DateTime.now(),
    );

    await PairedDevice.db.updateRow(session, updated);

    session.log(
      'Device updated - deviceId: $deviceId',
      level: LogLevel.info,
    );

    return updated;
  }

  /// Revoke/unpair a device
  /// 
  /// [session] - Serverpod session
  /// [deviceId] - Device database ID
  /// 
  /// Throws NotFoundError if device not found
  Future<void> revokeDevice(Session session, int deviceId) async {
    final device = await getDevice(session, deviceId);

    await PairedDevice.db.deleteRow(session, device);

    session.log(
      'Device revoked - deviceId: $deviceId',
      level: LogLevel.info,
    );
  }

  /// Revoke all devices for the current user
  /// 
  /// [session] - Serverpod session
  Future<void> revokeAllDevices(Session session) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    final devices = await PairedDevice.db.find(
      session,
      where: (t) => t.userId.equals(userIdStr),
    );

    for (final device in devices) {
      await PairedDevice.db.deleteRow(session, device);
    }

    session.log(
      'All devices revoked - userId: $userIdStr, count: ${devices.length}',
      level: LogLevel.info,
    );
  }

  /// Set system-wide device mode for user
  /// 
  /// Updates all devices to use the specified mode
  /// 
  /// [session] - Serverpod session
  /// [mode] - Device mode to set
  /// 
  /// Returns number of devices updated
  Future<int> setDeviceMode(Session session, DeviceMode mode) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    final devices = await PairedDevice.db.find(
      session,
      where: (t) => t.userId.equals(userIdStr),
    );

    int updatedCount = 0;
    for (final device in devices) {
      if (device.deviceMode != mode) {
        final updated = device.copyWith(deviceMode: mode);
        await PairedDevice.db.updateRow(session, updated);
        updatedCount++;
      }
    }

    // If switching to single-device mode, deactivate all but the most recent device
    if (mode == DeviceMode.singleDevice) {
      final activeDevices = devices.where((d) => d.isActive).toList();
      if (activeDevices.length > 1) {
        // Sort by last seen, keep most recent active
        activeDevices.sort((a, b) => b.lastSeenAt.compareTo(a.lastSeenAt));
        for (int i = 1; i < activeDevices.length; i++) {
          final deactivated = activeDevices[i].copyWith(isActive: false);
          await PairedDevice.db.updateRow(session, deactivated);
        }
      }
    }

    session.log(
      'Device mode updated - userId: $userIdStr, mode: ${mode.name}, updatedCount: $updatedCount',
      level: LogLevel.info,
    );

    return updatedCount;
  }

  /// Update last seen timestamp for a device
  /// 
  /// Called automatically when device makes authenticated requests
  /// 
  /// [session] - Serverpod session
  /// [deviceId] - Device identifier
  Future<void> updateLastSeen(Session session, String deviceId) async {
    final userId = await _authHelper.requireAuth(session);
    final userIdStr = userId.toString();

    final device = await PairedDevice.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userIdStr) & t.deviceId.equals(deviceId),
    );

    if (device != null) {
      final updated = device.copyWith(
        lastSeenAt: DateTime.now(),
        ipAddress: ClientIpHelper.extractSimple(session),
        userAgent: _extractUserAgent(session),
      );
      await PairedDevice.db.updateRow(session, updated);
    }
  }
}
