class Usuario {
  final String id;
  final String email;
  final String nombre;
  final String? telefono;
  final String? cedula;
  final String rol;
  final bool activo;

  const Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    this.telefono,
    this.cedula,
    required this.rol,
    required this.activo,
  });
}
