import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/alicuota_repository.dart';
import '../../domain/entities/alicuota.dart';

part 'alicuota_provider.g.dart';

@riverpod
AlicuotaRepository alicuotaRepository(Ref ref) =>
    AlicuotaRepository(ref.watch(dioClientProvider));

@riverpod
Future<MisPropiedades> misPropiedades(Ref ref) {
  debugPrint('[ALICUOTA] misPropiedadesProvider build');
  return ref.watch(alicuotaRepositoryProvider).getMisPropiedades();
}

@riverpod
Future<HistorialPagos> misPagos(Ref ref, {DateTime? desde, DateTime? hasta}) {
  debugPrint('[ALICUOTA] misPagosProvider build desde=$desde hasta=$hasta');
  return ref
      .watch(alicuotaRepositoryProvider)
      .getMisPagos(desde: desde, hasta: hasta);
}
