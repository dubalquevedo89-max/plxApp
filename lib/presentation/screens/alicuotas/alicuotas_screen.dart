import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/alicuota.dart';
import '../../providers/alicuota_provider.dart';
import 'reportar_pago_sheet.dart';

class AlicuotasScreen extends ConsumerStatefulWidget {
  const AlicuotasScreen({super.key});

  @override
  ConsumerState<AlicuotasScreen> createState() => _AlicuotasScreenState();
}

class _AlicuotasScreenState extends ConsumerState<AlicuotasScreen> {
  late DateTime _desde = DateTime(DateTime.now().year);
  late DateTime _hasta = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      misPagosProvider(desde: _desde, hasta: _hasta),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alícuotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filtrar período',
            onPressed: () => _showFilter(context),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          // 403 = módulo no habilitado para este proyecto
          final is403 = e is DioException && e.response?.statusCode == 403;
          if (is403) return const _ModuloNoDisponible();
          return _ErrorView(
            onRetry: () => ref.invalidate(misPagosProvider),
          );
        },
        data: (data) => _Body(
          data: data,
          desde: _desde,
          hasta: _hasta,
        ),
      ),
    );
  }

  Future<void> _showFilter(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _desde, end: _hasta),
      helpText: 'Selecciona el período',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      locale: const Locale('es'),
    );
    if (range != null) {
      setState(() {
        _desde = range.start;
        _hasta = range.end;
      });
    }
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final HistorialPagos data;
  final DateTime desde;
  final DateTime hasta;

  const _Body({required this.data, required this.desde, required this.hasta});

  @override
  Widget build(BuildContext context) {
    final cobros = data.cobros;
    final pagados = cobros.where((c) => c.isPagado).toList();
    final pendientes = cobros.where((c) => c.isPendiente).toList();

    final totalPagado = pagados.fold(0.0, (s, c) => s + c.monto);
    final totalPendiente = pendientes.fold(0.0, (s, c) => s + c.monto);
    final totalFacturado = totalPagado + totalPendiente;
    final pct = totalFacturado > 0
        ? (totalPagado / totalFacturado * 100).round()
        : 0;

    // Distribution by tipo_cargo (only non-anulado)
    final activos = cobros.where((c) => !c.isAnulado).toList();
    final dist = _distribution(activos);

    // Period label
    final fmt = DateFormat('dd MMM', 'es');
    final period = '${fmt.format(desde)} – ${fmt.format(hasta)}';

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period chip
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.calendar_today_outlined,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 6),
                Text(period,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500)),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(children: [
            Expanded(
                child: _StatCard(
              label: 'VALORES PAGADOS',
              value: '\$${totalPagado.toStringAsFixed(2)}',
              sub: 'Total en expensas pagadas',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              highlight: false,
            ).animate().fadeIn(delay: 50.ms)),
            const SizedBox(width: 12),
            Expanded(
                child: _StatCard(
              label: 'SALDO PENDIENTE',
              value: '\$${totalPendiente.toStringAsFixed(2)}',
              sub: 'Cargos pendientes de pago',
              icon: Icons.warning_amber_outlined,
              iconColor: Colors.orange,
              highlight: totalPendiente > 0,
            ).animate().fadeIn(delay: 100.ms)),
          ]),
          const SizedBox(height: 12),

          // Chart + registros
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DonutCard(
                  pct: pct,
                  pagado: totalPagado,
                  facturado: totalFacturado,
                ).animate().fadeIn(delay: 150.ms),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RegistrosCard(
                  total: cobros.length,
                  pagados: pagados.length,
                  pendientes: pendientes.length,
                ).animate().fadeIn(delay: 200.ms),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Distribución — ancho completo
          _DistributionCard(dist: dist, total: totalFacturado)
              .animate()
              .fadeIn(delay: 250.ms),
          const SizedBox(height: 20),

          // Cobros list
          if (cobros.isEmpty)
            const _EmptyView(
              icon: Icons.receipt_long_outlined,
              message: 'Sin cobros en este período.',
            )
          else ...[
            Text('Detalle de cobros',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...cobros.asMap().entries.map((e) => _CobroCard(
                  cobro: e.value,
                  allowCardPayments: data.allowCardPayments,
                ).animate().fadeIn(delay: (e.key * 40 + 250).ms)),
          ],
        ],
      ),
    );
  }

  Map<String, double> _distribution(List<Cobro> cobros) {
    final map = <String, double>{};
    for (final c in cobros) {
      final key = c.tipoCargo.endsWith('_saldo')
          ? c.tipoCargo.substring(0, c.tipoCargo.length - '_saldo'.length)
          : c.tipoCargo;
      map[key] = (map[key] ?? 0) + c.monto;
    }
    return map;
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color iconColor;
  final bool highlight;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.iconColor,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: highlight
            ? BorderSide(color: Colors.orange.shade300, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5)),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
            ]),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.orange.shade700 : iconColor)),
            const SizedBox(height: 4),
            Text(sub,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

// ── Donut chart ───────────────────────────────────────────────────────────────

class _DonutCard extends StatelessWidget {
  final int pct;
  final double pagado;
  final double facturado;

  const _DonutCard(
      {required this.pct, required this.pagado, required this.facturado});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CUMPLIMIENTO',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5)),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sectionsSpace: 2,
                      centerSpaceRadius: 42,
                      sections: [
                        PieChartSectionData(
                          value: pct.toDouble(),
                          color: primary,
                          radius: 18,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: (100 - pct).toDouble(),
                          color: Colors.grey.shade200,
                          radius: 18,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$pct%',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('PAGADO',
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.5)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pagado \$${pagado.toStringAsFixed(2)} de \$${facturado.toStringAsFixed(2)}',
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Registros card ────────────────────────────────────────────────────────────

class _RegistrosCard extends StatelessWidget {
  final int total;
  final int pagados;
  final int pendientes;

  const _RegistrosCard({
    required this.total,
    required this.pagados,
    required this.pendientes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REGISTROS',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5)),
            const SizedBox(height: 12),
            Text('$total',
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            Text('cobros encontrados',
                style:
                    TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            _RegistroRow(
              icon: Icons.check_circle_outline,
              color: Colors.green,
              label: 'Pagados',
              count: pagados,
            ),
            const SizedBox(height: 6),
            _RegistroRow(
              icon: Icons.schedule_outlined,
              color: Colors.orange,
              label: 'Pendientes',
              count: pendientes,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistroRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int count;

  const _RegistroRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 6),
      Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
      Text('$count',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color)),
    ]);
  }
}

// ── Distribution card ─────────────────────────────────────────────────────────

class _DistributionCard extends StatelessWidget {
  final Map<String, double> dist;
  final double total;

  const _DistributionCard({required this.dist, required this.total});

  static const _meta = <String, (String, Color)>{
    'alicuota':       ('Alícuota',                        Colors.blue),
    'arrendamiento':  ('Arrendamiento',                   Colors.indigo),
    'multa':          ('Multa',                           Colors.red),
    'extraordinaria': ('Extraordinaria',                  Colors.purple),
    'consumo':        ('Consumo',                         Colors.teal),
    'cuota':          ('Cuota · Venta a Crédito/Contado', Colors.green),
  };

  static (String, Color) _resolve(String tipo) {
    if (_meta.containsKey(tipo)) return _meta[tipo]!;
    if (tipo.endsWith('_saldo')) {
      final base = tipo.replaceAll('_saldo', '');
      final baseMeta = _meta[base];
      if (baseMeta != null) return ('${baseMeta.$1} · Saldo', baseMeta.$2);
    }
    return (tipo, Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    // Todos los tipos presentes en los cobros, conocidos primero
    final knownOrder = _meta.keys.where(dist.containsKey).toList();
    final unknown = dist.keys.where((k) => !_meta.containsKey(k)).toList();
    final allKeys = [...knownOrder, ...unknown];

    final palette = [
      Colors.blue, Colors.red, Colors.purple,
      Colors.teal, Colors.indigo, Colors.orange,
      Colors.green, Colors.brown, Colors.pink,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DISTRIBUCIÓN',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5)),
            const SizedBox(height: 12),
            ...allKeys.asMap().entries.map((e) {
              final key = e.value;
              final resolved = _resolve(key);
              final label = resolved.$1;
              final color = resolved.$2 == Colors.grey
                  ? palette[e.key % palette.length]
                  : resolved.$2;
              final monto = dist[key] ?? 0;
              final pct = total > 0 ? monto / total : 0.0;
              return _DistRow(label: label, monto: monto, pct: pct, color: color);
            }),
          ],
        ),
      ),
    );
  }
}

class _DistRow extends StatelessWidget {
  final String label;
  final double monto;
  final double pct;
  final Color color;

  const _DistRow({
    required this.label,
    required this.monto,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            Text(
              '\$${monto.toStringAsFixed(2)} (${(pct * 100).round()}%)',
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cobro card ────────────────────────────────────────────────────────────────

class _CobroCard extends StatelessWidget {
  final Cobro cobro;
  final bool allowCardPayments;

  const _CobroCard(
      {required this.cobro, required this.allowCardPayments});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: '\$');
    final (color, icon, label) = _estadoStyle(cobro.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cobro.inmuebleCodigo,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      cobro.descripcion ??
                          '${_mes(cobro.mes)} ${cobro.anio}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(currency.format(cobro.monto),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  _EstadoBadge(color: color, icon: icon, label: label),
                ],
              ),
            ]),
            const SizedBox(height: 8),
            _TipoBadge(tipo: cobro.tipoCargo),
            if (cobro.fechaPago != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text(
                  'Pagado el ${DateFormat('dd/MM/yyyy').format(cobro.fechaPago!)}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.green.shade700),
                ),
              ]),
            ],
            if (cobro.comprobanteUrl != null || cobro.isPendiente) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(children: [
                if (cobro.comprobanteUrl != null) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openUrl(cobro.comprobanteUrl!),
                      icon: const Icon(Icons.receipt_outlined, size: 16),
                      label: const Text('Ver comprobante'),
                      style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8)),
                    ),
                  ),
                  if (cobro.isPendiente) const SizedBox(width: 8),
                ],
                if (cobro.isPendiente)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        builder: (_) => ReportarPagoSheet(cobro: cobro),
                      ),
                      icon: const Icon(Icons.upload_outlined, size: 16),
                      label: Text(cobro.comprobanteUrl != null
                          ? 'Reemplazar pago'
                          : 'Reportar pago'),
                      style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8)),
                    ),
                  ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  (Color, IconData, String) _estadoStyle(String estado) => switch (estado) {
        'pagado' => (Colors.green, Icons.check_circle_outline, 'Pagado'),
        'revision' => (Colors.blue, Icons.hourglass_top_outlined, 'En revisión'),
        'vencido' => (Colors.red, Icons.error_outline, 'Vencido'),
        'anulado' => (Colors.grey, Icons.cancel_outlined, 'Anulado'),
        _ => (Colors.orange, Icons.schedule_outlined, 'Pendiente'),
      };

  String _mes(int m) => const [
        '',
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ][m];
}

// ── Shared small widgets ──────────────────────────────────────────────────────

class _EstadoBadge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _EstadoBadge(
      {required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _TipoBadge extends StatelessWidget {
  final String tipo;
  const _TipoBadge({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _DistributionCard._resolve(tipo);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(message,
                style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ModuloNoDisponible extends StatelessWidget {
  const _ModuloNoDisponible();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Módulo no habilitado',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'El módulo de Alícuotas no está disponible\npara este proyecto.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text('No se pudo cargar la información.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
