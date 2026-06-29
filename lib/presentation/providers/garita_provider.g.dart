// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garita_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(garitaDatasource)
final garitaDatasourceProvider = GaritaDatasourceProvider._();

final class GaritaDatasourceProvider
    extends
        $FunctionalProvider<
          GaritaDatasource,
          GaritaDatasource,
          GaritaDatasource
        >
    with $Provider<GaritaDatasource> {
  GaritaDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'garitaDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$garitaDatasourceHash();

  @$internal
  @override
  $ProviderElement<GaritaDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GaritaDatasource create(Ref ref) {
    return garitaDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GaritaDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GaritaDatasource>(value),
    );
  }
}

String _$garitaDatasourceHash() => r'7f4c247c295e4901535ca34c1be073b768e0e2ea';

@ProviderFor(accesoLogs)
final accesoLogsProvider = AccesoLogsFamily._();

final class AccesoLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccesoLogPage>,
          AccesoLogPage,
          FutureOr<AccesoLogPage>
        >
    with $FutureModifier<AccesoLogPage>, $FutureProvider<AccesoLogPage> {
  AccesoLogsProvider._({
    required AccesoLogsFamily super.from,
    required ({
      String? tipoAcceso,
      bool? allowedAccess,
      String? search,
      int page,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'accesoLogsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accesoLogsHash();

  @override
  String toString() {
    return r'accesoLogsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AccesoLogPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccesoLogPage> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? tipoAcceso,
              bool? allowedAccess,
              String? search,
              int page,
            });
    return accesoLogs(
      ref,
      tipoAcceso: argument.tipoAcceso,
      allowedAccess: argument.allowedAccess,
      search: argument.search,
      page: argument.page,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccesoLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accesoLogsHash() => r'014522e1383d61e5f04511b37f86148fd1a92d51';

final class AccesoLogsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<AccesoLogPage>,
          ({String? tipoAcceso, bool? allowedAccess, String? search, int page})
        > {
  AccesoLogsFamily._()
    : super(
        retry: null,
        name: r'accesoLogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccesoLogsProvider call({
    String? tipoAcceso,
    bool? allowedAccess,
    String? search,
    int page = 1,
  }) => AccesoLogsProvider._(
    argument: (
      tipoAcceso: tipoAcceso,
      allowedAccess: allowedAccess,
      search: search,
      page: page,
    ),
    from: this,
  );

  @override
  String toString() => r'accesoLogsProvider';
}
