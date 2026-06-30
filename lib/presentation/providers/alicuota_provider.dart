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
  return ref.read(alicuotaRepositoryProvider).getMisPropiedades();
}

@riverpod
Future<HistorialPagos> misPagos(Ref ref, {DateTime? desde, DateTime? hasta}) {
  return ref.read(alicuotaRepositoryProvider).getMisPagos(desde: desde, hasta: hasta);
}
