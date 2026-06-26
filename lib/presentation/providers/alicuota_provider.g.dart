// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alicuota_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alicuotaRepository)
final alicuotaRepositoryProvider = AlicuotaRepositoryProvider._();

final class AlicuotaRepositoryProvider
    extends
        $FunctionalProvider<
          AlicuotaRepository,
          AlicuotaRepository,
          AlicuotaRepository
        >
    with $Provider<AlicuotaRepository> {
  AlicuotaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alicuotaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alicuotaRepositoryHash();

  @$internal
  @override
  $ProviderElement<AlicuotaRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlicuotaRepository create(Ref ref) {
    return alicuotaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlicuotaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlicuotaRepository>(value),
    );
  }
}

String _$alicuotaRepositoryHash() =>
    r'4e1d2fb107715150e5eb9aea41f6fd62177200fc';

@ProviderFor(misPropiedades)
final misPropiedadesProvider = MisPropiedadesProvider._();

final class MisPropiedadesProvider
    extends
        $FunctionalProvider<
          AsyncValue<MisPropiedades>,
          MisPropiedades,
          FutureOr<MisPropiedades>
        >
    with $FutureModifier<MisPropiedades>, $FutureProvider<MisPropiedades> {
  MisPropiedadesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misPropiedadesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$misPropiedadesHash();

  @$internal
  @override
  $FutureProviderElement<MisPropiedades> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MisPropiedades> create(Ref ref) {
    return misPropiedades(ref);
  }
}

String _$misPropiedadesHash() => r'c4569ebbc052047211148cd6eb48b877048cfb7a';

@ProviderFor(misPagos)
final misPagosProvider = MisPagosFamily._();

final class MisPagosProvider
    extends
        $FunctionalProvider<
          AsyncValue<HistorialPagos>,
          HistorialPagos,
          FutureOr<HistorialPagos>
        >
    with $FutureModifier<HistorialPagos>, $FutureProvider<HistorialPagos> {
  MisPagosProvider._({
    required MisPagosFamily super.from,
    required ({DateTime? desde, DateTime? hasta}) super.argument,
  }) : super(
         retry: null,
         name: r'misPagosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$misPagosHash();

  @override
  String toString() {
    return r'misPagosProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<HistorialPagos> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HistorialPagos> create(Ref ref) {
    final argument = this.argument as ({DateTime? desde, DateTime? hasta});
    return misPagos(ref, desde: argument.desde, hasta: argument.hasta);
  }

  @override
  bool operator ==(Object other) {
    return other is MisPagosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$misPagosHash() => r'63150bb5709097637df97c9527aa7cf67cfe40ef';

final class MisPagosFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<HistorialPagos>,
          ({DateTime? desde, DateTime? hasta})
        > {
  MisPagosFamily._()
    : super(
        retry: null,
        name: r'misPagosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MisPagosProvider call({DateTime? desde, DateTime? hasta}) =>
      MisPagosProvider._(argument: (desde: desde, hasta: hasta), from: this);

  @override
  String toString() => r'misPagosProvider';
}
