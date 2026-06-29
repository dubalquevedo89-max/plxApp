class Solvencia {
  final String residentCode;
  final bool allowedAccess;
  final String status;
  final String message;
  final String? solarCodigo;
  final String? tipoPropiedad;
  final String nombre;
  final int totalPropiedades;
  final int propiedadesAlDia;

  const Solvencia({
    required this.residentCode,
    required this.allowedAccess,
    required this.status,
    required this.message,
    this.solarCodigo,
    this.tipoPropiedad,
    required this.nombre,
    required this.totalPropiedades,
    required this.propiedadesAlDia,
  });
}
