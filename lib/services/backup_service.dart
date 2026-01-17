import 'package:flutter/services.dart';
import 'dart:io';

class BackupService {
  static const platform = MethodChannel('com.hyperjam.gocards/backup');

  // singleton pattern
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  bool get isSupported => Platform.isAndroid || Platform.isIOS;

  String get platformName {
    if (Platform.isAndroid) return 'Google Drive';
    if (Platform.isIOS) return 'iCloud';
    return 'Unknown';
  }

  Future<bool> backupDatabase(String filePath) async {
    if (!isSupported) return false;
    try {
      final result = await platform.invokeMethod('backupDatabase', {
        'filePath': filePath,
      });
      return result as bool;
    } on PlatformException catch (e) {
      throw _handleException(e);
    }
  }

  Future<String?> restoreDatabase() async {
    if (!isSupported) return null;
    try {
      final result = await platform.invokeMethod('restoreDatabase');
      return result as String?;
    } on PlatformException catch (e) {
      throw _handleException(e);
    }
  }

  Future<bool> isBackupAvailable() async {
    if (!isSupported) return false;
    try {
      final result = await platform.invokeMethod('isBackupAvailable');
      return result as bool;
    } catch (_) {
      return false;
    }
  }

  String _handleException(PlatformException e) {
    switch (e.code) {
      case 'SIGN_IN_CANCELLED':
        return 'Sign in cancelled';
      case 'PERMISSION_DENIED':
        return 'Google Drive permission is required to backup';
      case 'SIGN_IN_FAILED':
        return 'Sign in failed';
      case 'NO_BACKUP':
        return 'No backup found';
      default:
        return e.message ?? 'Unknown error occurred';
    }
  }
}
