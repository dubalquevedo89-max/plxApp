import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/alicuota_model.dart';
import '../../../domain/entities/alicuota.dart';

class AlicuotaDatasource {
  final Dio _dio;
  const AlicuotaDatasource(this._dio);

  Future<MisPropiedades> getMisPropiedades() async {
    debugPrint('[ALICUOTA] calling /api/portal/alicuotas/mis-propiedades');
    final res = await _dio.get('/api/portal/alicuotas/mis-propiedades');
    final data = res.data as Map<String, dynamic>;

    final solaresList = (data['solares'] as List)
        .map((e) => SolarModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final subsList = (data['sub_propiedades'] as List)
        .map((e) => SubPropiedadModel.fromJson(e as Map<String, dynamic>)
            .toEntity())
        .toList();

    // Attach sub-propiedades to their parent solar
    final solares = solaresList.map((s) {
      final hijos = subsList.where((sp) => sp.solarId == s.id).toList();
      return s.toEntity(subPropiedades: hijos);
    }).toList();

    return MisPropiedades(solares: solares, subPropiedades: subsList);
  }

  Future<HistorialPagos> getMisPagos({DateTime? desde, DateTime? hasta}) async {
    final res = await _dio.get(
      '/api/portal/alicuotas/mis-pagos',
      queryParameters: {
        if (desde != null) 'desde': _fmt(desde),
        if (hasta != null) 'hasta': _fmt(hasta),
      },
    );
    final data = res.data as Map<String, dynamic>;
    final cobros = (data['cobros'] as List)
        .map((e) =>
            CobroModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
    return HistorialPagos(
      cobros: cobros,
      allowCardPayments: data['allow_card_payments'] as bool? ?? false,
      allowInvoicing: data['allow_invoicing'] as bool? ?? false,
    );
  }

  Future<String> subirComprobante(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });
    final res = await _dio.post(
      '/api/portal/alicuotas/comprobantes/subir',
      data: formData,
    );
    return (res.data as Map<String, dynamic>)['comprobante_url'] as String;
  }

  Future<void> reportarPago({
    required String pagoId,
    required String metodoPago,
    required String transaccionReferencia,
    required String comprobanteUrl,
  }) async {
    await _dio.post(
      '/api/portal/alicuotas/mis-pagos/$pagoId/reportar',
      data: {
        'metodo_pago': metodoPago,
        'transaccion_referencia': transaccionReferencia,
        'comprobante_url': comprobanteUrl,
      },
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
