// ── Sub-propiedad (unidad en propiedad horizontal) ───────────────────────────

class SubPropiedad {
  final String id;
  final String solarId;
  final String solarCodigo;
  final String codigo;
  final String tipo;
  final String estado;
  final double? areaConstruccionM2;
  final double precio;
  final String metodoAlicuota;
  final double alicuotaMensualFija;
  final double? tasaAlicuotaM2;
  final double alicuotaCalculada;
  final int? habitaciones;
  final double? banos;
  final int? parqueaderos;

  const SubPropiedad({
    required this.id,
    required this.solarId,
    required this.solarCodigo,
    required this.codigo,
    required this.tipo,
    required this.estado,
    this.areaConstruccionM2,
    required this.precio,
    required this.metodoAlicuota,
    required this.alicuotaMensualFija,
    this.tasaAlicuotaM2,
    required this.alicuotaCalculada,
    this.habitaciones,
    this.banos,
    this.parqueaderos,
  });
}

// ── Solar / predio ────────────────────────────────────────────────────────────

class Solar {
  final String id;
  final String codigo;
  final double areaM2;
  final double precio;
  final String metodoAlicuota;
  final double alicuotaMensualFija;
  final double? tasaAlicuotaM2;
  final double alicuotaCalculada;
  final List<SubPropiedad> subPropiedades;

  const Solar({
    required this.id,
    required this.codigo,
    required this.areaM2,
    required this.precio,
    required this.metodoAlicuota,
    required this.alicuotaMensualFija,
    this.tasaAlicuotaM2,
    required this.alicuotaCalculada,
    this.subPropiedades = const [],
  });
}

// ── Cobro / alícuota ──────────────────────────────────────────────────────────

class Cobro {
  final String id;
  final String? solarId;
  final String? subPropiedadId;
  final String inmuebleCodigo;
  final int anio;
  final int mes;
  final double monto;
  final String estado; // pendiente | pagado | vencido
  final String tipoCargo; // alicuota | multa | cuota_extraordinaria
  final String? descripcion;
  final String? metodoPago;
  final DateTime? fechaPago;
  final String? comprobanteUrl;
  final String? transaccionReferencia;

  const Cobro({
    required this.id,
    this.solarId,
    this.subPropiedadId,
    required this.inmuebleCodigo,
    required this.anio,
    required this.mes,
    required this.monto,
    required this.estado,
    required this.tipoCargo,
    this.descripcion,
    this.metodoPago,
    this.fechaPago,
    this.comprobanteUrl,
    this.transaccionReferencia,
  });

  bool get isPendiente => estado == 'pendiente' || estado == 'revision' || estado == 'vencido';
  bool get isPagado => estado == 'pagado';
  bool get isAnulado => estado == 'anulado';
}

// ── Mis propiedades (response) ────────────────────────────────────────────────

class MisPropiedades {
  final List<Solar> solares;
  final List<SubPropiedad> subPropiedades;

  const MisPropiedades({
    required this.solares,
    required this.subPropiedades,
  });
}

// ── Historial de pagos (response) ─────────────────────────────────────────────

class HistorialPagos {
  final List<Cobro> cobros;
  final bool allowCardPayments;
  final bool allowInvoicing;

  const HistorialPagos({
    required this.cobros,
    required this.allowCardPayments,
    required this.allowInvoicing,
  });
}
