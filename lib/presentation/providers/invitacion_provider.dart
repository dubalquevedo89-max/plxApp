import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/invitacion_repository.dart';
import '../../domain/entities/invitacion.dart';

part 'invitacion_provider.g.dart';

@riverpod
InvitacionRepository invitacionRepository(Ref ref) =>
    InvitacionRepository(ref.watch(dioClientProvider));

@riverpod
class InvitacionesNotifier extends _$InvitacionesNotifier {
  @override
  Future<List<Invitacion>> build() =>
      ref.read(invitacionRepositoryProvider).listar();

  Future<Invitacion?> crear({
    required String nombreInvitado,
    String? telefonoInvitado,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final inv = await ref.read(invitacionRepositoryProvider).crear(
          nombreInvitado: nombreInvitado,
          telefonoInvitado: telefonoInvitado,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );
    state = AsyncValue.data([inv, ...state.requireValue]);
    return inv;
  }

  Future<void> revocar(String id) async {
    await ref.read(invitacionRepositoryProvider).revocar(id);
    state = AsyncValue.data(
      state.requireValue.where((i) => i.id != id).toList(),
    );
  }
}
