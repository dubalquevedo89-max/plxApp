import 'package:dio/dio.dart';
import '../datasources/remote/auth_datasource.dart';
import '../datasources/remote/garita_datasource.dart';
import '../../core/network/tenant_profile.dart';
import '../../core/services/push_notification_service.dart';
import '../../core/storage/session_storage.dart';
import '../../domain/entities/usuario.dart';

class AuthRepository {
  AuthRepository(Dio dio)
      : _ds = AuthDatasource(dio),
        _garitaDs = GaritaDatasource(dio);
  final AuthDatasource _ds;
  final GaritaDatasource _garitaDs;

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
    final apiVpNombre = data['virtual_project_nombre'] as String?;
    final apiKeyGarita = data['gatehouse_api_key'] as String?;
    // El backend indica a qué VP pertenece el usuario aunque haya iniciado
    // sesión desde el tenant base — usamos ese slug como el efectivo.
    final effectiveVpSlug =
        virtualProjectSlug ?? data['virtual_project_slug'] as String?;
    final effectiveNombre = displayNombre ?? apiVpNombre ?? apiNombre;
    final me = await _ds.me(host, token: token, virtualProjectSlug: effectiveVpSlug);
    final user = me.toEntity();
    await SessionStorage.saveProfile(
      TenantProfile(
        slug: effectiveVpSlug ?? slug,
        nombre: effectiveNombre,
        host: host,
        primaryColor: primaryColor,
        logoUrl: logoUrl,
        usuarioNombre: user.nombre,
        usuarioEmail: user.email,
        usuarioRol: user.rol,
        apiKeyGarita: apiKeyGarita,
        virtualProjectSlug: effectiveVpSlug,
        parentSlug: effectiveVpSlug != null ? slug : null,
      ),
      token,
      refreshToken: refreshToken,
    );
    // Registrar device token para push notifications (best-effort)
    PushNotificationService.getToken().then((fcmToken) {
      if (fcmToken != null) {
        _ds.registerDeviceToken(fcmToken).catchError((_) {});
      }
    });

    // Cachear resident_code para QR offline (solo residentes)
    if (user.rol != 'guardia') {
      final profileKey = (effectiveVpSlug ?? slug) != slug
          ? '$effectiveVpSlug@$host'
          : host;
      _garitaDs.miSolvencia().then((s) {
        SessionStorage.saveResidentCode(profileKey, s.residentCode);
      }).catchError((_) {});
    }

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

  /// Refresca el perfil activo desde /me y actualiza Hive con el rol actual.
  Future<void> refreshActiveProfile() async {
    final profile = SessionStorage.activeProfile;
    if (profile == null) return;
    final token = await SessionStorage.getJwt(profile.storageKey);
    if (token == null) return;
    try {
      final me = await _ds.me(
        profile.host,
        token: token,
        virtualProjectSlug: profile.virtualProjectSlug,
      );
      final user = me.toEntity();
      await SessionStorage.saveProfile(
        TenantProfile(
          slug: profile.slug,
          nombre: profile.nombre,
          host: profile.host,
          primaryColor: profile.primaryColor,
          logoUrl: profile.logoUrl,
          usuarioNombre: user.nombre,
          usuarioEmail: user.email,
          usuarioRol: user.rol,
          apiKeyGarita: profile.apiKeyGarita,
          virtualProjectSlug: profile.virtualProjectSlug,
          parentSlug: profile.parentSlug,
          residentCode: profile.residentCode,
        ),
        token,
      );
      // Refrescar resident_code en background (solo residentes)
      if (user.rol != 'guardia') {
        _garitaDs.miSolvencia().then((s) {
          SessionStorage.saveResidentCode(profile.storageKey, s.residentCode);
        }).catchError((_) {});
      }
    } catch (_) {}
  }
}
