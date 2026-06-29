import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/reserva.dart';
import '../../providers/reserva_provider.dart';

class TramitesScreen extends ConsumerWidget {
  const TramitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(misReservasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Trámites')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
            onRetry: () => ref.invalidate(misReservasProvider)),
        data: (reservas) => reservas.isEmpty
            ? const _EmptyView()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reservas.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _ReservaCard(
                  reserva: reservas[i],
                  onTap: () => context.push(
                    AppRoutes.tramiteDetalle
                        .replaceFirst(':reservaId', reservas[i].id),
                  ),
                ).animate().fadeIn(delay: (i * 40).ms),
              ),
      ),
    );
  }
}

// ── Reserva card ──────────────────────────────────────────────────────────────

class _ReservaCard extends StatelessWidget {
  final Reserva reserva;
  final VoidCallback onTap;

  const _ReservaCard({required this.reserva, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy', 'es');
    final (statusColor, statusBg, statusIcon) = _estadoStyle(reserva.estado);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reserva.solarCodigo,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    _EstadoBadge(
                        label: reserva.estado.label,
                        color: statusColor),
                    const Spacer(),
                    Text(
                      fmt.format(reserva.fechaReserva.toLocal()),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ]),
                  if (reserva.fechaVencimiento != null &&
                      reserva.estado == EstadoReserva.pendientePago) ...[
                    const SizedBox(height: 6),
                    _VencimientoRow(fecha: reserva.fechaVencimiento!),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ]),
        ),
      ),
    );
  }

  (Color, Color, IconData) _estadoStyle(EstadoReserva e) => switch (e) {
        EstadoReserva.pendientePago => (
            Colors.orange.shade700,
            Colors.orange.shade50,
            Icons.schedule_rounded,
          ),
        EstadoReserva.activa => (
            Colors.blue.shade700,
            Colors.blue.shade50,
            Icons.verified_rounded,
          ),
        EstadoReserva.completada => (
            Colors.green.shade700,
            Colors.green.shade50,
            Icons.check_circle_rounded,
          ),
        EstadoReserva.cancelada => (
            Colors.grey.shade600,
            Colors.grey.shade100,
            Icons.cancel_rounded,
          ),
      };
}

class _EstadoBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _EstadoBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _VencimientoRow extends StatelessWidget {
  final DateTime fecha;
  const _VencimientoRow({required this.fecha});

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final restante = fecha.difference(ahora);
    final vencido = restante.isNegative;
    final horas = restante.inHours.abs();
    final label = vencido
        ? 'Vencida'
        : horas < 1
            ? 'Vence en menos de 1h'
            : 'Vence en $horas h';

    return Row(children: [
      Icon(
        vencido ? Icons.timer_off_outlined : Icons.timer_outlined,
        size: 12,
        color: vencido ? Colors.red : Colors.orange.shade700,
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: vencido ? Colors.red : Colors.orange.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    ]);
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
          Icon(Icons.assignment_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('Sin trámites registrados',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Tus reservas de terrenos aparecerán aquí',
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
          const Text('No se pudieron cargar los trámites'),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
