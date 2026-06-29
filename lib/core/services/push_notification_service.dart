import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  static final _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    // Solicitar permiso (iOS muestra diálogo, Android 13+ también)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Notificaciones en foreground visibles en Android
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Escuchar notificaciones cuando la app está abierta
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[FCM] Foreground: ${message.notification?.title}');
    });
  }

  // Solicita permiso y retorna true si fue concedido
  static Future<bool> requestAndCheckPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // Retorna el token del dispositivo para enviarlo al backend
  static Future<String?> getToken() async {
    final token = await _fcm.getToken();
    debugPrint('[FCM] Token: $token');
    return token;
  }

  // Llama esto después de login exitoso
  static void onTokenRefresh(void Function(String token) callback) {
    _fcm.onTokenRefresh.listen(callback);
  }
}
