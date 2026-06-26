// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'virtual_project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VirtualProjectModel {

 String get id; String get slug; String get nombre;@JsonKey(name: 'location_text') String? get locationText;@JsonKey(name: 'primary_color') String get primaryColor;@JsonKey(name: 'template_id') String? get templateId;@JsonKey(name: 'app_enabled') bool get appEnabled;@JsonKey(name: 'masterplan_app_enabled') bool get masterplanAppEnabled;
/// Create a copy of VirtualProjectModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VirtualProjectModelCopyWith<VirtualProjectModel> get copyWith => _$VirtualProjectModelCopyWithImpl<VirtualProjectModel>(this as VirtualProjectModel, _$identity);

  /// Serializes this VirtualProjectModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VirtualProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.appEnabled, appEnabled) || other.appEnabled == appEnabled)&&(identical(other.masterplanAppEnabled, masterplanAppEnabled) || other.masterplanAppEnabled == masterplanAppEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nombre,locationText,primaryColor,templateId,appEnabled,masterplanAppEnabled);

@override
String toString() {
  return 'VirtualProjectModel(id: $id, slug: $slug, nombre: $nombre, locationText: $locationText, primaryColor: $primaryColor, templateId: $templateId, appEnabled: $appEnabled, masterplanAppEnabled: $masterplanAppEnabled)';
}


}

/// @nodoc
abstract mixin class $VirtualProjectModelCopyWith<$Res>  {
  factory $VirtualProjectModelCopyWith(VirtualProjectModel value, $Res Function(VirtualProjectModel) _then) = _$VirtualProjectModelCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String nombre,@JsonKey(name: 'location_text') String? locationText,@JsonKey(name: 'primary_color') String primaryColor,@JsonKey(name: 'template_id') String? templateId,@JsonKey(name: 'app_enabled') bool appEnabled,@JsonKey(name: 'masterplan_app_enabled') bool masterplanAppEnabled
});




}
/// @nodoc
class _$VirtualProjectModelCopyWithImpl<$Res>
    implements $VirtualProjectModelCopyWith<$Res> {
  _$VirtualProjectModelCopyWithImpl(this._self, this._then);

  final VirtualProjectModel _self;
  final $Res Function(VirtualProjectModel) _then;

/// Create a copy of VirtualProjectModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? nombre = null,Object? locationText = freezed,Object? primaryColor = null,Object? templateId = freezed,Object? appEnabled = null,Object? masterplanAppEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,appEnabled: null == appEnabled ? _self.appEnabled : appEnabled // ignore: cast_nullable_to_non_nullable
as bool,masterplanAppEnabled: null == masterplanAppEnabled ? _self.masterplanAppEnabled : masterplanAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VirtualProjectModel].
extension VirtualProjectModelPatterns on VirtualProjectModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VirtualProjectModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VirtualProjectModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VirtualProjectModel value)  $default,){
final _that = this;
switch (_that) {
case _VirtualProjectModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VirtualProjectModel value)?  $default,){
final _that = this;
switch (_that) {
case _VirtualProjectModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String nombre, @JsonKey(name: 'location_text')  String? locationText, @JsonKey(name: 'primary_color')  String primaryColor, @JsonKey(name: 'template_id')  String? templateId, @JsonKey(name: 'app_enabled')  bool appEnabled, @JsonKey(name: 'masterplan_app_enabled')  bool masterplanAppEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VirtualProjectModel() when $default != null:
return $default(_that.id,_that.slug,_that.nombre,_that.locationText,_that.primaryColor,_that.templateId,_that.appEnabled,_that.masterplanAppEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String nombre, @JsonKey(name: 'location_text')  String? locationText, @JsonKey(name: 'primary_color')  String primaryColor, @JsonKey(name: 'template_id')  String? templateId, @JsonKey(name: 'app_enabled')  bool appEnabled, @JsonKey(name: 'masterplan_app_enabled')  bool masterplanAppEnabled)  $default,) {final _that = this;
switch (_that) {
case _VirtualProjectModel():
return $default(_that.id,_that.slug,_that.nombre,_that.locationText,_that.primaryColor,_that.templateId,_that.appEnabled,_that.masterplanAppEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String nombre, @JsonKey(name: 'location_text')  String? locationText, @JsonKey(name: 'primary_color')  String primaryColor, @JsonKey(name: 'template_id')  String? templateId, @JsonKey(name: 'app_enabled')  bool appEnabled, @JsonKey(name: 'masterplan_app_enabled')  bool masterplanAppEnabled)?  $default,) {final _that = this;
switch (_that) {
case _VirtualProjectModel() when $default != null:
return $default(_that.id,_that.slug,_that.nombre,_that.locationText,_that.primaryColor,_that.templateId,_that.appEnabled,_that.masterplanAppEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VirtualProjectModel extends VirtualProjectModel {
  const _VirtualProjectModel({required this.id, required this.slug, required this.nombre, @JsonKey(name: 'location_text') this.locationText, @JsonKey(name: 'primary_color') this.primaryColor = '#D4AF37', @JsonKey(name: 'template_id') this.templateId, @JsonKey(name: 'app_enabled') this.appEnabled = true, @JsonKey(name: 'masterplan_app_enabled') this.masterplanAppEnabled = false}): super._();
  factory _VirtualProjectModel.fromJson(Map<String, dynamic> json) => _$VirtualProjectModelFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String nombre;
@override@JsonKey(name: 'location_text') final  String? locationText;
@override@JsonKey(name: 'primary_color') final  String primaryColor;
@override@JsonKey(name: 'template_id') final  String? templateId;
@override@JsonKey(name: 'app_enabled') final  bool appEnabled;
@override@JsonKey(name: 'masterplan_app_enabled') final  bool masterplanAppEnabled;

/// Create a copy of VirtualProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VirtualProjectModelCopyWith<_VirtualProjectModel> get copyWith => __$VirtualProjectModelCopyWithImpl<_VirtualProjectModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VirtualProjectModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VirtualProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.appEnabled, appEnabled) || other.appEnabled == appEnabled)&&(identical(other.masterplanAppEnabled, masterplanAppEnabled) || other.masterplanAppEnabled == masterplanAppEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nombre,locationText,primaryColor,templateId,appEnabled,masterplanAppEnabled);

@override
String toString() {
  return 'VirtualProjectModel(id: $id, slug: $slug, nombre: $nombre, locationText: $locationText, primaryColor: $primaryColor, templateId: $templateId, appEnabled: $appEnabled, masterplanAppEnabled: $masterplanAppEnabled)';
}


}

/// @nodoc
abstract mixin class _$VirtualProjectModelCopyWith<$Res> implements $VirtualProjectModelCopyWith<$Res> {
  factory _$VirtualProjectModelCopyWith(_VirtualProjectModel value, $Res Function(_VirtualProjectModel) _then) = __$VirtualProjectModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String nombre,@JsonKey(name: 'location_text') String? locationText,@JsonKey(name: 'primary_color') String primaryColor,@JsonKey(name: 'template_id') String? templateId,@JsonKey(name: 'app_enabled') bool appEnabled,@JsonKey(name: 'masterplan_app_enabled') bool masterplanAppEnabled
});




}
/// @nodoc
class __$VirtualProjectModelCopyWithImpl<$Res>
    implements _$VirtualProjectModelCopyWith<$Res> {
  __$VirtualProjectModelCopyWithImpl(this._self, this._then);

  final _VirtualProjectModel _self;
  final $Res Function(_VirtualProjectModel) _then;

/// Create a copy of VirtualProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? nombre = null,Object? locationText = freezed,Object? primaryColor = null,Object? templateId = freezed,Object? appEnabled = null,Object? masterplanAppEnabled = null,}) {
  return _then(_VirtualProjectModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,appEnabled: null == appEnabled ? _self.appEnabled : appEnabled // ignore: cast_nullable_to_non_nullable
as bool,masterplanAppEnabled: null == masterplanAppEnabled ? _self.masterplanAppEnabled : masterplanAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
