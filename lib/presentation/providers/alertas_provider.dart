import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/alertas_datasource.dart';

part 'alertas_provider.g.dart';

@riverpod
AlertasDatasource alertasDatasource(Ref ref) =>
    AlertasDatasource(ref.watch(dioClientProvider));
