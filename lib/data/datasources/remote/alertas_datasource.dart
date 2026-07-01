import 'package:dio/dio.dart';
import '../../../domain/entities/alerta.dart';

class AlertasDatasource {
  final Dio _dio;
  const AlertasDatasource(this._dio);

  Future<AlertaPage> historial({int page = 1, int limit = 15}) async {
    final res = await _dio.get(
      '/api/alerts/historial',
      queryParameters: {'page': page, 'limit': limit},
      options: Options(extra: {'no_vp_scope': true, 'no_sandbox_scope': true}),
    );
    final d = res.data as Map<String, dynamic>;
    return AlertaPage(
      totalItems: d['total_items'] as int,
      totalPages: d['total_pages'] as int,
      currentPage: d['current_page'] as int,
      items: (d['items'] as List).map((e) => _parse(e as Map<String, dynamic>)).toList(),
    );
  }

  Future<void> send({
    required String tipo,
    required String mensaje,
    String? destinatarioId,
    String? coordenadas,
  }) async {
    final body = <String, dynamic>{
      'tipo': tipo,
      'mensaje': mensaje,
      if (destinatarioId != null) 'destinatario_id': destinatarioId,
      if (coordenadas != null) 'coordenadas': coordenadas,
    };
    await _dio.post('/api/alerts/send', data: body,
        options: Options(extra: {'no_vp_scope': true, 'no_sandbox_scope': true}));
  }

  Future<void> resolve(String alertId) async {
    await _dio.patch('/api/alerts/$alertId/resolve',
        options: Options(extra: {'no_vp_scope': true, 'no_sandbox_scope': true}));
  }

  Alerta _parse(Map<String, dynamic> m) => Alerta(
        id: m['id'] as String,
        tipo: (m['tipo'] as String?) ?? 'broadcast',
        mensaje: (m['mensaje'] as String?) ?? '',
        emisorId: (m['emisor_id'] as String?) ?? '',
        emisorNombre: (m['emisor_nombre'] as String?) ?? 'Desconocido',
        emisorRol: (m['emisor_rol'] as String?) ?? '',
        destinatarioId: m['destinatario_id'] as String?,
        destinatarioNombre: m['destinatario_nombre'] as String?,
        coordenadas: m['coordenadas'] as String?,
        resuelta: (m['resuelta'] as bool?) ?? false,
        createdAt: m['created_at'] != null
            ? DateTime.parse(m['created_at'] as String).toLocal()
            : DateTime.now(),
      );
}
