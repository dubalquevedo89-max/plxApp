// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'virtual_project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VirtualProjectModel _$VirtualProjectModelFromJson(Map<String, dynamic> json) =>
    _VirtualProjectModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nombre: json['nombre'] as String,
      locationText: json['location_text'] as String?,
      primaryColor: json['primary_color'] as String? ?? '#D4AF37',
      templateId: json['template_id'] as String?,
      appEnabled: json['app_enabled'] as bool? ?? true,
      masterplanAppEnabled: json['masterplan_app_enabled'] as bool? ?? false,
    );

Map<String, dynamic> _$VirtualProjectModelToJson(
  _VirtualProjectModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'nombre': instance.nombre,
  'location_text': instance.locationText,
  'primary_color': instance.primaryColor,
  'template_id': instance.templateId,
  'app_enabled': instance.appEnabled,
  'masterplan_app_enabled': instance.masterplanAppEnabled,
};
