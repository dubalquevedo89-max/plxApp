// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsuarioModel {

 String get id; String get email; String get nombre; String? get telefono; String? get cedula; String get rol; bool get activo;
/// Create a copy of UsuarioModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsuarioModelCopyWith<UsuarioModel> get copyWith => _$UsuarioModelCopyWithImpl<UsuarioModel>(this as UsuarioModel, _$identity);

  /// Serializes this UsuarioModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsuarioModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.cedula, cedula) || other.cedula == cedula)&&(identical(other.rol, rol) || other.rol == rol)&&(identical(other.activo, activo) || other.activo == activo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,nombre,telefono,cedula,rol,activo);

@override
String toString() {
  return 'UsuarioModel(id: $id, email: $email, nombre: $nombre, telefono: $telefono, cedula: $cedula, rol: $rol, activo: $activo)';
}


}

/// @nodoc
abstract mixin class $UsuarioModelCopyWith<$Res>  {
  factory $UsuarioModelCopyWith(UsuarioModel value, $Res Function(UsuarioModel) _then) = _$UsuarioModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String nombre, String? telefono, String? cedula, String rol, bool activo
});




}
/// @nodoc
class _$UsuarioModelCopyWithImpl<$Res>
    implements $UsuarioModelCopyWith<$Res> {
  _$UsuarioModelCopyWithImpl(this._self, this._then);

  final UsuarioModel _self;
  final $Res Function(UsuarioModel) _then;

/// Create a copy of UsuarioModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? nombre = null,Object? telefono = freezed,Object? cedula = freezed,Object? rol = null,Object? activo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,telefono: freezed == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String?,cedula: freezed == cedula ? _self.cedula : cedula // ignore: cast_nullable_to_non_nullable
as String?,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as String,activo: null == activo ? _self.activo : activo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UsuarioModel].
extension UsuarioModelPatterns on UsuarioModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsuarioModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsuarioModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsuarioModel value)  $default,){
final _that = this;
switch (_that) {
case _UsuarioModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsuarioModel value)?  $default,){
final _that = this;
switch (_that) {
case _UsuarioModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String nombre,  String? telefono,  String? cedula,  String rol,  bool activo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsuarioModel() when $default != null:
return $default(_that.id,_that.email,_that.nombre,_that.telefono,_that.cedula,_that.rol,_that.activo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String nombre,  String? telefono,  String? cedula,  String rol,  bool activo)  $default,) {final _that = this;
switch (_that) {
case _UsuarioModel():
return $default(_that.id,_that.email,_that.nombre,_that.telefono,_that.cedula,_that.rol,_that.activo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String nombre,  String? telefono,  String? cedula,  String rol,  bool activo)?  $default,) {final _that = this;
switch (_that) {
case _UsuarioModel() when $default != null:
return $default(_that.id,_that.email,_that.nombre,_that.telefono,_that.cedula,_that.rol,_that.activo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsuarioModel extends UsuarioModel {
  const _UsuarioModel({required this.id, required this.email, required this.nombre, this.telefono, this.cedula, required this.rol, this.activo = true}): super._();
  factory _UsuarioModel.fromJson(Map<String, dynamic> json) => _$UsuarioModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String nombre;
@override final  String? telefono;
@override final  String? cedula;
@override final  String rol;
@override@JsonKey() final  bool activo;

/// Create a copy of UsuarioModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsuarioModelCopyWith<_UsuarioModel> get copyWith => __$UsuarioModelCopyWithImpl<_UsuarioModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsuarioModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsuarioModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.cedula, cedula) || other.cedula == cedula)&&(identical(other.rol, rol) || other.rol == rol)&&(identical(other.activo, activo) || other.activo == activo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,nombre,telefono,cedula,rol,activo);

@override
String toString() {
  return 'UsuarioModel(id: $id, email: $email, nombre: $nombre, telefono: $telefono, cedula: $cedula, rol: $rol, activo: $activo)';
}


}

/// @nodoc
abstract mixin class _$UsuarioModelCopyWith<$Res> implements $UsuarioModelCopyWith<$Res> {
  factory _$UsuarioModelCopyWith(_UsuarioModel value, $Res Function(_UsuarioModel) _then) = __$UsuarioModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String nombre, String? telefono, String? cedula, String rol, bool activo
});




}
/// @nodoc
class __$UsuarioModelCopyWithImpl<$Res>
    implements _$UsuarioModelCopyWith<$Res> {
  __$UsuarioModelCopyWithImpl(this._self, this._then);

  final _UsuarioModel _self;
  final $Res Function(_UsuarioModel) _then;

/// Create a copy of UsuarioModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? nombre = null,Object? telefono = freezed,Object? cedula = freezed,Object? rol = null,Object? activo = null,}) {
  return _then(_UsuarioModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,telefono: freezed == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String?,cedula: freezed == cedula ? _self.cedula : cedula // ignore: cast_nullable_to_non_nullable
as String?,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as String,activo: null == activo ? _self.activo : activo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
