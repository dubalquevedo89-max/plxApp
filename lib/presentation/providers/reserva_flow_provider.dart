import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/push_notification_service.dart';
import '../../data/datasources/remote/auth_datasource.dart';
import '../../data/datasources/remote/reserva_datasource.dart';
import '../../domain/entities/reserva_result.dart';
import 'auth_provider.dart';

part 'reserva_flow_provider.g.dart';

enum ReservaStep { form, creatingAccount, loggingIn, requestingPermission, reserving, done, error, loginExisting }

class ReservaFlowState {
  final ReservaStep step;
  final String? errorMessage;
  final ReservaResult? result;
  // Kept for when we skip registration and go straight to login
  final String? prefillEmail;

  const ReservaFlowState({
    this.step = ReservaStep.form,
    this.errorMessage,
    this.result,
    this.prefillEmail,
  });

  ReservaFlowState copyWith({
    ReservaStep? step,
    String? errorMessage,
    ReservaResult? result,
    String? prefillEmail,
  }) =>
      ReservaFlowState(
        step: step ?? this.step,
        errorMessage: errorMessage,
        result: result ?? this.result,
        prefillEmail: prefillEmail ?? this.prefillEmail,
      );
}

@riverpod
class ReservaFlow extends _$ReservaFlow {
  @override
  ReservaFlowState build() => const ReservaFlowState();

  Future<void> execute({
    required String nombre,
    required String email,
    required String telefono,
    required String cedula,
    required String password,
    required String lotId,
    required String host,
    required String primaryColor,
    String? virtualProjectSlug,
    String? logoUrl,
  }) async {
    final dio = ref.read(dioClientProvider);
    final authDs = AuthDatasource(dio);
    final reservaDs = ReservaDatasource(dio);

    try {
      // Step 1: Create account
      state = state.copyWith(step: ReservaStep.creatingAccount);
      await authDs.registro(
        email: email,
        nombre: nombre,
        telefono: telefono,
        cedula: cedula,
        password: password,
        host: host,
        virtualProjectSlug: virtualProjectSlug,
      );

      // Step 2: Login (saves session via AuthRepository)
      state = state.copyWith(step: ReservaStep.loggingIn);
      await ref.read(authRepositoryProvider).login(
            email: email,
            password: password,
            host: host,
            primaryColor: primaryColor,
            logoUrl: logoUrl,
            virtualProjectSlug: virtualProjectSlug,
          );

      // Step 3: Permisos de notificaciones (obligatorio)
      state = state.copyWith(step: ReservaStep.requestingPermission);
      final granted = await PushNotificationService.requestAndCheckPermission();
      if (!granted) {
        state = state.copyWith(
          step: ReservaStep.error,
          errorMessage: 'Para completar la reserva debes permitir las notificaciones. '
              'Son necesarias para recibir actualizaciones de tu trámite.',
        );
        return;
      }

      // Step 4: Pre-reservar
      state = state.copyWith(step: ReservaStep.reserving);
      final storageKey =
          virtualProjectSlug != null ? '$virtualProjectSlug@$host' : host;
      final token = await ref
          .read(authRepositoryProvider)
          .getToken(storageKey);

      final result = await reservaDs.preReservar(
        lotId: lotId,
        token: token ?? '',
        host: host,
        virtualProjectSlug: virtualProjectSlug,
      );

      state = state.copyWith(step: ReservaStep.done, result: result);
    } catch (e) {
      if (_isEmailExists(e)) {
        // Don't show error — guide user to login with their existing account
        state = state.copyWith(
          step: ReservaStep.loginExisting,
          prefillEmail: email,
        );
      } else {
        state = state.copyWith(
            step: ReservaStep.error, errorMessage: _friendlyError(e));
      }
    }
  }

  Future<void> loginAndReserve({
    required String email,
    required String password,
    required String lotId,
    required String host,
    required String primaryColor,
    String? virtualProjectSlug,
    String? logoUrl,
  }) async {
    final reservaDs = ReservaDatasource(ref.read(dioClientProvider));

    try {
      state = state.copyWith(step: ReservaStep.loggingIn);
      await ref.read(authRepositoryProvider).login(
            email: email,
            password: password,
            host: host,
            primaryColor: primaryColor,
            logoUrl: logoUrl,
            virtualProjectSlug: virtualProjectSlug,
          );

      // Permisos de notificaciones (obligatorio)
      state = state.copyWith(step: ReservaStep.requestingPermission);
      final granted = await PushNotificationService.requestAndCheckPermission();
      if (!granted) {
        state = state.copyWith(
          step: ReservaStep.error,
          errorMessage: 'Para completar la reserva debes permitir las notificaciones. '
              'Son necesarias para recibir actualizaciones de tu trámite.',
        );
        return;
      }

      state = state.copyWith(step: ReservaStep.reserving);
      final storageKey =
          virtualProjectSlug != null ? '$virtualProjectSlug@$host' : host;
      final token = await ref.read(authRepositoryProvider).getToken(storageKey);

      final result = await reservaDs.preReservar(
        lotId: lotId,
        token: token ?? '',
        host: host,
        virtualProjectSlug: virtualProjectSlug,
      );

      state = state.copyWith(step: ReservaStep.done, result: result);
    } catch (e) {
      state = state.copyWith(
          step: ReservaStep.loginExisting,
          errorMessage: _friendlyError(e));
    }
  }

  void reset() => state = const ReservaFlowState();

  bool _isEmailExists(Object e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final detail = data is Map ? (data['detail']?.toString().toLowerCase() ?? '') : '';
      if (status == 400 || status == 409) return true;
      if (detail.contains('registrado') || detail.contains('already') || detail.contains('existe')) {
        return true;
      }
    }
    return false;
  }

  String _friendlyError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
      final status = e.response?.statusCode;
      if (status == 401) return 'Contraseña incorrecta. Inténtalo de nuevo.';
      if (status == 422) return 'Datos inválidos. Verifica el formulario.';
      if (status != null && status >= 500) return 'El servidor no está disponible. Inténtalo más tarde.';
    }
    final str = e.toString().toLowerCase();
    if (str.contains('connection') || str.contains('socket')) {
      return 'Sin conexión. Verifica tu internet.';
    }
    return 'Ocurrió un error. Inténtalo de nuevo.';
  }
}
