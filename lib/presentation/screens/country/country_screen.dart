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

/// Convierte un código ISO 3166-1 alpha-2 a emoji de bandera.
String _isoToFlag(String iso) {
  final base = 0x1F1E6 - 0x41;
  return String.fromCharCodes(iso.toUpperCase().codeUnits.map((c) => base + c));
}

/// Mapa nombre de país (como viene del backend) → ISO 3166-1 alpha-2.
const _countryIso = {
  'Argentina': 'AR', 'Bolivia': 'BO', 'Brasil': 'BR', 'Chile': 'CL',
  'Colombia': 'CO', 'Costa Rica': 'CR', 'Cuba': 'CU', 'Ecuador': 'EC',
  'El Salvador': 'SV', 'Guatemala': 'GT', 'Honduras': 'HN', 'México': 'MX',
  'Mexico': 'MX', 'Nicaragua': 'NI', 'Panamá': 'PA', 'Panama': 'PA',
  'Paraguay': 'PY', 'Perú': 'PE', 'Peru': 'PE', 'República Dominicana': 'DO',
  'Uruguay': 'UY', 'Venezuela': 'VE', 'España': 'ES', 'Spain': 'ES',
  'Estados Unidos': 'US', 'United States': 'US',
};

String _flagFor(String pais) {
  final iso = _countryIso[pais];
  return iso != null ? _isoToFlag(iso) : '🏳️';
}

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

  void _showPromo(BuildContext context) =>
      showPromoDialog(context, ref);

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
        onNotFound: () {
          Navigator.pop(context);
          context.push(AppRoutes.sandboxProjects);
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
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      '¡Hola! 👋',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn().slideY(begin: -0.2),
                    const SizedBox(height: 4),
                    Text(
                      'Selecciona tu país para continuar',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 12),
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

                          if (paises.isEmpty && _query.isNotEmpty) {
                            return _CountryNotFound(query: _query);
                          }

                          return ListView.separated(
                            itemCount: paises.length,
                            padding: const EdgeInsets.only(bottom: 8),
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final pais = paises[i];
                              return _CountryTile(
                                flag: _flagFor(pais),
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
          ),
          SafeArea(
            top: false,
            child: _BottomFabBar(
              onRegistro: () => _showPromo(context),
              onSandbox: sandboxSlug.isNotEmpty ? _goToSandbox : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet: seleccionar proyecto nuevo ──────────────────────────────────

class _NuevoProyectoSheet extends StatelessWidget {
  final Urbanizacion? tenant;
  final void Function(TenantOption) onSelect;
  final VoidCallback onNotFound;

  const _NuevoProyectoSheet({
    required this.tenant,
    required this.onSelect,
    required this.onNotFound,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    // Últimos 5 VPs (ya vienen ordenados por created desc desde el backend)
    final vps = tenant?.virtualProjects.take(1).toList() ?? [];

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
              onPressed: onNotFound,
              child: const Text('No es mi proyecto, ir a buscar'),
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

// ── Bottom FAB bar ────────────────────────────────────────────────────────────

class _BottomFabBar extends StatefulWidget {
  final VoidCallback onRegistro;
  final VoidCallback? onSandbox;
  const _BottomFabBar({required this.onRegistro, this.onSandbox});

  @override
  State<_BottomFabBar> createState() => _BottomFabBarState();
}

class _BottomFabBarState extends State<_BottomFabBar> {
  final _leftKey = GlobalKey<_SwipeFabState>();
  final _rightKey = GlobalKey<_SwipeFabState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20,
            top: 12,
            child: _SwipeFab(
              key: _leftKey,
              icon: Icons.rocket_launch_rounded,
              label: 'Crea tu proyecto gratis',
              expandsRight: true,
              onActivate: widget.onRegistro,
              onExpand: () => _rightKey.currentState?.collapse(),
            ),
          ),
          if (widget.onSandbox != null)
            Positioned(
              right: 20,
              top: 12,
              child: _SwipeFab(
                key: _rightKey,
                icon: Icons.layers_rounded,
                label: 'Explorar proyectos de prueba',
                expandsRight: false,
                expandWidth: 240.0,
                onActivate: widget.onSandbox!,
                onExpand: () => _leftKey.currentState?.collapse(),
              ),
            ),
        ],
      ),
    );
  }
}

class _CountryNotFound extends StatelessWidget {
  final String query;
  const _CountryNotFound({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Sin resultados para "$query"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Intenta con los proyectos de prueba',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
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

// ── Swipe FAB ────────────────────────────────────────────────────────────────

class _SwipeFab extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool expandsRight;
  final VoidCallback onActivate;
  final VoidCallback? onExpand;
  final double expandWidth;

  const _SwipeFab({
    super.key,
    required this.icon,
    required this.label,
    required this.expandsRight,
    required this.onActivate,
    this.onExpand,
    this.expandWidth = 190.0,
  });

  @override
  State<_SwipeFab> createState() => _SwipeFabState();
}

class _SwipeFabState extends State<_SwipeFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  static const _iconSize = 56.0;
  bool _notifiedExpand = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _ctrl.addListener(() {
      if (_ctrl.value > 0.15 && !_notifiedExpand) {
        _notifiedExpand = true;
        widget.onExpand?.call();
      } else if (_ctrl.value <= 0.15) {
        _notifiedExpand = false;
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void collapse() {
    _ctrl.animateTo(0.0, curve: Curves.easeIn);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    final delta = widget.expandsRight ? d.delta.dx : -d.delta.dx;
    _ctrl.value = (_ctrl.value + delta / widget.expandWidth).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails d) {
    if (_ctrl.value >= 0.5) {
      _ctrl.animateTo(1.0, curve: Curves.easeOut).then((_) {
        widget.onActivate();
        _ctrl.animateTo(0.0, curve: Curves.easeIn);
      });
    } else {
      _ctrl.animateTo(0.0, curve: Curves.easeIn);
    }
  }

  void _onTap() {
    if (_ctrl.value >= 0.85) {
      widget.onActivate();
      _ctrl.animateTo(0.0, curve: Curves.easeIn);
    } else if (_ctrl.value < 0.1) {
      _ctrl.animateTo(1.0, curve: Curves.easeOut).then((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _ctrl.value >= 0.9) {
            _ctrl.animateTo(0.0, curve: Curves.easeIn);
          }
        });
      });
    } else {
      _ctrl.animateTo(1.0, curve: Curves.easeOut).then((_) {
        widget.onActivate();
        _ctrl.animateTo(0.0, curve: Curves.easeIn);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: _onTap,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final extra = widget.expandWidth * _ctrl.value;
          final w = _iconSize + extra;
          final textOpacity = ((extra - 30) / 80).clamp(0.0, 1.0);
          return Container(
            width: w,
            height: _iconSize,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(_iconSize / 2),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: widget.expandsRight
                ? Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(widget.icon, color: Colors.white, size: 24),
                      if (extra > 10) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Opacity(
                              opacity: textOpacity,
                              child: Text(
                                widget.label,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else
                        const SizedBox(width: 16),
                    ],
                  )
                : Row(
                    children: [
                      if (extra > 10) ...[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Opacity(
                              opacity: textOpacity,
                              child: Text(
                                widget.label,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ] else
                        const SizedBox(width: 16),
                      Icon(widget.icon, color: Colors.white, size: 24),
                      const SizedBox(width: 16),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
