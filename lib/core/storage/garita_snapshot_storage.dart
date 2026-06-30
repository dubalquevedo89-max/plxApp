import 'package:hive_flutter/hive_flutter.dart';

const _boxSnapshot = 'garita_snapshot';

/// Almacenamiento local del snapshot de solvencias aislado por perfil.
///
/// Todas las claves se prefijan con el storageKey del perfil activo:
///   "cabaplan@tonsupa.plxmap.com::resident_code_uuid"
///   "cabaplan@tonsupa.plxmap.com::__meta__"
///
/// Esto garantiza que sincronizar un tenant no afecta a otro y que
/// las consultas siempre son del perfil correcto.
class GaritaSnapshotStorage {
  static late Box<Map> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxSnapshot);
  }

  // ── Claves internas ───────────────────────────────────────────────────────

  static String _key(String profileKey, String residentCode) =>
      '$profileKey::$residentCode';

  static String _metaKey(String profileKey) => '$profileKey::__meta__';

  // ── Escritura ─────────────────────────────────────────────────────────────

  /// Reemplaza solo los datos del perfil indicado, sin tocar otros tenants.
  static Future<void> save({
    required String profileKey,
    required String projectSlug,
    required List<Map<String, dynamic>> residents,
  }) async {
    // Borrar únicamente las entradas de este perfil
    final keysToDelete = _box.keys
        .where((k) => k.toString().startsWith('$profileKey::'))
        .toList();
    await _box.deleteAll(keysToDelete);

    // Insertar nuevos registros
    final entries = <String, Map>{
      _metaKey(profileKey): {
        'last_sync': DateTime.now().toIso8601String(),
        'project_slug': projectSlug,
        'count': residents.length,
      },
      for (final r in residents)
        _key(profileKey, r['resident_code'] as String): {
          'allowed_access': r['allowed_access'] as bool,
          'status': r['status'] as String,
        },
    };
    await _box.putAll(entries);
  }

  // ── Lectura ───────────────────────────────────────────────────────────────

  /// Busca un resident_code dentro del perfil activo. Retorna null si no existe.
  static ({bool allowedAccess, String status})? lookup({
    required String profileKey,
    required String residentCode,
  }) {
    final raw = _box.get(_key(profileKey, residentCode));
    if (raw == null) return null;
    return (
      allowedAccess: raw['allowed_access'] as bool,
      status: raw['status'] as String,
    );
  }

  static DateTime? lastSync(String profileKey) {
    final raw = _box.get(_metaKey(profileKey));
    if (raw == null) return null;
    return DateTime.tryParse(raw['last_sync'] as String? ?? '');
  }

  static int count(String profileKey) {
    final raw = _box.get(_metaKey(profileKey));
    return (raw?['count'] as int?) ?? 0;
  }

  static bool hasData(String profileKey) =>
      _box.containsKey(_metaKey(profileKey));

  // ── Limpieza ──────────────────────────────────────────────────────────────

  /// Elimina solo los datos del perfil indicado (ej. al cerrar sesión).
  static Future<void> clear(String profileKey) async {
    final keysToDelete = _box.keys
        .where((k) => k.toString().startsWith('$profileKey::'))
        .toList();
    await _box.deleteAll(keysToDelete);
  }
}
