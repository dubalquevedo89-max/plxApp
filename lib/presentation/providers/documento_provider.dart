import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/documento_repository.dart';
import '../../domain/entities/documento.dart';

part 'documento_provider.g.dart';

@riverpod
DocumentoRepository documentoRepository(Ref ref) =>
    DocumentoRepository(ref.watch(dioClientProvider));

@riverpod
Future<List<Documento>> documentosRecibidos(Ref ref) =>
    ref.read(documentoRepositoryProvider).listarRecibidos();

@riverpod
Future<List<Documento>> documentosMisUploads(Ref ref) =>
    ref.read(documentoRepositoryProvider).listarMisUploads();

@riverpod
Future<String> documentoUrl(Ref ref, String docId) =>
    ref.read(documentoRepositoryProvider).obtenerUrl(docId);

@riverpod
Future<List<Documento>> documentosDeReserva(Ref ref, String reservaId) =>
    ref.read(documentoRepositoryProvider).listarRecibidos(reservaId: reservaId);
