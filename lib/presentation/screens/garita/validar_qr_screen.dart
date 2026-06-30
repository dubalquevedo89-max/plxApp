import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/garita_verify_service.dart';
import '../../../core/storage/session_storage.dart';
import '../../../data/datasources/remote/garita_datasource.dart';

class ValidarQrScreen extends ConsumerStatefulWidget {
  const ValidarQrScreen({super.key});

  @override
  ConsumerState<ValidarQrScreen> createState() => _ValidarQrScreenState();
}

class _ValidarQrScreenState extends ConsumerState<ValidarQrScreen> {
  final _controller = MobileScannerController();
  bool _scanning = true;
  bool _loading = false;
  _ResultData? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_scanning || _loading) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() {
      _scanning = false;
      _loading = true;
    });
    await _controller.stop();

    final profile = SessionStorage.activeProfile;
    final service = GaritaVerifyService(GaritaDatasource(ref.read(dioClientProvider)));

    final res = await service.verificar(
      profileKey: profile?.storageKey ?? '',
      apiKey: profile?.apiKeyGarita,
      residentCode: code,
    );
    if (mounted) {
      setState(() {
        _loading = false;
        _result = _ResultData(
          allowed: res.allowedAccess,
          status: res.status,
          message: res.message,
          code: res.residentCode,
        );
      });
    }
  }

  void _resetScan() {
    setState(() {
      _scanning = true;
      _loading = false;
      _result = null;
    });
    _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validar acceso QR')),
      body: _result != null
          ? _ResultView(data: _result!, onNuevoEscaneo: _resetScan)
          : _loading
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Verificando acceso…'),
                    ],
                  ),
                )
              : _ScannerView(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
    );
  }
}

// ── Scanner ───────────────────────────────────────────────────────────────────

class _ScannerView extends StatelessWidget {
  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;

  const _ScannerView({required this.controller, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        MobileScanner(controller: controller, onDetect: onDetect),
        // Overlay con visor
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: primary, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Text(
            'Apunta la cámara al código QR',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Result ────────────────────────────────────────────────────────────────────

class _ResultData {
  final bool allowed;
  final String status;
  final String message;
  final String code;
  const _ResultData({
    required this.allowed,
    required this.status,
    required this.message,
    required this.code,
  });
}

class _ResultView extends StatelessWidget {
  final _ResultData data;
  final VoidCallback onNuevoEscaneo;

  const _ResultView({required this.data, required this.onNuevoEscaneo});

  @override
  Widget build(BuildContext context) {
    final allowed = data.allowed;
    final color = allowed ? Colors.green : Colors.red;
    final icon = allowed ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final title = allowed ? 'Acceso permitido' : 'Acceso denegado';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 72),
            )
                .animate()
                .scale(begin: const Offset(0.5, 0.5), duration: 400.ms)
                .fadeIn(),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: color),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 8),
            _StatusBadge(status: data.status),
            const SizedBox(height: 16),
            Text(
              data.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 8),
            Text(
              data.code,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: onNuevoEscaneo,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Escanear otro'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'AL_DIA' => ('Al día', Colors.green),
      'EN_MORA' => ('En mora', Colors.red),
      'PROGRAMADO' => ('Programado', Colors.blue),
      'EXPIRADO' => ('Expirado', Colors.orange),
      'NO_REGISTRADO' => ('No registrado', Colors.grey),
      _ => (status, Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
