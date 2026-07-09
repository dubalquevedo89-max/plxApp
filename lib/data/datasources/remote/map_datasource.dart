import 'package:dio/dio.dart';
import '../../../core/utils/geo_decrypt.dart';

class MapDatasource {
  final Dio _dio;
  const MapDatasource(this._dio);

  Future<Map<String, dynamic>> fetchGeoJson(
    String slug,
    String host, {
    String? virtualProjectSlug,
    String? parentSlug,
  }) async {
    final path = virtualProjectSlug != null
        ? '/api/solares/geojson'
        : '/api/public/projects/$slug/geojson';

    final headers = <String, dynamic>{'Host': host};
    if (virtualProjectSlug != null) {
      headers['X-Virtual-Project-Slug'] = virtualProjectSlug;
    }

    final res = await _dio.get(path, options: Options(headers: headers, extra: {'no_sandbox_scope': true}));
    final raw = res.data as Map<String, dynamic>;

    // VP: backend encrypts with the parent urbanización slug (e.g. "tonsupa_estates")
    final decryptSlug = virtualProjectSlug != null ? (parentSlug ?? slug) : slug;
    return decryptGeoJson(raw, decryptSlug);
  }
}
