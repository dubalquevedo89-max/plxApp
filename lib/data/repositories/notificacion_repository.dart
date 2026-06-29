import 'package:dio/dio.dart';
import '../datasources/remote/notificacion_datasource.dart';
import '../../domain/entities/notificacion.dart';

class NotificacionRepository {
  NotificacionRepository(Dio dio) : _ds = NotificacionDatasource(dio);
  final NotificacionDatasource _ds;

  Future<NotificacionContador> getContador() => _ds.getContador();
  Future<List<Notificacion>> getHistorial() => _ds.getHistorial();
  Future<void> marcarLeida(String id) => _ds.marcarLeida(id);
  Future<void> marcarTodasLeidas() => _ds.marcarTodasLeidas();
}
