import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/tenant_provider.dart';

String get _registroUrl {
  return kDebugMode
      ? (dotenv.env['REGISTER_URL_DEV'] ?? dotenv.env['REGISTER_URL'] ?? 'http://localhost:8000/registro')
      : (dotenv.env['REGISTER_URL'] ?? 'https://plxmap.com/registro');
}

class PromoFab extends ConsumerWidget {
  const PromoFab({super.key});

  Future<void> _showPromoDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (ctx) => _PromoDialog(ref: ref),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    return FloatingActionButton.extended(
      onPressed: () => _showPromoDialog(context, ref),
      backgroundColor: primary,
      elevation: 4,
      icon: const Icon(Icons.rocket_launch_rounded, color: Colors.white),
      label: const Text(
        '¡Crea tu proyecto!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    )
        .animate(delay: 600.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.4, duration: 500.ms, curve: Curves.easeOutBack);
  }
}

class _PromoDialog extends StatefulWidget {
  final WidgetRef ref;
  const _PromoDialog({required this.ref});

  @override
  State<_PromoDialog> createState() => _PromoDialogState();
}

class _PromoDialogState extends State<_PromoDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _openRegistro() async {
    Navigator.of(context).pop();
    final uri = Uri.parse(_registroUrl);
    widget.ref.read(registroOpenedProvider.notifier).set(true);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ScaleTransition(
      scale: _scale,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header degradado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withValues(alpha: 0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.rocket_launch_rounded,
                      color: Colors.white, size: 52)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(
                          begin: 0,
                          end: -6,
                          duration: 900.ms,
                          curve: Curves.easeInOut),
                  const SizedBox(height: 14),
                  const Text(
                    '¿Tienes un proyecto\nde urbanización?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Cuerpo
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                children: [
                  _Feature(
                    icon: Icons.home_work_rounded,
                    text: 'Gestiona reservas y ventas de tu proyecto inmobiliario en un solo lugar',
                  ),
                  const SizedBox(height: 12),
                  _Feature(
                    icon: Icons.people_rounded,
                    text: 'Administra residentes, alícuotas, accesos y más de tu urbanización',
                  ),
                  const SizedBox(height: 12),
                  _Feature(
                    icon: Icons.free_cancellation_rounded,
                    text: 'Prueba gratis, sin tarjeta de crédito',
                  ),
                  const SizedBox(height: 24),

                  // Botón principal
                  FilledButton.icon(
                    onPressed: _openRegistro,
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Crear mi proyecto gratis'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Ahora no',
                      style: TextStyle(color: Colors.grey.shade500),
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

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(text,
                style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ),
      ],
    );
  }
}
