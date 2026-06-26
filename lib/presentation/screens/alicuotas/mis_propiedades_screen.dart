import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/alicuota.dart';
import '../../providers/alicuota_provider.dart';

class MisPropiedadesScreen extends ConsumerWidget {
  const MisPropiedadesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(misPropiedadesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Propiedades')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          debugPrint('[MisPropiedades] error: $e\n$st');
          return _ErrorView(
            message: '$e',
            onRetry: () => ref.invalidate(misPropiedadesProvider),
          );
        },
        data: (data) {
          if (data.solares.isEmpty) {
            return const _EmptyView(
              icon: Icons.home_work_outlined,
              message: 'No tienes predios asignados.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(misPropiedadesProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.solares.length,
              itemBuilder: (context, i) => _SolarCard(solar: data.solares[i])
                  .animate()
                  .fadeIn(delay: (i * 80).ms)
                  .slideY(begin: 0.05),
            ),
          );
        },
      ),
    );
  }
}

// ── Solar card ────────────────────────────────────────────────────────────────

class _SolarCard extends StatelessWidget {
  final Solar solar;
  const _SolarCard({required this.solar});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: '\$');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header predio
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.landscape_outlined, color: primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(solar.codigo,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${solar.areaM2.toStringAsFixed(0)} m²',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                _AlicuotaBadge(monto: solar.alicuotaCalculada),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _StatChip(
                    label: 'Precio',
                    value: currency.format(solar.precio)),
                const SizedBox(width: 20),
                _StatChip(
                    label: 'Alícuota/mes',
                    value: currency.format(solar.alicuotaCalculada),
                    highlight: true),
              ],
            ),
          ),

          // Sub-propiedades
          if (solar.subPropiedades.isNotEmpty) ...[
            const Divider(height: 24, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.apartment_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text('Propiedad horizontal',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            ...solar.subPropiedades.map((sp) => _SubPropiedadTile(sub: sp)),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SubPropiedadTile extends StatelessWidget {
  final SubPropiedad sub;
  const _SubPropiedadTile({required this.sub});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(_tipoIcon(sub.tipo),
          size: 20, color: Theme.of(context).colorScheme.secondary),
      title: Text(sub.codigo,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(
        _tipoLabel(sub.tipo) +
            (sub.areaConstruccionM2 != null
                ? ' · ${sub.areaConstruccionM2!.toStringAsFixed(0)} m²'
                : ''),
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: _AlicuotaBadge(monto: sub.alicuotaCalculada, small: true),
    );
  }

  IconData _tipoIcon(String tipo) => switch (tipo) {
        'casa' => Icons.home_outlined,
        'departamento' => Icons.apartment_outlined,
        'local' => Icons.store_outlined,
        'oficina' => Icons.business_outlined,
        _ => Icons.domain_outlined,
      };

  String _tipoLabel(String tipo) => switch (tipo) {
        'casa' => 'Casa',
        'departamento' => 'Departamento',
        'local' => 'Local comercial',
        'oficina' => 'Oficina',
        _ => tipo,
      };
}

class _AlicuotaBadge extends StatelessWidget {
  final double monto;
  final bool small;
  const _AlicuotaBadge({required this.monto, this.small = false});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 8 : 10, vertical: small ? 3 : 5),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('\$${monto.toStringAsFixed(2)}/mes',
          style: TextStyle(
              fontSize: small ? 11 : 12,
              color: primary,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _StatChip(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: highlight
                    ? Theme.of(context).colorScheme.primary
                    : null)),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
