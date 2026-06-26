import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/storage/session_storage.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<Usuario?> build() => _fetchMe();

  Future<Usuario?> _fetchMe() async {
    final profile = SessionStorage.activeProfile;
    if (profile == null) return null;
    return ref.read(authRepositoryProvider).me(profile.host,
        virtualProjectSlug: profile.virtualProjectSlug);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchMe);
  }

  Future<String?> updateProfile({
    required String nombre,
    required String telefono,
    required String cedula,
  }) async {
    try {
      final updated = await ref.read(authRepositoryProvider).updateMe(
            nombre: nombre,
            telefono: telefono,
            cedula: cedula,
          );
      state = AsyncValue.data(updated);
      return null;
    } on DioException catch (e) {
      final detail = (e.response?.data as Map?)?['detail'] as String?;
      return detail ?? 'Error al actualizar el perfil.';
    } catch (_) {
      return 'Error al actualizar el perfil.';
    }
  }

  Future<String?> changePassword({
    required String passwordActual,
    required String passwordNuevo,
  }) async {
    try {
      await ref.read(authRepositoryProvider).changePassword(
            passwordActual: passwordActual,
            passwordNuevo: passwordNuevo,
          );
      return null;
    } on DioException catch (e) {
      final detail = (e.response?.data as Map?)?['detail'] as String?;
      return detail ?? 'Error al cambiar la contraseña.';
    } catch (_) {
      return 'Error al cambiar la contraseña.';
    }
  }
}
