import 'dart:io';
import 'package:dio/dio.dart';
import '../datasources/remote/documento_datasource.dart';
import '../../domain/entities/documento.dart';

class DocumentoRepository {
  DocumentoRepository(Dio dio) : _ds = DocumentoDatasource(dio);
  final DocumentoDatasource _ds;

  Future<List<Documento>> listarRecibidos({String? reservaId}) =>
      _ds.listarRecibidos(reservaId: reservaId);

  Future<List<Documento>> listarMisUploads() => _ds.listarMisUploads();

  Future<String> obtenerUrl(String docId) => _ds.obtenerUrl(docId);

  Future<void> subir({
    required File file,
    required TipoDocumento tipo,
    String? descripcion,
    String? reservaId,
  }) => _ds.subir(
        file: file,
        tipo: tipo,
        descripcion: descripcion,
        reservaId: reservaId,
      );
}
