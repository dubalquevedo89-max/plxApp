class Alerta {
  final String id;
  final String tipo; // sos | reporte | broadcast | individual
  final String mensaje;
  final String emisorId;
  final String emisorNombre;
  final String emisorRol;
  final String? destinatarioId;
  final String? destinatarioNombre;
  final String? coordenadas;
  final bool resuelta;
  final DateTime createdAt;

  const Alerta({
    required this.id,
    required this.tipo,
    required this.mensaje,
    required this.emisorId,
    required this.emisorNombre,
    required this.emisorRol,
    this.destinatarioId,
    this.destinatarioNombre,
    this.coordenadas,
    required this.resuelta,
    required this.createdAt,
  });

  bool get isSos => tipo == 'sos';
  bool get isUrgente => tipo == 'sos' || tipo == 'reporte';
}

class AlertaPage {
  final List<Alerta> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  const AlertaPage({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });
}
