enum EstadoReserva { pendientePago, activa, completada, cancelada }

extension EstadoReservaX on EstadoReserva {
  String get label => switch (this) {
        EstadoReserva.pendientePago => 'Pendiente de pago',
        EstadoReserva.activa => 'Activa',
        EstadoReserva.completada => 'Completada',
        EstadoReserva.cancelada => 'Cancelada',
      };

  static EstadoReserva fromApi(String? v) => switch (v) {
        'pendiente_pago' => EstadoReserva.pendientePago,
        'activa' => EstadoReserva.activa,
        'completada' => EstadoReserva.completada,
        _ => EstadoReserva.cancelada,
      };
}

class Reserva {
  final String id;
  final String solarCodigo;
  final EstadoReserva estado;
  final DateTime fechaReserva;
  final DateTime? fechaVencimiento;

  const Reserva({
    required this.id,
    required this.solarCodigo,
    required this.estado,
    required this.fechaReserva,
    this.fechaVencimiento,
  });

  bool get isVigente =>
      estado != EstadoReserva.cancelada &&
      (fechaVencimiento == null ||
          DateTime.now().isBefore(fechaVencimiento!));
}

class TimelineEvento {
  final String tipo;
  final DateTime fecha;
  final String titulo;
  final String descripcion;
  final String icono;
  final String color;

  const TimelineEvento({
    required this.tipo,
    required this.fecha,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
  });
}

class ReservaTimeline {
  final String reservaId;
  final String lote;
  final EstadoReserva estado;
  final List<TimelineEvento> eventos;

  const ReservaTimeline({
    required this.reservaId,
    required this.lote,
    required this.estado,
    required this.eventos,
  });
}
