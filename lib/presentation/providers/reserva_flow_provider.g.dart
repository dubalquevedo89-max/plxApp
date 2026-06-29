// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserva_flow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReservaFlow)
final reservaFlowProvider = ReservaFlowProvider._();

final class ReservaFlowProvider
    extends $NotifierProvider<ReservaFlow, ReservaFlowState> {
  ReservaFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reservaFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reservaFlowHash();

  @$internal
  @override
  ReservaFlow create() => ReservaFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReservaFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReservaFlowState>(value),
    );
  }
}

String _$reservaFlowHash() => r'4b96e3fb3952e63eb071ee30e81598c3db266efb';

abstract class _$ReservaFlow extends $Notifier<ReservaFlowState> {
  ReservaFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReservaFlowState, ReservaFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReservaFlowState, ReservaFlowState>,
              ReservaFlowState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
