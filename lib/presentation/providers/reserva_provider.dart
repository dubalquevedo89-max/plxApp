import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/reserva_repository.dart';
import '../../domain/entities/reserva.dart';

part 'reserva_provider.g.dart';

@riverpod
ReservaRepository reservaRepository(Ref ref) =>
    ReservaRepository(ref.watch(dioClientProvider));

@riverpod
Future<List<Reserva>> misReservas(Ref ref) =>
    ref.read(reservaRepositoryProvider).misReservas();

@riverpod
Future<ReservaTimeline> reservaTimeline(Ref ref, String reservaId) =>
    ref.read(reservaRepositoryProvider).timeline(reservaId);
