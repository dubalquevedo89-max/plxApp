import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/garita_datasource.dart';
import '../../domain/entities/acceso_log.dart';

part 'garita_provider.g.dart';

@riverpod
GaritaDatasource garitaDatasource(Ref ref) =>
    GaritaDatasource(ref.watch(dioClientProvider));

@riverpod
Future<AccesoLogPage> accesoLogs(
  Ref ref, {
  String? tipoAcceso,
  bool? allowedAccess,
  String? search,
  int page = 1,
}) =>
    ref.read(garitaDatasourceProvider).logs(
          tipoAcceso: tipoAcceso,
          allowedAccess: allowedAccess,
          search: search,
          page: page,
        );
