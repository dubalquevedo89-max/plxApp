import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/usuario.dart';

part 'usuario_model.freezed.dart';
part 'usuario_model.g.dart';

@freezed
abstract class UsuarioModel with _$UsuarioModel {
  const UsuarioModel._();

  const factory UsuarioModel({
    required String id,
    required String email,
    required String nombre,
    String? telefono,
    String? cedula,
    required String rol,
    @Default(true) bool activo,
  }) = _UsuarioModel;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModelFromJson(json);

  Usuario toEntity() => Usuario(
        id: id,
        email: email,
        nombre: nombre,
        telefono: telefono,
        cedula: cedula,
        rol: rol,
        activo: activo,
      );
}
