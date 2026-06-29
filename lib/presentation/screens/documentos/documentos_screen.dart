import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/documento.dart';
import '../../providers/documento_provider.dart';

class DocumentosScreen extends StatelessWidget {
  const DocumentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Documentos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recibidos'),
              Tab(text: 'Mis archivos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _RecibidosTab(),
            _MisArchivosTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tab Recibidos ─────────────────────────────────────────────────────────────

class _RecibidosTab extends ConsumerStatefulWidget {
  const _RecibidosTab();

  @override
  ConsumerState<_RecibidosTab> createState() => _RecibidosTabState();
}

class _RecibidosTabState extends ConsumerState<_RecibidosTab> {
  TipoDocumento? _filtro;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(documentosRecibidosProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
          onRetry: () => ref.invalidate(documentosRecibidosProvider)),
      data: (docs) {
        final tiposPresentes = TipoDocumento.values
            .where((t) => docs.any((d) => d.tipo == t))
            .toList();

        final filtrados =
            _filtro == null ? docs : docs.where((d) => d.tipo == _filtro).toList();

        return Column(
          children: [
            if (tiposPresentes.length > 1)
              _FilterChips(
                tipos: tiposPresentes,
                selected: _filtro,
                onSelected: (t) => setState(
                    () => _filtro = _filtro == t ? null : t),
              ),
            Expanded(
              child: filtrados.isEmpty
                  ? const _EmptyView(mensaje: 'No hay documentos en esta categoría')
                  : _DocList(docs: filtrados),
            ),
          ],
        );
      },
    );
  }
}

// ── Tab Mis archivos ──────────────────────────────────────────────────────────

class _MisArchivosTab extends ConsumerWidget {
  const _MisArchivosTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(documentosMisUploadsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
          onRetry: () => ref.invalidate(documentosMisUploadsProvider)),
      data: (docs) => docs.isEmpty
          ? const _EmptyView(mensaje: 'No has subido ningún archivo')
          : _DocList(docs: docs),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final List<TipoDocumento> tipos;
  final TipoDocumento? selected;
  final void Function(TipoDocumento) onSelected;

  const _FilterChips({
    required this.tipos,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: tipos.map((t) {
          final isSelected = selected == t;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(t.label),
              selected: isSelected,
              onSelected: (_) => onSelected(t),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Lista de documentos ───────────────────────────────────────────────────────

class _DocList extends StatelessWidget {
  final List<Documento> docs;
  const _DocList({required this.docs});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: docs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) =>
          _DocCard(doc: docs[i]).animate().fadeIn(delay: (i * 30).ms),
    );
  }
}

// ── Documento card ────────────────────────────────────────────────────────────

class _DocCard extends ConsumerStatefulWidget {
  final Documento doc;
  const _DocCard({required this.doc});

  @override
  ConsumerState<_DocCard> createState() => _DocCardState();
}

class _DocCardState extends ConsumerState<_DocCard> {
  bool _opening = false;

  Future<void> _abrir() async {
    setState(() => _opening = true);
    try {
      final url = await ref
          .read(documentoRepositoryProvider)
          .obtenerUrl(widget.doc.id);
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir el documento');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), duration: const Duration(seconds: 4)),
        );
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    final fmt = DateFormat('dd/MM/yyyy', 'es');
    final (bgColor, iconColor) = _tipoColors(doc.tipo);

    return Card(
      child: InkWell(
        onTap: _opening ? null : _abrir,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Ícono tipo
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(doc.tipo.icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          doc.nombreOriginal,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (doc.notifPendiente)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ]),
                    if (doc.descripcion != null && doc.descripcion!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          doc.descripcion!,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(children: [
                      _Badge(label: doc.extension, color: iconColor),
                      const SizedBox(width: 6),
                      _Badge(label: doc.tamanoLabel, color: Colors.grey),
                      const Spacer(),
                      Text(
                        fmt.format(doc.createdAt.toLocal()),
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Acción
              _opening
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.open_in_new_rounded,
                      size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color) _tipoColors(TipoDocumento tipo) => switch (tipo) {
        TipoDocumento.contrato => (
            Colors.blue.shade50,
            Colors.blue.shade700
          ),
        TipoDocumento.comprobantePago => (
            Colors.green.shade50,
            Colors.green.shade700
          ),
        TipoDocumento.escritura => (
            Colors.amber.shade50,
            Colors.amber.shade700
          ),
        TipoDocumento.otro => (
            Colors.grey.shade100,
            Colors.grey.shade600
          ),
      };
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final String mensaje;
  const _EmptyView({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(mensaje,
              style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 14)),
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
          const Text('No se pudieron cargar los documentos'),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
