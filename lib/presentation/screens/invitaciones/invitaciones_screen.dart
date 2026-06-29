import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/utils/qr_share.dart';
import '../../../domain/entities/invitacion.dart';
import '../../providers/invitacion_provider.dart';
import '../../widgets/qr_with_logo.dart';

class InvitacionesScreen extends ConsumerWidget {
  const InvitacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(invitacionesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Invitaciones')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCrearSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva invitación'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
            onRetry: () => ref.invalidate(invitacionesProvider)),
        data: (invs) => invs.isEmpty
            ? const _EmptyView()
            : ListView.separated(
                padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: invs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _SwipeableInvitacion(
                  inv: invs[i],
                  onVerQr: () => _showQr(context, invs[i]),
                  onRevocar: () => _revocarConUndo(context, ref, invs[i]),
                ).animate().fadeIn(delay: (i * 40).ms),
              ),
      ),
    );
  }

  Future<void> _showCrearSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CrearInvitacionSheet(ref: ref),
    );
  }

  void _showQr(BuildContext context, Invitacion inv) {
    showDialog(
      context: context,
      builder: (_) => _QrDialog(inv: inv),
    );
  }

  Future<void> _revocarConUndo(
      BuildContext context, WidgetRef ref, Invitacion inv) async {
    await ref.read(invitacionesProvider.notifier).revocar(inv.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pase de ${inv.nombreInvitado} revocado'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => ref
              .read(invitacionesProvider.notifier)
              .crear(
                nombreInvitado: inv.nombreInvitado,
                telefonoInvitado: inv.telefonoInvitado,
                fechaInicio: inv.fechaInicio,
                fechaFin: inv.fechaFin,
              ),
        ),
      ),
    );
  }
}

// ── Swipeable wrapper ─────────────────────────────────────────────────────────

class _SwipeableInvitacion extends StatelessWidget {
  final Invitacion inv;
  final VoidCallback onVerQr;
  final VoidCallback onRevocar;

  const _SwipeableInvitacion({
    required this.inv,
    required this.onVerQr,
    required this.onRevocar,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(inv.id),
      // Derecha → ver QR
      background: const _SwipeBg(
        alignment: Alignment.centerLeft,
        color: Colors.indigo,
        icon: Icons.qr_code_2_rounded,
        label: 'Ver QR',
      ),
      // Izquierda → revocar
      secondaryBackground: const _SwipeBg(
        alignment: Alignment.centerRight,
        color: Colors.red,
        icon: Icons.cancel_outlined,
        label: 'Revocar',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // swipe derecha → mostrar QR, no descartar
          onVerQr();
          return false;
        } else {
          // swipe izquierda → revocar (confirmar)
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Revocar invitación'),
              content: Text('¿Cancelar el pase de ${inv.nombreInvitado}?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('No')),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Revocar')),
              ],
            ),
          );
        }
      },
      onDismissed: (_) => onRevocar(),
      child: _InvitacionCard(
        inv: inv,
        onVerQr: onVerQr,
        onRevocar: onRevocar,
      ),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;

  const _SwipeBg({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = alignment == Alignment.centerRight;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: EdgeInsets.only(
        left: isRight ? 0 : 24,
        right: isRight ? 24 : 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Invitación card ───────────────────────────────────────────────────────────

class _InvitacionCard extends StatelessWidget {
  final Invitacion inv;
  final VoidCallback onVerQr;
  final VoidCallback onRevocar;

  const _InvitacionCard({
    required this.inv,
    required this.onVerQr,
    required this.onRevocar,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'es');
    final (statusLabel, statusColor) = inv.isVigente
        ? ('Vigente', Colors.green)
        : inv.isPendiente
            ? ('Pendiente', Colors.blue)
            : ('Expirada', Colors.grey);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline,
                    color: statusColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(inv.nombreInvitado,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    if (inv.telefonoInvitado != null)
                      Text(inv.telefonoInvitado!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusLabel,
                    style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.schedule_outlined,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${fmt.format(inv.fechaInicio.toLocal())} → ${fmt.format(inv.fechaFin.toLocal())}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ]),
            if (!inv.isExpirada) ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onVerQr,
                    icon: const Icon(Icons.qr_code_2_rounded, size: 16),
                    label: const Text('Ver QR'),
                    style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '← desliza para revocar',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}

// ── QR dialog ─────────────────────────────────────────────────────────────────

class _QrDialog extends StatefulWidget {
  final Invitacion inv;
  const _QrDialog({required this.inv});

  @override
  State<_QrDialog> createState() => _QrDialogState();
}

class _QrDialogState extends State<_QrDialog> {
  final _repaintKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      // Espera un frame para asegurar que el logo terminó de renderizarse
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await shareQrFromKey(
        _repaintKey,
        shareText:
            'Pase de acceso para ${widget.inv.nombreInvitado} · Parcelux',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo compartir: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM HH:mm', 'es');
    final logoUrl = SessionStorage.activeProfile?.logoUrl;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.inv.nombreInvitado,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              '${fmt.format(widget.inv.fechaInicio.toLocal())} – ${fmt.format(widget.inv.fechaFin.toLocal())}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            RepaintBoundary(
              key: _repaintKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: QrWithLogo(
                  data: widget.inv.id,
                  size: 220,
                  logoUrl: logoUrl,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('El guardia escanea este código',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sharing ? null : _share,
                icon: _sharing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.share_outlined, size: 18),
                label: const Text('Compartir'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Crear invitación sheet ────────────────────────────────────────────────────

class _CrearInvitacionSheet extends StatefulWidget {
  final WidgetRef ref;
  const _CrearInvitacionSheet({required this.ref});

  @override
  State<_CrearInvitacionSheet> createState() =>
      _CrearInvitacionSheetState();
}

class _CrearInvitacionSheetState extends State<_CrearInvitacionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  DateTime _inicio = DateTime.now();
  DateTime _fin = DateTime.now().add(const Duration(hours: 8));
  bool _loading = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'es');
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Form(
        key: _formKey,
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
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nueva invitación',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre del invitado',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoCtrl,
              decoration: const InputDecoration(
                labelText: 'Teléfono (opcional)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            // Fecha inicio
            _DateTimeTile(
              label: 'Desde',
              value: fmt.format(_inicio),
              onTap: () async {
                final dt = await _pickDateTime(context, _inicio);
                if (dt != null) setState(() => _inicio = dt);
              },
            ),
            const SizedBox(height: 8),
            // Fecha fin
            _DateTimeTile(
              label: 'Hasta',
              value: fmt.format(_fin),
              onTap: () async {
                final dt = await _pickDateTime(context, _fin);
                if (dt != null) setState(() => _fin = dt);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Crear invitación'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDateTime(
      BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(minutes: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es'),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fin.isBefore(_inicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('La fecha de fin debe ser posterior al inicio')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final inv = await widget.ref
          .read(invitacionesProvider.notifier)
          .crear(
            nombreInvitado: _nombreCtrl.text.trim(),
            telefonoInvitado: _telefonoCtrl.text.trim(),
            fechaInicio: _inicio,
            fechaFin: _fin,
          );
      if (!mounted) return;
      Navigator.pop(context);
      if (inv != null) {
        showDialog(
          context: context,
          builder: (_) => _QrDialog(inv: inv),
        );
      }
    } catch (e) {
      if (mounted) {
        final msg = _friendlyError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
    }
    return 'Ocurrió un error al crear la invitación. Inténtalo de nuevo.';
  }
}

class _DateTimeTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined,
              size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ]),
      ),
    );
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
          Icon(Icons.group_add_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('Sin invitaciones activas',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Crea un pase para tus visitantes',
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
          const Text('No se pudieron cargar las invitaciones'),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
