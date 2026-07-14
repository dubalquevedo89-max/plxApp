import 'package:dio/dio.dart';
import '../../../domain/entities/documento.dart';
import 'dart:io';

final _kOpts = Options(extra: {'no_sandbox_scope': true});

class DocumentoDatasource {
  final Dio _dio;
  const DocumentoDatasource(this._dio);

  Future<List<Documento>> listarRecibidos({String? reservaId}) async {
    final res = await _dio.get(
      '/api/portal/documentos',
      queryParameters: {'reserva_id': reservaId},
      options: _kOpts,
    );
    return (res.data as List).map(_fromJson).toList();
  }

  Future<List<Documento>> listarMisUploads() async {
    final res = await _dio.get('/api/portal/documentos/mis-uploads', options: _kOpts);
    return (res.data as List).map(_fromJson).toList();
  }

  Future<void> subir({
    required File file,
    required TipoDocumento tipo,
    String? descripcion,
    String? reservaId,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'tipo': _tipoToApi(tipo),
      'descripcion': descripcion,
      'reserva_id': reservaId,
    });
    await _dio.post('/api/portal/documentos/subir', data: formData, options: _kOpts);
  }

  String _tipoToApi(TipoDocumento t) => switch (t) {
        TipoDocumento.contrato => 'contrato',
        TipoDocumento.comprobantePago => 'comprobante_pago',
        TipoDocumento.escritura => 'escritura',
        TipoDocumento.otro => 'otro',
      };

  Future<String> obtenerUrl(String docId) async {
    final res = await _dio.get('/api/portal/documentos/$docId/url', options: _kOpts);
    return res.data['url'] as String;
  }

  Documento _fromJson(dynamic j) => Documento(
        id: j['id'] as String,
        nombreOriginal: j['nombre_original'] as String,
        tipo: TipoDocumentoX.fromApi(j['tipo'] as String?),
        descripcion: j['descripcion'] as String?,
        tamanoBytes: (j['tamano_bytes'] as num?)?.toInt() ?? 0,
        reservaId: j['reserva_id'] as String?,
        subidoPorComprador: j['subido_por_comprador'] as bool? ?? false,
        notifPendiente: j['notif_pendiente'] as bool? ?? false,
        createdAt: DateTime.parse(j['created_at'] as String),
      );
}
