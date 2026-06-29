class Notificacion {
  final String id;
  final String titulo;
  final String body;
  final Map<String, dynamic> data;
  final bool leido;
  final DateTime createdAt;

  const Notificacion({
    required this.id,
    required this.titulo,
    required this.body,
    required this.data,
    required this.leido,
    required this.createdAt,
  });

  String? get tipo => data['type'] as String?;

  Notificacion copyWith({bool? leido}) => Notificacion(
        id: id,
        titulo: titulo,
        body: body,
        data: data,
        leido: leido ?? this.leido,
        createdAt: createdAt,
      );
}

class NotificacionContador {
  final int pendientes;
  final int documentosPendientes;

  const NotificacionContador({
    required this.pendientes,
    required this.documentosPendientes,
  });
}
