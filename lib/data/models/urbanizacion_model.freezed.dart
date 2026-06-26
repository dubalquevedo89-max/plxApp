// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'urbanizacion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UrbanizacionModel {

 String get slug; String get nombre;@JsonKey(name: 'descripcion_publica') String? get descripcionPublica;@JsonKey(name: 'ubicacion_texto') String? get ubicacionTexto;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'primary_color') String get primaryColor;@JsonKey(name: 'whatsapp_number') String? get whatsappNumber;@JsonKey(name: 'frontend_url') String? get frontendUrl; String get pais; String? get subdivision; String? get ciudad;@JsonKey(name: 'app_enabled') bool get appEnabled;@JsonKey(name: 'masterplan_app_enabled') bool get masterplanAppEnabled;@JsonKey(name: 'virtual_projects') List<VirtualProjectModel> get virtualProjects;
/// Create a copy of UrbanizacionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrbanizacionModelCopyWith<UrbanizacionModel> get copyWith => _$UrbanizacionModelCopyWithImpl<UrbanizacionModel>(this as UrbanizacionModel, _$identity);

  /// Serializes this UrbanizacionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UrbanizacionModel&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcionPublica, descripcionPublica) || other.descripcionPublica == descripcionPublica)&&(identical(other.ubicacionTexto, ubicacionTexto) || other.ubicacionTexto == ubicacionTexto)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.frontendUrl, frontendUrl) || other.frontendUrl == frontendUrl)&&(identical(other.pais, pais) || other.pais == pais)&&(identical(other.subdivision, subdivision) || other.subdivision == subdivision)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.appEnabled, appEnabled) || other.appEnabled == appEnabled)&&(identical(other.masterplanAppEnabled, masterplanAppEnabled) || other.masterplanAppEnabled == masterplanAppEnabled)&&const DeepCollectionEquality().equals(other.virtualProjects, virtualProjects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nombre,descripcionPublica,ubicacionTexto,logoUrl,primaryColor,whatsappNumber,frontendUrl,pais,subdivision,ciudad,appEnabled,masterplanAppEnabled,const DeepCollectionEquality().hash(virtualProjects));

@override
String toString() {
  return 'UrbanizacionModel(slug: $slug, nombre: $nombre, descripcionPublica: $descripcionPublica, ubicacionTexto: $ubicacionTexto, logoUrl: $logoUrl, primaryColor: $primaryColor, whatsappNumber: $whatsappNumber, frontendUrl: $frontendUrl, pais: $pais, subdivision: $subdivision, ciudad: $ciudad, appEnabled: $appEnabled, masterplanAppEnabled: $masterplanAppEnabled, virtualProjects: $virtualProjects)';
}


}

/// @nodoc
abstract mixin class $UrbanizacionModelCopyWith<$Res>  {
  factory $UrbanizacionModelCopyWith(UrbanizacionModel value, $Res Function(UrbanizacionModel) _then) = _$UrbanizacionModelCopyWithImpl;
@useResult
$Res call({
 String slug, String nombre,@JsonKey(name: 'descripcion_publica') String? descripcionPublica,@JsonKey(name: 'ubicacion_texto') String? ubicacionTexto,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'primary_color') String primaryColor,@JsonKey(name: 'whatsapp_number') String? whatsappNumber,@JsonKey(name: 'frontend_url') String? frontendUrl, String pais, String? subdivision, String? ciudad,@JsonKey(name: 'app_enabled') bool appEnabled,@JsonKey(name: 'masterplan_app_enabled') bool masterplanAppEnabled,@JsonKey(name: 'virtual_projects') List<VirtualProjectModel> virtualProjects
});




}
/// @nodoc
class _$UrbanizacionModelCopyWithImpl<$Res>
    implements $UrbanizacionModelCopyWith<$Res> {
  _$UrbanizacionModelCopyWithImpl(this._self, this._then);

  final UrbanizacionModel _self;
  final $Res Function(UrbanizacionModel) _then;

/// Create a copy of UrbanizacionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? nombre = null,Object? descripcionPublica = freezed,Object? ubicacionTexto = freezed,Object? logoUrl = freezed,Object? primaryColor = null,Object? whatsappNumber = freezed,Object? frontendUrl = freezed,Object? pais = null,Object? subdivision = freezed,Object? ciudad = freezed,Object? appEnabled = null,Object? masterplanAppEnabled = null,Object? virtualProjects = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcionPublica: freezed == descripcionPublica ? _self.descripcionPublica : descripcionPublica // ignore: cast_nullable_to_non_nullable
as String?,ubicacionTexto: freezed == ubicacionTexto ? _self.ubicacionTexto : ubicacionTexto // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,frontendUrl: freezed == frontendUrl ? _self.frontendUrl : frontendUrl // ignore: cast_nullable_to_non_nullable
as String?,pais: null == pais ? _self.pais : pais // ignore: cast_nullable_to_non_nullable
as String,subdivision: freezed == subdivision ? _self.subdivision : subdivision // ignore: cast_nullable_to_non_nullable
as String?,ciudad: freezed == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String?,appEnabled: null == appEnabled ? _self.appEnabled : appEnabled // ignore: cast_nullable_to_non_nullable
as bool,masterplanAppEnabled: null == masterplanAppEnabled ? _self.masterplanAppEnabled : masterplanAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,virtualProjects: null == virtualProjects ? _self.virtualProjects : virtualProjects // ignore: cast_nullable_to_non_nullable
as List<VirtualProjectModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [UrbanizacionModel].
extension UrbanizacionModelPatterns on UrbanizacionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UrbanizacionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UrbanizacionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UrbanizacionModel value)  $default,){
final _that = this;
switch (_that) {
case _UrbanizacionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UrbanizacionModel value)?  $default,){
final _that = this;
switch (_that) {
case _UrbanizacionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String nombre, @JsonKey(name: 'descripcion_publica')  String? descripcionPublica, @JsonKey(name: 'ubicacion_texto')  String? ubicacionTexto, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'primary_color')  String primaryColor, @JsonKey(name: 'whatsapp_number')  String? whatsappNumber, @JsonKey(name: 'frontend_url')  String? frontendUrl,  String pais,  String? subdivision,  String? ciudad, @JsonKey(name: 'app_enabled')  bool appEnabled, @JsonKey(name: 'masterplan_app_enabled')  bool masterplanAppEnabled, @JsonKey(name: 'virtual_projects')  List<VirtualProjectModel> virtualProjects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UrbanizacionModel() when $default != null:
return $default(_that.slug,_that.nombre,_that.descripcionPublica,_that.ubicacionTexto,_that.logoUrl,_that.primaryColor,_that.whatsappNumber,_that.frontendUrl,_that.pais,_that.subdivision,_that.ciudad,_that.appEnabled,_that.masterplanAppEnabled,_that.virtualProjects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String nombre, @JsonKey(name: 'descripcion_publica')  String? descripcionPublica, @JsonKey(name: 'ubicacion_texto')  String? ubicacionTexto, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'primary_color')  String primaryColor, @JsonKey(name: 'whatsapp_number')  String? whatsappNumber, @JsonKey(name: 'frontend_url')  String? frontendUrl,  String pais,  String? subdivision,  String? ciudad, @JsonKey(name: 'app_enabled')  bool appEnabled, @JsonKey(name: 'masterplan_app_enabled')  bool masterplanAppEnabled, @JsonKey(name: 'virtual_projects')  List<VirtualProjectModel> virtualProjects)  $default,) {final _that = this;
switch (_that) {
case _UrbanizacionModel():
return $default(_that.slug,_that.nombre,_that.descripcionPublica,_that.ubicacionTexto,_that.logoUrl,_that.primaryColor,_that.whatsappNumber,_that.frontendUrl,_that.pais,_that.subdivision,_that.ciudad,_that.appEnabled,_that.masterplanAppEnabled,_that.virtualProjects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String nombre, @JsonKey(name: 'descripcion_publica')  String? descripcionPublica, @JsonKey(name: 'ubicacion_texto')  String? ubicacionTexto, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'primary_color')  String primaryColor, @JsonKey(name: 'whatsapp_number')  String? whatsappNumber, @JsonKey(name: 'frontend_url')  String? frontendUrl,  String pais,  String? subdivision,  String? ciudad, @JsonKey(name: 'app_enabled')  bool appEnabled, @JsonKey(name: 'masterplan_app_enabled')  bool masterplanAppEnabled, @JsonKey(name: 'virtual_projects')  List<VirtualProjectModel> virtualProjects)?  $default,) {final _that = this;
switch (_that) {
case _UrbanizacionModel() when $default != null:
return $default(_that.slug,_that.nombre,_that.descripcionPublica,_that.ubicacionTexto,_that.logoUrl,_that.primaryColor,_that.whatsappNumber,_that.frontendUrl,_that.pais,_that.subdivision,_that.ciudad,_that.appEnabled,_that.masterplanAppEnabled,_that.virtualProjects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UrbanizacionModel extends UrbanizacionModel {
  const _UrbanizacionModel({required this.slug, required this.nombre, @JsonKey(name: 'descripcion_publica') this.descripcionPublica, @JsonKey(name: 'ubicacion_texto') this.ubicacionTexto, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'primary_color') this.primaryColor = '#D4AF37', @JsonKey(name: 'whatsapp_number') this.whatsappNumber, @JsonKey(name: 'frontend_url') this.frontendUrl, this.pais = 'Ecuador', this.subdivision, this.ciudad, @JsonKey(name: 'app_enabled') this.appEnabled = true, @JsonKey(name: 'masterplan_app_enabled') this.masterplanAppEnabled = false, @JsonKey(name: 'virtual_projects') final  List<VirtualProjectModel> virtualProjects = const []}): _virtualProjects = virtualProjects,super._();
  factory _UrbanizacionModel.fromJson(Map<String, dynamic> json) => _$UrbanizacionModelFromJson(json);

@override final  String slug;
@override final  String nombre;
@override@JsonKey(name: 'descripcion_publica') final  String? descripcionPublica;
@override@JsonKey(name: 'ubicacion_texto') final  String? ubicacionTexto;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey(name: 'primary_color') final  String primaryColor;
@override@JsonKey(name: 'whatsapp_number') final  String? whatsappNumber;
@override@JsonKey(name: 'frontend_url') final  String? frontendUrl;
@override@JsonKey() final  String pais;
@override final  String? subdivision;
@override final  String? ciudad;
@override@JsonKey(name: 'app_enabled') final  bool appEnabled;
@override@JsonKey(name: 'masterplan_app_enabled') final  bool masterplanAppEnabled;
 final  List<VirtualProjectModel> _virtualProjects;
@override@JsonKey(name: 'virtual_projects') List<VirtualProjectModel> get virtualProjects {
  if (_virtualProjects is EqualUnmodifiableListView) return _virtualProjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_virtualProjects);
}


/// Create a copy of UrbanizacionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UrbanizacionModelCopyWith<_UrbanizacionModel> get copyWith => __$UrbanizacionModelCopyWithImpl<_UrbanizacionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrbanizacionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UrbanizacionModel&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcionPublica, descripcionPublica) || other.descripcionPublica == descripcionPublica)&&(identical(other.ubicacionTexto, ubicacionTexto) || other.ubicacionTexto == ubicacionTexto)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.frontendUrl, frontendUrl) || other.frontendUrl == frontendUrl)&&(identical(other.pais, pais) || other.pais == pais)&&(identical(other.subdivision, subdivision) || other.subdivision == subdivision)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.appEnabled, appEnabled) || other.appEnabled == appEnabled)&&(identical(other.masterplanAppEnabled, masterplanAppEnabled) || other.masterplanAppEnabled == masterplanAppEnabled)&&const DeepCollectionEquality().equals(other._virtualProjects, _virtualProjects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nombre,descripcionPublica,ubicacionTexto,logoUrl,primaryColor,whatsappNumber,frontendUrl,pais,subdivision,ciudad,appEnabled,masterplanAppEnabled,const DeepCollectionEquality().hash(_virtualProjects));

@override
String toString() {
  return 'UrbanizacionModel(slug: $slug, nombre: $nombre, descripcionPublica: $descripcionPublica, ubicacionTexto: $ubicacionTexto, logoUrl: $logoUrl, primaryColor: $primaryColor, whatsappNumber: $whatsappNumber, frontendUrl: $frontendUrl, pais: $pais, subdivision: $subdivision, ciudad: $ciudad, appEnabled: $appEnabled, masterplanAppEnabled: $masterplanAppEnabled, virtualProjects: $virtualProjects)';
}


}

/// @nodoc
abstract mixin class _$UrbanizacionModelCopyWith<$Res> implements $UrbanizacionModelCopyWith<$Res> {
  factory _$UrbanizacionModelCopyWith(_UrbanizacionModel value, $Res Function(_UrbanizacionModel) _then) = __$UrbanizacionModelCopyWithImpl;
@override @useResult
$Res call({
 String slug, String nombre,@JsonKey(name: 'descripcion_publica') String? descripcionPublica,@JsonKey(name: 'ubicacion_texto') String? ubicacionTexto,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'primary_color') String primaryColor,@JsonKey(name: 'whatsapp_number') String? whatsappNumber,@JsonKey(name: 'frontend_url') String? frontendUrl, String pais, String? subdivision, String? ciudad,@JsonKey(name: 'app_enabled') bool appEnabled,@JsonKey(name: 'masterplan_app_enabled') bool masterplanAppEnabled,@JsonKey(name: 'virtual_projects') List<VirtualProjectModel> virtualProjects
});




}
/// @nodoc
class __$UrbanizacionModelCopyWithImpl<$Res>
    implements _$UrbanizacionModelCopyWith<$Res> {
  __$UrbanizacionModelCopyWithImpl(this._self, this._then);

  final _UrbanizacionModel _self;
  final $Res Function(_UrbanizacionModel) _then;

/// Create a copy of UrbanizacionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? nombre = null,Object? descripcionPublica = freezed,Object? ubicacionTexto = freezed,Object? logoUrl = freezed,Object? primaryColor = null,Object? whatsappNumber = freezed,Object? frontendUrl = freezed,Object? pais = null,Object? subdivision = freezed,Object? ciudad = freezed,Object? appEnabled = null,Object? masterplanAppEnabled = null,Object? virtualProjects = null,}) {
  return _then(_UrbanizacionModel(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcionPublica: freezed == descripcionPublica ? _self.descripcionPublica : descripcionPublica // ignore: cast_nullable_to_non_nullable
as String?,ubicacionTexto: freezed == ubicacionTexto ? _self.ubicacionTexto : ubicacionTexto // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,frontendUrl: freezed == frontendUrl ? _self.frontendUrl : frontendUrl // ignore: cast_nullable_to_non_nullable
as String?,pais: null == pais ? _self.pais : pais // ignore: cast_nullable_to_non_nullable
as String,subdivision: freezed == subdivision ? _self.subdivision : subdivision // ignore: cast_nullable_to_non_nullable
as String?,ciudad: freezed == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String?,appEnabled: null == appEnabled ? _self.appEnabled : appEnabled // ignore: cast_nullable_to_non_nullable
as bool,masterplanAppEnabled: null == masterplanAppEnabled ? _self.masterplanAppEnabled : masterplanAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,virtualProjects: null == virtualProjects ? _self._virtualProjects : virtualProjects // ignore: cast_nullable_to_non_nullable
as List<VirtualProjectModel>,
  ));
}


}

// dart format on
