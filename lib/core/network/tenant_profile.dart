import 'package:plx_app/domain/entities/tenant_option.dart';

class TenantProfile {
  final String slug;
  final String nombre;
  final String host;           // root tenant host, e.g. tonsupa.plxmap.com
  final String primaryColor;
  final String? logoUrl;
  final String? usuarioNombre;
  final String? usuarioEmail;
  final String? usuarioRol;
  final String? apiKeyGarita;
  final String? virtualProjectSlug; // set for virtual projects
  final String? parentSlug;         // tenant slug, used for geo decryption in VPs
  final String? residentCode;       // cached for offline QR generation

  const TenantProfile({
    required this.slug,
    required this.nombre,
    required this.host,
    required this.primaryColor,
    this.logoUrl,
    this.usuarioNombre,
    this.usuarioEmail,
    this.usuarioRol,
    this.apiKeyGarita,
    this.virtualProjectSlug,
    this.parentSlug,
    this.residentCode,
  });

  bool get isGuardia => usuarioRol == 'guardia';

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
        'usuarioRol': usuarioRol,
        'apiKeyGarita': apiKeyGarita,
        'virtualProjectSlug': virtualProjectSlug,
        'parentSlug': parentSlug,
        'residentCode': residentCode,
      };

  TenantOption toTenantOption() => TenantOption(
        slug: slug,
        nombre: nombre,
        host: host,
        primaryColor: primaryColor,
        logoUrl: logoUrl,
        virtualProjectSlug: virtualProjectSlug,
        parentSlug: parentSlug,
      );

  factory TenantProfile.fromMap(Map<String, dynamic> m) => TenantProfile(
        slug: m['slug'] as String,
        nombre: m['nombre'] as String,
        host: m['host'] as String,
        primaryColor: m['primaryColor'] as String,
        logoUrl: m['logoUrl'] as String?,
        usuarioNombre: m['usuarioNombre'] as String?,
        usuarioEmail: m['usuarioEmail'] as String?,
        usuarioRol: m['usuarioRol'] as String?,
        apiKeyGarita: m['apiKeyGarita'] as String?,
        virtualProjectSlug: m['virtualProjectSlug'] as String?,
        parentSlug: m['parentSlug'] as String?,
        residentCode: m['residentCode'] as String?,
      );
}
