// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserva_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reservaRepository)
final reservaRepositoryProvider = ReservaRepositoryProvider._();

final class ReservaRepositoryProvider
    extends
        $FunctionalProvider<
          ReservaRepository,
          ReservaRepository,
          ReservaRepository
        >
    with $Provider<ReservaRepository> {
  ReservaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reservaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reservaRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReservaRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReservaRepository create(Ref ref) {
    return reservaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReservaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReservaRepository>(value),
    );
  }
}

String _$reservaRepositoryHash() => r'394554704fa5045d0f306662af125fd4f3c2e26d';

@ProviderFor(misReservas)
final misReservasProvider = MisReservasProvider._();

final class MisReservasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Reserva>>,
          List<Reserva>,
          FutureOr<List<Reserva>>
        >
    with $FutureModifier<List<Reserva>>, $FutureProvider<List<Reserva>> {
  MisReservasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misReservasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$misReservasHash();

  @$internal
  @override
  $FutureProviderElement<List<Reserva>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Reserva>> create(Ref ref) {
    return misReservas(ref);
  }
}

String _$misReservasHash() => r'58f2adb28675dd7426606f864ed61e2cf5c97e11';

@ProviderFor(reservaTimeline)
final reservaTimelineProvider = ReservaTimelineFamily._();

final class ReservaTimelineProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReservaTimeline>,
          ReservaTimeline,
          FutureOr<ReservaTimeline>
        >
    with $FutureModifier<ReservaTimeline>, $FutureProvider<ReservaTimeline> {
  ReservaTimelineProvider._({
    required ReservaTimelineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reservaTimelineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reservaTimelineHash();

  @override
  String toString() {
    return r'reservaTimelineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReservaTimeline> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReservaTimeline> create(Ref ref) {
    final argument = this.argument as String;
    return reservaTimeline(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservaTimelineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reservaTimelineHash() => r'528fd956e296bf9ab1c3848c5e44c41b5e5723a7';

final class ReservaTimelineFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReservaTimeline>, String> {
  ReservaTimelineFamily._()
    : super(
        retry: null,
        name: r'reservaTimelineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReservaTimelineProvider call(String reservaId) =>
      ReservaTimelineProvider._(argument: reservaId, from: this);

  @override
  String toString() => r'reservaTimelineProvider';
}
