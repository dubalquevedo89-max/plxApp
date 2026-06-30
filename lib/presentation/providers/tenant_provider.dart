import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/project_repository.dart';
import '../../domain/entities/tenant_option.dart';
import '../../domain/entities/urbanizacion.dart';

part 'tenant_provider.g.dart';

/// Flag: el usuario abrió el navegador para registrar un proyecto.
@riverpod
class RegistroOpened extends _$RegistroOpened {
  @override
  bool build() => false;
  void set(bool value) => state = value;
}

@riverpod
ProjectRepository projectRepository(Ref ref) =>
    ProjectRepository(ref.watch(dioClientProvider));

@riverpod
Future<Map<String, List<Urbanizacion>>> projectsByPais(Ref ref) =>
    ref.watch(projectRepositoryProvider).fetchByPais();

/// Urbanizaciones de un país, sin el tenant sandbox.
@riverpod
Future<List<Urbanizacion>> urbanizacionesByPais(
  Ref ref,
  String pais,
) async {
  final sandboxSlug = dotenv.env['SANDBOX_SLUG'] ?? '';
  final all = await ref.watch(projectsByPaisProvider.future);
  return (all[pais] ?? []).where((u) => u.slug != sandboxSlug).toList();
}

@riverpod
Future<List<String>> subdivisionesByPais(Ref ref, String pais) async {
  final items = await ref.watch(urbanizacionesByPaisProvider(pais).future);
  final subs = items
      .map((u) => u.subdivision)
      .whereType<String>()
      .toSet()
      .toList()
    ..sort();
  return subs;
}

@riverpod
Future<List<Urbanizacion>> urbanizacionesBySubdivision(
  Ref ref,
  String pais,
  String subdivision,
) async {
  final items = await ref.watch(urbanizacionesByPaisProvider(pais).future);
  return items.where((u) => u.subdivision == subdivision).toList();
}

List<TenantOption> _urbsToOptions(List<Urbanizacion> items) {
  final options = <TenantOption>[];
  for (final urb in items) {
    options.add(TenantOption(
      slug: urb.slug,
      nombre: urb.nombre,
      ubicacionTexto: urb.ubicacionTexto,
      logoUrl: urb.logoUrl,
      primaryColor: urb.primaryColor,
      host: urb.host,
      masterplanAppEnabled: urb.masterplanAppEnabled,
    ));
    for (final vp in urb.virtualProjects.where((v) => v.appEnabled)) {
      options.add(TenantOption(
        slug: vp.slug,
        nombre: vp.nombre,
        ubicacionTexto: vp.locationText ?? urb.ubicacionTexto,
        logoUrl: urb.logoUrl,
        primaryColor: vp.primaryColor,
        host: urb.host,
        virtualProjectSlug: vp.slug,
        parentNombre: urb.nombre,
        parentSlug: urb.slug,
        masterplanAppEnabled: vp.masterplanAppEnabled,
      ));
    }
  }
  return options;
}

@riverpod
Future<List<TenantOption>> tenantOptionsByPais(
  Ref ref,
  String pais,
) async {
  final items = await ref.watch(urbanizacionesByPaisProvider(pais).future);
  return _urbsToOptions(items);
}

/// VPs del tenant sandbox como TenantOption independientes (con su propia ubicación).
@riverpod
Future<List<TenantOption>> sandboxTenantOptions(Ref ref) async {
  final sandboxSlug = dotenv.env['SANDBOX_SLUG'] ?? '';
  if (sandboxSlug.isEmpty) return [];

  final all = await ref.watch(projectsByPaisProvider.future);
  Urbanizacion? sandbox;
  for (final urbs in all.values) {
    sandbox = urbs.where((u) => u.slug == sandboxSlug).firstOrNull;
    if (sandbox != null) break;
  }
  if (sandbox == null) return [];

  return sandbox.virtualProjects
      .where((vp) => vp.appEnabled)
      .map((vp) => TenantOption(
            slug: vp.slug,
            nombre: vp.nombre,
            ubicacionTexto: vp.locationText,
            logoUrl: sandbox!.logoUrl,
            primaryColor: vp.primaryColor,
            host: sandbox.host,
            virtualProjectSlug: vp.slug,
            parentNombre: sandbox.nombre,
            parentSlug: sandbox.slug,
            masterplanAppEnabled: vp.masterplanAppEnabled,
          ))
      .toList();
}
