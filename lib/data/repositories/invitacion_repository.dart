import 'package:dio/dio.dart';
import '../datasources/remote/invitacion_datasource.dart';
import '../../domain/entities/invitacion.dart';

class InvitacionRepository {
  InvitacionRepository(Dio dio) : _ds = InvitacionDatasource(dio);
  final InvitacionDatasource _ds;

  Future<List<Invitacion>> listar() => _ds.listar();

  Future<Invitacion> crear({
    required String nombreInvitado,
    String? telefonoInvitado,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) => _ds.crear(
        nombreInvitado: nombreInvitado,
        telefonoInvitado: telefonoInvitado,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

  Future<void> revocar(String id) => _ds.revocar(id);
}
