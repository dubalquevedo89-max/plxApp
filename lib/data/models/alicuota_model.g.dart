// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alicuota_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubPropiedadModel _$SubPropiedadModelFromJson(Map<String, dynamic> json) =>
    _SubPropiedadModel(
      id: json['id'] as String,
      solarId: json['solar_id'] as String,
      solarCodigo: json['solar_codigo'] as String,
      codigo: json['codigo'] as String,
      tipo: json['tipo'] as String,
      estado: json['estado'] as String,
      areaConstruccionM2: (json['area_construccion_m2'] as num?)?.toDouble(),
      precio: (json['precio'] as num).toDouble(),
      metodoAlicuota: json['metodo_alicuota'] as String,
      alicuotaMensualFija: (json['alicuota_mensual_fija'] as num).toDouble(),
      tasaAlicuotaM2: (json['tasa_alicuota_m2'] as num?)?.toDouble(),
      alicuotaCalculada: (json['alicuota_calculada'] as num).toDouble(),
      habitaciones: (json['habitaciones'] as num?)?.toInt(),
      banos: (json['banos'] as num?)?.toDouble(),
      parqueaderos: (json['parqueaderos'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubPropiedadModelToJson(_SubPropiedadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'solar_id': instance.solarId,
      'solar_codigo': instance.solarCodigo,
      'codigo': instance.codigo,
      'tipo': instance.tipo,
      'estado': instance.estado,
      'area_construccion_m2': instance.areaConstruccionM2,
      'precio': instance.precio,
      'metodo_alicuota': instance.metodoAlicuota,
      'alicuota_mensual_fija': instance.alicuotaMensualFija,
      'tasa_alicuota_m2': instance.tasaAlicuotaM2,
      'alicuota_calculada': instance.alicuotaCalculada,
      'habitaciones': instance.habitaciones,
      'banos': instance.banos,
      'parqueaderos': instance.parqueaderos,
    };

_SolarModel _$SolarModelFromJson(Map<String, dynamic> json) => _SolarModel(
  id: json['id'] as String,
  codigo: json['codigo'] as String,
  areaM2: (json['area_m2'] as num).toDouble(),
  precio: (json['precio'] as num).toDouble(),
  metodoAlicuota: json['metodo_alicuota'] as String,
  alicuotaMensualFija: (json['alicuota_mensual_fija'] as num).toDouble(),
  tasaAlicuotaM2: (json['tasa_alicuota_m2'] as num?)?.toDouble(),
  alicuotaCalculada: (json['alicuota_calculada'] as num).toDouble(),
);

Map<String, dynamic> _$SolarModelToJson(_SolarModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'area_m2': instance.areaM2,
      'precio': instance.precio,
      'metodo_alicuota': instance.metodoAlicuota,
      'alicuota_mensual_fija': instance.alicuotaMensualFija,
      'tasa_alicuota_m2': instance.tasaAlicuotaM2,
      'alicuota_calculada': instance.alicuotaCalculada,
    };

_CobroModel _$CobroModelFromJson(Map<String, dynamic> json) => _CobroModel(
  id: json['id'] as String,
  solarId: json['solar_id'] as String?,
  subPropiedadId: json['sub_propiedad_id'] as String?,
  inmuebleCodigo: json['inmueble_codigo'] as String,
  anio: (json['anio'] as num).toInt(),
  mes: (json['mes'] as num).toInt(),
  monto: (json['monto'] as num).toDouble(),
  estado: json['estado'] as String,
  tipoCargo: json['tipo_cargo'] as String,
  descripcion: json['descripcion'] as String?,
  metodoPago: json['metodo_pago'] as String?,
  fechaPago: json['fecha_pago'] == null
      ? null
      : DateTime.parse(json['fecha_pago'] as String),
  comprobanteUrl: json['comprobante_url'] as String?,
  transaccionReferencia: json['transaccion_referencia'] as String?,
);

Map<String, dynamic> _$CobroModelToJson(_CobroModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'solar_id': instance.solarId,
      'sub_propiedad_id': instance.subPropiedadId,
      'inmueble_codigo': instance.inmuebleCodigo,
      'anio': instance.anio,
      'mes': instance.mes,
      'monto': instance.monto,
      'estado': instance.estado,
      'tipo_cargo': instance.tipoCargo,
      'descripcion': instance.descripcion,
      'metodo_pago': instance.metodoPago,
      'fecha_pago': instance.fechaPago?.toIso8601String(),
      'comprobante_url': instance.comprobanteUrl,
      'transaccion_referencia': instance.transaccionReferencia,
    };
