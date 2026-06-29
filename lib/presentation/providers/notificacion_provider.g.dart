// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificacionRepository)
final notificacionRepositoryProvider = NotificacionRepositoryProvider._();

final class NotificacionRepositoryProvider
    extends
        $FunctionalProvider<
          NotificacionRepository,
          NotificacionRepository,
          NotificacionRepository
        >
    with $Provider<NotificacionRepository> {
  NotificacionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificacionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificacionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificacionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificacionRepository create(Ref ref) {
    return notificacionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificacionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificacionRepository>(value),
    );
  }
}

String _$notificacionRepositoryHash() =>
    r'f40f319f463ee28497d110c5d38e6a48b2ba3ed5';

@ProviderFor(notificacionContador)
final notificacionContadorProvider = NotificacionContadorProvider._();

final class NotificacionContadorProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificacionContador>,
          NotificacionContador,
          FutureOr<NotificacionContador>
        >
    with
        $FutureModifier<NotificacionContador>,
        $FutureProvider<NotificacionContador> {
  NotificacionContadorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificacionContadorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificacionContadorHash();

  @$internal
  @override
  $FutureProviderElement<NotificacionContador> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificacionContador> create(Ref ref) {
    return notificacionContador(ref);
  }
}

String _$notificacionContadorHash() =>
    r'b0155b6afaacb3f40619a6afe1bbfaf090fef95c';

@ProviderFor(NotificacionesNotifier)
final notificacionesProvider = NotificacionesNotifierProvider._();

final class NotificacionesNotifierProvider
    extends $AsyncNotifierProvider<NotificacionesNotifier, List<Notificacion>> {
  NotificacionesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificacionesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificacionesNotifierHash();

  @$internal
  @override
  NotificacionesNotifier create() => NotificacionesNotifier();
}

String _$notificacionesNotifierHash() =>
    r'edf0902c7c3a5414f1e704dfef015dfb3a2030a2';

abstract class _$NotificacionesNotifier
    extends $AsyncNotifier<List<Notificacion>> {
  FutureOr<List<Notificacion>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Notificacion>>, List<Notificacion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Notificacion>>, List<Notificacion>>,
              AsyncValue<List<Notificacion>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
