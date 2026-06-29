import 'package:dio/dio.dart';
import '../datasources/remote/reserva_datasource.dart';
import '../../domain/entities/reserva.dart';
import '../../domain/entities/reserva_result.dart';

class ReservaRepository {
  ReservaRepository(Dio dio) : _ds = ReservaDatasource(dio);
  final ReservaDatasource _ds;

  Future<ReservaResult> preReservar({
    required String lotId,
    required String token,
    required String host,
    String? virtualProjectSlug,
  }) => _ds.preReservar(
        lotId: lotId,
        token: token,
        host: host,
        virtualProjectSlug: virtualProjectSlug,
      );

  Future<List<Reserva>> misReservas() => _ds.misReservas();

  Future<ReservaTimeline> timeline(String reservaId) =>
      _ds.timeline(reservaId);
}
