import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:loyalty_cards_app/db/sembast_database.dart';
import 'package:loyalty_cards_app/db/loyalty_card.dao.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';

part 'loyalty_card_provider.g.dart';

@riverpod
class LoyaltyCards extends _$LoyaltyCards {
  // final LoyaltyCardBackupService _backupService = LoyaltyCardBackupService();

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

  Future<List<LoyaltyCard>> _fetch() {
    return _withDao((dao) => dao.getAll());
  }

  // syncs current cards to backup if backup is enabled
  // runs async without blocking the UI
  // Future<void> _syncBackupIfEnabled(List<LoyaltyCard> cards) async {
  //   try {
  //     final isEnabled = await _backupService.isBackupEnabled();
  //     if (isEnabled) {
  //       // not awaited to avoid blocking UI
  //       _backupService.backupCards(cards).catchError((e) {
  //         log('Backup sync error: $e');
  //       });
  //     }
  //   } catch (e) {
  //     log('Error checking backup status: $e');
  //   }
  // }

  @override
  FutureOr<List<LoyaltyCard>> build() {
    return _fetch();
  }

  Future<void> loadCards() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
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
    
    // sync to backup after cards are loaded
    // if (state.hasValue) {
    //   await _syncBackupIfEnabled(state.asData!.value);
    // }
  }

  Future<void> updateCard(LoyaltyCard card) async {
    await _withDao((dao) => dao.update(card));
    await loadCards();
    
    // sync to backup after cards are loaded
    // if (state.hasValue) {
    //   await _syncBackupIfEnabled(state.asData!.value);
    // }
  }

  Future<void> deleteCard(int id) async {
    await _withDao((dao) => dao.delete(id));
    await loadCards();
    
    // sync to backup after cards are loaded
    // if (state.hasValue) {
    //   await _syncBackupIfEnabled(state.asData!.value);
    // }
  }

  // enable backup and immediately sync all current cards
  // Future<void> enableBackup() async {
  //   if (state.hasValue) {
  //     await _backupService.backupCards(state.asData!.value);
  //     await _backupService.setBackupEnabled(true);
  //   }
  // }

  // disable backup (doesn't delete backed up data)
  // Future<void> disableBackup() async {
  //   await _backupService.setBackupEnabled(false);
  // }

  // check if backup is enabled
  // Future<bool> isBackupEnabled() => _backupService.isBackupEnabled();

  // restore all cards from backup (overwrites local data)
  // Future<void> restoreFromBackup() async {
  //   final backupCards = await _backupService.restoreCards();
    
  //   // clear local DB
  //   final current = state.asData?.value ?? [];
  //   for (final card in current) {
  //     if (card.id != null) {
  //       await _withDao((dao) => dao.delete(card.id!));
  //     }
  //   }
    
  //   // insert backup cards
  //   for (final card in backupCards) {
  //     await _withDao((dao) => dao.insert(card));
  //   }
    
  //   await loadCards();
  // }

  // clear backup data
  // Future<void> clearBackup() async {
  //   await _backupService.clearBackup();
  // }
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