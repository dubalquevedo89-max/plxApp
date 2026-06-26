// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lot_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LotDetailModel {

 String get id; String get codigo; String? get zona;@JsonKey(name: 'zona_color') String? get zonaColor; String? get etapa;@JsonKey(name: 'area_m2') double? get areaM2; double? get precio; String get estado; String? get descripcion; List<String> get fotos; List<String> get videos;@JsonKey(name: 'has_tour_virtual') bool get hasTourVirtual;@JsonKey(name: 'tour_virtual_url') String? get tourVirtualUrl;@JsonKey(name: 'video_sobrevuelo_url') String? get videoSobrevueloUrl;@JsonKey(name: 'valor_arriendo') double? get valorArriendo;@JsonKey(name: 'tiene_ph') bool get tienePh;@JsonKey(name: 'ph_count') int get phCount;@JsonKey(name: 'destacado') bool get destacado;
/// Create a copy of LotDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotDetailModelCopyWith<LotDetailModel> get copyWith => _$LotDetailModelCopyWithImpl<LotDetailModel>(this as LotDetailModel, _$identity);

  /// Serializes this LotDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.codigo, codigo) || other.codigo == codigo)&&(identical(other.zona, zona) || other.zona == zona)&&(identical(other.zonaColor, zonaColor) || other.zonaColor == zonaColor)&&(identical(other.etapa, etapa) || other.etapa == etapa)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.precio, precio) || other.precio == precio)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&const DeepCollectionEquality().equals(other.fotos, fotos)&&const DeepCollectionEquality().equals(other.videos, videos)&&(identical(other.hasTourVirtual, hasTourVirtual) || other.hasTourVirtual == hasTourVirtual)&&(identical(other.tourVirtualUrl, tourVirtualUrl) || other.tourVirtualUrl == tourVirtualUrl)&&(identical(other.videoSobrevueloUrl, videoSobrevueloUrl) || other.videoSobrevueloUrl == videoSobrevueloUrl)&&(identical(other.valorArriendo, valorArriendo) || other.valorArriendo == valorArriendo)&&(identical(other.tienePh, tienePh) || other.tienePh == tienePh)&&(identical(other.phCount, phCount) || other.phCount == phCount)&&(identical(other.destacado, destacado) || other.destacado == destacado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,codigo,zona,zonaColor,etapa,areaM2,precio,estado,descripcion,const DeepCollectionEquality().hash(fotos),const DeepCollectionEquality().hash(videos),hasTourVirtual,tourVirtualUrl,videoSobrevueloUrl,valorArriendo,tienePh,phCount,destacado);

@override
String toString() {
  return 'LotDetailModel(id: $id, codigo: $codigo, zona: $zona, zonaColor: $zonaColor, etapa: $etapa, areaM2: $areaM2, precio: $precio, estado: $estado, descripcion: $descripcion, fotos: $fotos, videos: $videos, hasTourVirtual: $hasTourVirtual, tourVirtualUrl: $tourVirtualUrl, videoSobrevueloUrl: $videoSobrevueloUrl, valorArriendo: $valorArriendo, tienePh: $tienePh, phCount: $phCount, destacado: $destacado)';
}


}

/// @nodoc
abstract mixin class $LotDetailModelCopyWith<$Res>  {
  factory $LotDetailModelCopyWith(LotDetailModel value, $Res Function(LotDetailModel) _then) = _$LotDetailModelCopyWithImpl;
@useResult
$Res call({
 String id, String codigo, String? zona,@JsonKey(name: 'zona_color') String? zonaColor, String? etapa,@JsonKey(name: 'area_m2') double? areaM2, double? precio, String estado, String? descripcion, List<String> fotos, List<String> videos,@JsonKey(name: 'has_tour_virtual') bool hasTourVirtual,@JsonKey(name: 'tour_virtual_url') String? tourVirtualUrl,@JsonKey(name: 'video_sobrevuelo_url') String? videoSobrevueloUrl,@JsonKey(name: 'valor_arriendo') double? valorArriendo,@JsonKey(name: 'tiene_ph') bool tienePh,@JsonKey(name: 'ph_count') int phCount,@JsonKey(name: 'destacado') bool destacado
});




}
/// @nodoc
class _$LotDetailModelCopyWithImpl<$Res>
    implements $LotDetailModelCopyWith<$Res> {
  _$LotDetailModelCopyWithImpl(this._self, this._then);

  final LotDetailModel _self;
  final $Res Function(LotDetailModel) _then;

/// Create a copy of LotDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? codigo = null,Object? zona = freezed,Object? zonaColor = freezed,Object? etapa = freezed,Object? areaM2 = freezed,Object? precio = freezed,Object? estado = null,Object? descripcion = freezed,Object? fotos = null,Object? videos = null,Object? hasTourVirtual = null,Object? tourVirtualUrl = freezed,Object? videoSobrevueloUrl = freezed,Object? valorArriendo = freezed,Object? tienePh = null,Object? phCount = null,Object? destacado = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,codigo: null == codigo ? _self.codigo : codigo // ignore: cast_nullable_to_non_nullable
as String,zona: freezed == zona ? _self.zona : zona // ignore: cast_nullable_to_non_nullable
as String?,zonaColor: freezed == zonaColor ? _self.zonaColor : zonaColor // ignore: cast_nullable_to_non_nullable
as String?,etapa: freezed == etapa ? _self.etapa : etapa // ignore: cast_nullable_to_non_nullable
as String?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,precio: freezed == precio ? _self.precio : precio // ignore: cast_nullable_to_non_nullable
as double?,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,fotos: null == fotos ? _self.fotos : fotos // ignore: cast_nullable_to_non_nullable
as List<String>,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<String>,hasTourVirtual: null == hasTourVirtual ? _self.hasTourVirtual : hasTourVirtual // ignore: cast_nullable_to_non_nullable
as bool,tourVirtualUrl: freezed == tourVirtualUrl ? _self.tourVirtualUrl : tourVirtualUrl // ignore: cast_nullable_to_non_nullable
as String?,videoSobrevueloUrl: freezed == videoSobrevueloUrl ? _self.videoSobrevueloUrl : videoSobrevueloUrl // ignore: cast_nullable_to_non_nullable
as String?,valorArriendo: freezed == valorArriendo ? _self.valorArriendo : valorArriendo // ignore: cast_nullable_to_non_nullable
as double?,tienePh: null == tienePh ? _self.tienePh : tienePh // ignore: cast_nullable_to_non_nullable
as bool,phCount: null == phCount ? _self.phCount : phCount // ignore: cast_nullable_to_non_nullable
as int,destacado: null == destacado ? _self.destacado : destacado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LotDetailModel].
extension LotDetailModelPatterns on LotDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LotDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LotDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LotDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _LotDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LotDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _LotDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String codigo,  String? zona, @JsonKey(name: 'zona_color')  String? zonaColor,  String? etapa, @JsonKey(name: 'area_m2')  double? areaM2,  double? precio,  String estado,  String? descripcion,  List<String> fotos,  List<String> videos, @JsonKey(name: 'has_tour_virtual')  bool hasTourVirtual, @JsonKey(name: 'tour_virtual_url')  String? tourVirtualUrl, @JsonKey(name: 'video_sobrevuelo_url')  String? videoSobrevueloUrl, @JsonKey(name: 'valor_arriendo')  double? valorArriendo, @JsonKey(name: 'tiene_ph')  bool tienePh, @JsonKey(name: 'ph_count')  int phCount, @JsonKey(name: 'destacado')  bool destacado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LotDetailModel() when $default != null:
return $default(_that.id,_that.codigo,_that.zona,_that.zonaColor,_that.etapa,_that.areaM2,_that.precio,_that.estado,_that.descripcion,_that.fotos,_that.videos,_that.hasTourVirtual,_that.tourVirtualUrl,_that.videoSobrevueloUrl,_that.valorArriendo,_that.tienePh,_that.phCount,_that.destacado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String codigo,  String? zona, @JsonKey(name: 'zona_color')  String? zonaColor,  String? etapa, @JsonKey(name: 'area_m2')  double? areaM2,  double? precio,  String estado,  String? descripcion,  List<String> fotos,  List<String> videos, @JsonKey(name: 'has_tour_virtual')  bool hasTourVirtual, @JsonKey(name: 'tour_virtual_url')  String? tourVirtualUrl, @JsonKey(name: 'video_sobrevuelo_url')  String? videoSobrevueloUrl, @JsonKey(name: 'valor_arriendo')  double? valorArriendo, @JsonKey(name: 'tiene_ph')  bool tienePh, @JsonKey(name: 'ph_count')  int phCount, @JsonKey(name: 'destacado')  bool destacado)  $default,) {final _that = this;
switch (_that) {
case _LotDetailModel():
return $default(_that.id,_that.codigo,_that.zona,_that.zonaColor,_that.etapa,_that.areaM2,_that.precio,_that.estado,_that.descripcion,_that.fotos,_that.videos,_that.hasTourVirtual,_that.tourVirtualUrl,_that.videoSobrevueloUrl,_that.valorArriendo,_that.tienePh,_that.phCount,_that.destacado);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String codigo,  String? zona, @JsonKey(name: 'zona_color')  String? zonaColor,  String? etapa, @JsonKey(name: 'area_m2')  double? areaM2,  double? precio,  String estado,  String? descripcion,  List<String> fotos,  List<String> videos, @JsonKey(name: 'has_tour_virtual')  bool hasTourVirtual, @JsonKey(name: 'tour_virtual_url')  String? tourVirtualUrl, @JsonKey(name: 'video_sobrevuelo_url')  String? videoSobrevueloUrl, @JsonKey(name: 'valor_arriendo')  double? valorArriendo, @JsonKey(name: 'tiene_ph')  bool tienePh, @JsonKey(name: 'ph_count')  int phCount, @JsonKey(name: 'destacado')  bool destacado)?  $default,) {final _that = this;
switch (_that) {
case _LotDetailModel() when $default != null:
return $default(_that.id,_that.codigo,_that.zona,_that.zonaColor,_that.etapa,_that.areaM2,_that.precio,_that.estado,_that.descripcion,_that.fotos,_that.videos,_that.hasTourVirtual,_that.tourVirtualUrl,_that.videoSobrevueloUrl,_that.valorArriendo,_that.tienePh,_that.phCount,_that.destacado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LotDetailModel extends LotDetailModel {
  const _LotDetailModel({required this.id, required this.codigo, this.zona, @JsonKey(name: 'zona_color') this.zonaColor, this.etapa, @JsonKey(name: 'area_m2') this.areaM2, this.precio, required this.estado, this.descripcion, final  List<String> fotos = const [], final  List<String> videos = const [], @JsonKey(name: 'has_tour_virtual') this.hasTourVirtual = false, @JsonKey(name: 'tour_virtual_url') this.tourVirtualUrl, @JsonKey(name: 'video_sobrevuelo_url') this.videoSobrevueloUrl, @JsonKey(name: 'valor_arriendo') this.valorArriendo, @JsonKey(name: 'tiene_ph') this.tienePh = false, @JsonKey(name: 'ph_count') this.phCount = 0, @JsonKey(name: 'destacado') this.destacado = false}): _fotos = fotos,_videos = videos,super._();
  factory _LotDetailModel.fromJson(Map<String, dynamic> json) => _$LotDetailModelFromJson(json);

@override final  String id;
@override final  String codigo;
@override final  String? zona;
@override@JsonKey(name: 'zona_color') final  String? zonaColor;
@override final  String? etapa;
@override@JsonKey(name: 'area_m2') final  double? areaM2;
@override final  double? precio;
@override final  String estado;
@override final  String? descripcion;
 final  List<String> _fotos;
@override@JsonKey() List<String> get fotos {
  if (_fotos is EqualUnmodifiableListView) return _fotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fotos);
}

 final  List<String> _videos;
@override@JsonKey() List<String> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}

@override@JsonKey(name: 'has_tour_virtual') final  bool hasTourVirtual;
@override@JsonKey(name: 'tour_virtual_url') final  String? tourVirtualUrl;
@override@JsonKey(name: 'video_sobrevuelo_url') final  String? videoSobrevueloUrl;
@override@JsonKey(name: 'valor_arriendo') final  double? valorArriendo;
@override@JsonKey(name: 'tiene_ph') final  bool tienePh;
@override@JsonKey(name: 'ph_count') final  int phCount;
@override@JsonKey(name: 'destacado') final  bool destacado;

/// Create a copy of LotDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotDetailModelCopyWith<_LotDetailModel> get copyWith => __$LotDetailModelCopyWithImpl<_LotDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.codigo, codigo) || other.codigo == codigo)&&(identical(other.zona, zona) || other.zona == zona)&&(identical(other.zonaColor, zonaColor) || other.zonaColor == zonaColor)&&(identical(other.etapa, etapa) || other.etapa == etapa)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.precio, precio) || other.precio == precio)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&const DeepCollectionEquality().equals(other._fotos, _fotos)&&const DeepCollectionEquality().equals(other._videos, _videos)&&(identical(other.hasTourVirtual, hasTourVirtual) || other.hasTourVirtual == hasTourVirtual)&&(identical(other.tourVirtualUrl, tourVirtualUrl) || other.tourVirtualUrl == tourVirtualUrl)&&(identical(other.videoSobrevueloUrl, videoSobrevueloUrl) || other.videoSobrevueloUrl == videoSobrevueloUrl)&&(identical(other.valorArriendo, valorArriendo) || other.valorArriendo == valorArriendo)&&(identical(other.tienePh, tienePh) || other.tienePh == tienePh)&&(identical(other.phCount, phCount) || other.phCount == phCount)&&(identical(other.destacado, destacado) || other.destacado == destacado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,codigo,zona,zonaColor,etapa,areaM2,precio,estado,descripcion,const DeepCollectionEquality().hash(_fotos),const DeepCollectionEquality().hash(_videos),hasTourVirtual,tourVirtualUrl,videoSobrevueloUrl,valorArriendo,tienePh,phCount,destacado);

@override
String toString() {
  return 'LotDetailModel(id: $id, codigo: $codigo, zona: $zona, zonaColor: $zonaColor, etapa: $etapa, areaM2: $areaM2, precio: $precio, estado: $estado, descripcion: $descripcion, fotos: $fotos, videos: $videos, hasTourVirtual: $hasTourVirtual, tourVirtualUrl: $tourVirtualUrl, videoSobrevueloUrl: $videoSobrevueloUrl, valorArriendo: $valorArriendo, tienePh: $tienePh, phCount: $phCount, destacado: $destacado)';
}


}

/// @nodoc
abstract mixin class _$LotDetailModelCopyWith<$Res> implements $LotDetailModelCopyWith<$Res> {
  factory _$LotDetailModelCopyWith(_LotDetailModel value, $Res Function(_LotDetailModel) _then) = __$LotDetailModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String codigo, String? zona,@JsonKey(name: 'zona_color') String? zonaColor, String? etapa,@JsonKey(name: 'area_m2') double? areaM2, double? precio, String estado, String? descripcion, List<String> fotos, List<String> videos,@JsonKey(name: 'has_tour_virtual') bool hasTourVirtual,@JsonKey(name: 'tour_virtual_url') String? tourVirtualUrl,@JsonKey(name: 'video_sobrevuelo_url') String? videoSobrevueloUrl,@JsonKey(name: 'valor_arriendo') double? valorArriendo,@JsonKey(name: 'tiene_ph') bool tienePh,@JsonKey(name: 'ph_count') int phCount,@JsonKey(name: 'destacado') bool destacado
});




}
/// @nodoc
class __$LotDetailModelCopyWithImpl<$Res>
    implements _$LotDetailModelCopyWith<$Res> {
  __$LotDetailModelCopyWithImpl(this._self, this._then);

  final _LotDetailModel _self;
  final $Res Function(_LotDetailModel) _then;

/// Create a copy of LotDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? codigo = null,Object? zona = freezed,Object? zonaColor = freezed,Object? etapa = freezed,Object? areaM2 = freezed,Object? precio = freezed,Object? estado = null,Object? descripcion = freezed,Object? fotos = null,Object? videos = null,Object? hasTourVirtual = null,Object? tourVirtualUrl = freezed,Object? videoSobrevueloUrl = freezed,Object? valorArriendo = freezed,Object? tienePh = null,Object? phCount = null,Object? destacado = null,}) {
  return _then(_LotDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,codigo: null == codigo ? _self.codigo : codigo // ignore: cast_nullable_to_non_nullable
as String,zona: freezed == zona ? _self.zona : zona // ignore: cast_nullable_to_non_nullable
as String?,zonaColor: freezed == zonaColor ? _self.zonaColor : zonaColor // ignore: cast_nullable_to_non_nullable
as String?,etapa: freezed == etapa ? _self.etapa : etapa // ignore: cast_nullable_to_non_nullable
as String?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,precio: freezed == precio ? _self.precio : precio // ignore: cast_nullable_to_non_nullable
as double?,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,fotos: null == fotos ? _self._fotos : fotos // ignore: cast_nullable_to_non_nullable
as List<String>,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<String>,hasTourVirtual: null == hasTourVirtual ? _self.hasTourVirtual : hasTourVirtual // ignore: cast_nullable_to_non_nullable
as bool,tourVirtualUrl: freezed == tourVirtualUrl ? _self.tourVirtualUrl : tourVirtualUrl // ignore: cast_nullable_to_non_nullable
as String?,videoSobrevueloUrl: freezed == videoSobrevueloUrl ? _self.videoSobrevueloUrl : videoSobrevueloUrl // ignore: cast_nullable_to_non_nullable
as String?,valorArriendo: freezed == valorArriendo ? _self.valorArriendo : valorArriendo // ignore: cast_nullable_to_non_nullable
as double?,tienePh: null == tienePh ? _self.tienePh : tienePh // ignore: cast_nullable_to_non_nullable
as bool,phCount: null == phCount ? _self.phCount : phCount // ignore: cast_nullable_to_non_nullable
as int,destacado: null == destacado ? _self.destacado : destacado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
