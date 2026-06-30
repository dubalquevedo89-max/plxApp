// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Flag: el usuario abrió el navegador para registrar un proyecto.

@ProviderFor(RegistroOpened)
final registroOpenedProvider = RegistroOpenedProvider._();

/// Flag: el usuario abrió el navegador para registrar un proyecto.
final class RegistroOpenedProvider
    extends $NotifierProvider<RegistroOpened, bool> {
  /// Flag: el usuario abrió el navegador para registrar un proyecto.
  RegistroOpenedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registroOpenedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registroOpenedHash();

  @$internal
  @override
  RegistroOpened create() => RegistroOpened();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$registroOpenedHash() => r'df4bc185502c2408219ed227014cd7e0e40ac9b7';

/// Flag: el usuario abrió el navegador para registrar un proyecto.

abstract class _$RegistroOpened extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(projectRepository)
final projectRepositoryProvider = ProjectRepositoryProvider._();

final class ProjectRepositoryProvider
    extends
        $FunctionalProvider<
          ProjectRepository,
          ProjectRepository,
          ProjectRepository
        >
    with $Provider<ProjectRepository> {
  ProjectRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectRepository create(Ref ref) {
    return projectRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectRepository>(value),
    );
  }
}

String _$projectRepositoryHash() => r'be84d46d0c5f5c6362360ddc9f30b44b7f85c776';

@ProviderFor(projectsByPais)
final projectsByPaisProvider = ProjectsByPaisProvider._();

final class ProjectsByPaisProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<Urbanizacion>>>,
          Map<String, List<Urbanizacion>>,
          FutureOr<Map<String, List<Urbanizacion>>>
        >
    with
        $FutureModifier<Map<String, List<Urbanizacion>>>,
        $FutureProvider<Map<String, List<Urbanizacion>>> {
  ProjectsByPaisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsByPaisProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsByPaisHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<Urbanizacion>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<Urbanizacion>>> create(Ref ref) {
    return projectsByPais(ref);
  }
}

String _$projectsByPaisHash() => r'1f23531d388c8afd9fc91e6fca1343c67c87187f';

/// Urbanizaciones de un país, sin el tenant sandbox.

@ProviderFor(urbanizacionesByPais)
final urbanizacionesByPaisProvider = UrbanizacionesByPaisFamily._();

/// Urbanizaciones de un país, sin el tenant sandbox.

final class UrbanizacionesByPaisProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Urbanizacion>>,
          List<Urbanizacion>,
          FutureOr<List<Urbanizacion>>
        >
    with
        $FutureModifier<List<Urbanizacion>>,
        $FutureProvider<List<Urbanizacion>> {
  /// Urbanizaciones de un país, sin el tenant sandbox.
  UrbanizacionesByPaisProvider._({
    required UrbanizacionesByPaisFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'urbanizacionesByPaisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$urbanizacionesByPaisHash();

  @override
  String toString() {
    return r'urbanizacionesByPaisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Urbanizacion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Urbanizacion>> create(Ref ref) {
    final argument = this.argument as String;
    return urbanizacionesByPais(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UrbanizacionesByPaisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$urbanizacionesByPaisHash() =>
    r'c83b2e5c5bc960c91701df6c618961333869a83f';

/// Urbanizaciones de un país, sin el tenant sandbox.

final class UrbanizacionesByPaisFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Urbanizacion>>, String> {
  UrbanizacionesByPaisFamily._()
    : super(
        retry: null,
        name: r'urbanizacionesByPaisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Urbanizaciones de un país, sin el tenant sandbox.

  UrbanizacionesByPaisProvider call(String pais) =>
      UrbanizacionesByPaisProvider._(argument: pais, from: this);

  @override
  String toString() => r'urbanizacionesByPaisProvider';
}

@ProviderFor(subdivisionesByPais)
final subdivisionesByPaisProvider = SubdivisionesByPaisFamily._();

final class SubdivisionesByPaisProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  SubdivisionesByPaisProvider._({
    required SubdivisionesByPaisFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'subdivisionesByPaisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subdivisionesByPaisHash();

  @override
  String toString() {
    return r'subdivisionesByPaisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return subdivisionesByPais(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubdivisionesByPaisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subdivisionesByPaisHash() =>
    r'5845b55c49a9ee5e02c892328ff0fbd201bfa807';

final class SubdivisionesByPaisFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  SubdivisionesByPaisFamily._()
    : super(
        retry: null,
        name: r'subdivisionesByPaisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SubdivisionesByPaisProvider call(String pais) =>
      SubdivisionesByPaisProvider._(argument: pais, from: this);

  @override
  String toString() => r'subdivisionesByPaisProvider';
}

@ProviderFor(urbanizacionesBySubdivision)
final urbanizacionesBySubdivisionProvider =
    UrbanizacionesBySubdivisionFamily._();

final class UrbanizacionesBySubdivisionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Urbanizacion>>,
          List<Urbanizacion>,
          FutureOr<List<Urbanizacion>>
        >
    with
        $FutureModifier<List<Urbanizacion>>,
        $FutureProvider<List<Urbanizacion>> {
  UrbanizacionesBySubdivisionProvider._({
    required UrbanizacionesBySubdivisionFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'urbanizacionesBySubdivisionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$urbanizacionesBySubdivisionHash();

  @override
  String toString() {
    return r'urbanizacionesBySubdivisionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Urbanizacion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Urbanizacion>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return urbanizacionesBySubdivision(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is UrbanizacionesBySubdivisionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$urbanizacionesBySubdivisionHash() =>
    r'04904d6a23627c2ca38d58eca51aefba7aac3018';

final class UrbanizacionesBySubdivisionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Urbanizacion>>,
          (String, String)
        > {
  UrbanizacionesBySubdivisionFamily._()
    : super(
        retry: null,
        name: r'urbanizacionesBySubdivisionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UrbanizacionesBySubdivisionProvider call(String pais, String subdivision) =>
      UrbanizacionesBySubdivisionProvider._(
        argument: (pais, subdivision),
        from: this,
      );

  @override
  String toString() => r'urbanizacionesBySubdivisionProvider';
}

@ProviderFor(tenantOptionsByPais)
final tenantOptionsByPaisProvider = TenantOptionsByPaisFamily._();

final class TenantOptionsByPaisProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TenantOption>>,
          List<TenantOption>,
          FutureOr<List<TenantOption>>
        >
    with
        $FutureModifier<List<TenantOption>>,
        $FutureProvider<List<TenantOption>> {
  TenantOptionsByPaisProvider._({
    required TenantOptionsByPaisFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tenantOptionsByPaisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantOptionsByPaisHash();

  @override
  String toString() {
    return r'tenantOptionsByPaisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TenantOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TenantOption>> create(Ref ref) {
    final argument = this.argument as String;
    return tenantOptionsByPais(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantOptionsByPaisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantOptionsByPaisHash() =>
    r'dee193387774f3bb72af6ab44ef9601e0a59034f';

final class TenantOptionsByPaisFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TenantOption>>, String> {
  TenantOptionsByPaisFamily._()
    : super(
        retry: null,
        name: r'tenantOptionsByPaisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TenantOptionsByPaisProvider call(String pais) =>
      TenantOptionsByPaisProvider._(argument: pais, from: this);

  @override
  String toString() => r'tenantOptionsByPaisProvider';
}

/// VPs del tenant sandbox como TenantOption independientes (con su propia ubicación).

@ProviderFor(sandboxTenantOptions)
final sandboxTenantOptionsProvider = SandboxTenantOptionsProvider._();

/// VPs del tenant sandbox como TenantOption independientes (con su propia ubicación).

final class SandboxTenantOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TenantOption>>,
          List<TenantOption>,
          FutureOr<List<TenantOption>>
        >
    with
        $FutureModifier<List<TenantOption>>,
        $FutureProvider<List<TenantOption>> {
  /// VPs del tenant sandbox como TenantOption independientes (con su propia ubicación).
  SandboxTenantOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sandboxTenantOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sandboxTenantOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<TenantOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TenantOption>> create(Ref ref) {
    return sandboxTenantOptions(ref);
  }
}

String _$sandboxTenantOptionsHash() =>
    r'5e5c1681d2ddddfbf3b07b35ae73ef58d72cfbc8';
