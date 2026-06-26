import 'dart:io';
import 'package:dio/dio.dart';
import '../datasources/remote/alicuota_datasource.dart';
import '../../domain/entities/alicuota.dart';

class AlicuotaRepository {
  AlicuotaRepository(Dio dio) : _ds = AlicuotaDatasource(dio);
  final AlicuotaDatasource _ds;

  Future<MisPropiedades> getMisPropiedades() => _ds.getMisPropiedades();

  Future<HistorialPagos> getMisPagos({DateTime? desde, DateTime? hasta}) =>
      _ds.getMisPagos(desde: desde, hasta: hasta);

  Future<String> subirComprobante(File file) => _ds.subirComprobante(file);

  Future<void> reportarPago({
    required String pagoId,
    required String metodoPago,
    required String transaccionReferencia,
    required String comprobanteUrl,
  }) =>
      _ds.reportarPago(
        pagoId: pagoId,
        metodoPago: metodoPago,
        transaccionReferencia: transaccionReferencia,
        comprobanteUrl: comprobanteUrl,
      );
}
