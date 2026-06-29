// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documento_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentoRepository)
final documentoRepositoryProvider = DocumentoRepositoryProvider._();

final class DocumentoRepositoryProvider
    extends
        $FunctionalProvider<
          DocumentoRepository,
          DocumentoRepository,
          DocumentoRepository
        >
    with $Provider<DocumentoRepository> {
  DocumentoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentoRepositoryHash();

  @$internal
  @override
  $ProviderElement<DocumentoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentoRepository create(Ref ref) {
    return documentoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentoRepository>(value),
    );
  }
}

String _$documentoRepositoryHash() =>
    r'ee374409ea367377d530056328717b993fefb568';

@ProviderFor(documentosRecibidos)
final documentosRecibidosProvider = DocumentosRecibidosProvider._();

final class DocumentosRecibidosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Documento>>,
          List<Documento>,
          FutureOr<List<Documento>>
        >
    with $FutureModifier<List<Documento>>, $FutureProvider<List<Documento>> {
  DocumentosRecibidosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentosRecibidosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentosRecibidosHash();

  @$internal
  @override
  $FutureProviderElement<List<Documento>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Documento>> create(Ref ref) {
    return documentosRecibidos(ref);
  }
}

String _$documentosRecibidosHash() =>
    r'b88997f5e7654cdc0156016cda9e5a07ec7fbe69';

@ProviderFor(documentosMisUploads)
final documentosMisUploadsProvider = DocumentosMisUploadsProvider._();

final class DocumentosMisUploadsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Documento>>,
          List<Documento>,
          FutureOr<List<Documento>>
        >
    with $FutureModifier<List<Documento>>, $FutureProvider<List<Documento>> {
  DocumentosMisUploadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentosMisUploadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentosMisUploadsHash();

  @$internal
  @override
  $FutureProviderElement<List<Documento>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Documento>> create(Ref ref) {
    return documentosMisUploads(ref);
  }
}

String _$documentosMisUploadsHash() =>
    r'582eab92e9e3377b8f20da7f859ee81be42a0837';

@ProviderFor(documentoUrl)
final documentoUrlProvider = DocumentoUrlFamily._();

final class DocumentoUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  DocumentoUrlProvider._({
    required DocumentoUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentoUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentoUrlHash();

  @override
  String toString() {
    return r'documentoUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return documentoUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentoUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentoUrlHash() => r'daaf6c783e17c5215a407a44298daf4691a53033';

final class DocumentoUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  DocumentoUrlFamily._()
    : super(
        retry: null,
        name: r'documentoUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DocumentoUrlProvider call(String docId) =>
      DocumentoUrlProvider._(argument: docId, from: this);

  @override
  String toString() => r'documentoUrlProvider';
}

@ProviderFor(documentosDeReserva)
final documentosDeReservaProvider = DocumentosDeReservaFamily._();

final class DocumentosDeReservaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Documento>>,
          List<Documento>,
          FutureOr<List<Documento>>
        >
    with $FutureModifier<List<Documento>>, $FutureProvider<List<Documento>> {
  DocumentosDeReservaProvider._({
    required DocumentosDeReservaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentosDeReservaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentosDeReservaHash();

  @override
  String toString() {
    return r'documentosDeReservaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Documento>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Documento>> create(Ref ref) {
    final argument = this.argument as String;
    return documentosDeReserva(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentosDeReservaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentosDeReservaHash() =>
    r'016e0c82d4b187ba0b81011348728f6d0c6782dc';

final class DocumentosDeReservaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Documento>>, String> {
  DocumentosDeReservaFamily._()
    : super(
        retry: null,
        name: r'documentosDeReservaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DocumentosDeReservaProvider call(String reservaId) =>
      DocumentosDeReservaProvider._(argument: reservaId, from: this);

  @override
  String toString() => r'documentosDeReservaProvider';
}
