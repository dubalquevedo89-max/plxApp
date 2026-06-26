import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/alicuota.dart';

part 'alicuota_model.freezed.dart';
part 'alicuota_model.g.dart';

// ── Sub-propiedad model ───────────────────────────────────────────────────────

@freezed
abstract class SubPropiedadModel with _$SubPropiedadModel {
  const SubPropiedadModel._();

  const factory SubPropiedadModel({
    required String id,
    @JsonKey(name: 'solar_id') required String solarId,
    @JsonKey(name: 'solar_codigo') required String solarCodigo,
    required String codigo,
    required String tipo,
    required String estado,
    @JsonKey(name: 'area_construccion_m2') double? areaConstruccionM2,
    required double precio,
    @JsonKey(name: 'metodo_alicuota') required String metodoAlicuota,
    @JsonKey(name: 'alicuota_mensual_fija') required double alicuotaMensualFija,
    @JsonKey(name: 'tasa_alicuota_m2') double? tasaAlicuotaM2,
    @JsonKey(name: 'alicuota_calculada') required double alicuotaCalculada,
    int? habitaciones,
    double? banos,
    int? parqueaderos,
  }) = _SubPropiedadModel;

  factory SubPropiedadModel.fromJson(Map<String, dynamic> json) =>
      _$SubPropiedadModelFromJson(json);

  SubPropiedad toEntity() => SubPropiedad(
        id: id,
        solarId: solarId,
        solarCodigo: solarCodigo,
        codigo: codigo,
        tipo: tipo,
        estado: estado,
        areaConstruccionM2: areaConstruccionM2,
        precio: precio,
        metodoAlicuota: metodoAlicuota,
        alicuotaMensualFija: alicuotaMensualFija,
        tasaAlicuotaM2: tasaAlicuotaM2,
        alicuotaCalculada: alicuotaCalculada,
        habitaciones: habitaciones,
        banos: banos,
        parqueaderos: parqueaderos,
      );
}

// ── Solar model ───────────────────────────────────────────────────────────────

@freezed
abstract class SolarModel with _$SolarModel {
  const SolarModel._();

  const factory SolarModel({
    required String id,
    required String codigo,
    @JsonKey(name: 'area_m2') required double areaM2,
    required double precio,
    @JsonKey(name: 'metodo_alicuota') required String metodoAlicuota,
    @JsonKey(name: 'alicuota_mensual_fija') required double alicuotaMensualFija,
    @JsonKey(name: 'tasa_alicuota_m2') double? tasaAlicuotaM2,
    @JsonKey(name: 'alicuota_calculada') required double alicuotaCalculada,
  }) = _SolarModel;

  factory SolarModel.fromJson(Map<String, dynamic> json) =>
      _$SolarModelFromJson(json);

  Solar toEntity({List<SubPropiedad> subPropiedades = const []}) => Solar(
        id: id,
        codigo: codigo,
        areaM2: areaM2,
        precio: precio,
        metodoAlicuota: metodoAlicuota,
        alicuotaMensualFija: alicuotaMensualFija,
        tasaAlicuotaM2: tasaAlicuotaM2,
        alicuotaCalculada: alicuotaCalculada,
        subPropiedades: subPropiedades,
      );
}

// ── Cobro model ───────────────────────────────────────────────────────────────

@freezed
abstract class CobroModel with _$CobroModel {
  const CobroModel._();

  const factory CobroModel({
    required String id,
    @JsonKey(name: 'solar_id') String? solarId,
    @JsonKey(name: 'sub_propiedad_id') String? subPropiedadId,
    @JsonKey(name: 'inmueble_codigo') required String inmuebleCodigo,
    required int anio,
    required int mes,
    required double monto,
    required String estado,
    @JsonKey(name: 'tipo_cargo') required String tipoCargo,
    String? descripcion,
    @JsonKey(name: 'metodo_pago') String? metodoPago,
    @JsonKey(name: 'fecha_pago') DateTime? fechaPago,
    @JsonKey(name: 'comprobante_url') String? comprobanteUrl,
    @JsonKey(name: 'transaccion_referencia') String? transaccionReferencia,
  }) = _CobroModel;

  factory CobroModel.fromJson(Map<String, dynamic> json) =>
      _$CobroModelFromJson(json);

  Cobro toEntity() => Cobro(
        id: id,
        solarId: solarId,
        subPropiedadId: subPropiedadId,
        inmuebleCodigo: inmuebleCodigo,
        anio: anio,
        mes: mes,
        monto: monto,
        estado: estado,
        tipoCargo: tipoCargo,
        descripcion: descripcion,
        metodoPago: metodoPago,
        fechaPago: fechaPago,
        comprobanteUrl: comprobanteUrl,
        transaccionReferencia: transaccionReferencia,
      );
}
