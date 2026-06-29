import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/acceso_log.dart';
import '../../providers/garita_provider.dart';

class AccesosScreen extends ConsumerStatefulWidget {
  const AccesosScreen({super.key});

  @override
  ConsumerState<AccesosScreen> createState() => _AccesosScreenState();
}

class _AccesosScreenState extends ConsumerState<AccesosScreen> {
  // Filters
  String? _tipoAcceso;
  bool? _allowedAccess;
  final _searchCtrl = TextEditingController();
  String _search = '';

  // Pagination
  final _scrollCtrl = ScrollController();
  final _items = <AccesoLog>[];
  int _page = 1;
  int _total = 0;
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
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  bool get _hasMore => _items.length < _total;

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
        _total = 0;
      });
    } else {
      setState(() => _loadingMore = true);
    }

    try {
      final page = await ref.read(garitaDatasourceProvider).logs(
            tipoAcceso: _tipoAcceso,
            allowedAccess: _allowedAccess,
            search: _search.isEmpty ? null : _search,
            page: _page,
          );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _total = page.total;
        _page++;
      });
    } catch (e) {
      if (mounted) { setState(() => _error = e.toString()); }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  void _applyFilters() {
    _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accesos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Buscar código o mensaje…',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                              _applyFilters();
                            },
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) => setState(() => _search = v.trim()),
                  onSubmitted: (_) => _applyFilters(),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Chip(
                        label: 'Todos',
                        selected: _tipoAcceso == null && _allowedAccess == null,
                        onTap: () {
                          setState(() {
                            _tipoAcceso = null;
                            _allowedAccess = null;
                          });
                          _applyFilters();
                        },
                      ),
                      _Chip(
                        label: 'Permitidos',
                        selected: _allowedAccess == true,
                        color: Colors.green,
                        onTap: () {
                          setState(() => _allowedAccess =
                              _allowedAccess == true ? null : true);
                          _applyFilters();
                        },
                      ),
                      _Chip(
                        label: 'Denegados',
                        selected: _allowedAccess == false,
                        color: Colors.red,
                        onTap: () {
                          setState(() => _allowedAccess =
                              _allowedAccess == false ? null : false);
                          _applyFilters();
                        },
                      ),
                      _Chip(
                        label: 'Residentes',
                        selected: _tipoAcceso == 'residente',
                        onTap: () {
                          setState(() => _tipoAcceso =
                              _tipoAcceso == 'residente' ? null : 'residente');
                          _applyFilters();
                        },
                      ),
                      _Chip(
                        label: 'Visitantes',
                        selected: _tipoAcceso == 'visitante',
                        onTap: () {
                          setState(() => _tipoAcceso =
                              _tipoAcceso == 'visitante' ? null : 'visitante');
                          _applyFilters();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      const Text('No se pudieron cargar los accesos'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => _load(reset: true),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _items.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history_toggle_off_outlined,
                              size: 56, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('Sin registros',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _load(reset: true),
                      child: ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                        itemCount: _items.length + (_loadingMore ? 1 : 0) + 1,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '$_total registros',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500),
                              ),
                            );
                          }
                          final idx = i - 1;
                          if (idx == _items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                          return _LogCard(log: _items[idx]);
                        },
                      ),
                    ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: c.withValues(alpha: 0.15),
        checkmarkColor: c,
        side: BorderSide(color: selected ? c : Colors.grey.shade300),
        labelStyle: TextStyle(
          fontSize: 12,
          color: selected ? c : Colors.grey,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}

// ── Log card ──────────────────────────────────────────────────────────────────

class _LogCard extends StatelessWidget {
  final AccesoLog log;
  const _LogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final allowed = log.allowedAccess;
    final color = allowed ? Colors.green : Colors.red;
    final icon = allowed ? Icons.check_circle_outline : Icons.cancel_outlined;
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'es');

    final (tipoIcon, tipoLabel) = switch (log.tipoAcceso) {
      'residente' => (Icons.home_outlined, 'Residente'),
      'visitante' => (Icons.person_outline, 'Visitante'),
      _ => (Icons.help_outline, 'Desconocido'),
    };

    final (statusColor, statusLabel) = switch (log.status) {
      'AL_DIA' => (Colors.green, 'Al día'),
      'EN_MORA' => (Colors.red, 'En mora'),
      'PROGRAMADO' => (Colors.blue, 'Programado'),
      'EXPIRADO' => (Colors.orange, 'Expirado'),
      'NO_REGISTRADO' => (Colors.grey, 'No registrado'),
      _ => (Colors.grey, log.status),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        log.message,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                            fontSize: 10,
                            color: statusColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    log.residentCode,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(tipoIcon, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(tipoLabel,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                    const Spacer(),
                    Icon(Icons.access_time_outlined,
                        size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(fmt.format(log.fechaHora),
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
