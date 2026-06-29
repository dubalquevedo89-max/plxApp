import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, dynamic> decryptGeoJson(Map<String, dynamic> response, String slug) {
  final encrypted = response['encrypted'] as bool? ?? false;
  if (!encrypted) return response;

  final salt = kDebugMode
      ? (dotenv.env['GEO_DECRYPT_KEY_DEV'] ?? dotenv.env['GEO_DECRYPT_KEY'] ?? '')
      : (dotenv.env['GEO_DECRYPT_KEY'] ?? '');
  final keyStr = '$slug-$salt';
  final keyBytes = utf8.encode(keyStr);
  // normalize handles missing padding and whitespace
  final dataBytes = base64.decode(base64.normalize(response['data'] as String));

  final decrypted = Uint8List(dataBytes.length);
  for (var i = 0; i < dataBytes.length; i++) {
    decrypted[i] = dataBytes[i] ^ keyBytes[i % keyBytes.length];
  }

  final jsonStr = utf8.decode(decrypted);
  return jsonDecode(jsonStr) as Map<String, dynamic>;
}
