import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/tenant_profile.dart';

const _boxTenants = 'tenant_profiles';
const _keyActiveHost = 'active_host';

class SessionStorage {
  static late Box<Map> _box;
  static const _secure = FlutterSecureStorage();

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<Map>(_boxTenants);
  }

  // Returns the storage key of the active session (may be "vp@host" or "host")
  static String? get activeHost =>
      _box.get(_keyActiveHost)?['host'] as String?;

  // Returns the active profile (for Dio interceptor to read host + vp slug)
  static TenantProfile? get activeProfile {
    final key = activeHost;
    if (key == null) return null;
    return getProfile(key);
  }

  static Future<void> saveProfile(
    TenantProfile profile,
    String jwt, {
    String? refreshToken,
  }) async {
    final key = profile.storageKey;
    await _box.put(key, profile.toMap());
    await _box.put(_keyActiveHost, {'host': key});
    await _secure.write(key: 'jwt_$key', value: jwt);
    if (refreshToken != null) {
      await _secure.write(key: 'refresh_$key', value: refreshToken);
    }
  }

  static Future<String?> getJwt(String key) =>
      _secure.read(key: 'jwt_$key');

  static Future<String?> getRefreshToken(String key) =>
      _secure.read(key: 'refresh_$key');

  static Future<void> saveTokens(
      String key, String jwt, String refreshToken) async {
    await _secure.write(key: 'jwt_$key', value: jwt);
    await _secure.write(key: 'refresh_$key', value: refreshToken);
  }

  static TenantProfile? getProfile(String key) {
    final map = _box.get(key);
    if (map == null) return null;
    return TenantProfile.fromMap(Map<String, dynamic>.from(map));
  }

  static List<TenantProfile> allProfiles() => _box.keys
      .where((k) => k != _keyActiveHost)
      .map((k) =>
          TenantProfile.fromMap(Map<String, dynamic>.from(_box.get(k)!)))
      .toList();

  static Future<void> switchProfile(String key) async =>
      _box.put(_keyActiveHost, {'host': key});

  static Future<void> clearProfile(String key) async {
    await _box.delete(key);
    await _secure.delete(key: 'jwt_$key');
    await _secure.delete(key: 'refresh_$key');
    if (activeHost == key) {
      await _box.delete(_keyActiveHost);
      final remaining = allProfiles();
      if (remaining.isNotEmpty) {
        await _box.put(
            _keyActiveHost, {'host': remaining.first.storageKey});
      }
    }
  }
}
