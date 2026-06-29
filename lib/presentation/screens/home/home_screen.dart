import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../../core/network/tenant_profile.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notificacion_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    debugPrint('[HOME] rol=${profile?.usuarioRol} isGuardia=${profile?.isGuardia}');
    final pendientes = ref.watch(notificacionContadorProvider).when(
          data: (c) => c.pendientes,
          loading: () => 0,
          error: (_, __) => 0,
        );

    final theme = profile != null
        ? AppTheme.fromTenantColor(profile.primaryColor)
        : Theme.of(context);

    final isGuardia = profile?.isGuardia ?? false;

    return Theme(
      data: theme,
      child: isGuardia
          ? _GuardiaHome(profile: profile)
          : Scaffold(
              appBar: AppBar(
                title: Text(profile?.nombre ?? 'Parcelux'),
                actions: [
                  _ProfileSwitcherButton(currentProfile: profile),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WelcomeHeader(nombre: profile?.usuarioNombre ?? ''),
                    const SizedBox(height: 20),
                    _QrCard().animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                    const SizedBox(height: 24),
                    Text('Módulos',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _ModuleGrid(),
                  ],
                ),
              ),
              bottomNavigationBar: NavigationBar(
                destinations: [
                  const NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Inicio'),
                  const NavigationDestination(
                      icon: Icon(Icons.map_outlined),
                      selectedIcon: Icon(Icons.map),
                      label: 'Mapa'),
                  NavigationDestination(
                      icon: _NotifIcon(pendientes: pendientes),
                      selectedIcon:
                          _NotifIcon(pendientes: pendientes, selected: true),
                      label: 'Notificaciones'),
                  const NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Perfil'),
                ],
                onDestinationSelected: (i) {
                  switch (i) {
                    case 1:
                      context.push(AppRoutes.map,
                          extra:
                              SessionStorage.activeProfile?.toTenantOption());
                    case 2:
                      context.push(AppRoutes.notificaciones);
                    case 3:
                      context.push(AppRoutes.profile);
                  }
                },
              ),
            ),
    );
  }
}

// ── Profile switcher button ───────────────────────────────────────────────────

class _ProfileSwitcherButton extends ConsumerWidget {
  final TenantProfile? currentProfile;
  const _ProfileSwitcherButton({this.currentProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _showSwitcher(context, ref),
        child: _ProfileAvatar(profile: currentProfile, size: 34, isActive: true),
      ),
    );
  }

  void _showSwitcher(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ProfileSwitcherSheet(),
    );
  }
}

// ── Profile switcher sheet ────────────────────────────────────────────────────

class _ProfileSwitcherSheet extends ConsumerStatefulWidget {
  const _ProfileSwitcherSheet();

  @override
  ConsumerState<_ProfileSwitcherSheet> createState() =>
      _ProfileSwitcherSheetState();
}

class _ProfileSwitcherSheetState
    extends ConsumerState<_ProfileSwitcherSheet> {
  String? _switchingKey; // storageKey currently being verified

  @override
  Widget build(BuildContext context) {
    final profiles = SessionStorage.allProfiles();
    final activeKey = SessionStorage.activeHost;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Mis proyectos',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...profiles.map((p) {
            final isActive = p.storageKey == activeKey;
            final isLoading = _switchingKey == p.storageKey;
            return _ProfileCard(
              profile: p,
              isActive: isActive,
              isLoading: isLoading,
              onSwitch: isLoading ? null : () => _switchTo(p),
              onLogout: () => _logout(context, p),
            ).animate().fadeIn().slideX(begin: -0.05);
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.country);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar proyecto'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _switchTo(TenantProfile profile) async {
    setState(() => _switchingKey = profile.storageKey);

    final error = await _verifyProfile(profile);

    if (!mounted) return;

    if (error != null) {
      setState(() => _switchingKey = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(error)),
          ]),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange.shade700,
        ),
      );
      return;
    }

    await SessionStorage.switchProfile(profile.storageKey);
    // Invalidate reactive provider → HomeScreen rebuilds with new profile
    ref.invalidate(activeProfileProvider);
    if (!mounted) return;
    Navigator.pop(context);
  }

  // Verify using the sheet's own ref — avoids the autoDispose issue on AuthNotifier.
  Future<String?> _verifyProfile(TenantProfile profile) async {
    try {
      final token = await SessionStorage.getJwt(profile.storageKey);
      if (token == null) return 'Sin sesión guardada.';
      final repo = ref.read(authRepositoryProvider);
      await repo.me(
        profile.host,
        token: token,
        virtualProjectSlug: profile.virtualProjectSlug,
      );
      return null;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) return 'Tu sesión expiró en ${profile.nombre}.';
      if (status == 404) return '${profile.nombre} ya no está disponible.';
      return 'Sin conexión. Inténtalo más tarde.';
    } catch (e) {
      debugPrint('[verifyProfile] $e');
      return 'No se pudo verificar la sesión.';
    }
  }

  Future<void> _logout(BuildContext context, TenantProfile profile) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: Text('¿Salir de ${profile.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    // Close the sheet now that the user confirmed
    Navigator.pop(context);
    if (!context.mounted) return;

    final wasActive = SessionStorage.activeHost == profile.storageKey;
    await SessionStorage.clearProfile(profile.storageKey);

    // Notify reactive provider
    ref.invalidate(activeProfileProvider);

    if (!context.mounted) return;

    if (!wasActive) return; // removed a background profile — home stays as-is

    final hasOther = SessionStorage.activeHost != null;
    if (!hasOther) {
      context.go(AppRoutes.country);
    }
    // if hasOther, activeProfileProvider already switched to the next — HomeScreen rebuilds
  }
}

// ── Profile card ──────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final TenantProfile profile;
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onSwitch;
  final VoidCallback onLogout;

  const _ProfileCard({
    required this.profile,
    required this.isActive,
    this.isLoading = false,
    required this.onSwitch,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Color(
      int.parse('FF${profile.primaryColor.replaceAll('#', '')}', radix: 16),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isActive
            ? BorderSide(color: primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isActive || isLoading ? null : onSwitch,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              if (isLoading)
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: primary),
                )
              else
                _ProfileAvatar(profile: profile, size: 48, isActive: isActive),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.nombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('Activo',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                    if (profile.usuarioEmail != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile.usuarioEmail!,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600),
                      ),
                    ],
                    if (profile.virtualProjectSlug != null) ...[
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.layers_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text('Proyecto',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500)),
                      ]),
                    ],
                  ],
                ),
              ),
              // Logout button per profile
              IconButton(
                icon: Icon(Icons.logout_rounded,
                    size: 20, color: Colors.grey.shade500),
                tooltip: 'Cerrar sesión',
                onPressed: onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile avatar ────────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final TenantProfile? profile;
  final double size;
  final bool isActive;

  const _ProfileAvatar({this.profile, required this.size, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final primary = profile != null
        ? Color(int.parse(
            'FF${profile!.primaryColor.replaceAll('#', '')}', radix: 16))
        : Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? primary : Colors.grey.shade300,
              width: isActive ? 2 : 1,
            ),
          ),
          child: ClipOval(
            child: profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: profile!.logoUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => _Fallback(color: primary, size: size),
                  )
                : _Fallback(color: primary, size: size),
          ),
        ),
        if (isActive)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(Icons.check,
                  color: Colors.white, size: size * 0.18),
            ),
          ),
      ],
    );
  }
}

class _Fallback extends StatelessWidget {
  final Color color;
  final double size;
  const _Fallback({required this.color, required this.size});

  @override
  Widget build(BuildContext context) => Container(
        color: color.withValues(alpha: 0.12),
        child: Icon(Icons.location_city_rounded,
            color: color, size: size * 0.55),
      );
}

// ── Notification icon with badge ──────────────────────────────────────────────

class _NotifIcon extends StatelessWidget {
  final int pendientes;
  final bool selected;
  const _NotifIcon({required this.pendientes, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(selected
            ? Icons.notifications
            : Icons.notifications_outlined),
        if (pendientes > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints:
                  const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                pendientes > 99 ? '99+' : '$pendientes',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Existing widgets ──────────────────────────────────────────────────────────

class _WelcomeHeader extends StatelessWidget {
  final String nombre;
  const _WelcomeHeader({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, ${nombre.split(' ').first} 👋',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Bienvenido a tu portal',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }
}

class _QrCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      color: primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(AppRoutes.qrAccess),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.qr_code_2_rounded,
                  color: Colors.white, size: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pase de Acceso QR',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Muestra en garita · 60 seg',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      _ModuleItem(
          icon: Icons.home_work_outlined,
          label: 'Mis Propiedades',
          route: AppRoutes.misPropiedades),
      _ModuleItem(
          icon: Icons.receipt_long_outlined,
          label: 'Mis Pagos',
          route: AppRoutes.alicuotas),
      _ModuleItem(
          icon: Icons.group_add_outlined,
          label: 'Invitaciones',
          route: AppRoutes.invitaciones),
      _ModuleItem(
          icon: Icons.timeline_outlined,
          label: 'Mis Trámites',
          route: AppRoutes.tramites),
      _ModuleItem(
          icon: Icons.folder_shared_outlined,
          label: 'Documentos',
          route: AppRoutes.documentos),
      _ModuleItem(
          icon: Icons.sos_rounded,
          label: 'Alertas',
          route: AppRoutes.alertas,
          color: Colors.red),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 3;
        const spacing = 10.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: List.generate(
            items.length,
            (i) => SizedBox(
              width: itemWidth,
              height: itemWidth / 0.9,
              child: items[i]
                  .animate()
                  .fadeIn(delay: (i * 60 + 200).ms)
                  .scale(begin: const Offset(0.85, 0.85)),
            ),
          ),
        );
      },
    );
  }
}

class _ModuleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final Color? color;
  const _ModuleItem(
      {required this.icon, required this.label, required this.route, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.primary;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: iconColor),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Guardia home ──────────────────────────────────────────────────────────────

class _GuardiaHome extends ConsumerWidget {
  final TenantProfile? profile;
  const _GuardiaHome({this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    final pendientes = ref.watch(notificacionContadorProvider).when(
          data: (c) => c.pendientes,
          loading: () => 0,
          error: (_, __) => 0,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(profile?.nombre ?? 'Parcelux'),
        actions: [
          _ProfileSwitcherButton(currentProfile: profile),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Mapa'),
          NavigationDestination(
              icon: _NotifIcon(pendientes: pendientes),
              selectedIcon: _NotifIcon(pendientes: pendientes, selected: true),
              label: 'Notificaciones'),
          const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil'),
        ],
        onDestinationSelected: (i) {
          switch (i) {
            case 1:
              context.push(AppRoutes.map,
                  extra: SessionStorage.activeProfile?.toTenantOption());
            case 2:
              context.push(AppRoutes.notificaciones);
            case 3:
              context.push(AppRoutes.profile);
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeHeader(nombre: profile?.usuarioNombre ?? ''),
            const SizedBox(height: 20),

            // Banner principal: Validar acceso QR
            Card(
              color: primary,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push(AppRoutes.validarQr),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded,
                          color: Colors.white, size: 48),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Validar acceso QR',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Escanea el código QR del residente o visita',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

            const SizedBox(height: 24),
            Text('Módulos',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Módulos centrados (2)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GuardiaModule(
                  icon: Icons.history_rounded,
                  label: 'Accesos',
                  color: primary,
                  onTap: () => context.push(AppRoutes.accesos),
                  delay: 200,
                ),
                const SizedBox(width: 16),
                _GuardiaModule(
                  icon: Icons.notifications_active_rounded,
                  label: 'Alertas',
                  color: Colors.orange,
                  onTap: () => context.push(AppRoutes.alertasHistorial),
                  delay: 260,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardiaModule extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _GuardiaModule({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 10),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(
        begin: const Offset(0.85, 0.85));
  }
}
