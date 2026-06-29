// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alertas_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alertasDatasource)
final alertasDatasourceProvider = AlertasDatasourceProvider._();

final class AlertasDatasourceProvider
    extends
        $FunctionalProvider<
          AlertasDatasource,
          AlertasDatasource,
          AlertasDatasource
        >
    with $Provider<AlertasDatasource> {
  AlertasDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertasDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertasDatasourceHash();

  @$internal
  @override
  $ProviderElement<AlertasDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlertasDatasource create(Ref ref) {
    return alertasDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertasDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertasDatasource>(value),
    );
  }
}

String _$alertasDatasourceHash() => r'9bd4538c25af00540db3ccc86b705f02eef072fe';
