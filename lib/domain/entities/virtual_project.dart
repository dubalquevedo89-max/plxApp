class VirtualProject {
  final String id;
  final String slug;
  final String nombre;
  final String? locationText;
  final String primaryColor;
  final String? templateId;
  final bool appEnabled;
  final bool masterplanAppEnabled;

  const VirtualProject({
    required this.id,
    required this.slug,
    required this.nombre,
    this.locationText,
    required this.primaryColor,
    this.templateId,
    required this.appEnabled,
    required this.masterplanAppEnabled,
  });
}
