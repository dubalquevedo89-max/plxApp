import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/session_storage.dart';
import '../../data/datasources/remote/lot_datasource.dart';
import '../../domain/entities/lot_detail.dart';

part 'lot_provider.g.dart';

@riverpod
Future<LotDetail> lotDetail(
  Ref ref,
  String lotId,
  String host, {
  String? virtualProjectSlug,
}) async {
  final token = await SessionStorage.getJwt(SessionStorage.activeHost ?? host);
  final ds = LotDatasource(ref.watch(dioClientProvider));
  return ds.fetchLot(
    lotId,
    host,
    virtualProjectSlug: virtualProjectSlug,
    token: token,
  );
}
