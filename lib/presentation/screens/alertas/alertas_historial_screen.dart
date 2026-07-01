import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/datasources/remote/alertas_datasource.dart';
import '../../../domain/entities/alerta.dart';
import '../../providers/alertas_provider.dart';

class AlertasHistorialScreen extends ConsumerStatefulWidget {
  const AlertasHistorialScreen({super.key});

  @override
  ConsumerState<AlertasHistorialScreen> createState() =>
      _AlertasHistorialScreenState();
}

class _AlertasHistorialScreenState
    extends ConsumerState<AlertasHistorialScreen> {
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

  Future<void> _resolve(Alerta alerta) async {
    try {
      await ref.read(alertasDatasourceProvider).resolve(alerta.id);
      if (!mounted) return;
      setState(() {
        final i = _items.indexWhere((a) => a.id == alerta.id);
        if (i != -1) {
          _items[i] = Alerta(
            id: alerta.id,
            tipo: alerta.tipo,
            mensaje: alerta.mensaje,
            emisorId: alerta.emisorId,
            emisorNombre: alerta.emisorNombre,
            emisorRol: alerta.emisorRol,
            destinatarioId: alerta.destinatarioId,
            destinatarioNombre: alerta.destinatarioNombre,
            coordenadas: alerta.coordenadas,
            resuelta: true,
            createdAt: alerta.createdAt,
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alerta marcada como resuelta'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo resolver la alerta'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _showEnviarDialog() async {
    final ds = ref.read(alertasDatasourceProvider);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _EnviarAlertaSheet(
        datasource: ds,
        onSent: () => _load(reset: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Alertas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _load(reset: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showEnviarDialog,
        icon: const Icon(Icons.campaign_rounded),
        label: const Text('Enviar comunicado'),
      ),
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
                          Text('Sin alertas registradas',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _load(reset: true),
                      child: ListView.builder(
                        controller: _scrollCtrl,
                        padding:
                            const EdgeInsets.fromLTRB(12, 12, 12, 100),
                        itemCount: _items.length + (_loadingMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == _items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                          return _AlertaCard(
                            alerta: _items[i],
                            onResolve: _resolve,
                          );
                        },
                      ),
                    ),
    );
  }
}

// ── Alerta card ───────────────────────────────────────────────────────────────

class _AlertaCard extends StatelessWidget {
  final Alerta alerta;
  final Future<void> Function(Alerta) onResolve;

  const _AlertaCard({required this.alerta, required this.onResolve});

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (alerta.tipo) {
      'sos' => (Icons.sos_rounded, Colors.red, 'SOS'),
      'reporte' => (Icons.report_outlined, Colors.orange, 'Reporte'),
      'broadcast' => (Icons.campaign_rounded, Colors.blue, 'Comunicado'),
      'individual' => (Icons.person_pin_rounded, Colors.purple, 'Individual'),
      _ => (Icons.notifications_rounded, Colors.grey, alerta.tipo),
    };
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'es');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
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
                          child: const Text('Resuelta',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ]),
                    const SizedBox(height: 2),
                    Text(alerta.emisorNombre,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Text(alerta.mensaje,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4)),
            if (alerta.destinatarioNombre != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.person_outline,
                    size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text('Para: ${alerta.destinatarioNombre}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ],
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.access_time_outlined,
                  size: 12, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(fmt.format(alerta.createdAt),
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500)),
              const Spacer(),
              if (!alerta.resuelta && alerta.isUrgente)
                TextButton.icon(
                  onPressed: () => onResolve(alerta),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text('Marcar resuelta',
                      style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Enviar comunicado (guardia) ───────────────────────────────────────────────

class _EnviarAlertaSheet extends StatefulWidget {
  final AlertasDatasource datasource;
  final VoidCallback onSent;

  const _EnviarAlertaSheet({
    required this.datasource,
    required this.onSent,
  });

  @override
  State<_EnviarAlertaSheet> createState() => _EnviarAlertaSheetState();
}

class _EnviarAlertaSheetState extends State<_EnviarAlertaSheet> {
  final _formKey = GlobalKey<FormState>();
  final _msgCtrl = TextEditingController();
  String _tipo = 'broadcast';
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
      await widget.datasource.send(
        tipo: _tipo,
        mensaje: _msgCtrl.text.trim(),
      );
      if (!mounted) return;
      widget.onSent();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comunicado enviado'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo enviar el comunicado'),
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
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enviar comunicado',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Tipo
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'broadcast',
                  icon: Icon(Icons.campaign_rounded),
                  label: Text('A todos'),
                ),
                ButtonSegment(
                  value: 'individual',
                  icon: Icon(Icons.person_pin_rounded),
                  label: Text('Individual'),
                ),
              ],
              selected: {_tipo},
              onSelectionChanged: (s) =>
                  setState(() => _tipo = s.first),
            ),
            if (_tipo == 'individual') ...[
              const SizedBox(height: 4),
              Text(
                'Nota: el envío individual por código de residente estará disponible próximamente.',
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _msgCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Mensaje',
                hintText: 'Ej: El camión de basura ingresará en 10 minutos...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().length < 5
                  ? 'Escribe un mensaje'
                  : null,
            ),
            const SizedBox(height: 20),
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
              label: Text(_sending ? 'Enviando...' : 'Enviar'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
