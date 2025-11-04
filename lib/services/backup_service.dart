// import 'dart:convert';
// import 'dart:io';
// import 'package:loyalty_cards_app/models/loyalty_card.dart';

// class LoyaltyCardBackupService {
//   static const String _backupFileName = 'loyalty_cards_backup.json';
  
//   CloudStorageProvider? _provider;
//   bool _backupEnabled = false;

//   /// Initialize iCloud backup (iOS)
//   Future<bool> initializeICloud({required String containerId}) async {
//     try {
//       _provider = await MultiCloudStorage.connectToIcloud(
//         containerId: containerId,
//       );
//       return _provider != null;
//     } catch (e) {
//       throw Exception('Failed to connect to iCloud: $e');
//     }
//   }

//   /// Initialize Google Drive backup (Android) - for future use
//   Future<bool> initializeGoogleDrive() async {
//     try {
//       _provider = await MultiCloudStorage.connectToGoogleDrive();
//       return _provider != null;
//     } catch (e) {
//       throw Exception('Failed to connect to Google Drive: $e');
//     }
//   }

//   /// Check if backup is enabled
//   Future<bool> isBackupEnabled() async {
//     if (_provider == null) return false;
//     try {
//       return await _provider!.tokenExpired().then((expired) => !expired);
//     } catch (_) {
//       return false;
//     }
//   }

//   /// Enable backup - just checks if provider is initialized
//   Future<void> setBackupEnabled(bool enabled) async {
//     _backupEnabled = enabled;
//     if (!enabled) {
//       await logout();
//     }
//   }

//   /// Backup cards to cloud
//   Future<void> backupCards(List<LoyaltyCard> cards) async {
//     if (_provider == null) {
//       throw Exception('Cloud storage not initialized. Please enable backup first.');
//     }

//     try {
//       final json = jsonEncode(cards.map((c) => c.toJson()).toList());
//       final bytes = utf8.encode(json);

//       // Create temp file
//       final tempDir = Directory.systemTemp;
//       final tempFile = File('${tempDir.path}/$_backupFileName');
//       await tempFile.writeAsBytes(bytes);

//       try {
//         await _provider!.uploadFile(
//           localPath: tempFile.path,
//           remotePath: '/$_backupFileName',
//         );
//       } finally {
//         // Clean up temp file
//         if (await tempFile.exists()) {
//           await tempFile.delete();
//         }
//       }
//     } catch (e) {
//       throw Exception('Failed to backup cards: $e');
//     }
//   }

//   /// Restore cards from cloud
//   Future<List<LoyaltyCard>> restoreCards() async {
//     if (_provider == null) {
//       throw Exception('Cloud storage not initialized');
//     }

//     try {
//       // Download to temp file
//       final tempDir = Directory.systemTemp;
//       final tempFile = File('${tempDir.path}/${_backupFileName}_restore');

//       try {
//         await _provider!.downloadFile(
//           remotePath: '/$_backupFileName',
//           localPath: tempFile.path,
//         );

//         final bytes = await tempFile.readAsBytes();
//         final json = utf8.decode(bytes);
//         final List<dynamic> decoded = jsonDecode(json);

//         return decoded
//             .map((c) => LoyaltyCard.fromJson(c as Map<String, dynamic>))
//             .toList();
//       } finally {
//         // Clean up temp file
//         if (await tempFile.exists()) {
//           await tempFile.delete();
//         }
//       }
//     } catch (e) {
//       throw Exception('Failed to restore cards: $e');
//     }
//   }

//   /// Check if backup exists in cloud
//   Future<bool> backupExists() async {
//     if (_provider == null) return false;
//     try {
//       final files = await _provider!.listFiles(path: '/');
//       return files.any((f) => f.name == _backupFileName);
//     } catch (_) {
//       return false;
//     }
//   }

//   /// Delete backup from cloud
//   Future<void> clearBackup() async {
//     if (_provider == null) throw Exception('Cloud storage not initialized');
//     try {
//       await _provider!.deleteFile(remotePath: '/$_backupFileName');
//     } catch (e) {
//       throw Exception('Failed to delete backup: $e');
//     }
//   }

//   /// Logout from cloud provider
//   Future<void> logout() async {
//     if (_provider == null) return;
//     try {
//       await _provider!.logout();
//       _provider = null;
//       _backupEnabled = false;
//     } catch (e) {
//       throw Exception('Failed to logout: $e');
//     }
//   }
// }