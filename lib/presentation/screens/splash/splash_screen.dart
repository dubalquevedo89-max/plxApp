import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../../core/storage/session_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final host = SessionStorage.activeHost;
    if (host != null) {
      final jwt = await SessionStorage.getJwt(host);
      if (!mounted) return;
      if (jwt != null) {
        context.go(AppRoutes.home);
        return;
      }
    }
    if (!mounted) return;
    context.go(AppRoutes.country);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_city_rounded, size: 72, color: Colors.white)
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.6, 0.6)),
            const SizedBox(height: 20),
            Text(
              'Parcelux',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2),
            const SizedBox(height: 8),
            Text(
              'Portal de Residentes',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ).animate().fadeIn(delay: 700.ms),
          ],
        ),
      ),
    );
  }
}
