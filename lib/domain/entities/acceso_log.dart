class AccesoValidacion {
  final String residentCode;
  final bool allowedAccess;
  final String status;
  final String message;

  const AccesoValidacion({
    required this.residentCode,
    required this.allowedAccess,
    required this.status,
    required this.message,
  });
}

class AccesoLog {
  final String id;
  final DateTime fechaHora;
  final String residentCode;
  final bool allowedAccess;
  final String status;
  final String message;
  final String tipoAcceso;

  const AccesoLog({
    required this.id,  // UUID string from API
    required this.fechaHora,
    required this.residentCode,
    required this.allowedAccess,
    required this.status,
    required this.message,
    required this.tipoAcceso,
  });
}

class AccesoLogPage {
  final int total;
  final int page;
  final int limit;
  final List<AccesoLog> items;

  const AccesoLogPage({
    required this.total,
    required this.page,
    required this.limit,
    required this.items,
  });
}
