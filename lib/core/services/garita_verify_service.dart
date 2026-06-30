import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/remote/garita_datasource.dart';
import '../../domain/entities/acceso_log.dart';
import '../storage/garita_snapshot_storage.dart';

class GaritaVerifyService {
  final GaritaDatasource _ds;

  const GaritaVerifyService(this._ds);

  Future<AccesoValidacion> verificar({
    required String profileKey,
    String? apiKey,
    required String residentCode,
  }) async {
    // 1. Buscar en DB local del perfil activo (sin latencia, funciona offline)
    final local = GaritaSnapshotStorage.lookup(
      profileKey: profileKey,
      residentCode: residentCode,
    );
    if (local != null) {
      final msg = local.allowedAccess
          ? 'Acceso autorizado (validación local)'
          : 'Acceso denegado: residente en mora (validación local)';
      return AccesoValidacion(
        residentCode: residentCode,
        allowedAccess: local.allowedAccess,
        status: local.status,
        message: msg,
      );
    }

    // 2. No está en local — fallback online si hay conexión
    final connectivity = await Connectivity().checkConnectivity();
    final hasInternet = connectivity.any((c) => c != ConnectivityResult.none);

    if (hasInternet) {
      try {
        return await _ds.verificar(apiKey: apiKey, residentCode: residentCode);
      } on DioException catch (e) {
        final detail = (e.response?.data as Map?)?['detail']?.toString();
        return AccesoValidacion(
          residentCode: residentCode,
          allowedAccess: false,
          status: 'ERROR',
          message: detail ?? 'Error al verificar en línea.',
        );
      }
    }

    // 3. Sin local ni red
    return AccesoValidacion(
      residentCode: residentCode,
      allowedAccess: false,
      status: 'NO_REGISTRADO',
      message: 'Código no registrado. Dispositivo sin conexión.',
    );
  }
}
