import 'package:dio/dio.dart';
import '../../../domain/entities/reserva_result.dart';

class ReservaDatasource {
  final Dio _dio;
  const ReservaDatasource(this._dio);

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
