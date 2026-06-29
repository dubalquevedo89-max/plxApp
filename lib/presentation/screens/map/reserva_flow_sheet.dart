import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/tenant_option.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reserva_flow_provider.dart';

class ReservaFlowSheet extends ConsumerStatefulWidget {
  final String lotId;
  final String lotCodigo;
  final TenantOption tenant;

  const ReservaFlowSheet({
    super.key,
    required this.lotId,
    required this.lotCodigo,
    required this.tenant,
  });

  static Future<void> show(
    BuildContext context, {
    required String lotId,
    required String lotCodigo,
    required TenantOption tenant,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ReservaFlowSheet(
        lotId: lotId,
        lotCodigo: lotCodigo,
        tenant: tenant,
      ),
    );
  }

  @override
  ConsumerState<ReservaFlowSheet> createState() => _ReservaFlowSheetState();
}

class _ReservaFlowSheetState extends ConsumerState<ReservaFlowSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _cedulaCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _cedulaCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(reservaFlowProvider.notifier).execute(
          nombre: _nombreCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim(),
          cedula: _cedulaCtrl.text.trim(),
          password: _passCtrl.text,
          lotId: widget.lotId,
          host: widget.tenant.host,
          primaryColor: widget.tenant.primaryColor,
          virtualProjectSlug: widget.tenant.virtualProjectSlug,
          logoUrl: widget.tenant.logoUrl,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reservaFlowProvider);
    final inProgress = state.step != ReservaStep.form &&
        state.step != ReservaStep.done &&
        state.step != ReservaStep.error &&
        state.step != ReservaStep.loginExisting;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Reservar lote',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Código: ${widget.lotCodigo}',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
                if (!inProgress && state.step != ReservaStep.done)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(reservaFlowProvider.notifier).reset();
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
          const Divider(height: 20),

          // Content
          if (state.step == ReservaStep.form)
            _FormView(
              formKey: _formKey,
              nombreCtrl: _nombreCtrl,
              emailCtrl: _emailCtrl,
              telefonoCtrl: _telefonoCtrl,
              cedulaCtrl: _cedulaCtrl,
              passCtrl: _passCtrl,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onSubmit: _submit,
            )
          else if (state.step == ReservaStep.loginExisting)
            _LoginExistingView(
              prefillEmail: state.prefillEmail,
              errorMessage: state.errorMessage,
              lotId: widget.lotId,
              tenant: widget.tenant,
            )
          else if (inProgress)
            _ProgressView(step: state.step)
          else if (state.step == ReservaStep.done)
            _SuccessView(
              result: state.result!,
              onClose: () {
                ref.read(reservaFlowProvider.notifier).reset();
                ref.invalidate(activeProfileProvider);
                Navigator.pop(context);
                context.go(AppRoutes.home);
              },
            )
          else
            _ErrorView(
              message: state.errorMessage ?? 'Error desconocido.',
              onRetry: () => ref.read(reservaFlowProvider.notifier).reset(),
            ),
        ],
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombreCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController telefonoCtrl;
  final TextEditingController cedulaCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _FormView({
    required this.formKey,
    required this.nombreCtrl,
    required this.emailCtrl,
    required this.telefonoCtrl,
    required this.cedulaCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _field(nombreCtrl, 'Nombre completo', Icons.person_outline,
                validator: (v) => v != null && v.trim().length >= 3
                    ? null
                    : 'Ingresa tu nombre completo'),
            const SizedBox(height: 12),
            _field(emailCtrl, 'Correo electrónico', Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@')
                    ? null
                    : 'Correo inválido'),
            const SizedBox(height: 12),
            _field(telefonoCtrl, 'Teléfono', Icons.phone_outlined,
                keyboard: TextInputType.phone,
                validator: (v) => v != null && v.trim().length >= 7
                    ? null
                    : 'Teléfono inválido'),
            const SizedBox(height: 12),
            _field(cedulaCtrl, 'Cédula / Pasaporte', Icons.badge_outlined,
                validator: (v) => v != null && v.trim().length >= 6
                    ? null
                    : 'Documento inválido'),
            const SizedBox(height: 12),
            TextFormField(
              controller: passCtrl,
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: onToggleObscure,
                ),
              ),
              validator: (v) => v != null && v.length >= 6
                  ? null
                  : 'Mínimo 6 caracteres',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Registrarme y reservar'),
            ),
            const SizedBox(height: 8),
            Text(
              'Se creará tu cuenta y el lote quedará reservado automáticamente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: validator,
      );
}

// ── Progress ──────────────────────────────────────────────────────────────────

class _ProgressView extends StatelessWidget {
  final ReservaStep step;
  const _ProgressView({required this.step});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (ReservaStep.creatingAccount, 'Creando tu cuenta…'),
      (ReservaStep.loggingIn, 'Iniciando sesión…'),
      (ReservaStep.requestingPermission, 'Activando notificaciones…'),
      (ReservaStep.reserving, 'Reservando lote…'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ...steps.map((s) {
            final isDone = steps.indexOf(s) <
                steps.indexWhere((e) => e.$1 == step);
            final isCurrent = s.$1 == step;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: isCurrent
                        ? const CircularProgressIndicator(strokeWidth: 2.5)
                            .animate()
                            .fadeIn()
                        : Icon(
                            isDone
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked,
                            color: isDone ? Colors.green : Colors.grey.shade400,
                            size: 26,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    s.$2,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isCurrent
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isCurrent
                          ? Theme.of(context).colorScheme.primary
                          : isDone
                              ? Colors.black87
                              : Colors.grey.shade400,
                    ),
                  ),
                ],
              ).animate(delay: (steps.indexOf(s) * 100).ms).fadeIn().slideX(begin: -0.1),
            );
          }),
        ],
      ),
    );
  }
}

// ── Success ───────────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  final dynamic result;
  final VoidCallback onClose;
  const _SuccessView({required this.result, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final venc = result.vencimiento as DateTime?;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 64)
              .animate()
              .scale(begin: const Offset(0.5, 0.5))
              .fadeIn(),
          const SizedBox(height: 16),
          const Text('¡Lote reservado!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20))
              .animate(delay: 200.ms)
              .fadeIn(),
          const SizedBox(height: 8),
          if (venc != null)
            Text(
              'Tu lote está reservado hasta el ${_formatDate(venc)}. '
              'Si no se llega a un acuerdo en ese plazo, volverá a estar disponible.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ).animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: 24),
          if (result.whatsappLink != null)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366)),
              onPressed: () =>
                  launchUrl(Uri.parse(result.whatsappLink as String)),
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Contactar por WhatsApp'),
            ).animate(delay: 400.ms).fadeIn(),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onClose,
            child: const Text('Cerrar'),
          ).animate(delay: 450.ms).fadeIn(),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const meses = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${dt.day} de ${meses[dt.month]} de ${dt.year}';
  }
}

// ── Login existing ────────────────────────────────────────────────────────────

class _LoginExistingView extends ConsumerStatefulWidget {
  final String? prefillEmail;
  final String? errorMessage;
  final String lotId;
  final TenantOption tenant;

  const _LoginExistingView({
    this.prefillEmail,
    this.errorMessage,
    required this.lotId,
    required this.tenant,
  });

  @override
  ConsumerState<_LoginExistingView> createState() => _LoginExistingViewState();
}

class _LoginExistingViewState extends ConsumerState<_LoginExistingView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.prefillEmail ?? '');
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tenant;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Ya tienes una cuenta. Ingresa tu contraseña para continuar con la reserva.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Error from previous login attempt
            if (widget.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  Icon(Icons.error_outline,
                      color: Colors.red.shade600, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.errorMessage!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.red.shade700)),
                  ),
                ]),
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (v) =>
                  v != null && v.contains('@') ? null : 'Correo inválido',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passCtrl,
              obscureText: _obscure,
              autofocus: widget.prefillEmail != null,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) =>
                  v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                ref.read(reservaFlowProvider.notifier).loginAndReserve(
                      email: _emailCtrl.text.trim(),
                      password: _passCtrl.text,
                      lotId: widget.lotId,
                      host: t.host,
                      primaryColor: t.primaryColor,
                      virtualProjectSlug: t.virtualProjectSlug,
                      logoUrl: t.logoUrl,
                    );
              },
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Iniciar sesión y reservar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 52)
              .animate()
              .shake(),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 20),
          FilledButton(
              onPressed: onRetry, child: const Text('Intentar de nuevo')),
        ],
      ),
    );
  }
}
