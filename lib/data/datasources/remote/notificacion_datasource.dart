import 'package:dio/dio.dart';
import '../../../domain/entities/notificacion.dart';

final _kOpts = Options(extra: {'no_sandbox_scope': true});

class NotificacionDatasource {
  final Dio _dio;
  const NotificacionDatasource(this._dio);

  Future<NotificacionContador> getContador() async {
    final res = await _dio.get('/api/portal/notificaciones', options: _kOpts);
    return NotificacionContador(
      pendientes: res.data['pendientes'] as int? ?? 0,
      documentosPendientes: res.data['documentos_pendientes'] as int? ?? 0,
    );
  }

  Future<List<Notificacion>> getHistorial() async {
    final res = await _dio.get('/api/portal/notificaciones/historial', options: _kOpts);
    return (res.data as List)
        .map((j) => Notificacion(
              id: j['id'] as String,
              titulo: j['titulo'] as String,
              body: j['body'] as String,
              data: (j['data'] as Map<String, dynamic>?) ?? {},
              leido: j['leido'] as bool? ?? false,
              createdAt: DateTime.parse(j['created_at'] as String),
            ))
        .toList();
  }

  Future<void> marcarLeida(String id) async {
    await _dio.patch('/api/portal/notificaciones/$id/leer', options: _kOpts);
  }

  Future<void> marcarTodasLeidas() async {
    await _dio.post('/api/portal/notificaciones/leer-todas', options: _kOpts);
  }
}
