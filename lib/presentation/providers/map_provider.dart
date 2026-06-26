import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/map_datasource.dart';

part 'map_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> geoJson(
  Ref ref,
  String slug,
  String host, {
  String? virtualProjectSlug,
  String? parentSlug,
}) async {
  final ds = MapDatasource(ref.watch(dioClientProvider));
  return ds.fetchGeoJson(
    slug,
    host,
    virtualProjectSlug: virtualProjectSlug,
    parentSlug: parentSlug,
  );
}
