// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsuarioModel _$UsuarioModelFromJson(Map<String, dynamic> json) =>
    _UsuarioModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String?,
      cedula: json['cedula'] as String?,
      rol: json['rol'] as String,
      activo: json['activo'] as bool? ?? true,
    );

Map<String, dynamic> _$UsuarioModelToJson(_UsuarioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nombre': instance.nombre,
      'telefono': instance.telefono,
      'cedula': instance.cedula,
      'rol': instance.rol,
      'activo': instance.activo,
    };
