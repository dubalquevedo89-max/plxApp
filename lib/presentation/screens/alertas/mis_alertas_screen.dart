import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/alerta.dart';
import '../../providers/alertas_provider.dart';

class MisAlertasScreen extends ConsumerStatefulWidget {
  const MisAlertasScreen({super.key});

  @override
  ConsumerState<MisAlertasScreen> createState() => _MisAlertasScreenState();
}

class _MisAlertasScreenState extends ConsumerState<MisAlertasScreen> {
  final _scrollCtrl = ScrollController();
  final _items = <Alerta>[];
  int _page = 1;
  int _totalPages = 1;
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  bool get _hasMore => _page <= _totalPages;

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
            _scrollCtrl.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_loadingMore &&
        !_loading) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _items.clear();
        _page = 1;
        _totalPages = 1;
      });
    } else {
      setState(() => _loadingMore = true);
    }
    try {
      final page =
          await ref.read(alertasDatasourceProvider).historial(page: _page);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _totalPages = page.totalPages;
        _page++;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis alertas y reportes')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        const Text('No se pudo cargar el historial'),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => _load(reset: true),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : _items.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_none_rounded,
                              size: 56, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No has enviado alertas aún',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _load(reset: true),
                      child: ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                        itemCount: _items.length + (_loadingMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == _items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return _MiAlertaCard(alerta: _items[i]);
                        },
                      ),
                    ),
    );
  }
}

class _MiAlertaCard extends StatelessWidget {
  final Alerta alerta;
  const _MiAlertaCard({required this.alerta});

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (alerta.tipo) {
      'sos' => (Icons.sos_rounded, Colors.red, 'SOS'),
      'reporte' => (Icons.report_outlined, Colors.orange, 'Reporte'),
      _ => (Icons.notifications_rounded, Colors.grey, alerta.tipo),
    };
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'es');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(label,
                          style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    if (alerta.resuelta)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Atendida',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w600)),
                      ),
                  ]),
                  const SizedBox(height: 6),
                  Text(alerta.mensaje,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.access_time_outlined,
                        size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(fmt.format(alerta.createdAt),
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
