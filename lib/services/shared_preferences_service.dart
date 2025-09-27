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
      throw StateError('SharedPrefs.init() must be called before getString.');
    }
    return p.getString(key);
  }

  static String getStringOr(String key, String fallback) {
    return getString(key) ?? fallback;
  }

  // setters (async)
  static Future<void> setString(String key, String value) async {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs.init() must be called before setString.');
    }
    return p.setString(key, value);
  }

  static Future<void> remove(String key) async {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs.init() must be called before remove.');
    }
    return p.remove(key);
  }

  static Future<void> clear() async {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPrefs.init() must be called before clear.');
    }
    await p.clear();
  }
}