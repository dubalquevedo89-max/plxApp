import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/notificacion_repository.dart';
import '../../domain/entities/notificacion.dart';

part 'notificacion_provider.g.dart';

@riverpod
NotificacionRepository notificacionRepository(Ref ref) =>
    NotificacionRepository(ref.watch(dioClientProvider));

@riverpod
Future<NotificacionContador> notificacionContador(Ref ref) =>
    ref.watch(notificacionRepositoryProvider).getContador();

@riverpod
class NotificacionesNotifier extends _$NotificacionesNotifier {
  @override
  Future<List<Notificacion>> build() =>
      ref.watch(notificacionRepositoryProvider).getHistorial();

  Future<void> marcarLeida(String id) async {
    await ref.read(notificacionRepositoryProvider).marcarLeida(id);
    final current = state.requireValue;
    state = AsyncValue.data(
      current.map((n) => n.id == id ? n.copyWith(leido: true) : n).toList(),
    );
    ref.invalidate(notificacionContadorProvider);
  }

  Future<void> marcarTodasLeidas() async {
    await ref.read(notificacionRepositoryProvider).marcarTodasLeidas();
    final current = state.requireValue;
    state = AsyncValue.data(
      current.map((n) => n.copyWith(leido: true)).toList(),
    );
    ref.invalidate(notificacionContadorProvider);
  }
}
