// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lotDetail)
final lotDetailProvider = LotDetailFamily._();

final class LotDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<LotDetail>,
          LotDetail,
          FutureOr<LotDetail>
        >
    with $FutureModifier<LotDetail>, $FutureProvider<LotDetail> {
  LotDetailProvider._({
    required LotDetailFamily super.from,
    required (String, String, {String? virtualProjectSlug}) super.argument,
  }) : super(
         retry: null,
         name: r'lotDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotDetailHash();

  @override
  String toString() {
    return r'lotDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LotDetail> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<LotDetail> create(Ref ref) {
    final argument =
        this.argument as (String, String, {String? virtualProjectSlug});
    return lotDetail(
      ref,
      argument.$1,
      argument.$2,
      virtualProjectSlug: argument.virtualProjectSlug,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LotDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotDetailHash() => r'4b804d3bbda512648af62f62b5ae1f3fb667cff6';

final class LotDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<LotDetail>,
          (String, String, {String? virtualProjectSlug})
        > {
  LotDetailFamily._()
    : super(
        retry: null,
        name: r'lotDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LotDetailProvider call(
    String lotId,
    String host, {
    String? virtualProjectSlug,
  }) => LotDetailProvider._(
    argument: (lotId, host, virtualProjectSlug: virtualProjectSlug),
    from: this,
  );

  @override
  String toString() => r'lotDetailProvider';
}
