import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/notificacion.dart';
import '../../providers/notificacion_provider.dart';

class NotificacionesScreen extends ConsumerWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificacionesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          async.when(data: (l) => l.any((n) => !n.leido), loading: () => false, error: (_, __) => false)
              ? TextButton(
                  onPressed: () => ref
                      .read(notificacionesProvider.notifier)
                      .marcarTodasLeidas(),
                  child: const Text('Leer todas'),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          onRetry: () => ref.invalidate(notificacionesProvider),
        ),
        data: (notifs) => notifs.isEmpty
            ? const _EmptyView()
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: notifs.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 72),
                itemBuilder: (context, i) => _NotifTile(
                  notif: notifs[i],
                  onTap: () => _onTap(context, ref, notifs[i]),
                ).animate().fadeIn(delay: (i * 30).ms),
              ),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref, Notificacion notif) {
    if (!notif.leido) {
      ref
          .read(notificacionesProvider.notifier)
          .marcarLeida(notif.id);
    }
    // Navegar según el tipo
    switch (notif.tipo) {
      case 'alicuota_generated':
      case 'cobro_vencido':
        context.push(AppRoutes.alicuotas);
      case 'document_uploaded':
        context.push(AppRoutes.documentos);
      default:
        break;
    }
  }
}

class _NotifTile extends StatelessWidget {
  final Notificacion notif;
  final VoidCallback onTap;

  const _NotifTile({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconForTipo(notif.tipo);
    final timeAgo = _timeAgo(notif.createdAt);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: notif.leido
            ? null
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono con punto de no leído
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (!notif.leido)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        notif.titulo,
                        style: TextStyle(
                          fontWeight: notif.leido
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _iconForTipo(String? tipo) => switch (tipo) {
        'alicuota_generated' => (
            Icons.receipt_long_outlined,
            Colors.blue
          ),
        'cobro_vencido' => (Icons.warning_amber_outlined, Colors.orange),
        'document_uploaded' => (
            Icons.folder_outlined,
            Colors.purple
          ),
        'pago_recibido' => (Icons.check_circle_outline, Colors.green),
        _ => (Icons.notifications_outlined, Colors.grey),
      };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('dd/MM').format(dt);
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('Sin notificaciones',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Aquí aparecerán tus alertas',
              style: TextStyle(
                  color: Colors.grey.shade400, fontSize: 13)),
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
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          const Text('No se pudo cargar las notificaciones'),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
