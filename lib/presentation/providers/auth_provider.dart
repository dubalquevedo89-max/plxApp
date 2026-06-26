import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/tenant_profile.dart';
import '../../core/storage/session_storage.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/usuario.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(dioClientProvider));

/// Reactive active profile — invalidate this after any profile switch/logout
/// so every widget watching it rebuilds automatically.
@Riverpod(keepAlive: true)
TenantProfile? activeProfile(Ref ref) => SessionStorage.activeProfile;

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<Usuario?> build() => const AsyncValue.data(null);

  Future<void> login({
    required String email,
    required String password,
    required String host,
    required String primaryColor,
    String? logoUrl,
    String? virtualProjectSlug,
    String? displayNombre,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
          host: host,
          primaryColor: primaryColor,
          logoUrl: logoUrl,
          virtualProjectSlug: virtualProjectSlug,
          displayNombre: displayNombre,
        ));
  }

  // Logout active session
  Future<void> logout() async {
    final key = SessionStorage.activeHost;
    if (key != null) await ref.read(authRepositoryProvider).logout(key);
    if (ref.mounted) state = const AsyncValue.data(null);
  }

  // Logout a specific profile (may not be the active one)
  Future<void> logoutProfile(String storageKey) async {
    await ref.read(authRepositoryProvider).logout(storageKey);
    if (ref.mounted) state = const AsyncValue.data(null);
  }

  // Verify a profile's session is still valid. Returns null on success, error message on failure.
  Future<String?> verifyProfile(TenantProfile profile) async {
    try {
      final token = await SessionStorage.getJwt(profile.storageKey);
      if (token == null) return 'Sin sesión guardada.';
      await ref.read(authRepositoryProvider).me(
            profile.host,
            token: token,
            virtualProjectSlug: profile.virtualProjectSlug,
          );
      return null;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        return 'Tu sesión expiró en ${profile.nombre}.';
      }
      if (status == 404) return '${profile.nombre} ya no está disponible.';
      return 'Sin conexión. Inténtalo más tarde.';
    } catch (e, st) {
      debugPrint('[verifyProfile] unexpected error: $e\n$st');
      return 'No se pudo verificar la sesión.';
    }
  }
}
