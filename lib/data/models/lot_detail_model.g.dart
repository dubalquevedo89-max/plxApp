// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LotDetailModel _$LotDetailModelFromJson(Map<String, dynamic> json) =>
    _LotDetailModel(
      id: json['id'] as String,
      codigo: json['codigo'] as String,
      zona: json['zona'] as String?,
      zonaColor: json['zona_color'] as String?,
      etapa: json['etapa'] as String?,
      areaM2: (json['area_m2'] as num?)?.toDouble(),
      precio: (json['precio'] as num?)?.toDouble(),
      estado: json['estado'] as String,
      descripcion: json['descripcion'] as String?,
      fotos:
          (json['fotos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasTourVirtual: json['has_tour_virtual'] as bool? ?? false,
      tourVirtualUrl: json['tour_virtual_url'] as String?,
      videoSobrevueloUrl: json['video_sobrevuelo_url'] as String?,
      valorArriendo: (json['valor_arriendo'] as num?)?.toDouble(),
      tienePh: json['tiene_ph'] as bool? ?? false,
      phCount: (json['ph_count'] as num?)?.toInt() ?? 0,
      destacado: json['destacado'] as bool? ?? false,
    );

Map<String, dynamic> _$LotDetailModelToJson(_LotDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'zona': instance.zona,
      'zona_color': instance.zonaColor,
      'etapa': instance.etapa,
      'area_m2': instance.areaM2,
      'precio': instance.precio,
      'estado': instance.estado,
      'descripcion': instance.descripcion,
      'fotos': instance.fotos,
      'videos': instance.videos,
      'has_tour_virtual': instance.hasTourVirtual,
      'tour_virtual_url': instance.tourVirtualUrl,
      'video_sobrevuelo_url': instance.videoSobrevueloUrl,
      'valor_arriendo': instance.valorArriendo,
      'tiene_ph': instance.tienePh,
      'ph_count': instance.phCount,
      'destacado': instance.destacado,
    };
