import 'package:dio/dio.dart';
import '../datasources/remote/auth_datasource.dart';
import '../../core/network/tenant_profile.dart';
import '../../core/storage/session_storage.dart';
import '../../domain/entities/usuario.dart';

class AuthRepository {
  AuthRepository(Dio dio) : _ds = AuthDatasource(dio);
  final AuthDatasource _ds;

  Future<Usuario> login({
    required String email,
    required String password,
    required String host,
    required String primaryColor,
    String? logoUrl,
    String? virtualProjectSlug,
    String? displayNombre, // shown in UI; overrides project_nombre from API
  }) async {
    final data = await _ds.login(
      email,
      password,
      host,
      virtualProjectSlug: virtualProjectSlug,
    );
    final token = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String?;
    final slug = data['project_slug'] as String;
    final apiNombre = data['project_nombre'] as String;
    final me = await _ds.me(host, token: token, virtualProjectSlug: virtualProjectSlug);
    final user = me.toEntity();
    await SessionStorage.saveProfile(
      TenantProfile(
        slug: virtualProjectSlug ?? slug,
        nombre: displayNombre ?? apiNombre,
        host: host,
        primaryColor: primaryColor,
        logoUrl: logoUrl,
        usuarioNombre: user.nombre,
        usuarioEmail: user.email,
        virtualProjectSlug: virtualProjectSlug,
      ),
      token,
      refreshToken: refreshToken,
    );
    return user;
  }

  Future<Usuario> me(String host,
          {String? token, String? virtualProjectSlug}) async =>
      (await _ds.me(host,
              token: token, virtualProjectSlug: virtualProjectSlug))
          .toEntity();

  Future<Usuario> updateMe({
    required String nombre,
    required String telefono,
    required String cedula,
  }) async =>
      (await _ds.updateMe(
              nombre: nombre, telefono: telefono, cedula: cedula))
          .toEntity();

  Future<void> changePassword({
    required String passwordActual,
    required String passwordNuevo,
  }) =>
      _ds.changePassword(
          passwordActual: passwordActual, passwordNuevo: passwordNuevo);

  Future<void> solicitarRecuperacion(String email) =>
      _ds.solicitarRecuperacion(email);

  Future<String?> getToken(String host) => SessionStorage.getJwt(host);

  Future<void> logout(String host) => SessionStorage.clearProfile(host);
}
