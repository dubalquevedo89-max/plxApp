import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/url_helper.dart';
import '../../domain/entities/urbanizacion.dart';
import 'virtual_project_model.dart';

part 'urbanizacion_model.freezed.dart';
part 'urbanizacion_model.g.dart';

@freezed
abstract class UrbanizacionModel with _$UrbanizacionModel {
  const UrbanizacionModel._();

  const factory UrbanizacionModel({
    required String slug,
    required String nombre,
    @JsonKey(name: 'descripcion_publica') String? descripcionPublica,
    @JsonKey(name: 'ubicacion_texto') String? ubicacionTexto,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'primary_color') @Default('#D4AF37') String primaryColor,
    @JsonKey(name: 'whatsapp_number') String? whatsappNumber,
    @JsonKey(name: 'frontend_url') String? frontendUrl,
    @Default('Ecuador') String pais,
    String? subdivision,
    String? ciudad,
    @JsonKey(name: 'app_enabled') @Default(true) bool appEnabled,
    @JsonKey(name: 'masterplan_app_enabled') @Default(false) bool masterplanAppEnabled,
    @JsonKey(name: 'virtual_projects') @Default([]) List<VirtualProjectModel> virtualProjects,
  }) = _UrbanizacionModel;

  factory UrbanizacionModel.fromJson(Map<String, dynamic> json) =>
      _$UrbanizacionModelFromJson(json);

  Urbanizacion toEntity() => Urbanizacion(
        slug: slug,
        nombre: nombre,
        descripcionPublica: descripcionPublica,
        ubicacionTexto: ubicacionTexto,
        logoUrl: fixLocalUrl(logoUrl),
        primaryColor: primaryColor,
        whatsappNumber: whatsappNumber,
        frontendUrl: frontendUrl,
        pais: pais,
        subdivision: subdivision,
        ciudad: ciudad,
        appEnabled: appEnabled,
        masterplanAppEnabled: masterplanAppEnabled,
        virtualProjects: virtualProjects.map((v) => v.toEntity()).toList(),
      );
}
