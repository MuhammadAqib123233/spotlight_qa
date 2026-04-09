import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PermissionService extends GetxService {

  /// Call this once at app startup (in main or binding)
  Future<void> initPermissions() async {
    await _requestCameraAndPhotos();
  }

  /// Request camera + photo library upfront
  Future<void> _requestCameraAndPhotos() async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    // Silently note results — we don't block the user here
    debugPrint('Camera: ${statuses[Permission.camera]}');
    debugPrint('Photos: ${statuses[Permission.photos]}');
  }

  /// Call before opening camera (from chatbot file-picker etc.)
  Future<bool> ensureCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await _showSettingsDialog(
        title: 'Camera Access Required',
        message:
            'This app needs camera access to attach photos to messages. '
            'Please enable it in Settings.',
      );
      return false;
    }

    return false;
  }

  /// Call before opening photo library
  Future<bool> ensurePhotosPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isDenied) {
      final result = await Permission.photos.request();
      return result.isGranted || result.isLimited;
    }

    if (status.isPermanentlyDenied) {
      await _showSettingsDialog(
        title: 'Photo Library Access Required',
        message:
            'This app needs photo library access to attach images to messages. '
            'Please enable it in Settings.',
      );
      return false;
    }

    return false;
  }

  Future<void> _showSettingsDialog({
    required String title,
    required String message,
  }) async {
    final context = Get.context;
    if (context == null) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await openAppSettings(); // opens iOS Settings for your app
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<bool> ensurePhotosOrCameraPermission() async {
  // Check both — show one dialog covering both if needed
  final cameraStatus = await Permission.camera.status;
  final photosStatus = await Permission.photos.status;

  // If either is permanently denied, guide to settings
  if (cameraStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
    await _showSettingsDialog(
      title: 'Media Access Required',
      message:
          'This app needs access to your camera and photo library to attach '
          'files to messages. Please enable both in Settings.',
    );
    return false;
  }

  // Request whichever are not granted
  final toRequest = <Permission>[];
  if (!cameraStatus.isGranted) toRequest.add(Permission.camera);
  if (!photosStatus.isGranted && !photosStatus.isLimited) {
    toRequest.add(Permission.photos);
  }

  if (toRequest.isNotEmpty) {
    final results = await toRequest.request();
    final cameraOk = results[Permission.camera]?.isGranted ?? cameraStatus.isGranted;
    final photosOk = results[Permission.photos]?.isGranted ??
        results[Permission.photos]?.isLimited ??
        photosStatus.isGranted;
    return cameraOk || photosOk; // allow if at least one granted
  }

  return true;
}

Future<void> showPermissionDeniedDialog() async {
  final context = Get.context;
  if (context == null) return;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Permission Required'),
      content: const Text(
        'Camera and photo library access are required to attach files '
        'to messages. Please enable them in Settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            await openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}
}