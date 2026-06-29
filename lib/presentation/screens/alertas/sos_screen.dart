import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../../core/services/location_service.dart';
import '../../providers/alertas_provider.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  bool _sending = false;
  bool _sent = false;
  String? _error;

  Future<void> _enviarSos() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Confirmar alerta SOS'),
        content: const Text(
          'Se notificará de inmediato a todos los guardias del proyecto con tu ubicación. ¿Confirmas que necesitas asistencia?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, enviar SOS'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      final coords = await LocationService.getCurrentCoords();
      await ref.read(alertasDatasourceProvider).send(
            tipo: 'sos',
            mensaje: '¡ALERTA DE AUXILIO SOS! El residente solicita asistencia inmediata.',
            coordenadas: coords,
          );
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) setState(() => _error = 'No se pudo enviar la alerta. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.misAlertas),
            icon: const Icon(Icons.history_rounded, size: 18),
            label: const Text('Mis alertas'),
          ),
        ],
      ),
      body: _sent ? _SentView() : _ActionView(
        sending: _sending,
        error: _error,
        onSos: _enviarSos,
        onReporte: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _ReporteSheet()),
        ),
      ),
    );
  }
}

// ── Enviado ───────────────────────────────────────────────────────────────────

class _SentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 72),
            ).animate().scale(begin: const Offset(0.5, 0.5), duration: 400.ms),
            const SizedBox(height: 24),
            const Text('Alerta enviada',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Los guardias han sido notificados. Mantente en un lugar seguro.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Acciones ──────────────────────────────────────────────────────────────────

class _ActionView extends StatelessWidget {
  final bool sending;
  final String? error;
  final VoidCallback onSos;
  final VoidCallback onReporte;

  const _ActionView({
    required this.sending,
    required this.error,
    required this.onSos,
    required this.onReporte,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Botón SOS
          _AlertCard(
            icon: Icons.sos_rounded,
            iconColor: Colors.white,
            bgColor: Colors.red,
            title: 'Botón de Pánico (SOS)',
            subtitle: 'Notifica de inmediato a todos los guardias con tu ubicación. Úsalo solo en emergencias.',
            onTap: sending ? null : onSos,
            child: sending
                ? const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: LinearProgressIndicator(color: Colors.white),
                  )
                : null,
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Botón Reporte
          _AlertCard(
            icon: Icons.report_outlined,
            iconColor: Colors.orange,
            bgColor: Colors.orange.shade50,
            title: 'Reporte de Seguridad',
            subtitle: 'Reporta una situación sospechosa, daño en instalaciones u otro incidente.',
            onTap: onReporte,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

          if (error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13))),
              ]),
            ),
          ],
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? child;

  const _AlertCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.grey),
              ]),
              const SizedBox(height: 10),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reporte sheet ─────────────────────────────────────────────────────────────

class _ReporteSheet extends ConsumerStatefulWidget {
  const _ReporteSheet();

  @override
  ConsumerState<_ReporteSheet> createState() => _ReporteSheetState();
}

class _ReporteSheetState extends ConsumerState<_ReporteSheet> {
  final _formKey = GlobalKey<FormState>();
  final _msgCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await ref.read(alertasDatasourceProvider).send(
            tipo: 'reporte',
            mensaje: _msgCtrl.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte enviado correctamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo enviar el reporte'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de Seguridad')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Describe con detalle lo que observaste. El equipo de seguridad revisará tu reporte.',
                    style: TextStyle(
                        fontSize: 13, color: Colors.orange.shade800),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _msgCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Descripción del incidente',
                hintText: 'Ej: Vi una persona desconocida rondando el sector B...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().length < 10
                  ? 'Mínimo 10 caracteres'
                  : null,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _sending ? null : _submit,
              icon: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(_sending ? 'Enviando...' : 'Enviar reporte'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
