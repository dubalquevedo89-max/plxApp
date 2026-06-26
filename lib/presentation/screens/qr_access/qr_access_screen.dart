import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() => _authenticating = true);
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: 'Verifica tu identidad para ver el pase QR',
        options: const AuthenticationOptions(biometricOnly: false),
      );
      if (ok) {
        _startCountdown();
        setState(() => _authenticated = true);
      } else if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _authenticating = false);
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
                    host: profile?.host ?? '',
                    remaining: _remaining,
                    total: _totalSeconds,
                    onRenovar: _renovar,
                  )
                : _ExpiredView(onRenovar: _renovar),
      ),
    );
  }
}

class _QrView extends StatelessWidget {
  final String host;
  final int remaining;
  final int total;
  final VoidCallback onRenovar;

  const _QrView({
    required this.host,
    required this.remaining,
    required this.total,
    required this.onRenovar,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = remaining / total;
    final isUrgent = remaining <= 10;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: const Offset(0, 8))],
            ),
            padding: const EdgeInsets.all(20),
            child: QrImageView(
              data: host,
              version: QrVersions.auto,
              size: 220,
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 6,
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('seg', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                ],
              ),
            ],
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms, color: Colors.white24),
          const SizedBox(height: 32),
          if (remaining <= 0)
            FilledButton.icon(
              onPressed: onRenovar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Renovar pase'),
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black87),
            ).animate().fadeIn(),
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
