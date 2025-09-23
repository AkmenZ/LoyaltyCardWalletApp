import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:loyalty_cards_app/db/sembast_database.dart';
import 'package:loyalty_cards_app/db/loyalty_card.dao.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';

part 'loyalty_card_provider.g.dart';

@riverpod
class LoyaltyCards extends _$LoyaltyCards {
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

  @override
  FutureOr<List<LoyaltyCard>> build() {
    return _fetch();
  }

  Future<void> loadCards() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  // Keep this utility for direct lookups if you ever need it imperatively.
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
  }

  Future<void> updateCard(LoyaltyCard card) async {
    await _withDao((dao) => dao.update(card));
    await loadCards();
  }

  Future<void> deleteCard(int id) async {
    await _withDao((dao) => dao.delete(id));
    await loadCards();
  }
}

// Family provider that returns AsyncValue<LoyaltyCard?> for a given id.
// - Watches the list for immediate/reactive updates.
// - Falls back to a direct DB lookup if not present.
@riverpod
Future<LoyaltyCard?> loyaltyCardById(Ref ref, int id) async {
  // Wait for the list to resolve; this re-runs when the list provider refreshes.
  final list = await ref.watch(loyaltyCardsProvider.future);
  try {
    return list.firstWhere((c) => c.id == id);
  } catch (_) {
    // Optional: direct lookup (in case item not in list yet)
    return ref.read(loyaltyCardsProvider.notifier).loadCardById(id);
  }
}