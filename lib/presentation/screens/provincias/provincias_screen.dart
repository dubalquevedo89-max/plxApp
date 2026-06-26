import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../providers/tenant_provider.dart';

class ProvinciasScreen extends ConsumerWidget {
  final String pais;
  const ProvinciasScreen({super.key, required this.pais});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subdivAsync = ref.watch(subdivisionesByPaisProvider(pais));

    return Scaffold(
      appBar: AppBar(title: Text(pais)),
      body: subdivAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (subdivisions) {
          if (subdivisions.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushReplacement(AppRoutes.urbanizaciones,
                  extra: (pais: pais, subdivision: null));
            });
            return const SizedBox.shrink();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: subdivisions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final sub = subdivisions[i];
              return _SubdivisionTile(
                nombre: sub,
                onTap: () => context.push(
                  AppRoutes.urbanizaciones,
                  extra: (pais: pais, subdivision: sub),
                ),
              ).animate().fadeIn(delay: (i * 60).ms).slideX(begin: -0.1);
            },
          );
        },
      ),
    );
  }
}

class _SubdivisionTile extends StatelessWidget {
  final String nombre;
  final VoidCallback onTap;
  const _SubdivisionTile({required this.nombre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.map_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(nombre,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
