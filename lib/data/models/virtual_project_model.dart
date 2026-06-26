import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/virtual_project.dart';

part 'virtual_project_model.freezed.dart';
part 'virtual_project_model.g.dart';

@freezed
abstract class VirtualProjectModel with _$VirtualProjectModel {
  const VirtualProjectModel._();

  const factory VirtualProjectModel({
    required String id,
    required String slug,
    required String nombre,
    @JsonKey(name: 'location_text') String? locationText,
    @JsonKey(name: 'primary_color') @Default('#D4AF37') String primaryColor,
    @JsonKey(name: 'template_id') String? templateId,
    @JsonKey(name: 'app_enabled') @Default(true) bool appEnabled,
    @JsonKey(name: 'masterplan_app_enabled') @Default(false) bool masterplanAppEnabled,
  }) = _VirtualProjectModel;

  factory VirtualProjectModel.fromJson(Map<String, dynamic> json) =>
      _$VirtualProjectModelFromJson(json);

  VirtualProject toEntity() => VirtualProject(
        id: id,
        slug: slug,
        nombre: nombre,
        locationText: locationText,
        primaryColor: primaryColor,
        templateId: templateId,
        appEnabled: appEnabled,
        masterplanAppEnabled: masterplanAppEnabled,
      );
}
