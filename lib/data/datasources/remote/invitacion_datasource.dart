import 'package:dio/dio.dart';
import '../../../domain/entities/invitacion.dart';

final _kOpts = Options(extra: {'no_sandbox_scope': true});

class InvitacionDatasource {
  final Dio _dio;
  const InvitacionDatasource(this._dio);

  Future<List<Invitacion>> listar() async {
    final res = await _dio.get('/api/portal/invitaciones', options: _kOpts);
    return (res.data as List).map(_fromJson).toList();
  }

  Future<Invitacion> crear({
    required String nombreInvitado,
    String? telefonoInvitado,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final res = await _dio.post('/api/portal/invitaciones',
        data: {
          'nombre_invitado': nombreInvitado,
          if (telefonoInvitado != null && telefonoInvitado.isNotEmpty)
            'telefono_invitado': telefonoInvitado,
          'fecha_inicio': fechaInicio.toUtc().toIso8601String(),
          'fecha_fin': fechaFin.toUtc().toIso8601String(),
        },
        options: _kOpts);
    return _fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> revocar(String id) async {
    await _dio.delete('/api/portal/invitaciones/$id', options: _kOpts);
  }

  Invitacion _fromJson(dynamic j) => Invitacion(
        id: j['id'] as String,
        nombreInvitado: j['nombre_invitado'] as String,
        telefonoInvitado: j['telefono_invitado'] as String?,
        fechaInicio: DateTime.parse(j['fecha_inicio'] as String),
        fechaFin: DateTime.parse(j['fecha_fin'] as String),
        activo: j['activo'] as bool? ?? true,
        createdAt: DateTime.parse(j['created_at'] as String),
      );
}
