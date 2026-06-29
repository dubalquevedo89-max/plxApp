import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/datasources/remote/garita_datasource.dart';
import '../../../domain/entities/solvencia.dart';
import '../../widgets/qr_with_logo.dart';

class QrAccessScreen extends ConsumerStatefulWidget {
  const QrAccessScreen({super.key});

  @override
  ConsumerState<QrAccessScreen> createState() => _QrAccessScreenState();
}

class _QrAccessScreenState extends ConsumerState<QrAccessScreen> {
  static const _totalSeconds = 60;
  final _localAuth = LocalAuthentication();
  bool _authenticated = false;
  bool _authenticating = false;
  int _remaining = _totalSeconds;
  Timer? _timer;
  String? _qrData;
  Solvencia? _solvencia;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() => _authenticating = true);
    try {
      final canCheck = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      bool ok;
      if (canCheck) {
        ok = await _localAuth.authenticate(
          localizedReason: 'Verifica tu identidad para ver el pase QR',
          options: const AuthenticationOptions(biometricOnly: false),
        );
      } else {
        // Dispositivo sin autenticación configurada → permitir acceso directo
        ok = true;
      }

      if (!mounted) return;
      if (ok) {
        _qrData = await _fetchResidentCode();
        _startCountdown();
        setState(() => _authenticated = true);
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      // Error de plataforma (ej. biometría no disponible en este dispositivo)
      // Intentar acceder sin autenticación biométrica
      try {
        _qrData = await _fetchResidentCode();
        _startCountdown();
        setState(() => _authenticated = true);
      } catch (_) {
        if (mounted) Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _authenticating = false);
    }
  }

  Future<String?> _fetchResidentCode() async {
    // Usar cache local primero — funciona sin internet
    final cached = SessionStorage.activeProfile?.residentCode;
    if (cached != null) {
      // Refrescar en background silenciosamente
      GaritaDatasource(ref.read(dioClientProvider)).miSolvencia().then((s) {
        final key = SessionStorage.activeProfile?.storageKey;
        if (key != null) SessionStorage.saveResidentCode(key, s.residentCode);
        if (mounted) setState(() => _qrData = s.residentCode);
      }).catchError((_) {});
      return cached;
    }
    // Sin cache → llamada de red (primer uso)
    try {
      final ds = GaritaDatasource(ref.read(dioClientProvider));
      _solvencia = await ds.miSolvencia();
      final key = SessionStorage.activeProfile?.storageKey;
      if (key != null) {
        SessionStorage.saveResidentCode(key, _solvencia!.residentCode);
      }
      return _solvencia!.residentCode;
    } catch (_) {
      return null;
    }
  }

  void _startCountdown() {
    _remaining = _totalSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _remaining--);
      if (_remaining <= 0) {
        t.cancel();
        setState(() => _authenticated = false);
      }
    });
  }

  Future<void> _renovar() async {
    _timer?.cancel();
    setState(() => _authenticated = false);
    await _authenticate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = SessionStorage.activeHost != null
        ? SessionStorage.getProfile(SessionStorage.activeHost!)
        : null;
    final primaryColor = profile?.primaryColor ?? '#D4AF37';
    final primary = Color(int.parse('FF${primaryColor.replaceAll('#', '')}', radix: 16));

    return Theme(
      data: AppTheme.fromTenantColor(primaryColor),
      child: Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Pase de Acceso', style: TextStyle(color: Colors.white)),
        ),
        body: _authenticating
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _authenticated
                ? _QrView(
                    qrData: _qrData ?? '',
                    logoUrl: profile?.logoUrl,
                    remaining: _remaining,
                    total: _totalSeconds,
                    onRenovar: _renovar,
                    solvencia: _solvencia,
                  )
                : _ExpiredView(onRenovar: _renovar),
      ),
    );
  }
}

class _QrView extends StatelessWidget {
  final String qrData;
  final String? logoUrl;
  final int remaining;
  final int total;
  final VoidCallback onRenovar;
  final Solvencia? solvencia;

  const _QrView({
    required this.qrData,
    this.logoUrl,
    required this.remaining,
    required this.total,
    required this.onRenovar,
    this.solvencia,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = remaining / total;
    final isUrgent = remaining <= 10;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: const Offset(0, 8))],
            ),
            padding: const EdgeInsets.all(20),
            child: QrWithLogo(
              data: qrData,
              size: 240,
              logoUrl: logoUrl,
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 32),

          // Temporizador
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 5,
                  backgroundColor: Colors.white24,
                  color: isUrgent ? Colors.red[300] : Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    '$remaining',
                    style: TextStyle(
                      color: isUrgent ? Colors.red[200] : Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('seg', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                ],
              ),
            ],
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms, color: Colors.white24),

          const SizedBox(height: 24),
          if (remaining <= 0)
            FilledButton.icon(
              onPressed: onRenovar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Renovar pase'),
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black87),
            ).animate().fadeIn(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ExpiredView extends StatelessWidget {
  final VoidCallback onRenovar;
  const _ExpiredView({required this.onRenovar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_off_rounded, color: Colors.white, size: 72),
          const SizedBox(height: 16),
          const Text('Pase expirado', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Verifica tu identidad para renovarlo', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onRenovar,
            icon: const Icon(Icons.fingerprint_rounded),
            label: const Text('Verificar y renovar'),
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black87),
          ),
        ],
      ),
    );
  }
}
