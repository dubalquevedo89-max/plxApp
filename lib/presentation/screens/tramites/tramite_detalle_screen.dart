import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/documento.dart';
import '../../../domain/entities/reserva.dart';
import '../../providers/documento_provider.dart';
import '../../providers/reserva_provider.dart';

class TramiteDetalleScreen extends ConsumerWidget {
  final String reservaId;
  const TramiteDetalleScreen({super.key, required this.reservaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(reservaTimelineProvider(reservaId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Trámite')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              const Text('No se pudo cargar el trámite'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(reservaTimelineProvider(reservaId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (tl) {
          final vigente = tl.estado == EstadoReserva.pendientePago ||
              tl.estado == EstadoReserva.activa;
          return Stack(
            children: [
              _TimelineView(timeline: tl, reservaId: reservaId),
              if (vigente)
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: _SubirDocumentoFab(reservaId: reservaId),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ── FAB subir documento ────────────────────────────────────────────────────────

class _SubirDocumentoFab extends StatelessWidget {
  final String reservaId;
  const _SubirDocumentoFab({required this.reservaId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'subir_doc',
      onPressed: () => _showSubirSheet(context),
      icon: const Icon(Icons.upload_file_rounded),
      label: const Text('Subir documento'),
    );
  }

  Future<void> _showSubirSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _SubirDocumentoSheet(reservaId: reservaId),
    );
  }
}

// ── Sheet subir documento ─────────────────────────────────────────────────────

class _SubirDocumentoSheet extends ConsumerStatefulWidget {
  final String reservaId;
  const _SubirDocumentoSheet({required this.reservaId});

  @override
  ConsumerState<_SubirDocumentoSheet> createState() =>
      _SubirDocumentoSheetState();
}

class _SubirDocumentoSheetState extends ConsumerState<_SubirDocumentoSheet> {
  File? _archivo;
  String? _nombreArchivo;
  TipoDocumento _tipo = TipoDocumento.otro;
  final _descripcionCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
    );
    if (result == null || result.files.single.path == null) return;
    final path = result.files.single.path!;
    final size = result.files.single.size;
    if (size > 5 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El archivo no debe superar 5 MB')),
        );
      }
      return;
    }
    setState(() {
      _archivo = File(path);
      _nombreArchivo = result.files.single.name;
    });
  }

  Future<void> _subir() async {
    if (_archivo == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(documentoRepositoryProvider).subir(
            file: _archivo!,
            tipo: _tipo,
            descripcion: _descripcionCtrl.text.trim(),
            reservaId: widget.reservaId,
          );
      ref.invalidate(documentosDeReservaProvider(widget.reservaId));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Documento subido correctamente'),
              duration: Duration(seconds: 3)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir: $e'),
              duration: const Duration(seconds: 4)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
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
          Text('Subir documento',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Selector de archivo
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(
                    color: _archivo != null
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: _archivo != null ? 2 : 1),
                borderRadius: BorderRadius.circular(12),
                color: _archivo != null
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.05)
                    : Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  Icon(
                    _archivo != null
                        ? Icons.check_circle_rounded
                        : Icons.upload_file_rounded,
                    size: 36,
                    color: _archivo != null
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _nombreArchivo ?? 'Toca para seleccionar archivo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _archivo != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _archivo != null
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text('PDF, JPG, PNG, WEBP · máx 5 MB',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Tipo
          DropdownButtonFormField<TipoDocumento>(
            initialValue: _tipo,
            decoration: const InputDecoration(
              labelText: 'Tipo de documento',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: TipoDocumento.values
                .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text('${t.icon}  ${t.label}')))
                .toList(),
            onChanged: (v) => setState(() => _tipo = v ?? _tipo),
          ),
          const SizedBox(height: 12),

          // Descripción
          TextFormField(
            controller: _descripcionCtrl,
            decoration: const InputDecoration(
              labelText: 'Descripción (opcional)',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: (_archivo == null || _loading) ? null : _subir,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.cloud_upload_rounded),
              label: const Text('Subir'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Timeline view ─────────────────────────────────────────────────────────────

class _TimelineView extends ConsumerWidget {
  final ReservaTimeline timeline;
  final String reservaId;
  const _TimelineView({required this.timeline, required this.reservaId});

  /// Para cada documento encuentra el índice del evento cuya fecha es la más
  /// cercana anterior (o igual) al created_at del doc. Si el doc es anterior a
  /// todos los eventos, lo asigna al primero.
  Map<int, List<Documento>> _agruparDocs(
      List<TimelineEvento> eventos, List<Documento> docs) {
    final mapa = <int, List<Documento>>{};
    for (final doc in docs) {
      int idx = 0;
      for (int i = 0; i < eventos.length; i++) {
        if (!eventos[i].fecha.isAfter(doc.createdAt)) idx = i;
      }
      mapa.putIfAbsent(idx, () => []).add(doc);
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentosDeReservaProvider(reservaId));
    final (estadoColor, _) = _estadoStyle(timeline.estado);

    return docsAsync.when(
      loading: () => _buildScrollView(context, estadoColor, {}),
      error: (_, _) => _buildScrollView(context, estadoColor, {}),
      data: (docs) => _buildScrollView(
          context, estadoColor, _agruparDocs(timeline.eventos, docs)),
    );
  }

  Widget _buildScrollView(BuildContext context, Color estadoColor,
      Map<int, List<Documento>> docsPorEvento) {
    final eventos = timeline.eventos;

    return CustomScrollView(
      slivers: [
        // Header lote + estado
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: estadoColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: estadoColor.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              Icon(Icons.home_work_outlined, color: estadoColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timeline.lote,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: estadoColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(timeline.estado.label,
                          style: TextStyle(
                              fontSize: 12,
                              color: estadoColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ]),
          ).animate().fadeIn().slideY(begin: -0.1),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text('Historial del proceso',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey)),
          ),
        ),

        // Eventos con docs embebidos
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList.builder(
            itemCount: eventos.length,
            itemBuilder: (context, i) {
              final isLast = i == eventos.length - 1;
              final docs = docsPorEvento[i] ?? [];
              return _EventoTile(
                evento: eventos[i],
                isLast: isLast && docs.isEmpty,
                docs: docs,
              ).animate().fadeIn(delay: (i * 60).ms).slideX(begin: -0.05);
            },
          ),
        ),
      ],
    );
  }

  (Color, Color) _estadoStyle(EstadoReserva e) => switch (e) {
        EstadoReserva.pendientePago => (
            Colors.orange.shade700,
            Colors.orange.shade50
          ),
        EstadoReserva.activa => (Colors.blue.shade700, Colors.blue.shade50),
        EstadoReserva.completada => (
            Colors.green.shade700,
            Colors.green.shade50
          ),
        EstadoReserva.cancelada => (
            Colors.grey.shade600,
            Colors.grey.shade100
          ),
      };
}

// ── Doc tile ──────────────────────────────────────────────────────────────────

class _DocTile extends ConsumerStatefulWidget {
  final Documento doc;
  const _DocTile({required this.doc});

  @override
  ConsumerState<_DocTile> createState() => _DocTileState();
}

class _DocTileState extends ConsumerState<_DocTile> {
  bool _opening = false;

  Future<void> _abrir() async {
    setState(() => _opening = true);
    try {
      final url =
          await ref.read(documentoRepositoryProvider).obtenerUrl(widget.doc.id);
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'),
              duration: const Duration(seconds: 4)),
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
    final (bgColor, fgColor) = _tipoColors(doc.tipo);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: _opening ? null : _abrir,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child:
                      Text(doc.tipo.icon, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.nombreOriginal,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Row(children: [
                    _Pill(label: doc.extension, color: fgColor),
                    const SizedBox(width: 6),
                    _Pill(label: doc.tamanoLabel, color: Colors.grey),
                    const Spacer(),
                    Text(fmt.format(doc.createdAt.toLocal()),
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _opening
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(Icons.open_in_new_rounded,
                    size: 16, color: Colors.grey.shade400),
          ]),
        ),
      ),
    );
  }

  (Color, Color) _tipoColors(TipoDocumento t) => switch (t) {
        TipoDocumento.contrato => (Colors.blue.shade50, Colors.blue.shade700),
        TipoDocumento.comprobantePago => (
            Colors.green.shade50,
            Colors.green.shade700
          ),
        TipoDocumento.escritura => (
            Colors.amber.shade50,
            Colors.amber.shade700
          ),
        TipoDocumento.otro => (Colors.grey.shade100, Colors.grey.shade600),
      };
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Evento tile ───────────────────────────────────────────────────────────────

class _EventoTile extends StatelessWidget {
  final TimelineEvento evento;
  final bool isLast;
  final List<Documento> docs;
  const _EventoTile({
    required this.evento,
    required this.isLast,
    this.docs = const [],
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy · HH:mm', 'es');
    final color = _resolveColor(evento.color);
    final icon = _resolveIcon(evento.icono);

    final hasDocsBelow = docs.isNotEmpty;
    final lineExtends = !isLast || hasDocsBelow;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda: punto + línea
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (lineExtends)
                Container(
                  width: 2,
                  // La línea cubre el texto del evento + los docs debajo
                  height: hasDocsBelow ? null : 20,
                  constraints: hasDocsBelow
                      ? null
                      : const BoxConstraints(minHeight: 20),
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Columna derecha: texto + docs
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(evento.titulo,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(evento.descripcion,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(fmt.format(evento.fecha.toLocal()),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade400)),
                    ]),
                  ],
                ),
              ),
              // Documentos asociados a este paso
              if (hasDocsBelow)
                Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    children: docs
                        .map((doc) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _DocTile(doc: doc),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _resolveColor(String c) => switch (c) {
        'emerald' || 'green' => Colors.green.shade600,
        'blue' || 'indigo' => Colors.blue.shade600,
        'yellow' || 'amber' => Colors.amber.shade700,
        'red' || 'rose' => Colors.red.shade600,
        'orange' => Colors.orange.shade700,
        'purple' || 'violet' => Colors.purple.shade600,
        _ => Colors.blue.shade600,
      };

  IconData _resolveIcon(String i) => switch (i) {
        'shield' => Icons.shield_rounded,
        'check' || 'check_circle' => Icons.check_circle_rounded,
        'document' || 'file' => Icons.description_rounded,
        'payment' || 'money' => Icons.payments_rounded,
        'sign' || 'pen' => Icons.draw_rounded,
        'key' => Icons.vpn_key_rounded,
        'home' => Icons.home_rounded,
        'warning' => Icons.warning_rounded,
        'cancel' => Icons.cancel_rounded,
        'upload' => Icons.upload_file_rounded,
        'mail' || 'email' => Icons.mail_rounded,
        _ => Icons.info_rounded,
      };
}
