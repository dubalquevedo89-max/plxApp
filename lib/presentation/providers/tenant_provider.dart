import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/project_repository.dart';
import '../../domain/entities/tenant_option.dart';
import '../../domain/entities/urbanizacion.dart';

part 'tenant_provider.g.dart';

@riverpod
ProjectRepository projectRepository(Ref ref) =>
    ProjectRepository(ref.watch(dioClientProvider));

@riverpod
Future<Map<String, List<Urbanizacion>>> projectsByPais(Ref ref) =>
    ref.watch(projectRepositoryProvider).fetchByPais();

@riverpod
Future<List<Urbanizacion>> urbanizacionesByPais(
  Ref ref,
  String pais,
) async {
  final all = await ref.watch(projectsByPaisProvider.future);
  return all[pais] ?? [];
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

@riverpod
Future<List<TenantOption>> tenantOptionsBySubdivision(
  Ref ref,
  String pais,
  String subdivision,
) async {
  final items = await ref.watch(
      urbanizacionesBySubdivisionProvider(pais, subdivision).future);
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
        ubicacionTexto: urb.ubicacionTexto,
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
        ubicacionTexto: urb.ubicacionTexto,
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
