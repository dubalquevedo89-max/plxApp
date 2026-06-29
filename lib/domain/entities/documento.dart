enum TipoDocumento { contrato, comprobantePago, escritura, otro }

extension TipoDocumentoX on TipoDocumento {
  String get label => switch (this) {
        TipoDocumento.contrato => 'Contratos',
        TipoDocumento.comprobantePago => 'Comprobantes',
        TipoDocumento.escritura => 'Escrituras',
        TipoDocumento.otro => 'Otros',
      };

  String get icon => switch (this) {
        TipoDocumento.contrato => '📄',
        TipoDocumento.comprobantePago => '🧾',
        TipoDocumento.escritura => '📜',
        TipoDocumento.otro => '📁',
      };

  static TipoDocumento fromApi(String? v) => switch (v) {
        'contrato' => TipoDocumento.contrato,
        'comprobante_pago' => TipoDocumento.comprobantePago,
        'escritura' => TipoDocumento.escritura,
        _ => TipoDocumento.otro,
      };
}

class Documento {
  final String id;
  final String nombreOriginal;
  final TipoDocumento tipo;
  final String? descripcion;
  final int tamanoBytes;
  final String? reservaId;
  final bool subidoPorComprador;
  final bool notifPendiente;
  final DateTime createdAt;

  const Documento({
    required this.id,
    required this.nombreOriginal,
    required this.tipo,
    this.descripcion,
    required this.tamanoBytes,
    this.reservaId,
    required this.subidoPorComprador,
    required this.notifPendiente,
    required this.createdAt,
  });

  String get tamanoLabel {
    if (tamanoBytes < 1024) return '$tamanoBytes B';
    if (tamanoBytes < 1024 * 1024) {
      return '${(tamanoBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(tamanoBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get extension =>
      nombreOriginal.contains('.')
          ? nombreOriginal.split('.').last.toUpperCase()
          : '?';
}
