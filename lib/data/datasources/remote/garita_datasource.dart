import 'package:dio/dio.dart';
import '../../../domain/entities/acceso_log.dart';
import '../../../domain/entities/solvencia.dart';

final _kOpts = Options(extra: {'no_sandbox_scope': true});

class GaritaDatasource {
  final Dio _dio;
  const GaritaDatasource(this._dio);

  /// Devuelve la solvencia del residente autenticado (para mostrar en QR).
  Future<Solvencia> miSolvencia() async {
    final res = await _dio.get('/api/portal/solvencia/mi-propiedad', options: _kOpts);
    final d = res.data as Map<String, dynamic>;
    return Solvencia(
      residentCode: d['resident_code'] as String,
      allowedAccess: d['allowed_access'] as bool,
      status: d['status'] as String,
      message: d['message'] as String,
      solarCodigo: d['solar_codigo'] as String?,
      tipoPropiedad: d['tipo_propiedad'] as String?,
      nombre: d['nombre'] as String,
      totalPropiedades: d['total_propiedades'] as int,
      propiedadesAlDia: d['propiedades_al_dia'] as int,
    );
  }

  Future<({String projectSlug, List<Map<String, dynamic>> residents})> snapshot({
    required String apiKey,
  }) async {
    final res = await _dio.post(
      '/api/public/garita/snapshot',
      data: {'api_key': apiKey},
    );
    final d = res.data as Map<String, dynamic>;
    return (
      projectSlug: d['project_slug'] as String,
      residents: (d['residents'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  Future<AccesoValidacion> verificar({
    String? apiKey,
    required String residentCode,
  }) async {
    final body = <String, dynamic>{'resident_code': residentCode};
    if (apiKey != null) body['api_key'] = apiKey;
    final res = await _dio.post(
      '/api/public/garita/verify',
      data: body,
    );
    final d = res.data as Map<String, dynamic>;
    return AccesoValidacion(
      residentCode: d['resident_code'] as String,
      allowedAccess: d['allowed_access'] as bool,
      status: d['status'] as String,
      message: d['message'] as String,
    );
  }

  Future<AccesoLogPage> logs({
    String? tipoAcceso,
    bool? allowedAccess,
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'tipo_acceso': tipoAcceso,
      'allowed_access': allowedAccess,
      if (search != null && search.isNotEmpty) 'search': search,
    }..removeWhere((_, v) => v == null);
    final res = await _dio.get(
      '/api/admin/alicuotas/garita/logs',
      queryParameters: params,
      options: _kOpts,
    );
    final d = res.data as Map<String, dynamic>;
    return AccesoLogPage(
      total: d['total'] as int,
      page: d['page'] as int,
      limit: d['limit'] as int,
      items: (d['items'] as List).map((e) {
        final m = e as Map<String, dynamic>;
        return AccesoLog(
          id: m['id'] as String,
          fechaHora: DateTime.parse(m['fecha_hora'] as String).toLocal(),
          residentCode: m['resident_code'] as String,
          allowedAccess: m['allowed_access'] as bool,
          status: m['status'] as String,
          message: m['message'] as String,
          tipoAcceso: m['tipo_acceso'] as String,
        );
      }).toList(),
    );
  }
}
