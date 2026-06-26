import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/config/app_router.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/tenant_option.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final TenantOption tenant;
  const LoginScreen({super.key, required this.tenant});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  final _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkActiveSession();
  }

  Future<void> _checkActiveSession() async {
    final t = widget.tenant;
    // Key used when this tenant has a session
    final key = t.isVirtualProject
        ? '${t.virtualProjectSlug}@${t.host}'
        : t.host;
    final jwt = await SessionStorage.getJwt(key);
    if (jwt != null && mounted) {
      // Activate this tenant's session and go home
      await SessionStorage.switchProfile(key);
      if (mounted) context.go(AppRoutes.home);
      return;
    }
    _tryBiometricLogin();
  }

  Future<void> _tryBiometricLogin() async {
    final host = widget.tenant.host;
    final existing = SessionStorage.getProfile(host);
    if (existing == null) return;
    final jwt = await SessionStorage.getJwt(host);
    if (jwt == null) return;
    final canCheck = await _localAuth.canCheckBiometrics;
    if (!canCheck || !mounted) return;
    final ok = await _localAuth.authenticate(
      localizedReason: 'Accede a ${widget.tenant.nombre}',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (ok && mounted) {
      await SessionStorage.switchProfile(host);
      if (mounted) context.go(AppRoutes.home);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final t = widget.tenant;
    await ref.read(authProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          host: t.host,
          primaryColor: t.primaryColor,
          logoUrl: t.logoUrl,
          virtualProjectSlug: t.virtualProjectSlug,
          displayNombre: t.nombre,
        );
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state.hasValue && state.value != null) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tenant;
    final primary = Color(
      int.parse('FF${t.primaryColor.replaceAll('#', '')}', radix: 16),
    );
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Theme(
      data: AppTheme.fromTenantColor(t.primaryColor),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: t.logoUrl != null && t.logoUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: t.logoUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => _LogoFallback(
                                  primary: primary),
                            )
                          : _LogoFallback(primary: primary),
                    ),
                  ).animate().fadeIn().scale(begin: const Offset(0.7, 0.7)),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      t.nombre,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  if (t.parentNombre != null)
                    Center(
                      child: Text(
                        'by ${t.parentNombre}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: primary,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ).animate().fadeIn(delay: 120.ms),
                  if (t.ubicacionTexto != null)
                    Center(
                      child: Text(
                        t.ubicacionTexto!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) =>
                        v != null && v.contains('@') ? null : 'Ingresa un correo válido',
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) =>
                        v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                  ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.1),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (authState.hasError)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 8),
                          const Expanded(
                              child: Text('Credenciales incorrectas')),
                        ],
                      ),
                    ).animate().fadeIn().shake(),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Ingresar'),
                  ).animate().fadeIn(delay: 350.ms),
                  if (t.masterplanAppEnabled) ...[
                    const SizedBox(height: 20),
                    _MasterplanBanner(
                      primary: primary,
                      onTap: () => context.push(AppRoutes.map, extra: t),
                    ).animate().fadeIn(delay: 420.ms).slideY(begin: 0.08),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MasterplanBanner extends StatelessWidget {
  final Color primary;
  final VoidCallback onTap;
  const _MasterplanBanner({required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.85),
              primary.withValues(alpha: 0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Grid lines simulating map
            CustomPaint(
              size: const Size(double.infinity, 110),
              painter: _MapGridPainter(color: Colors.white),
            ),
            // Dot cluster (lotes)
            Positioned(
              right: 24,
              top: 16,
              child: _LotDots(),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 120, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.map_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'Masterplan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Explora los lotes disponibles\nsin necesidad de cuenta',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver mapa',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final Color color;
  const _MapGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _LotDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mini lot grid simulation
    const lots = [
      (0.0, 0.0, true),   // disponible
      (30.0, 0.0, false),  // vendido
      (60.0, 0.0, true),
      (0.0, 28.0, true),
      (30.0, 28.0, false),
      (60.0, 28.0, true),
      (15.0, 56.0, true),
      (45.0, 56.0, false),
    ];
    return SizedBox(
      width: 90,
      height: 80,
      child: Stack(
        children: lots.map((l) => Positioned(
          left: l.$1,
          top: l.$2,
          child: Container(
            width: 24,
            height: 22,
            decoration: BoxDecoration(
              color: l.$3
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.red.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5), width: 0.8),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  final Color primary;
  const _LogoFallback({required this.primary});

  @override
  Widget build(BuildContext context) => Container(
        width: 80,
        height: 80,
        color: primary.withValues(alpha: 0.12),
        child: Icon(Icons.location_city_rounded, color: primary, size: 42),
      );
}
