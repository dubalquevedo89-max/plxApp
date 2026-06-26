// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'fd15ef56f32ebc25e6b26bfe09399c18ac7f5db3';

/// Reactive active profile — invalidate this after any profile switch/logout
/// so every widget watching it rebuilds automatically.

@ProviderFor(activeProfile)
final activeProfileProvider = ActiveProfileProvider._();

/// Reactive active profile — invalidate this after any profile switch/logout
/// so every widget watching it rebuilds automatically.

final class ActiveProfileProvider
    extends $FunctionalProvider<TenantProfile?, TenantProfile?, TenantProfile?>
    with $Provider<TenantProfile?> {
  /// Reactive active profile — invalidate this after any profile switch/logout
  /// so every widget watching it rebuilds automatically.
  ActiveProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeProfileHash();

  @$internal
  @override
  $ProviderElement<TenantProfile?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TenantProfile? create(Ref ref) {
    return activeProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TenantProfile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TenantProfile?>(value),
    );
  }
}

String _$activeProfileHash() => r'ed42558d8109914ed796b4d02ba5f88315d13430';

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AsyncValue<Usuario?>> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Usuario?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Usuario?>>(value),
    );
  }
}

String _$authNotifierHash() => r'1da36705809385e2948ecc9cc70c637a5ec05d4a';

abstract class _$AuthNotifier extends $Notifier<AsyncValue<Usuario?>> {
  AsyncValue<Usuario?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Usuario?>, AsyncValue<Usuario?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Usuario?>, AsyncValue<Usuario?>>,
              AsyncValue<Usuario?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
