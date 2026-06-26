// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geoJson)
final geoJsonProvider = GeoJsonFamily._();

final class GeoJsonProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  GeoJsonProvider._({
    required GeoJsonFamily super.from,
    required (String, String, {String? virtualProjectSlug, String? parentSlug})
    super.argument,
  }) : super(
         retry: null,
         name: r'geoJsonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$geoJsonHash();

  @override
  String toString() {
    return r'geoJsonProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument =
        this.argument
            as (
              String,
              String, {
              String? virtualProjectSlug,
              String? parentSlug,
            });
    return geoJson(
      ref,
      argument.$1,
      argument.$2,
      virtualProjectSlug: argument.virtualProjectSlug,
      parentSlug: argument.parentSlug,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeoJsonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geoJsonHash() => r'd640f714b2801ff62cfe9cdc0126a74a964c5109';

final class GeoJsonFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          (String, String, {String? virtualProjectSlug, String? parentSlug})
        > {
  GeoJsonFamily._()
    : super(
        retry: null,
        name: r'geoJsonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GeoJsonProvider call(
    String slug,
    String host, {
    String? virtualProjectSlug,
    String? parentSlug,
  }) => GeoJsonProvider._(
    argument: (
      slug,
      host,
      virtualProjectSlug: virtualProjectSlug,
      parentSlug: parentSlug,
    ),
    from: this,
  );

  @override
  String toString() => r'geoJsonProvider';
}
