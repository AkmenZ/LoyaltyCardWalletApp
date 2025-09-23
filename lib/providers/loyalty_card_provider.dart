import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:loyalty_cards_app/db/sembast_database.dart';
import 'package:loyalty_cards_app/db/loyalty_card.dao.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';

part 'loyalty_card_provider.g.dart';

@riverpod
class LoyaltyCards extends _$LoyaltyCards {
  Future<T> _withDao<T>(Future<T> Function(LoyaltyCardSembastDao dao) action) async {
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
    // Initial load
    return _fetch();
  }

  // Explicit reload (alias: loadCards)
  Future<void> loadCards() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  // Insert a card, then refresh the list
  Future<void> insertCard(LoyaltyCard card) async {
    await _withDao((dao) => dao.insert(card));
    await loadCards();
  }

  // Edit/update a card, then refresh the list
  Future<void> editCard(LoyaltyCard card) async {
    await _withDao((dao) => dao.update(card));
    await loadCards();
  }

  // Delete a card by id, then refresh the list
  Future<void> deleteCard(int id) async {
    await _withDao((dao) => dao.delete(id));
    await loadCards();
  }
}