import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();
  static SharedPreferencesWithCache? _prefs;

  // initialize SharedPreferences instance
  static Future<void> init({
    SharedPreferencesWithCacheOptions cacheOptions =
        const SharedPreferencesWithCacheOptions(),
    SharedPreferencesOptions sharedPreferencesOptions =
        const SharedPreferencesOptions(),
    Map<String, Object?>? prefillCache,
  }) async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: cacheOptions,
      sharedPreferencesOptions: sharedPreferencesOptions,
      cache: prefillCache,
    );
  }

  static bool get isReady => _prefs != null;

  // getters (static)
  static String? getString(String key) {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs not initialized');
    }
    return p.getString(key);
  }

  static String getStringOr(String key, String fallback) {
    return getString(key) ?? fallback;
  }

  static bool? getBool(String key) {
    final p = _prefs;
    if (p == null) throw StateError('SharedPrefs not initialized');
    return p.getBool(key);
  }

  // setters (async)
  static Future<void> setString(String key, String value) async {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs not initialized');
    }
    return p.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    final p = _prefs;
    if (p == null) throw StateError('SharedPrefs not initialized');
    return p.setBool(key, value);
  }

  // remove key
  static Future<void> remove(String key) async {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs not initialized');
    }
    return p.remove(key);
  }

  // clear all keys
  static Future<void> clear() async {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs not initialized');
    }
    await p.clear();
  }
}
