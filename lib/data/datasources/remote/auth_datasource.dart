import 'dart:io';
import 'package:dio/dio.dart';
import '../../models/usuario_model.dart';

class AuthDatasource {
  final Dio _dio;
  const AuthDatasource(this._dio);

  Future<Map<String, dynamic>> login(
    String email,
    String password,
    String host, {
    String? virtualProjectSlug,
  }) async {
    final res = await _dio.post(
      '/api/auth/login',
      data: FormData.fromMap({'username': email, 'password': password}),
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          'Host': host,
          'x-virtual-project-slug': virtualProjectSlug,
          'X-Client-Type': 'mobile',
        },
      ),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<UsuarioModel> me(String host, {String? token, String? virtualProjectSlug}) async {
    final res = await _dio.get(
      '/api/auth/me',
      options: Options(headers: {
        'Host': host,
        'Authorization': token != null ? 'Bearer $token' : null,
        'x-virtual-project-slug': virtualProjectSlug,
      }),
    );
    return UsuarioModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> registro({
    required String email,
    required String nombre,
    required String telefono,
    required String cedula,
    required String password,
    required String host,
    String? virtualProjectSlug,
  }) async {
    await _dio.post(
      '/api/auth/registro',
      data: {
        'email': email,
        'nombre': nombre,
        'telefono': telefono,
        'cedula': cedula,
        'rol': 'comprador',
        'password': password,
      },
      options: Options(headers: {
        'Host': host,
        'x-virtual-project-slug': virtualProjectSlug,
      }),
    );
  }

  Future<Map<String, dynamic>> refreshTokens(String refreshToken) async {
    final res = await _dio.post(
      '/api/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(headers: {'Authorization': null}), // no bearer needed
    );
    return res.data as Map<String, dynamic>;
  }

  Future<UsuarioModel> updateMe({
    required String nombre,
    required String telefono,
    required String cedula,
  }) async {
    final res = await _dio.put(
      '/api/auth/me',
      data: {'nombre': nombre, 'telefono': telefono, 'cedula': cedula},
    );
    return UsuarioModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> changePassword({
    required String passwordActual,
    required String passwordNuevo,
  }) async {
    await _dio.put(
      '/api/auth/me/password',
      data: {
        'password_actual': passwordActual,
        'password_nuevo': passwordNuevo,
      },
    );
  }

  Future<void> solicitarRecuperacion(String email, String host, {String? virtualProjectSlug}) async {
    await _dio.post(
      '/api/auth/recuperar-password/solicitar',
      data: {'email': email},
      options: Options(headers: {
        'Host': host,
        'x-virtual-project-slug': virtualProjectSlug,
      }),
    );
  }

  Future<void> registerDeviceToken(String token) async {
    await _dio.post(
      '/api/auth/device-token',
      data: {
        'device_token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'confirmed': true,
      },
    );
  }
}
