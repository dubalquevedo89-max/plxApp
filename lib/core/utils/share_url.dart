import 'package:share_plus/share_plus.dart';
import '../../core/network/tenant_profile.dart';

/// Porta la lógica de shareUrl.ts del frontend web.
///
/// Prioridad:
///  1. frontend_url explícita en el perfil (white-label)
///  2. VP / sandbox: origin + /slug
///  3. Producción con dominio propio: origin es el proyecto
String buildPublicProjectUrl(TenantProfile profile) {
  // 1. White-label con frontend_url almacenada
  // TenantProfile no almacena frontend_url directamente; se usa el host.
  // Si el host ya es el dominio propio (ej. tonsupa.com), se usa directo.

  final host = profile.host; // ej. tonsupa.plxmap.com

  // 2. Virtual project → base/slug
  if (profile.virtualProjectSlug != null) {
    return 'https://$host/${profile.virtualProjectSlug}';
  }

  // 3. Root tenant → dominio propio
  return 'https://$host';
}

String buildPublicLoteUrl(TenantProfile profile, String codigo) {
  final base = buildPublicProjectUrl(profile);
  return '$base/lote/${Uri.encodeComponent(codigo)}';
}

/// Comparte la URL pública del proyecto via share sheet nativo.
Future<void> shareProject(TenantProfile profile) async {
  final url = buildPublicProjectUrl(profile);
  try {
    await SharePlus.instance.share(ShareParams(
      text: '🏘️ ${profile.nombre}\n$url',
      subject: profile.nombre,
    ));
  } catch (_) {
    // Ignore: share_plus bug on Android throws when user dismisses the share sheet.
  }
}

/// Comparte la URL pública de un lote específico.
Future<void> shareLote(TenantProfile profile, String codigo) async {
  final url = buildPublicLoteUrl(profile, codigo);
  try {
    await SharePlus.instance.share(ShareParams(
      text: '🏡 Lote $codigo — ${profile.nombre}\n$url',
      subject: 'Lote $codigo',
    ));
  } catch (_) {
    // Ignore: share_plus bug on Android throws when user dismisses the share sheet.
  }
}
