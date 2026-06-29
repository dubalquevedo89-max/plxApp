import 'package:dio/dio.dart';
import '../../../domain/entities/reserva.dart';
import '../../../domain/entities/reserva_result.dart';

class ReservaDatasource {
  final Dio _dio;
  const ReservaDatasource(this._dio);

  Future<List<Reserva>> misReservas() async {
    final res = await _dio.get('/api/reservas/mis-reservas');
    return (res.data as List).map(_reservaFromJson).toList();
  }

  Future<ReservaTimeline> timeline(String reservaId) async {
    final res = await _dio.get('/api/portal/timeline/$reservaId');
    final j = res.data as Map<String, dynamic>;
    return ReservaTimeline(
      reservaId: j['reserva_id'] as String,
      lote: j['lote'] as String,
      estado: EstadoReservaX.fromApi(j['estado'] as String?),
      eventos: (j['eventos'] as List).map(_eventoFromJson).toList(),
    );
  }

  Reserva _reservaFromJson(dynamic j) => Reserva(
        id: j['id'] as String,
        solarCodigo: j['solar_codigo'] as String,
        estado: EstadoReservaX.fromApi(j['estado'] as String?),
        fechaReserva: DateTime.parse(j['fecha_reserva'] as String),
        fechaVencimiento: j['fecha_vencimiento'] != null
            ? DateTime.parse(j['fecha_vencimiento'] as String)
            : null,
      );

  TimelineEvento _eventoFromJson(dynamic j) => TimelineEvento(
        tipo: j['tipo'] as String,
        fecha: DateTime.parse(j['fecha'] as String),
        titulo: j['titulo'] as String,
        descripcion: j['descripcion'] as String,
        icono: j['icono'] as String? ?? 'info',
        color: j['color'] as String? ?? 'blue',
      );


  Future<ReservaResult> preReservar({
    required String lotId,
    required String token,
    required String host,
    String? virtualProjectSlug,
  }) async {
    final res = await _dio.post(
      '/api/reservas/$lotId/pre-reservar',
      options: Options(headers: {
        'Host': host,
        'Authorization': 'Bearer $token',
        'x-virtual-project-slug': virtualProjectSlug,
      }),
    );
    final data = res.data as Map<String, dynamic>;
    return ReservaResult(
      detail: data['detail'] as String? ?? '',
      whatsappLink: data['whatsapp_link'] as String?,
      vencimiento: data['vencimiento'] != null
          ? DateTime.tryParse(data['vencimiento'] as String)
          : null,
    );
  }
}
