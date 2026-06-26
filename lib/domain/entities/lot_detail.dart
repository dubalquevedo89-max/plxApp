class LotDetail {
  final String id;
  final String codigo;
  final String? zona;
  final String? zonaColor;
  final String? etapa;
  final double? areaM2;
  final double? precio;
  final String estado;
  final String? descripcion;
  final List<String> fotos;
  final List<String> videos;
  final bool hasTourVirtual;
  final String? tourVirtualUrl;
  final String? videoSobrevueloUrl;
  final double? valorArriendo;
  final bool tienePh;
  final int phCount;
  final bool destacado;

  const LotDetail({
    required this.id,
    required this.codigo,
    this.zona,
    this.zonaColor,
    this.etapa,
    this.areaM2,
    this.precio,
    required this.estado,
    this.descripcion,
    this.fotos = const [],
    this.videos = const [],
    this.hasTourVirtual = false,
    this.tourVirtualUrl,
    this.videoSobrevueloUrl,
    this.valorArriendo,
    this.tienePh = false,
    this.phCount = 0,
    this.destacado = false,
  });
}
