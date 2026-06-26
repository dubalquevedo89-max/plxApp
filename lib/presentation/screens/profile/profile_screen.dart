import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/session_storage.dart';
import '../../../domain/entities/usuario.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final tenantProfile = SessionStorage.activeProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('No se pudieron cargar tus datos',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    ref.read(profileProvider.notifier).refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AvatarHeader(user: user, tenantColor: tenantProfile?.primaryColor)
                  .animate()
                  .fadeIn()
                  .slideY(begin: -0.1),
              const SizedBox(height: 24),
              _InfoSection(user: user)
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.05),
              const SizedBox(height: 16),
              _EditProfileTile(user: user)
                  .animate()
                  .fadeIn(delay: 180.ms),
              const SizedBox(height: 8),
              _ChangePasswordTile()
                  .animate()
                  .fadeIn(delay: 240.ms),
            ],
          );
        },
      ),
    );
  }
}

// ── Avatar / header ───────────────────────────────────────────────────────────

class _AvatarHeader extends StatelessWidget {
  final Usuario user;
  final String? tenantColor;
  const _AvatarHeader({required this.user, this.tenantColor});

  @override
  Widget build(BuildContext context) {
    final primary = tenantColor != null
        ? Color(int.parse('FF${tenantColor!.replaceAll('#', '')}', radix: 16))
        : Theme.of(context).colorScheme.primary;

    final initials = user.nombre
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: primary.withValues(alpha: 0.15),
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.nombre,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

// ── Info chips ────────────────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  final Usuario user;
  const _InfoSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'Cédula',
              value: user.cedula ?? '—',
            ),
            const Divider(height: 1, indent: 56),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              value: user.telefono ?? '—',
            ),
            const Divider(height: 1, indent: 56),
            _InfoRow(
              icon: Icons.verified_user_outlined,
              label: 'Rol',
              value: _rolLabel(user.rol),
            ),
          ],
        ),
      ),
    );
  }

  String _rolLabel(String rol) => switch (rol) {
        'comprador' => 'Residente / Comprador',
        'admin' => 'Administrador',
        _ => rol,
      };
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          color: Theme.of(context).colorScheme.primary, size: 22),
      title: Text(label,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      subtitle: Text(value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500)),
      dense: true,
    );
  }
}

// ── Edit profile tile ─────────────────────────────────────────────────────────

class _EditProfileTile extends ConsumerWidget {
  final Usuario user;
  const _EditProfileTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading:
            Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary),
        title: const Text('Editar información personal'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showEditSheet(context, ref),
      ),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditProfileSheet(user: user),
    );
  }
}

// ── Edit profile sheet ────────────────────────────────────────────────────────

class _EditProfileSheet extends ConsumerStatefulWidget {
  final Usuario user;
  const _EditProfileSheet({required this.user});

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.user.nombre);
  late final _telefonoCtrl =
      TextEditingController(text: widget.user.telefono ?? '');
  late final _cedulaCtrl =
      TextEditingController(text: widget.user.cedula ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _cedulaCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final error = await ref.read(profileProvider.notifier).updateProfile(
          nombre: _nombreCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim(),
          cedula: _cedulaCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil actualizado correctamente.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text('Editar perfil',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombreCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  v != null && v.trim().length >= 3 ? null : 'Mínimo 3 caracteres',
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: '+593998887766',
              ),
              validator: (v) =>
                  v != null && v.trim().isNotEmpty ? null : 'Ingresa un teléfono',
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _cedulaCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cédula',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (v) =>
                  v != null && v.trim().isNotEmpty ? null : 'Ingresa tu cédula',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Change password tile ──────────────────────────────────────────────────────

class _ChangePasswordTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.lock_outline,
            color: Theme.of(context).colorScheme.primary),
        title: const Text('Cambiar contraseña'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showChangePasswordSheet(context, ref),
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ChangePasswordSheet(),
    );
  }
}

// ── Change password sheet ─────────────────────────────────────────────────────

class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  @override
  ConsumerState<_ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _actualCtrl = TextEditingController();
  final _nuevoCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _obscureActual = true;
  bool _obscureNuevo = true;
  bool _obscureConfirmar = true;
  bool _saving = false;

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevoCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final error =
        await ref.read(profileProvider.notifier).changePassword(
              passwordActual: _actualCtrl.text,
              passwordNuevo: _nuevoCtrl.text,
            );

    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contraseña actualizada correctamente.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text('Cambiar contraseña',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _PasswordField(
              controller: _actualCtrl,
              label: 'Contraseña actual',
              obscure: _obscureActual,
              onToggle: () =>
                  setState(() => _obscureActual = !_obscureActual),
              validator: (v) => v != null && v.isNotEmpty ? null : 'Requerida',
            ),
            const SizedBox(height: 14),
            _PasswordField(
              controller: _nuevoCtrl,
              label: 'Nueva contraseña',
              obscure: _obscureNuevo,
              onToggle: () => setState(() => _obscureNuevo = !_obscureNuevo),
              validator: (v) => v != null && v.length >= 8
                  ? null
                  : 'Mínimo 8 caracteres',
            ),
            const SizedBox(height: 14),
            _PasswordField(
              controller: _confirmarCtrl,
              label: 'Confirmar nueva contraseña',
              obscure: _obscureConfirmar,
              onToggle: () =>
                  setState(() => _obscureConfirmar = !_obscureConfirmar),
              validator: (v) => v == _nuevoCtrl.text
                  ? null
                  : 'Las contraseñas no coinciden',
            ),
            const SizedBox(height: 8),
            // Strength indicator
            _PasswordStrengthBar(password: _nuevoCtrl.text),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }
}

// ── Password strength bar ─────────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  final String password;
  const _PasswordStrengthBar({required this.password});

  ({int level, String label, Color color}) _strength(String p) {
    if (p.isEmpty) return (level: 0, label: '', color: Colors.transparent);
    int score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;
    return switch (score) {
      <= 1 => (level: 1, label: 'Débil', color: Colors.red),
      2 => (level: 2, label: 'Regular', color: Colors.orange),
      3 => (level: 3, label: 'Buena', color: Colors.amber),
      _ => (level: 4, label: 'Fuerte', color: Colors.green),
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = _strength(password);
    if (password.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          children: List.generate(4, (i) {
            final filled = i < s.level;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: filled ? s.color : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(s.label,
            style: TextStyle(fontSize: 12, color: s.color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
