class TenantOption {
  final String slug;
  final String nombre;
  final String? ubicacionTexto;
  final String? logoUrl;
  final String primaryColor;
  final String host;
  final String? virtualProjectSlug;
  final String? parentNombre;
  final String? parentSlug;
  final bool masterplanAppEnabled;

  const TenantOption({
    required this.slug,
    required this.nombre,
    this.ubicacionTexto,
    this.logoUrl,
    required this.primaryColor,
    required this.host,
    this.virtualProjectSlug,
    this.parentNombre,
    this.parentSlug,
    this.masterplanAppEnabled = false,
  });

  bool get isVirtualProject => virtualProjectSlug != null;
}
