import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/url_helper.dart';
import '../../domain/entities/lot_detail.dart';

part 'lot_detail_model.freezed.dart';
part 'lot_detail_model.g.dart';

@freezed
abstract class LotDetailModel with _$LotDetailModel {
  const factory LotDetailModel({
    required String id,
    required String codigo,
    String? zona,
    @JsonKey(name: 'zona_color') String? zonaColor,
    String? etapa,
    @JsonKey(name: 'area_m2') double? areaM2,
    double? precio,
    required String estado,
    String? descripcion,
    @Default([]) List<String> fotos,
    @Default([]) List<String> videos,
    @JsonKey(name: 'has_tour_virtual') @Default(false) bool hasTourVirtual,
    @JsonKey(name: 'tour_virtual_url') String? tourVirtualUrl,
    @JsonKey(name: 'video_sobrevuelo_url') String? videoSobrevueloUrl,
    @JsonKey(name: 'valor_arriendo') double? valorArriendo,
    @JsonKey(name: 'tiene_ph') @Default(false) bool tienePh,
    @JsonKey(name: 'ph_count') @Default(0) int phCount,
    @JsonKey(name: 'destacado') @Default(false) bool destacado,
  }) = _LotDetailModel;

  const LotDetailModel._();

  factory LotDetailModel.fromJson(Map<String, dynamic> json) =>
      _$LotDetailModelFromJson(json);

  LotDetail toEntity() => LotDetail(
        id: id,
        codigo: codigo,
        zona: zona,
        zonaColor: zonaColor,
        etapa: etapa,
        areaM2: areaM2,
        precio: precio,
        estado: estado,
        descripcion: descripcion,
        fotos: fotos.map(fixLocalUrl).where((u) => u.isNotEmpty).toList(),
        videos: videos,
        hasTourVirtual: hasTourVirtual,
        tourVirtualUrl: tourVirtualUrl,
        videoSobrevueloUrl: videoSobrevueloUrl,
        valorArriendo: valorArriendo,
        tienePh: tienePh,
        phCount: phCount,
        destacado: destacado,
      );
}
