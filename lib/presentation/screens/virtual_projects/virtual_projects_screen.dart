import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/urbanizacion.dart';
import '../../../domain/entities/virtual_project.dart';

class VirtualProjectsScreen extends StatelessWidget {
  final Urbanizacion urbanizacion;
  const VirtualProjectsScreen({super.key, required this.urbanizacion});

  @override
  Widget build(BuildContext context) {
    final urb = urbanizacion;
    final vps = urb.virtualProjects.where((v) => v.appEnabled).toList();

    return Scaffold(
      appBar: AppBar(title: Text(urb.nombre)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vps.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final vp = vps[i];
          return _VirtualProjectTile(
            vp: vp,
            parentUrb: urb,
          ).animate().fadeIn(delay: (i * 60).ms).slideY(begin: 0.1);
        },
      ),
    );
  }
}

class _VirtualProjectTile extends StatelessWidget {
  final VirtualProject vp;
  final Urbanizacion parentUrb;

  const _VirtualProjectTile({required this.vp, required this.parentUrb});

  @override
  Widget build(BuildContext context) {
    final primary = Color(
      int.parse('FF${vp.primaryColor.replaceAll('#', '')}', radix: 16),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.login,
          extra: (urbanizacion: parentUrb, virtualProject: vp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 5, color: primary),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.domain_rounded, color: primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vp.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (vp.locationText != null) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  vp.locationText!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (vp.masterplanAppEnabled) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.map_outlined,
                                  size: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary),
                              const SizedBox(width: 4),
                              Text(
                                'Masterplan disponible',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
