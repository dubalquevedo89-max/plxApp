class Invitacion {
  final String id;
  final String nombreInvitado;
  final String? telefonoInvitado;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool activo;
  final DateTime createdAt;

  const Invitacion({
    required this.id,
    required this.nombreInvitado,
    this.telefonoInvitado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.activo,
    required this.createdAt,
  });

  bool get isVigente =>
      activo &&
      DateTime.now().isAfter(fechaInicio) &&
      DateTime.now().isBefore(fechaFin);

  bool get isPendiente => activo && DateTime.now().isBefore(fechaInicio);
  bool get isExpirada => !activo || DateTime.now().isAfter(fechaFin);
}
