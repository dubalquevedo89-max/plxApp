import 'package:dio/dio.dart';
import '../../models/urbanizacion_model.dart';

class PublicDatasource {
  final Dio _dio;
  const PublicDatasource(this._dio);

  Future<List<UrbanizacionModel>> fetchProjects() async {
    final res = await _dio.get('/api/public/app-projects');
    return (res.data as List)
        .map((e) => UrbanizacionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
