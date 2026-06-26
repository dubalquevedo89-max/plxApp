import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/tenant_option.dart';
import '../../presentation/screens/country/country_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/map/map_screen.dart';
import '../../presentation/screens/qr_access/qr_access_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/alicuotas/alicuotas_screen.dart';
import '../../presentation/screens/alicuotas/mis_propiedades_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/urbanizaciones/urbanizaciones_screen.dart';

part 'app_router.g.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const country = '/country';
  static const urbanizaciones = '/urbanizaciones';
  static const login = '/login';
  static const home = '/home';
  static const qrAccess = '/qr-access';
  static const map = '/map';
  static const misPropiedades = '/mis-propiedades';
  static const alicuotas = '/alicuotas';
  static const documentos = '/documentos';
  static const profile = '/profile';
  static const timeline = '/timeline/:reservaId';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.country,
        builder: (_, _) => const CountryScreen(),
      ),
      GoRoute(
        path: AppRoutes.urbanizaciones,
        builder: (_, state) =>
            UrbanizacionesScreen(pais: state.extra as String),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, state) =>
            LoginScreen(tenant: state.extra as TenantOption),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.qrAccess,
        builder: (_, _) => const QrAccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) {
          final tenant = state.extra as TenantOption?;
          if (tenant == null) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => context.pop());
            return const SizedBox.shrink();
          }
          return MapScreen(tenant: tenant);
        },
      ),
      GoRoute(
        path: AppRoutes.misPropiedades,
        builder: (_, _) => const MisPropiedadesScreen(),
      ),
      GoRoute(
        path: AppRoutes.alicuotas,
        builder: (_, _) => const AlicuotasScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentos,
        builder: (_, _) => const _Placeholder('Documentos'),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.timeline,
        builder: (_, state) =>
            _Placeholder('Timeline · ${state.pathParameters['reservaId']}'),
      ),
    ],
  );
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(title)),
      );
}
