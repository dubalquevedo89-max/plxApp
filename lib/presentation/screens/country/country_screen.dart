import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../providers/tenant_provider.dart';

const _flags = {
  'Ecuador': '🇪🇨',
  'Colombia': '🇨🇴',
  'Perú': '🇵🇪',
  'Panamá': '🇵🇦',
};

class CountryScreen extends ConsumerWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsByPaisProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn().slideY(begin: -0.2),
              const SizedBox(height: 8),
              Text(
                '¿En qué país se encuentra tu urbanización?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 40),
              Expanded(
                child: projectsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _ErrorView(onRetry: () => ref.invalidate(projectsByPaisProvider)),
                  data: (byPais) {
                    final paises = byPais.keys.toList()..sort();
                    return ListView.separated(
                      itemCount: paises.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final pais = paises[i];
                        return _CountryTile(
                          flag: _flags[pais] ?? '🏳️',
                          pais: pais,
                          onTap: () => context.push(
                            AppRoutes.urbanizaciones,
                            extra: pais,
                          ),
                        ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: -0.1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  final String flag;
  final String pais;
  final VoidCallback onTap;

  const _CountryTile({
    required this.flag,
    required this.pais,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Text(flag, style: const TextStyle(fontSize: 36)),
        title: Text(pais, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
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
          const Icon(Icons.wifi_off_rounded, size: 56),
          const SizedBox(height: 16),
          const Text('No se pudo cargar la información'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
