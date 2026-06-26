// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urbanizacion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UrbanizacionModel _$UrbanizacionModelFromJson(Map<String, dynamic> json) =>
    _UrbanizacionModel(
      slug: json['slug'] as String,
      nombre: json['nombre'] as String,
      descripcionPublica: json['descripcion_publica'] as String?,
      ubicacionTexto: json['ubicacion_texto'] as String?,
      logoUrl: json['logo_url'] as String?,
      primaryColor: json['primary_color'] as String? ?? '#D4AF37',
      whatsappNumber: json['whatsapp_number'] as String?,
      frontendUrl: json['frontend_url'] as String?,
      pais: json['pais'] as String? ?? 'Ecuador',
      subdivision: json['subdivision'] as String?,
      ciudad: json['ciudad'] as String?,
      appEnabled: json['app_enabled'] as bool? ?? true,
      masterplanAppEnabled: json['masterplan_app_enabled'] as bool? ?? false,
      virtualProjects:
          (json['virtual_projects'] as List<dynamic>?)
              ?.map(
                (e) => VirtualProjectModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UrbanizacionModelToJson(_UrbanizacionModel instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'nombre': instance.nombre,
      'descripcion_publica': instance.descripcionPublica,
      'ubicacion_texto': instance.ubicacionTexto,
      'logo_url': instance.logoUrl,
      'primary_color': instance.primaryColor,
      'whatsapp_number': instance.whatsappNumber,
      'frontend_url': instance.frontendUrl,
      'pais': instance.pais,
      'subdivision': instance.subdivision,
      'ciudad': instance.ciudad,
      'app_enabled': instance.appEnabled,
      'masterplan_app_enabled': instance.masterplanAppEnabled,
      'virtual_projects': instance.virtualProjects,
    };
