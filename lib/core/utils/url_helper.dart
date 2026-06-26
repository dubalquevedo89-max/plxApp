import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reemplaza `localhost` en URLs de assets (MinIO, etc.) con el mismo host
/// configurado en API_BASE_URL, para que funcione tanto en iOS como Android.
String fixLocalUrl(String? url) {
  if (url == null || url.isEmpty) return '';
  final apiBase = dotenv.env['API_BASE_URL'] ?? '';
  if (apiBase.isEmpty) return url;
  try {
    final apiUri = Uri.parse(apiBase);
    final assetUri = Uri.parse(url);
    if (assetUri.host == 'localhost' || assetUri.host == '127.0.0.1') {
      return assetUri.replace(host: apiUri.host).toString();
    }
  } catch (_) {}
  return url;
}
