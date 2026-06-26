import 'package:dio/dio.dart';
import '../datasources/remote/public_datasource.dart';
import '../../domain/entities/urbanizacion.dart';

class ProjectRepository {
  ProjectRepository(Dio dio) : _ds = PublicDatasource(dio);
  final PublicDatasource _ds;

  Future<List<Urbanizacion>> fetchAll() async =>
      (await _ds.fetchProjects()).map((m) => m.toEntity()).toList();

  Future<Map<String, List<Urbanizacion>>> fetchByPais() async {
    final all = await fetchAll();
    final Map<String, List<Urbanizacion>> grouped = {};
    for (final u in all) {
      grouped.putIfAbsent(u.pais, () => []).add(u);
    }
    return grouped;
  }
}
