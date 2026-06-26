class TenantProfile {
  final String slug;
  final String nombre;
  final String host;           // root tenant host, e.g. tonsupa.plxmap.com
  final String primaryColor;
  final String? logoUrl;
  final String? usuarioNombre;
  final String? usuarioEmail;
  final String? virtualProjectSlug; // set for virtual projects

  const TenantProfile({
    required this.slug,
    required this.nombre,
    required this.host,
    required this.primaryColor,
    this.logoUrl,
    this.usuarioNombre,
    this.usuarioEmail,
    this.virtualProjectSlug,
  });

  // Unique storage key: for VPs use "vp_slug@host", otherwise just "host"
  String get storageKey => virtualProjectSlug != null
      ? '$virtualProjectSlug@$host'
      : host;

  Map<String, dynamic> toMap() => {
        'slug': slug,
        'nombre': nombre,
        'host': host,
        'primaryColor': primaryColor,
        'logoUrl': logoUrl,
        'usuarioNombre': usuarioNombre,
        'usuarioEmail': usuarioEmail,
        'virtualProjectSlug': virtualProjectSlug,
      };

  factory TenantProfile.fromMap(Map<String, dynamic> m) => TenantProfile(
        slug: m['slug'] as String,
        nombre: m['nombre'] as String,
        host: m['host'] as String,
        primaryColor: m['primaryColor'] as String,
        logoUrl: m['logoUrl'] as String?,
        usuarioNombre: m['usuarioNombre'] as String?,
        usuarioEmail: m['usuarioEmail'] as String?,
        virtualProjectSlug: m['virtualProjectSlug'] as String?,
      );
}
