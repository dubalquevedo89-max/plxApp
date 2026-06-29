// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitacion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(invitacionRepository)
final invitacionRepositoryProvider = InvitacionRepositoryProvider._();

final class InvitacionRepositoryProvider
    extends
        $FunctionalProvider<
          InvitacionRepository,
          InvitacionRepository,
          InvitacionRepository
        >
    with $Provider<InvitacionRepository> {
  InvitacionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitacionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitacionRepositoryHash();

  @$internal
  @override
  $ProviderElement<InvitacionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvitacionRepository create(Ref ref) {
    return invitacionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvitacionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvitacionRepository>(value),
    );
  }
}

String _$invitacionRepositoryHash() =>
    r'3d243725757100a6a9410b6b1759dbbb71b28613';

@ProviderFor(InvitacionesNotifier)
final invitacionesProvider = InvitacionesNotifierProvider._();

final class InvitacionesNotifierProvider
    extends $AsyncNotifierProvider<InvitacionesNotifier, List<Invitacion>> {
  InvitacionesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitacionesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitacionesNotifierHash();

  @$internal
  @override
  InvitacionesNotifier create() => InvitacionesNotifier();
}

String _$invitacionesNotifierHash() =>
    r'0c7bde4f214a2a071f61bfb83c89f027296fcf9e';

abstract class _$InvitacionesNotifier extends $AsyncNotifier<List<Invitacion>> {
  FutureOr<List<Invitacion>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Invitacion>>, List<Invitacion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Invitacion>>, List<Invitacion>>,
              AsyncValue<List<Invitacion>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
