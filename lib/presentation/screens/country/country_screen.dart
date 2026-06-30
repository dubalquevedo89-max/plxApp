import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/tenant_option.dart';
import '../../../domain/entities/urbanizacion.dart';
import '../../providers/tenant_provider.dart';
import '../../widgets/promo_fab.dart';

const _flags = {
  'Ecuador': '🇪🇨',
  'Colombia': '🇨🇴',
  'Perú': '🇵🇪',
  'Panamá': '🇵🇦',
};

class CountryScreen extends ConsumerStatefulWidget {
  const CountryScreen({super.key});

  @override
  ConsumerState<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends ConsumerState<CountryScreen>
    with WidgetsBindingObserver {

  bool _pendingCheck = false;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _pendingCheck = true);
    }
  }

  void _goToSandbox() {
    if (!mounted) return;
    context.push(AppRoutes.sandboxProjects);
  }

  Future<void> _showSheet() async {
    if (!mounted) return;

    Map<String, List<Urbanizacion>> projects;
    try {
      projects = await ref.refresh(projectsByPaisProvider.future);
    } catch (_) {
      projects = ref.read(projectsByPaisProvider).value ?? {};
    }

    if (!mounted) return;

    final sandboxSlug = dotenv.env['SANDBOX_SLUG'] ?? '';
    Urbanizacion? pruebasTenant;
    for (final urbs in projects.values) {
      for (final urb in urbs) {
        if (urb.slug == sandboxSlug) {
          pruebasTenant = urb;
          break;
        }
      }
      if (pruebasTenant != null) break;
    }

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _NuevoProyectoSheet(
        tenant: pruebasTenant,
        onSelect: (option) {
          Navigator.pop(context);
          context.push(AppRoutes.login, extra: option);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opened = ref.watch(registroOpenedProvider);
    final projectsAsync = ref.watch(projectsByPaisProvider);

    if (_pendingCheck && opened) {
      _pendingCheck = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(registroOpenedProvider.notifier).set(false);
        _showSheet();
      });
    }

    final sandboxSlug = dotenv.env['SANDBOX_SLUG'] ?? '';

    return Scaffold(
      floatingActionButton: const PromoFab(),
      bottomNavigationBar: sandboxSlug.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _SandboxTile(onTap: _goToSandbox),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn().slideY(begin: -0.2),
              const SizedBox(height: 8),
              Text(
                '¿En qué país se encuentra tu urbanización?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 16),
              SearchBar(
                controller: _searchCtrl,
                hintText: 'Buscar país…',
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
                onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: projectsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _ErrorView(
                      onRetry: () => ref.invalidate(projectsByPaisProvider)),
                  data: (byPais) {
                    final paises = byPais.keys
                        .where((p) => byPais[p]!.any((u) => u.slug != sandboxSlug))
                        .where((p) => _query.isEmpty || p.toLowerCase().contains(_query))
                        .toList()
                      ..sort();

                    return ListView.separated(
                      itemCount: paises.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final pais = paises[i];
                        return _CountryTile(
                          flag: _flags[pais] ?? '🏳️',
                          pais: pais,
                          onTap: () => context.push(
                            AppRoutes.urbanizaciones,
                            extra: pais,
                          ),
                        ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: -0.1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom sheet: seleccionar proyecto nuevo ──────────────────────────────────

class _NuevoProyectoSheet extends StatelessWidget {
  final Urbanizacion? tenant;
  final void Function(TenantOption) onSelect;

  const _NuevoProyectoSheet({required this.tenant, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    // Últimos 5 VPs (ya vienen ordenados por created desc desde el backend)
    final vps = tenant?.virtualProjects.take(5).toList() ?? [];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Icon(Icons.celebration_rounded, size: 48, color: primary)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1),
                        duration: 700.ms),
                const SizedBox(height: 12),
                Text(
                  '¡Tu proyecto ya está listo!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona tu proyecto para iniciar sesión',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (tenant == null || vps.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No encontramos proyectos recientes. Búscalo manualmente en la sección de tu país.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vps.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final vp = vps[i];
                final option = TenantOption(
                  slug: vp.slug,
                  nombre: vp.nombre,
                  primaryColor: vp.primaryColor,
                  host: tenant!.host,
                  virtualProjectSlug: vp.slug,
                  parentNombre: tenant!.nombre,
                  parentSlug: tenant!.slug,
                );
                return Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor:
                          Color(int.tryParse('0xFF${vp.primaryColor.replaceAll('#', '')}') ??
                              0xFF000000),
                      child: Text(
                        vp.nombre.isNotEmpty ? vp.nombre[0].toUpperCase() : '?',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(vp.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(vp.slug,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                    trailing: const Icon(Icons.login_rounded),
                    onTap: () => onSelect(option),
                  ),
                ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: 0.1);
              },
            ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No es ninguno de estos'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Reutilizables ─────────────────────────────────────────────────────────────

class _CountryTile extends StatelessWidget {
  final String flag;
  final String pais;
  final VoidCallback onTap;

  const _CountryTile({
    required this.flag,
    required this.pais,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Text(flag, style: const TextStyle(fontSize: 36)),
        title: Text(pais,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 17)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _SandboxTile extends StatelessWidget {
  final VoidCallback onTap;
  const _SandboxTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primary.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.science_rounded, color: primary),
        ),
        title: Text(
          '¡Tengo un proyecto de pruebas!',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: primary),
        ),
        subtitle: const Text('Accede a tu proyecto sandbox', style: TextStyle(fontSize: 12)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primary),
        onTap: onTap,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 56),
          const SizedBox(height: 16),
          const Text('No se pudo cargar la información'),
          const SizedBox(height: 12),
          FilledButton(
              onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
