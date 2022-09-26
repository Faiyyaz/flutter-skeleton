import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dialog_service.dart';
import 'service_locator.dart' as service_locator;

import '../enums/app_permission.dart';

/// This class is used to check and get permission
class PermissionService {
  final DialogService _dialogService = service_locator.locator<DialogService>();

  Future<void> getPermission({
    required AppPermission appPermission,
    required VoidCallback onAccept,
    VoidCallback? onDecline,
    VoidCallback? onDenied,
  }) async {
    bool permissionGrantedBefore = await _isPermissionAlreadyGranted(
      appPermission: appPermission,
    );

    if (permissionGrantedBefore) {
      onAccept();
    } else {
      await _requestPermission(
        appPermission: appPermission,
        onDenied: onDenied,
        onAccept: onAccept,
        onDecline: onDecline,
      );
    }
  }

  _requestPermission({
    required AppPermission appPermission,
    required VoidCallback onAccept,
    VoidCallback? onDecline,
    VoidCallback? onDenied,
  }) async {
    PermissionStatus permissionStatus;
    switch (appPermission) {
      case AppPermission.camera:
        permissionStatus = await Permission.camera.request();
        break;
      case AppPermission.gallery:
        permissionStatus = Platform.isIOS
            ? await Permission.photos.request()
            : await Permission.storage.request();
        break;
      default:
        return null;
    }
    switch (permissionStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        onAccept();
        break;
      case PermissionStatus.denied:
        if (Platform.isAndroid) {
          if (onDecline != null) {
            onDecline();
          }
        } else {
          if (onDenied != null) {
            onDenied();
          }
        }
        break;
      case PermissionStatus.restricted:
        if (onDenied != null) {
          onDenied();
        }
        break;
      case PermissionStatus.permanentlyDenied:
        if (onDenied != null) {
          onDenied();
        }
        break;
      default:
    }
  }

  Future<bool> _isPermissionAlreadyGranted({
    required AppPermission appPermission,
  }) async {
    PermissionStatus permissionStatus;
    switch (appPermission) {
      case AppPermission.camera:
        permissionStatus = await Permission.camera.status;
        break;
      case AppPermission.gallery:
        permissionStatus = Platform.isIOS
            ? await Permission.photos.status
            : await Permission.storage.status;
        break;
      default:
        return false;
    }
    switch (permissionStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.permanentlyDenied:
        return false;
      default:
        return false;
    }
  }

  /// This function can be used to show alert dialog when permission is denied
  Future<void> showPermissionDialog({
    required BuildContext context,
    required AppPermission appPermission,
    required String message,
    required VoidCallback onAccept,
    VoidCallback? onDecline,
    VoidCallback? onDenied,
  }) async {
    _dialogService.showAlertDialog(
      context: context,
      title: 'Permission Required',
      message: message,
      onPositiveButtonClick: () async {
        await _requestPermission(
          appPermission: appPermission,
          onDenied: onDenied,
          onAccept: onAccept,
          onDecline: onDecline,
        );
      },
    );
  }

  /// This function can be used to show alert dialog when permission is permanentlyDenied
  Future<void> showSettingsDialog({
    required BuildContext context,
    required AppPermission appPermission,
    required String message,
    required VoidCallback onAccept,
    VoidCallback? onDecline,
    VoidCallback? onDenied,
  }) async {
    _dialogService.showAlertDialog(
      context: context,
      title: 'Permission Required',
      message: message,
      onPositiveButtonClick: () async {
        await _openPermissionSettings();
      },
    );
  }

  _openPermissionSettings() {
    openAppSettings();
  }
}
