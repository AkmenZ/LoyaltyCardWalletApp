import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:loyalty_cards_app/services/backup_service.dart';
import 'package:loyalty_cards_app/services/shared_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:loyalty_cards_app/db/sembast_database.dart';
import 'package:loyalty_cards_app/db/loyalty_card.dao.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';

part 'loyalty_card_provider.g.dart';

@riverpod
class LoyaltyCards extends _$LoyaltyCards {
  final _backupService = BackupService();
  bool _isAutoBackupEnabled = false;
  
  Future<T> _withDao<T>(
    Future<T> Function(LoyaltyCardSembastDao dao) action,
  ) async {
    final db = await SembastDatabase.open();
    try {
      final dao = LoyaltyCardSembastDao(db);
      return await action(dao);
    } finally {
      await db.close();
    }
  }

  // initial load
  @override
  FutureOr<List<LoyaltyCard>> build() async {
    // load setting from SharedPrefs
    final isEnabled = SharedPrefs.getBool('auto_backup_enabled');
    _isAutoBackupEnabled = isEnabled ?? false;

    // load data
    final data = await _withDao((dao) => dao.getAll());

    // catchup auto-backup if enabled
    // ensures any changes made while device was offline are backed up
    if (_isAutoBackupEnabled) {
      // small delay to let the UI render first
      Future.delayed(const Duration(seconds: 3), _triggerAutoBackup);
    }

    return data;
  }

  // --- CRUD Operations ---
  Future<void> loadCards() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _withDao((dao) => dao.getAll()));
  }

  Future<LoyaltyCard?> loadCardById(int id) async {
    final current = state.asData?.value;
    if (current != null) {
      for (final c in current) {
        if (c.id == id) return c;
      }
    }
    return _withDao((dao) async {
      final all = await dao.getAll();
      for (final c in all) {
        if (c.id == id) return c;
      }
      return null;
    });
  }

  Future<void> insertCard(LoyaltyCard card) async {
    await _withDao((dao) => dao.insert(card));
    await loadCards();
    _triggerAutoBackup();
  }

  Future<void> updateCard(LoyaltyCard card) async {
    await _withDao((dao) => dao.update(card));
    await loadCards();
    _triggerAutoBackup();
  }

  Future<void> deleteCard(int id) async {
    await _withDao((dao) => dao.delete(id));
    await loadCards();
    _triggerAutoBackup();
  }

  // --- Cloud Backup Management ---
  Future<void> _triggerAutoBackup() async {
    if (!_isAutoBackupEnabled) return;

    try {
      // Don't await this if you want it completely background, 
      // but waiting ensures data consistency before next op
      final path = await SembastDatabase.filePath();
      await _backupService.backupDatabase(path);
      log('☁️ Auto-backup complete');
    } catch (e) {
      log('☁️ Auto-backup failed: $e');
    }
  }

  // force a backup
  Future<void> forceBackup() async {
    final path = await SembastDatabase.filePath();
    await _backupService.backupDatabase(path);
  }

  /// restore from Cloud
  Future<void> restoreFromCloud() async {
    state = const AsyncLoading();
    try {
      // download to temp
      final tempPath = await _backupService.restoreDatabase();
      
      if (tempPath != null) {
        // get DB path
        final dbPath = await SembastDatabase.filePath();
        
        // overwrite
        final backupFile = File(tempPath);
        await backupFile.copy(dbPath);
        
        // cleanup temp
        if (await backupFile.exists()) await backupFile.delete();

        // reload application state
        await loadCards();
      } else {
        throw Exception("No backup found on cloud");
      }
    } catch (e) {
      // reload old data if restore failed
      await loadCards();
      rethrow;
    }
  }

  // --- Settings Management ---
  bool get isBackupEnabled => _isAutoBackupEnabled;

  Future<void> toggleBackup(bool isEnabled) async {
    _isAutoBackupEnabled = isEnabled;
    
    // save to SharedPrefs
    await SharedPrefs.setBool('auto_backup_enabled', isEnabled);
    // if turned ON, do an immediate backup
    if (isEnabled) {
      try {
        await forceBackup();
      } catch (e) {
        log("Initial backup failed: $e");
        _isAutoBackupEnabled = false;
        await SharedPrefs.setBool('auto_backup_enabled', false);
        // propagate error
        rethrow;
      }
    }
  }
  
  Future<bool> checkCloudBackupExists() async {
    return _backupService.isBackupAvailable();
  }
}

@riverpod
Future<LoyaltyCard?> loyaltyCardById(Ref ref, int id) async {
  final list = await ref.watch(loyaltyCardsProvider.future);
  try {
    return list.firstWhere((c) => c.id == id);
  } catch (_) {
    return ref.read(loyaltyCardsProvider.notifier).loadCardById(id);
  }
}