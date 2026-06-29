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
import '../../presentation/screens/documentos/documentos_screen.dart';
import '../../presentation/screens/invitaciones/invitaciones_screen.dart';
import '../../presentation/screens/notificaciones/notificaciones_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/tramites/tramites_screen.dart';
import '../../presentation/screens/tramites/tramite_detalle_screen.dart';
import '../../presentation/screens/urbanizaciones/urbanizaciones_screen.dart';
import '../../presentation/screens/garita/validar_qr_screen.dart';
import '../../presentation/screens/garita/accesos_screen.dart';
import '../../presentation/screens/alertas/sos_screen.dart';
import '../../presentation/screens/alertas/alertas_historial_screen.dart';
import '../../presentation/screens/alertas/mis_alertas_screen.dart';

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
  static const invitaciones = '/invitaciones';
  static const notificaciones = '/notificaciones';
  static const tramites = '/tramites';
  static const tramiteDetalle = '/tramites/:reservaId';
  static const profile = '/profile';
  static const validarQr = '/validar-qr';
  static const accesos = '/accesos';
  static const alertas = '/alertas';
  static const alertasHistorial = '/alertas-historial';
  static const misAlertas = '/mis-alertas';
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
        path: AppRoutes.invitaciones,
        builder: (_, _) => const InvitacionesScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentos,
        builder: (_, _) => const DocumentosScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificaciones,
        builder: (_, _) => const NotificacionesScreen(),
      ),
      GoRoute(
        path: AppRoutes.tramites,
        builder: (_, _) => const TramitesScreen(),
      ),
      GoRoute(
        path: AppRoutes.tramiteDetalle,
        builder: (_, state) => TramiteDetalleScreen(
          reservaId: state.pathParameters['reservaId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.validarQr,
        builder: (_, _) => const ValidarQrScreen(),
      ),
      GoRoute(
        path: AppRoutes.accesos,
        builder: (_, _) => const AccesosScreen(),
      ),
      GoRoute(
        path: AppRoutes.alertas,
        builder: (_, _) => const SosScreen(),
      ),
      GoRoute(
        path: AppRoutes.alertasHistorial,
        builder: (_, _) => const AlertasHistorialScreen(),
      ),
      GoRoute(
        path: AppRoutes.misAlertas,
        builder: (_, _) => const MisAlertasScreen(),
      ),
    ],
  );
}
