// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

@ProviderFor(urbanizacionesByPais)
final urbanizacionesByPaisProvider = UrbanizacionesByPaisFamily._();

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
    r'de550ca06b452da46ca2944e9c50e9b8870a5ca0';

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

@ProviderFor(tenantOptionsBySubdivision)
final tenantOptionsBySubdivisionProvider = TenantOptionsBySubdivisionFamily._();

final class TenantOptionsBySubdivisionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TenantOption>>,
          List<TenantOption>,
          FutureOr<List<TenantOption>>
        >
    with
        $FutureModifier<List<TenantOption>>,
        $FutureProvider<List<TenantOption>> {
  TenantOptionsBySubdivisionProvider._({
    required TenantOptionsBySubdivisionFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tenantOptionsBySubdivisionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantOptionsBySubdivisionHash();

  @override
  String toString() {
    return r'tenantOptionsBySubdivisionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TenantOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TenantOption>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return tenantOptionsBySubdivision(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantOptionsBySubdivisionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantOptionsBySubdivisionHash() =>
    r'7651f5c96e77d311b8f8590a7738e0dd41aaed09';

final class TenantOptionsBySubdivisionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TenantOption>>,
          (String, String)
        > {
  TenantOptionsBySubdivisionFamily._()
    : super(
        retry: null,
        name: r'tenantOptionsBySubdivisionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TenantOptionsBySubdivisionProvider call(String pais, String subdivision) =>
      TenantOptionsBySubdivisionProvider._(
        argument: (pais, subdivision),
        from: this,
      );

  @override
  String toString() => r'tenantOptionsBySubdivisionProvider';
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
    r'f1625c557125aeadd18c8b990cd7bcce714eb895';

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
