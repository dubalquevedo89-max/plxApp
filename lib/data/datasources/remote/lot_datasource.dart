import 'package:dio/dio.dart';
import '../../../domain/entities/lot_detail.dart';
import '../../models/lot_detail_model.dart';

class LotDatasource {
  final Dio _dio;
  const LotDatasource(this._dio);

  Future<LotDetail> fetchLot(
    String lotId,
    String host, {
    String? virtualProjectSlug,
    String? token,
  }) async {
    final headers = <String, dynamic>{'Host': host};
    if (virtualProjectSlug != null) {
      headers['X-Virtual-Project-Slug'] = virtualProjectSlug;
    }
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _dio.get(
      '/api/solares/$lotId',
      options: Options(headers: headers),
    );
    return LotDetailModel.fromJson(res.data as Map<String, dynamic>).toEntity();
  }
}
