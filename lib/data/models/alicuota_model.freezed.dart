// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alicuota_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubPropiedadModel {

 String get id;@JsonKey(name: 'solar_id') String get solarId;@JsonKey(name: 'solar_codigo') String get solarCodigo; String get codigo; String get tipo; String get estado;@JsonKey(name: 'area_construccion_m2') double? get areaConstruccionM2; double get precio;@JsonKey(name: 'metodo_alicuota') String get metodoAlicuota;@JsonKey(name: 'alicuota_mensual_fija') double get alicuotaMensualFija;@JsonKey(name: 'tasa_alicuota_m2') double? get tasaAlicuotaM2;@JsonKey(name: 'alicuota_calculada') double get alicuotaCalculada; int? get habitaciones; double? get banos; int? get parqueaderos;
/// Create a copy of SubPropiedadModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubPropiedadModelCopyWith<SubPropiedadModel> get copyWith => _$SubPropiedadModelCopyWithImpl<SubPropiedadModel>(this as SubPropiedadModel, _$identity);

  /// Serializes this SubPropiedadModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubPropiedadModel&&(identical(other.id, id) || other.id == id)&&(identical(other.solarId, solarId) || other.solarId == solarId)&&(identical(other.solarCodigo, solarCodigo) || other.solarCodigo == solarCodigo)&&(identical(other.codigo, codigo) || other.codigo == codigo)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.areaConstruccionM2, areaConstruccionM2) || other.areaConstruccionM2 == areaConstruccionM2)&&(identical(other.precio, precio) || other.precio == precio)&&(identical(other.metodoAlicuota, metodoAlicuota) || other.metodoAlicuota == metodoAlicuota)&&(identical(other.alicuotaMensualFija, alicuotaMensualFija) || other.alicuotaMensualFija == alicuotaMensualFija)&&(identical(other.tasaAlicuotaM2, tasaAlicuotaM2) || other.tasaAlicuotaM2 == tasaAlicuotaM2)&&(identical(other.alicuotaCalculada, alicuotaCalculada) || other.alicuotaCalculada == alicuotaCalculada)&&(identical(other.habitaciones, habitaciones) || other.habitaciones == habitaciones)&&(identical(other.banos, banos) || other.banos == banos)&&(identical(other.parqueaderos, parqueaderos) || other.parqueaderos == parqueaderos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,solarId,solarCodigo,codigo,tipo,estado,areaConstruccionM2,precio,metodoAlicuota,alicuotaMensualFija,tasaAlicuotaM2,alicuotaCalculada,habitaciones,banos,parqueaderos);

@override
String toString() {
  return 'SubPropiedadModel(id: $id, solarId: $solarId, solarCodigo: $solarCodigo, codigo: $codigo, tipo: $tipo, estado: $estado, areaConstruccionM2: $areaConstruccionM2, precio: $precio, metodoAlicuota: $metodoAlicuota, alicuotaMensualFija: $alicuotaMensualFija, tasaAlicuotaM2: $tasaAlicuotaM2, alicuotaCalculada: $alicuotaCalculada, habitaciones: $habitaciones, banos: $banos, parqueaderos: $parqueaderos)';
}


}

/// @nodoc
abstract mixin class $SubPropiedadModelCopyWith<$Res>  {
  factory $SubPropiedadModelCopyWith(SubPropiedadModel value, $Res Function(SubPropiedadModel) _then) = _$SubPropiedadModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'solar_id') String solarId,@JsonKey(name: 'solar_codigo') String solarCodigo, String codigo, String tipo, String estado,@JsonKey(name: 'area_construccion_m2') double? areaConstruccionM2, double precio,@JsonKey(name: 'metodo_alicuota') String metodoAlicuota,@JsonKey(name: 'alicuota_mensual_fija') double alicuotaMensualFija,@JsonKey(name: 'tasa_alicuota_m2') double? tasaAlicuotaM2,@JsonKey(name: 'alicuota_calculada') double alicuotaCalculada, int? habitaciones, double? banos, int? parqueaderos
});




}
/// @nodoc
class _$SubPropiedadModelCopyWithImpl<$Res>
    implements $SubPropiedadModelCopyWith<$Res> {
  _$SubPropiedadModelCopyWithImpl(this._self, this._then);

  final SubPropiedadModel _self;
  final $Res Function(SubPropiedadModel) _then;

/// Create a copy of SubPropiedadModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? solarId = null,Object? solarCodigo = null,Object? codigo = null,Object? tipo = null,Object? estado = null,Object? areaConstruccionM2 = freezed,Object? precio = null,Object? metodoAlicuota = null,Object? alicuotaMensualFija = null,Object? tasaAlicuotaM2 = freezed,Object? alicuotaCalculada = null,Object? habitaciones = freezed,Object? banos = freezed,Object? parqueaderos = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,solarId: null == solarId ? _self.solarId : solarId // ignore: cast_nullable_to_non_nullable
as String,solarCodigo: null == solarCodigo ? _self.solarCodigo : solarCodigo // ignore: cast_nullable_to_non_nullable
as String,codigo: null == codigo ? _self.codigo : codigo // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as String,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,areaConstruccionM2: freezed == areaConstruccionM2 ? _self.areaConstruccionM2 : areaConstruccionM2 // ignore: cast_nullable_to_non_nullable
as double?,precio: null == precio ? _self.precio : precio // ignore: cast_nullable_to_non_nullable
as double,metodoAlicuota: null == metodoAlicuota ? _self.metodoAlicuota : metodoAlicuota // ignore: cast_nullable_to_non_nullable
as String,alicuotaMensualFija: null == alicuotaMensualFija ? _self.alicuotaMensualFija : alicuotaMensualFija // ignore: cast_nullable_to_non_nullable
as double,tasaAlicuotaM2: freezed == tasaAlicuotaM2 ? _self.tasaAlicuotaM2 : tasaAlicuotaM2 // ignore: cast_nullable_to_non_nullable
as double?,alicuotaCalculada: null == alicuotaCalculada ? _self.alicuotaCalculada : alicuotaCalculada // ignore: cast_nullable_to_non_nullable
as double,habitaciones: freezed == habitaciones ? _self.habitaciones : habitaciones // ignore: cast_nullable_to_non_nullable
as int?,banos: freezed == banos ? _self.banos : banos // ignore: cast_nullable_to_non_nullable
as double?,parqueaderos: freezed == parqueaderos ? _self.parqueaderos : parqueaderos // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubPropiedadModel].
extension SubPropiedadModelPatterns on SubPropiedadModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubPropiedadModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubPropiedadModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubPropiedadModel value)  $default,){
final _that = this;
switch (_that) {
case _SubPropiedadModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubPropiedadModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubPropiedadModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'solar_id')  String solarId, @JsonKey(name: 'solar_codigo')  String solarCodigo,  String codigo,  String tipo,  String estado, @JsonKey(name: 'area_construccion_m2')  double? areaConstruccionM2,  double precio, @JsonKey(name: 'metodo_alicuota')  String metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija')  double alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2')  double? tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada')  double alicuotaCalculada,  int? habitaciones,  double? banos,  int? parqueaderos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubPropiedadModel() when $default != null:
return $default(_that.id,_that.solarId,_that.solarCodigo,_that.codigo,_that.tipo,_that.estado,_that.areaConstruccionM2,_that.precio,_that.metodoAlicuota,_that.alicuotaMensualFija,_that.tasaAlicuotaM2,_that.alicuotaCalculada,_that.habitaciones,_that.banos,_that.parqueaderos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'solar_id')  String solarId, @JsonKey(name: 'solar_codigo')  String solarCodigo,  String codigo,  String tipo,  String estado, @JsonKey(name: 'area_construccion_m2')  double? areaConstruccionM2,  double precio, @JsonKey(name: 'metodo_alicuota')  String metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija')  double alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2')  double? tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada')  double alicuotaCalculada,  int? habitaciones,  double? banos,  int? parqueaderos)  $default,) {final _that = this;
switch (_that) {
case _SubPropiedadModel():
return $default(_that.id,_that.solarId,_that.solarCodigo,_that.codigo,_that.tipo,_that.estado,_that.areaConstruccionM2,_that.precio,_that.metodoAlicuota,_that.alicuotaMensualFija,_that.tasaAlicuotaM2,_that.alicuotaCalculada,_that.habitaciones,_that.banos,_that.parqueaderos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'solar_id')  String solarId, @JsonKey(name: 'solar_codigo')  String solarCodigo,  String codigo,  String tipo,  String estado, @JsonKey(name: 'area_construccion_m2')  double? areaConstruccionM2,  double precio, @JsonKey(name: 'metodo_alicuota')  String metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija')  double alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2')  double? tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada')  double alicuotaCalculada,  int? habitaciones,  double? banos,  int? parqueaderos)?  $default,) {final _that = this;
switch (_that) {
case _SubPropiedadModel() when $default != null:
return $default(_that.id,_that.solarId,_that.solarCodigo,_that.codigo,_that.tipo,_that.estado,_that.areaConstruccionM2,_that.precio,_that.metodoAlicuota,_that.alicuotaMensualFija,_that.tasaAlicuotaM2,_that.alicuotaCalculada,_that.habitaciones,_that.banos,_that.parqueaderos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubPropiedadModel extends SubPropiedadModel {
  const _SubPropiedadModel({required this.id, @JsonKey(name: 'solar_id') required this.solarId, @JsonKey(name: 'solar_codigo') required this.solarCodigo, required this.codigo, required this.tipo, required this.estado, @JsonKey(name: 'area_construccion_m2') this.areaConstruccionM2, required this.precio, @JsonKey(name: 'metodo_alicuota') required this.metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija') required this.alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2') this.tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada') required this.alicuotaCalculada, this.habitaciones, this.banos, this.parqueaderos}): super._();
  factory _SubPropiedadModel.fromJson(Map<String, dynamic> json) => _$SubPropiedadModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'solar_id') final  String solarId;
@override@JsonKey(name: 'solar_codigo') final  String solarCodigo;
@override final  String codigo;
@override final  String tipo;
@override final  String estado;
@override@JsonKey(name: 'area_construccion_m2') final  double? areaConstruccionM2;
@override final  double precio;
@override@JsonKey(name: 'metodo_alicuota') final  String metodoAlicuota;
@override@JsonKey(name: 'alicuota_mensual_fija') final  double alicuotaMensualFija;
@override@JsonKey(name: 'tasa_alicuota_m2') final  double? tasaAlicuotaM2;
@override@JsonKey(name: 'alicuota_calculada') final  double alicuotaCalculada;
@override final  int? habitaciones;
@override final  double? banos;
@override final  int? parqueaderos;

/// Create a copy of SubPropiedadModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubPropiedadModelCopyWith<_SubPropiedadModel> get copyWith => __$SubPropiedadModelCopyWithImpl<_SubPropiedadModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubPropiedadModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubPropiedadModel&&(identical(other.id, id) || other.id == id)&&(identical(other.solarId, solarId) || other.solarId == solarId)&&(identical(other.solarCodigo, solarCodigo) || other.solarCodigo == solarCodigo)&&(identical(other.codigo, codigo) || other.codigo == codigo)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.areaConstruccionM2, areaConstruccionM2) || other.areaConstruccionM2 == areaConstruccionM2)&&(identical(other.precio, precio) || other.precio == precio)&&(identical(other.metodoAlicuota, metodoAlicuota) || other.metodoAlicuota == metodoAlicuota)&&(identical(other.alicuotaMensualFija, alicuotaMensualFija) || other.alicuotaMensualFija == alicuotaMensualFija)&&(identical(other.tasaAlicuotaM2, tasaAlicuotaM2) || other.tasaAlicuotaM2 == tasaAlicuotaM2)&&(identical(other.alicuotaCalculada, alicuotaCalculada) || other.alicuotaCalculada == alicuotaCalculada)&&(identical(other.habitaciones, habitaciones) || other.habitaciones == habitaciones)&&(identical(other.banos, banos) || other.banos == banos)&&(identical(other.parqueaderos, parqueaderos) || other.parqueaderos == parqueaderos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,solarId,solarCodigo,codigo,tipo,estado,areaConstruccionM2,precio,metodoAlicuota,alicuotaMensualFija,tasaAlicuotaM2,alicuotaCalculada,habitaciones,banos,parqueaderos);

@override
String toString() {
  return 'SubPropiedadModel(id: $id, solarId: $solarId, solarCodigo: $solarCodigo, codigo: $codigo, tipo: $tipo, estado: $estado, areaConstruccionM2: $areaConstruccionM2, precio: $precio, metodoAlicuota: $metodoAlicuota, alicuotaMensualFija: $alicuotaMensualFija, tasaAlicuotaM2: $tasaAlicuotaM2, alicuotaCalculada: $alicuotaCalculada, habitaciones: $habitaciones, banos: $banos, parqueaderos: $parqueaderos)';
}


}

/// @nodoc
abstract mixin class _$SubPropiedadModelCopyWith<$Res> implements $SubPropiedadModelCopyWith<$Res> {
  factory _$SubPropiedadModelCopyWith(_SubPropiedadModel value, $Res Function(_SubPropiedadModel) _then) = __$SubPropiedadModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'solar_id') String solarId,@JsonKey(name: 'solar_codigo') String solarCodigo, String codigo, String tipo, String estado,@JsonKey(name: 'area_construccion_m2') double? areaConstruccionM2, double precio,@JsonKey(name: 'metodo_alicuota') String metodoAlicuota,@JsonKey(name: 'alicuota_mensual_fija') double alicuotaMensualFija,@JsonKey(name: 'tasa_alicuota_m2') double? tasaAlicuotaM2,@JsonKey(name: 'alicuota_calculada') double alicuotaCalculada, int? habitaciones, double? banos, int? parqueaderos
});




}
/// @nodoc
class __$SubPropiedadModelCopyWithImpl<$Res>
    implements _$SubPropiedadModelCopyWith<$Res> {
  __$SubPropiedadModelCopyWithImpl(this._self, this._then);

  final _SubPropiedadModel _self;
  final $Res Function(_SubPropiedadModel) _then;

/// Create a copy of SubPropiedadModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? solarId = null,Object? solarCodigo = null,Object? codigo = null,Object? tipo = null,Object? estado = null,Object? areaConstruccionM2 = freezed,Object? precio = null,Object? metodoAlicuota = null,Object? alicuotaMensualFija = null,Object? tasaAlicuotaM2 = freezed,Object? alicuotaCalculada = null,Object? habitaciones = freezed,Object? banos = freezed,Object? parqueaderos = freezed,}) {
  return _then(_SubPropiedadModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,solarId: null == solarId ? _self.solarId : solarId // ignore: cast_nullable_to_non_nullable
as String,solarCodigo: null == solarCodigo ? _self.solarCodigo : solarCodigo // ignore: cast_nullable_to_non_nullable
as String,codigo: null == codigo ? _self.codigo : codigo // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as String,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,areaConstruccionM2: freezed == areaConstruccionM2 ? _self.areaConstruccionM2 : areaConstruccionM2 // ignore: cast_nullable_to_non_nullable
as double?,precio: null == precio ? _self.precio : precio // ignore: cast_nullable_to_non_nullable
as double,metodoAlicuota: null == metodoAlicuota ? _self.metodoAlicuota : metodoAlicuota // ignore: cast_nullable_to_non_nullable
as String,alicuotaMensualFija: null == alicuotaMensualFija ? _self.alicuotaMensualFija : alicuotaMensualFija // ignore: cast_nullable_to_non_nullable
as double,tasaAlicuotaM2: freezed == tasaAlicuotaM2 ? _self.tasaAlicuotaM2 : tasaAlicuotaM2 // ignore: cast_nullable_to_non_nullable
as double?,alicuotaCalculada: null == alicuotaCalculada ? _self.alicuotaCalculada : alicuotaCalculada // ignore: cast_nullable_to_non_nullable
as double,habitaciones: freezed == habitaciones ? _self.habitaciones : habitaciones // ignore: cast_nullable_to_non_nullable
as int?,banos: freezed == banos ? _self.banos : banos // ignore: cast_nullable_to_non_nullable
as double?,parqueaderos: freezed == parqueaderos ? _self.parqueaderos : parqueaderos // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SolarModel {

 String get id; String get codigo;@JsonKey(name: 'area_m2') double get areaM2; double get precio;@JsonKey(name: 'metodo_alicuota') String get metodoAlicuota;@JsonKey(name: 'alicuota_mensual_fija') double get alicuotaMensualFija;@JsonKey(name: 'tasa_alicuota_m2') double? get tasaAlicuotaM2;@JsonKey(name: 'alicuota_calculada') double get alicuotaCalculada;
/// Create a copy of SolarModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SolarModelCopyWith<SolarModel> get copyWith => _$SolarModelCopyWithImpl<SolarModel>(this as SolarModel, _$identity);

  /// Serializes this SolarModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SolarModel&&(identical(other.id, id) || other.id == id)&&(identical(other.codigo, codigo) || other.codigo == codigo)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.precio, precio) || other.precio == precio)&&(identical(other.metodoAlicuota, metodoAlicuota) || other.metodoAlicuota == metodoAlicuota)&&(identical(other.alicuotaMensualFija, alicuotaMensualFija) || other.alicuotaMensualFija == alicuotaMensualFija)&&(identical(other.tasaAlicuotaM2, tasaAlicuotaM2) || other.tasaAlicuotaM2 == tasaAlicuotaM2)&&(identical(other.alicuotaCalculada, alicuotaCalculada) || other.alicuotaCalculada == alicuotaCalculada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,codigo,areaM2,precio,metodoAlicuota,alicuotaMensualFija,tasaAlicuotaM2,alicuotaCalculada);

@override
String toString() {
  return 'SolarModel(id: $id, codigo: $codigo, areaM2: $areaM2, precio: $precio, metodoAlicuota: $metodoAlicuota, alicuotaMensualFija: $alicuotaMensualFija, tasaAlicuotaM2: $tasaAlicuotaM2, alicuotaCalculada: $alicuotaCalculada)';
}


}

/// @nodoc
abstract mixin class $SolarModelCopyWith<$Res>  {
  factory $SolarModelCopyWith(SolarModel value, $Res Function(SolarModel) _then) = _$SolarModelCopyWithImpl;
@useResult
$Res call({
 String id, String codigo,@JsonKey(name: 'area_m2') double areaM2, double precio,@JsonKey(name: 'metodo_alicuota') String metodoAlicuota,@JsonKey(name: 'alicuota_mensual_fija') double alicuotaMensualFija,@JsonKey(name: 'tasa_alicuota_m2') double? tasaAlicuotaM2,@JsonKey(name: 'alicuota_calculada') double alicuotaCalculada
});




}
/// @nodoc
class _$SolarModelCopyWithImpl<$Res>
    implements $SolarModelCopyWith<$Res> {
  _$SolarModelCopyWithImpl(this._self, this._then);

  final SolarModel _self;
  final $Res Function(SolarModel) _then;

/// Create a copy of SolarModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? codigo = null,Object? areaM2 = null,Object? precio = null,Object? metodoAlicuota = null,Object? alicuotaMensualFija = null,Object? tasaAlicuotaM2 = freezed,Object? alicuotaCalculada = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,codigo: null == codigo ? _self.codigo : codigo // ignore: cast_nullable_to_non_nullable
as String,areaM2: null == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double,precio: null == precio ? _self.precio : precio // ignore: cast_nullable_to_non_nullable
as double,metodoAlicuota: null == metodoAlicuota ? _self.metodoAlicuota : metodoAlicuota // ignore: cast_nullable_to_non_nullable
as String,alicuotaMensualFija: null == alicuotaMensualFija ? _self.alicuotaMensualFija : alicuotaMensualFija // ignore: cast_nullable_to_non_nullable
as double,tasaAlicuotaM2: freezed == tasaAlicuotaM2 ? _self.tasaAlicuotaM2 : tasaAlicuotaM2 // ignore: cast_nullable_to_non_nullable
as double?,alicuotaCalculada: null == alicuotaCalculada ? _self.alicuotaCalculada : alicuotaCalculada // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SolarModel].
extension SolarModelPatterns on SolarModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SolarModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SolarModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SolarModel value)  $default,){
final _that = this;
switch (_that) {
case _SolarModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SolarModel value)?  $default,){
final _that = this;
switch (_that) {
case _SolarModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String codigo, @JsonKey(name: 'area_m2')  double areaM2,  double precio, @JsonKey(name: 'metodo_alicuota')  String metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija')  double alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2')  double? tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada')  double alicuotaCalculada)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SolarModel() when $default != null:
return $default(_that.id,_that.codigo,_that.areaM2,_that.precio,_that.metodoAlicuota,_that.alicuotaMensualFija,_that.tasaAlicuotaM2,_that.alicuotaCalculada);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String codigo, @JsonKey(name: 'area_m2')  double areaM2,  double precio, @JsonKey(name: 'metodo_alicuota')  String metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija')  double alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2')  double? tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada')  double alicuotaCalculada)  $default,) {final _that = this;
switch (_that) {
case _SolarModel():
return $default(_that.id,_that.codigo,_that.areaM2,_that.precio,_that.metodoAlicuota,_that.alicuotaMensualFija,_that.tasaAlicuotaM2,_that.alicuotaCalculada);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String codigo, @JsonKey(name: 'area_m2')  double areaM2,  double precio, @JsonKey(name: 'metodo_alicuota')  String metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija')  double alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2')  double? tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada')  double alicuotaCalculada)?  $default,) {final _that = this;
switch (_that) {
case _SolarModel() when $default != null:
return $default(_that.id,_that.codigo,_that.areaM2,_that.precio,_that.metodoAlicuota,_that.alicuotaMensualFija,_that.tasaAlicuotaM2,_that.alicuotaCalculada);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SolarModel extends SolarModel {
  const _SolarModel({required this.id, required this.codigo, @JsonKey(name: 'area_m2') required this.areaM2, required this.precio, @JsonKey(name: 'metodo_alicuota') required this.metodoAlicuota, @JsonKey(name: 'alicuota_mensual_fija') required this.alicuotaMensualFija, @JsonKey(name: 'tasa_alicuota_m2') this.tasaAlicuotaM2, @JsonKey(name: 'alicuota_calculada') required this.alicuotaCalculada}): super._();
  factory _SolarModel.fromJson(Map<String, dynamic> json) => _$SolarModelFromJson(json);

@override final  String id;
@override final  String codigo;
@override@JsonKey(name: 'area_m2') final  double areaM2;
@override final  double precio;
@override@JsonKey(name: 'metodo_alicuota') final  String metodoAlicuota;
@override@JsonKey(name: 'alicuota_mensual_fija') final  double alicuotaMensualFija;
@override@JsonKey(name: 'tasa_alicuota_m2') final  double? tasaAlicuotaM2;
@override@JsonKey(name: 'alicuota_calculada') final  double alicuotaCalculada;

/// Create a copy of SolarModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SolarModelCopyWith<_SolarModel> get copyWith => __$SolarModelCopyWithImpl<_SolarModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SolarModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SolarModel&&(identical(other.id, id) || other.id == id)&&(identical(other.codigo, codigo) || other.codigo == codigo)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.precio, precio) || other.precio == precio)&&(identical(other.metodoAlicuota, metodoAlicuota) || other.metodoAlicuota == metodoAlicuota)&&(identical(other.alicuotaMensualFija, alicuotaMensualFija) || other.alicuotaMensualFija == alicuotaMensualFija)&&(identical(other.tasaAlicuotaM2, tasaAlicuotaM2) || other.tasaAlicuotaM2 == tasaAlicuotaM2)&&(identical(other.alicuotaCalculada, alicuotaCalculada) || other.alicuotaCalculada == alicuotaCalculada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,codigo,areaM2,precio,metodoAlicuota,alicuotaMensualFija,tasaAlicuotaM2,alicuotaCalculada);

@override
String toString() {
  return 'SolarModel(id: $id, codigo: $codigo, areaM2: $areaM2, precio: $precio, metodoAlicuota: $metodoAlicuota, alicuotaMensualFija: $alicuotaMensualFija, tasaAlicuotaM2: $tasaAlicuotaM2, alicuotaCalculada: $alicuotaCalculada)';
}


}

/// @nodoc
abstract mixin class _$SolarModelCopyWith<$Res> implements $SolarModelCopyWith<$Res> {
  factory _$SolarModelCopyWith(_SolarModel value, $Res Function(_SolarModel) _then) = __$SolarModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String codigo,@JsonKey(name: 'area_m2') double areaM2, double precio,@JsonKey(name: 'metodo_alicuota') String metodoAlicuota,@JsonKey(name: 'alicuota_mensual_fija') double alicuotaMensualFija,@JsonKey(name: 'tasa_alicuota_m2') double? tasaAlicuotaM2,@JsonKey(name: 'alicuota_calculada') double alicuotaCalculada
});




}
/// @nodoc
class __$SolarModelCopyWithImpl<$Res>
    implements _$SolarModelCopyWith<$Res> {
  __$SolarModelCopyWithImpl(this._self, this._then);

  final _SolarModel _self;
  final $Res Function(_SolarModel) _then;

/// Create a copy of SolarModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? codigo = null,Object? areaM2 = null,Object? precio = null,Object? metodoAlicuota = null,Object? alicuotaMensualFija = null,Object? tasaAlicuotaM2 = freezed,Object? alicuotaCalculada = null,}) {
  return _then(_SolarModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,codigo: null == codigo ? _self.codigo : codigo // ignore: cast_nullable_to_non_nullable
as String,areaM2: null == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double,precio: null == precio ? _self.precio : precio // ignore: cast_nullable_to_non_nullable
as double,metodoAlicuota: null == metodoAlicuota ? _self.metodoAlicuota : metodoAlicuota // ignore: cast_nullable_to_non_nullable
as String,alicuotaMensualFija: null == alicuotaMensualFija ? _self.alicuotaMensualFija : alicuotaMensualFija // ignore: cast_nullable_to_non_nullable
as double,tasaAlicuotaM2: freezed == tasaAlicuotaM2 ? _self.tasaAlicuotaM2 : tasaAlicuotaM2 // ignore: cast_nullable_to_non_nullable
as double?,alicuotaCalculada: null == alicuotaCalculada ? _self.alicuotaCalculada : alicuotaCalculada // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CobroModel {

 String get id;@JsonKey(name: 'solar_id') String? get solarId;@JsonKey(name: 'sub_propiedad_id') String? get subPropiedadId;@JsonKey(name: 'inmueble_codigo') String get inmuebleCodigo; int get anio; int get mes; double get monto; String get estado;@JsonKey(name: 'tipo_cargo') String get tipoCargo; String? get descripcion;@JsonKey(name: 'metodo_pago') String? get metodoPago;@JsonKey(name: 'fecha_pago') DateTime? get fechaPago;@JsonKey(name: 'comprobante_url') String? get comprobanteUrl;@JsonKey(name: 'transaccion_referencia') String? get transaccionReferencia;
/// Create a copy of CobroModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CobroModelCopyWith<CobroModel> get copyWith => _$CobroModelCopyWithImpl<CobroModel>(this as CobroModel, _$identity);

  /// Serializes this CobroModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CobroModel&&(identical(other.id, id) || other.id == id)&&(identical(other.solarId, solarId) || other.solarId == solarId)&&(identical(other.subPropiedadId, subPropiedadId) || other.subPropiedadId == subPropiedadId)&&(identical(other.inmuebleCodigo, inmuebleCodigo) || other.inmuebleCodigo == inmuebleCodigo)&&(identical(other.anio, anio) || other.anio == anio)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.monto, monto) || other.monto == monto)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.tipoCargo, tipoCargo) || other.tipoCargo == tipoCargo)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.metodoPago, metodoPago) || other.metodoPago == metodoPago)&&(identical(other.fechaPago, fechaPago) || other.fechaPago == fechaPago)&&(identical(other.comprobanteUrl, comprobanteUrl) || other.comprobanteUrl == comprobanteUrl)&&(identical(other.transaccionReferencia, transaccionReferencia) || other.transaccionReferencia == transaccionReferencia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,solarId,subPropiedadId,inmuebleCodigo,anio,mes,monto,estado,tipoCargo,descripcion,metodoPago,fechaPago,comprobanteUrl,transaccionReferencia);

@override
String toString() {
  return 'CobroModel(id: $id, solarId: $solarId, subPropiedadId: $subPropiedadId, inmuebleCodigo: $inmuebleCodigo, anio: $anio, mes: $mes, monto: $monto, estado: $estado, tipoCargo: $tipoCargo, descripcion: $descripcion, metodoPago: $metodoPago, fechaPago: $fechaPago, comprobanteUrl: $comprobanteUrl, transaccionReferencia: $transaccionReferencia)';
}


}

/// @nodoc
abstract mixin class $CobroModelCopyWith<$Res>  {
  factory $CobroModelCopyWith(CobroModel value, $Res Function(CobroModel) _then) = _$CobroModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'solar_id') String? solarId,@JsonKey(name: 'sub_propiedad_id') String? subPropiedadId,@JsonKey(name: 'inmueble_codigo') String inmuebleCodigo, int anio, int mes, double monto, String estado,@JsonKey(name: 'tipo_cargo') String tipoCargo, String? descripcion,@JsonKey(name: 'metodo_pago') String? metodoPago,@JsonKey(name: 'fecha_pago') DateTime? fechaPago,@JsonKey(name: 'comprobante_url') String? comprobanteUrl,@JsonKey(name: 'transaccion_referencia') String? transaccionReferencia
});




}
/// @nodoc
class _$CobroModelCopyWithImpl<$Res>
    implements $CobroModelCopyWith<$Res> {
  _$CobroModelCopyWithImpl(this._self, this._then);

  final CobroModel _self;
  final $Res Function(CobroModel) _then;

/// Create a copy of CobroModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? solarId = freezed,Object? subPropiedadId = freezed,Object? inmuebleCodigo = null,Object? anio = null,Object? mes = null,Object? monto = null,Object? estado = null,Object? tipoCargo = null,Object? descripcion = freezed,Object? metodoPago = freezed,Object? fechaPago = freezed,Object? comprobanteUrl = freezed,Object? transaccionReferencia = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,solarId: freezed == solarId ? _self.solarId : solarId // ignore: cast_nullable_to_non_nullable
as String?,subPropiedadId: freezed == subPropiedadId ? _self.subPropiedadId : subPropiedadId // ignore: cast_nullable_to_non_nullable
as String?,inmuebleCodigo: null == inmuebleCodigo ? _self.inmuebleCodigo : inmuebleCodigo // ignore: cast_nullable_to_non_nullable
as String,anio: null == anio ? _self.anio : anio // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as int,monto: null == monto ? _self.monto : monto // ignore: cast_nullable_to_non_nullable
as double,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,tipoCargo: null == tipoCargo ? _self.tipoCargo : tipoCargo // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,metodoPago: freezed == metodoPago ? _self.metodoPago : metodoPago // ignore: cast_nullable_to_non_nullable
as String?,fechaPago: freezed == fechaPago ? _self.fechaPago : fechaPago // ignore: cast_nullable_to_non_nullable
as DateTime?,comprobanteUrl: freezed == comprobanteUrl ? _self.comprobanteUrl : comprobanteUrl // ignore: cast_nullable_to_non_nullable
as String?,transaccionReferencia: freezed == transaccionReferencia ? _self.transaccionReferencia : transaccionReferencia // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CobroModel].
extension CobroModelPatterns on CobroModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CobroModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CobroModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CobroModel value)  $default,){
final _that = this;
switch (_that) {
case _CobroModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CobroModel value)?  $default,){
final _that = this;
switch (_that) {
case _CobroModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'solar_id')  String? solarId, @JsonKey(name: 'sub_propiedad_id')  String? subPropiedadId, @JsonKey(name: 'inmueble_codigo')  String inmuebleCodigo,  int anio,  int mes,  double monto,  String estado, @JsonKey(name: 'tipo_cargo')  String tipoCargo,  String? descripcion, @JsonKey(name: 'metodo_pago')  String? metodoPago, @JsonKey(name: 'fecha_pago')  DateTime? fechaPago, @JsonKey(name: 'comprobante_url')  String? comprobanteUrl, @JsonKey(name: 'transaccion_referencia')  String? transaccionReferencia)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CobroModel() when $default != null:
return $default(_that.id,_that.solarId,_that.subPropiedadId,_that.inmuebleCodigo,_that.anio,_that.mes,_that.monto,_that.estado,_that.tipoCargo,_that.descripcion,_that.metodoPago,_that.fechaPago,_that.comprobanteUrl,_that.transaccionReferencia);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'solar_id')  String? solarId, @JsonKey(name: 'sub_propiedad_id')  String? subPropiedadId, @JsonKey(name: 'inmueble_codigo')  String inmuebleCodigo,  int anio,  int mes,  double monto,  String estado, @JsonKey(name: 'tipo_cargo')  String tipoCargo,  String? descripcion, @JsonKey(name: 'metodo_pago')  String? metodoPago, @JsonKey(name: 'fecha_pago')  DateTime? fechaPago, @JsonKey(name: 'comprobante_url')  String? comprobanteUrl, @JsonKey(name: 'transaccion_referencia')  String? transaccionReferencia)  $default,) {final _that = this;
switch (_that) {
case _CobroModel():
return $default(_that.id,_that.solarId,_that.subPropiedadId,_that.inmuebleCodigo,_that.anio,_that.mes,_that.monto,_that.estado,_that.tipoCargo,_that.descripcion,_that.metodoPago,_that.fechaPago,_that.comprobanteUrl,_that.transaccionReferencia);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'solar_id')  String? solarId, @JsonKey(name: 'sub_propiedad_id')  String? subPropiedadId, @JsonKey(name: 'inmueble_codigo')  String inmuebleCodigo,  int anio,  int mes,  double monto,  String estado, @JsonKey(name: 'tipo_cargo')  String tipoCargo,  String? descripcion, @JsonKey(name: 'metodo_pago')  String? metodoPago, @JsonKey(name: 'fecha_pago')  DateTime? fechaPago, @JsonKey(name: 'comprobante_url')  String? comprobanteUrl, @JsonKey(name: 'transaccion_referencia')  String? transaccionReferencia)?  $default,) {final _that = this;
switch (_that) {
case _CobroModel() when $default != null:
return $default(_that.id,_that.solarId,_that.subPropiedadId,_that.inmuebleCodigo,_that.anio,_that.mes,_that.monto,_that.estado,_that.tipoCargo,_that.descripcion,_that.metodoPago,_that.fechaPago,_that.comprobanteUrl,_that.transaccionReferencia);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CobroModel extends CobroModel {
  const _CobroModel({required this.id, @JsonKey(name: 'solar_id') this.solarId, @JsonKey(name: 'sub_propiedad_id') this.subPropiedadId, @JsonKey(name: 'inmueble_codigo') required this.inmuebleCodigo, required this.anio, required this.mes, required this.monto, required this.estado, @JsonKey(name: 'tipo_cargo') required this.tipoCargo, this.descripcion, @JsonKey(name: 'metodo_pago') this.metodoPago, @JsonKey(name: 'fecha_pago') this.fechaPago, @JsonKey(name: 'comprobante_url') this.comprobanteUrl, @JsonKey(name: 'transaccion_referencia') this.transaccionReferencia}): super._();
  factory _CobroModel.fromJson(Map<String, dynamic> json) => _$CobroModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'solar_id') final  String? solarId;
@override@JsonKey(name: 'sub_propiedad_id') final  String? subPropiedadId;
@override@JsonKey(name: 'inmueble_codigo') final  String inmuebleCodigo;
@override final  int anio;
@override final  int mes;
@override final  double monto;
@override final  String estado;
@override@JsonKey(name: 'tipo_cargo') final  String tipoCargo;
@override final  String? descripcion;
@override@JsonKey(name: 'metodo_pago') final  String? metodoPago;
@override@JsonKey(name: 'fecha_pago') final  DateTime? fechaPago;
@override@JsonKey(name: 'comprobante_url') final  String? comprobanteUrl;
@override@JsonKey(name: 'transaccion_referencia') final  String? transaccionReferencia;

/// Create a copy of CobroModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CobroModelCopyWith<_CobroModel> get copyWith => __$CobroModelCopyWithImpl<_CobroModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CobroModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CobroModel&&(identical(other.id, id) || other.id == id)&&(identical(other.solarId, solarId) || other.solarId == solarId)&&(identical(other.subPropiedadId, subPropiedadId) || other.subPropiedadId == subPropiedadId)&&(identical(other.inmuebleCodigo, inmuebleCodigo) || other.inmuebleCodigo == inmuebleCodigo)&&(identical(other.anio, anio) || other.anio == anio)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.monto, monto) || other.monto == monto)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.tipoCargo, tipoCargo) || other.tipoCargo == tipoCargo)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.metodoPago, metodoPago) || other.metodoPago == metodoPago)&&(identical(other.fechaPago, fechaPago) || other.fechaPago == fechaPago)&&(identical(other.comprobanteUrl, comprobanteUrl) || other.comprobanteUrl == comprobanteUrl)&&(identical(other.transaccionReferencia, transaccionReferencia) || other.transaccionReferencia == transaccionReferencia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,solarId,subPropiedadId,inmuebleCodigo,anio,mes,monto,estado,tipoCargo,descripcion,metodoPago,fechaPago,comprobanteUrl,transaccionReferencia);

@override
String toString() {
  return 'CobroModel(id: $id, solarId: $solarId, subPropiedadId: $subPropiedadId, inmuebleCodigo: $inmuebleCodigo, anio: $anio, mes: $mes, monto: $monto, estado: $estado, tipoCargo: $tipoCargo, descripcion: $descripcion, metodoPago: $metodoPago, fechaPago: $fechaPago, comprobanteUrl: $comprobanteUrl, transaccionReferencia: $transaccionReferencia)';
}


}

/// @nodoc
abstract mixin class _$CobroModelCopyWith<$Res> implements $CobroModelCopyWith<$Res> {
  factory _$CobroModelCopyWith(_CobroModel value, $Res Function(_CobroModel) _then) = __$CobroModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'solar_id') String? solarId,@JsonKey(name: 'sub_propiedad_id') String? subPropiedadId,@JsonKey(name: 'inmueble_codigo') String inmuebleCodigo, int anio, int mes, double monto, String estado,@JsonKey(name: 'tipo_cargo') String tipoCargo, String? descripcion,@JsonKey(name: 'metodo_pago') String? metodoPago,@JsonKey(name: 'fecha_pago') DateTime? fechaPago,@JsonKey(name: 'comprobante_url') String? comprobanteUrl,@JsonKey(name: 'transaccion_referencia') String? transaccionReferencia
});




}
/// @nodoc
class __$CobroModelCopyWithImpl<$Res>
    implements _$CobroModelCopyWith<$Res> {
  __$CobroModelCopyWithImpl(this._self, this._then);

  final _CobroModel _self;
  final $Res Function(_CobroModel) _then;

/// Create a copy of CobroModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? solarId = freezed,Object? subPropiedadId = freezed,Object? inmuebleCodigo = null,Object? anio = null,Object? mes = null,Object? monto = null,Object? estado = null,Object? tipoCargo = null,Object? descripcion = freezed,Object? metodoPago = freezed,Object? fechaPago = freezed,Object? comprobanteUrl = freezed,Object? transaccionReferencia = freezed,}) {
  return _then(_CobroModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,solarId: freezed == solarId ? _self.solarId : solarId // ignore: cast_nullable_to_non_nullable
as String?,subPropiedadId: freezed == subPropiedadId ? _self.subPropiedadId : subPropiedadId // ignore: cast_nullable_to_non_nullable
as String?,inmuebleCodigo: null == inmuebleCodigo ? _self.inmuebleCodigo : inmuebleCodigo // ignore: cast_nullable_to_non_nullable
as String,anio: null == anio ? _self.anio : anio // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as int,monto: null == monto ? _self.monto : monto // ignore: cast_nullable_to_non_nullable
as double,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,tipoCargo: null == tipoCargo ? _self.tipoCargo : tipoCargo // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,metodoPago: freezed == metodoPago ? _self.metodoPago : metodoPago // ignore: cast_nullable_to_non_nullable
as String?,fechaPago: freezed == fechaPago ? _self.fechaPago : fechaPago // ignore: cast_nullable_to_non_nullable
as DateTime?,comprobanteUrl: freezed == comprobanteUrl ? _self.comprobanteUrl : comprobanteUrl // ignore: cast_nullable_to_non_nullable
as String?,transaccionReferencia: freezed == transaccionReferencia ? _self.transaccionReferencia : transaccionReferencia // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
