import 'package:sembast/sembast.dart';
import '../models/loyalty_card.dart';

class LoyaltyCardSembastDao {
  final Database db;
  LoyaltyCardSembastDao(this.db);

  // int-keyed Map store for cards
  final _store = intMapStoreFactory.store('loyalty_cards');

  Future<int> insert(LoyaltyCard card) async {
    final json = card.toJson()..remove('id');
    return _store.add(db, json);
  }

  Future<void> update(LoyaltyCard card) async {
    final id = card.id;
    if (id == null) throw ArgumentError('update requires an id');
    final json = card.toJson()..remove('id');
    await _store.record(id).put(db, json);
  }

  Future<void> delete(int id) => _store.record(id).delete(db);

  Future<LoyaltyCard?> getById(int id) async {
    final snap = await _store.record(id).getSnapshot(db);
    if (snap == null) return null;
    final value = Map<String, Object?>.from(snap.value)..['id'] = snap.key;
    return LoyaltyCard.fromJson(value);
  }

  Future<List<LoyaltyCard>> getAll() async {
    final snaps = await _store.find(
      db,
      finder: Finder(sortOrders: [SortOrder('merchant', true)]),
    );
    return snaps.map((s) {
      final value = Map<String, Object?>.from(s.value)..['id'] = s.key;
      return LoyaltyCard.fromJson(value);
    }).toList();
  }

  Future<int> count() async {
    final snaps = await _store.find(db);
    return snaps.length;
  }
}