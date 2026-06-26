import 'virtual_project.dart';

class Urbanizacion {
  final String slug;
  final String nombre;
  final String? descripcionPublica;
  final String? ubicacionTexto;
  final String? logoUrl;
  final String primaryColor;
  final String? whatsappNumber;
  final String? frontendUrl;
  final String pais;
  final String? subdivision;
  final String? ciudad;
  final bool appEnabled;
  final bool masterplanAppEnabled;
  final List<VirtualProject> virtualProjects;

  const Urbanizacion({
    required this.slug,
    required this.nombre,
    this.descripcionPublica,
    this.ubicacionTexto,
    this.logoUrl,
    required this.primaryColor,
    this.whatsappNumber,
    this.frontendUrl,
    required this.pais,
    this.subdivision,
    this.ciudad,
    this.appEnabled = true,
    this.masterplanAppEnabled = false,
    this.virtualProjects = const [],
  });

  String get host {
    if (frontendUrl != null && frontendUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(frontendUrl!);
        if (uri.host.isNotEmpty) return uri.host;
      } catch (_) {}
    }
    return '$slug.plxmap.com';
  }
}
