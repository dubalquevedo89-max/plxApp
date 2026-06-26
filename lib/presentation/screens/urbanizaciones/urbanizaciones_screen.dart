import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/tenant_option.dart';
import '../../providers/tenant_provider.dart';

class UrbanizacionesScreen extends ConsumerStatefulWidget {
  final String pais;
  const UrbanizacionesScreen({super.key, required this.pais});

  @override
  ConsumerState<UrbanizacionesScreen> createState() =>
      _UrbanizacionesScreenState();
}

class _UrbanizacionesScreenState extends ConsumerState<UrbanizacionesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedSubdivision;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subdivAsync = ref.watch(subdivisionesByPaisProvider(widget.pais));

    return subdivAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (subdivisions) {
        // Selecciona la primera por defecto
        final active = _selectedSubdivision ??
            (subdivisions.isNotEmpty ? subdivisions.first : null);

        final listAsync = active != null
            ? ref.watch(tenantOptionsBySubdivisionProvider(widget.pais, active))
            : ref.watch(tenantOptionsByPaisProvider(widget.pais));

        return Scaffold(
          appBar: AppBar(title: Text(widget.pais)),
          body: Column(
            children: [
              // Chips de provincia
              if (subdivisions.isNotEmpty)
                _SubdivisionChips(
                  subdivisions: subdivisions,
                  selected: active,
                  onSelected: (sub) => setState(() {
                    _selectedSubdivision = sub;
                    _searchCtrl.clear();
                    _query = '';
                  }),
                ),
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: SearchBar(
                  controller: _searchCtrl,
                  hintText: 'Buscar urbanización…',
                  leading: const Icon(Icons.search_rounded),
                  trailing: [
                    if (_query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                  ],
                  onChanged: (v) =>
                      setState(() => _query = v.trim().toLowerCase()),
                ),
              ),
              // Lista
              Expanded(
                child: listAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (items) {
                    final filtered = _query.isEmpty
                        ? items
                        : items
                            .where((t) =>
                                t.nombre.toLowerCase().contains(_query) ||
                                (t.ubicacionTexto
                                        ?.toLowerCase()
                                        .contains(_query) ??
                                    false) ||
                                (t.parentNombre
                                        ?.toLowerCase()
                                        .contains(_query) ??
                                    false))
                            .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_off_rounded,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(
                              _query.isEmpty
                                  ? 'No hay proyectos en esta zona'
                                  : 'Sin resultados para "$_query"',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _TenantCard(
                        option: filtered[i],
                        onTap: () => context.push(
                          AppRoutes.login,
                          extra: filtered[i],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (i * 50).ms)
                          .slideY(begin: 0.08),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubdivisionChips extends StatelessWidget {
  final List<String> subdivisions;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _SubdivisionChips({
    required this.subdivisions,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: subdivisions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final sub = subdivisions[i];
          final isSelected = sub == selected;
          return FilterChip(
            label: Text(sub),
            selected: isSelected,
            onSelected: (_) => onSelected(sub),
            showCheckmark: false,
            labelStyle: TextStyle(
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}

class _TenantCard extends StatelessWidget {
  final TenantOption option;
  final VoidCallback onTap;
  const _TenantCard({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Color(
      int.parse('FF${option.primaryColor.replaceAll('#', '')}', radix: 16),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 6, color: primary),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _Logo(logoUrl: option.logoUrl, primary: primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (option.parentNombre != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'by ${option.parentNombre}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                        if (option.ubicacionTexto != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  option.ubicacionTexto!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String? logoUrl;
  final Color primary;
  const _Logo({this.logoUrl, required this.primary});

  @override
  Widget build(BuildContext context) {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: logoUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _fallback(primary),
        ),
      );
    }
    return _fallback(primary);
  }

  Widget _fallback(Color color) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.location_city_rounded, color: color),
      );
}
