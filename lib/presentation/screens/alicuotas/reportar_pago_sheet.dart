import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/alicuota.dart';
import '../../providers/alicuota_provider.dart';

class ReportarPagoSheet extends ConsumerStatefulWidget {
  final Cobro cobro;
  const ReportarPagoSheet({super.key, required this.cobro});

  @override
  ConsumerState<ReportarPagoSheet> createState() => _ReportarPagoSheetState();
}

class _ReportarPagoSheetState extends ConsumerState<ReportarPagoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _referenciaCtrl = TextEditingController();
  String _metodoPago = 'transferencia';
  File? _archivo;
  String? _archivoNombre;
  bool _uploading = false;
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _referenciaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      withData: false,
      withReadStream: false,
    );
    if (result == null || result.files.single.path == null) return;
    setState(() {
      _archivo = File(result.files.single.path!);
      _archivoNombre = result.files.single.name;
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_archivo == null) {
      setState(() => _error = 'Debes adjuntar un comprobante.');
      return;
    }

    setState(() {
      _uploading = true;
      _error = null;
    });

    try {
      // 1. Subir comprobante
      final url = await ref
          .read(alicuotaRepositoryProvider)
          .subirComprobante(_archivo!);

      setState(() {
        _uploading = false;
        _sending = true;
      });

      // 2. Reportar pago
      await ref.read(alicuotaRepositoryProvider).reportarPago(
            pagoId: widget.cobro.id,
            metodoPago: _metodoPago,
            transaccionReferencia: _referenciaCtrl.text.trim(),
            comprobanteUrl: url,
          );

      if (!mounted) return;
      ref.invalidate(misPagosProvider);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Comprobante enviado. Tu pago está bajo revisión.'),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      final detail =
          (e.response?.data as Map?)?['detail'] as String?;
      setState(() {
        _uploading = false;
        _sending = false;
        _error = detail ?? 'Error al enviar el comprobante.';
      });
    } catch (_) {
      setState(() {
        _uploading = false;
        _sending = false;
        _error = 'Error inesperado. Inténtalo de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: '\$');
    final isLoading = _uploading || _sending;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Reportar pago',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${widget.cobro.inmuebleCodigo} · ${currency.format(widget.cobro.monto)}',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Método de pago
            DropdownButtonFormField<String>(
              value: _metodoPago,
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                prefixIcon: Icon(Icons.payment_outlined),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'transferencia',
                    child: Text('Transferencia bancaria')),
                DropdownMenuItem(
                    value: 'deposito', child: Text('Depósito')),
              ],
              onChanged: (v) => setState(() => _metodoPago = v!),
            ),
            const SizedBox(height: 14),

            // Referencia
            TextFormField(
              controller: _referenciaCtrl,
              decoration: const InputDecoration(
                labelText: 'Referencia / N° de transacción',
                prefixIcon: Icon(Icons.tag_outlined),
              ),
              validator: (v) =>
                  v != null && v.trim().isNotEmpty ? null : 'Requerida',
            ),
            const SizedBox(height: 14),

            // Comprobante
            GestureDetector(
              onTap: isLoading ? null : _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _archivo != null
                        ? Colors.green
                        : Theme.of(context).colorScheme.outline,
                    width: _archivo != null ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _archivo != null
                      ? Colors.green.withValues(alpha: 0.04)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _archivo != null
                          ? Icons.check_circle_outline
                          : Icons.upload_file_outlined,
                      color: _archivo != null
                          ? Colors.green
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _archivoNombre ??
                            'Adjuntar comprobante (PDF, JPG, PNG)',
                        style: TextStyle(
                          fontSize: 13,
                          color: _archivo != null
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    if (_archivo != null)
                      GestureDetector(
                        onTap: () => setState(() {
                          _archivo = null;
                          _archivoNombre = null;
                        }),
                        child: Icon(Icons.close,
                            size: 18, color: Colors.grey.shade500),
                      ),
                  ],
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  Icon(Icons.error_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_error!,
                        style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.error)),
                  ),
                ]),
              ),
            ],

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: isLoading ? null : _submit,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_outlined, size: 18),
              label: Text(_uploading
                  ? 'Subiendo comprobante…'
                  : _sending
                      ? 'Enviando reporte…'
                      : 'Enviar comprobante'),
            ),
          ],
        ),
      ),
    );
  }
}
