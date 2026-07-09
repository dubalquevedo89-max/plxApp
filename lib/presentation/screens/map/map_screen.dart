import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/utils/share_url.dart';
import '../../../domain/entities/lot_detail.dart';
import '../../../domain/entities/tenant_option.dart';
import '../../providers/lot_provider.dart';
import '../../providers/map_provider.dart';
import 'reserva_flow_sheet.dart';

// ── Tile sources ──────────────────────────────────────────────────────────────

const _osmUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _satelliteUrl =
    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

// ── Status helpers ────────────────────────────────────────────────────────────

const _allStatuses = ['disponible', 'reservado', 'vendido', 'no_disponible'];

Color _lotColor(String estado) {
  switch (estado.toLowerCase()) {
    case 'disponible':
      return Colors.green;
    case 'vendido':
    case 'venta_completada':
      return Colors.red;
    case 'reservado':
    case 'reserva_activa':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String _statusKey(String estado) {
  switch (estado.toLowerCase()) {
    case 'vendido':
    case 'venta_completada':
      return 'vendido';
    case 'reservado':
    case 'reserva_activa':
      return 'reservado';
    case 'bloqueado':
    case 'no_disponible':
      return 'no_disponible';
    default:
      return 'disponible';
  }
}

String _statusLabel(String key) {
  const map = {
    'disponible': 'Disponible',
    'vendido': 'Vendido',
    'reservado': 'Reservado',
    'no_disponible': 'No disponible',
  };
  return map[key] ?? key;
}

// ── Entity ────────────────────────────────────────────────────────────────────

class _LotFeature {
  final String? id;
  final String codigo;
  final String estado;
  final String statusKey;
  final String? area;
  final List<LatLng> points;

  const _LotFeature({
    this.id,
    required this.codigo,
    required this.estado,
    required this.statusKey,
    this.area,
    required this.points,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class MapScreen extends ConsumerStatefulWidget {
  final TenantOption tenant;
  const MapScreen({super.key, required this.tenant});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  final _searchCtrl = TextEditingController();

  // Kept for the PolygonLayer (required param) but we don't use it for selection
  final _hitNotifier = LayerHitNotifier<_LotFeature>(null);

  _LotFeature? _selected;
  List<_LotFeature> _allFeatures = [];
  Set<String> _activeStatuses = Set.from(_allStatuses);
  bool _isSatellite = false;
  bool _searchOpen = false;
  String _searchQuery = '';
  String _lastZoomedQuery = '';
  String _lastFilterHash = '';

  @override
  void dispose() {
    _hitNotifier.dispose();
    _mapController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // Only called by MapOptions.onTap — flutter_map guarantees this is a real tap, not a drag
  void _onMapTap(LatLng tapped) {
    final hit = _allFeatures.firstWhere(
      (f) => _pointInPolygon(tapped, f.points),
      orElse: () => _LotFeature(
        codigo: '',
        estado: '',
        statusKey: '',
        points: [],
      ),
    );
    setState(() => _selected = hit.points.isEmpty ? null : hit);
  }

  static bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    int crossings = 0;
    for (int i = 0; i < polygon.length; i++) {
      final a = polygon[i];
      final b = polygon[(i + 1) % polygon.length];
      if (((a.latitude <= point.latitude && point.latitude < b.latitude) ||
              (b.latitude <= point.latitude &&
                  point.latitude < a.latitude)) &&
          point.longitude <
              (b.longitude - a.longitude) *
                      (point.latitude - a.latitude) /
                      (b.latitude - a.latitude) +
                  a.longitude) {
        crossings++;
      }
    }
    return crossings.isOdd;
  }

  void _zoomToFit(List<_LotFeature> features) {
    final allPoints = features.expand((f) => f.points).toList();
    if (allPoints.isEmpty) return;
    _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: allPoints,
        padding: const EdgeInsets.all(24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tenant;
    final geoAsync = ref.watch(geoJsonProvider(
      t.slug,
      t.host,
      virtualProjectSlug: t.virtualProjectSlug,
      parentSlug: t.parentSlug,
    ));

    return Scaffold(
      appBar: AppBar(
        title: _searchOpen
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar lote por código…',
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _searchQuery = v.trim()),
              )
            : Text(t.nombre),
        actions: [
          IconButton(
            icon: Icon(_searchOpen ? Icons.close : Icons.search_rounded),
            onPressed: () => setState(() {
              _searchOpen = !_searchOpen;
              if (!_searchOpen) {
                _searchQuery = '';
                _searchCtrl.clear();
              }
            }),
          ),
          IconButton(
            tooltip: _isSatellite ? 'Ver mapa' : 'Ver satélite',
            icon: Icon(_isSatellite
                ? Icons.map_outlined
                : Icons.satellite_alt_outlined),
            onPressed: () => setState(() => _isSatellite = !_isSatellite),
          ),
        ],
      ),
      body: geoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          error: e,
          onRetry: () => ref.invalidate(geoJsonProvider(
            t.slug,
            t.host,
            virtualProjectSlug: t.virtualProjectSlug,
            parentSlug: t.parentSlug,
          )),
        ),
        data: (geojson) {
          final allFeatures = _parseFeatures(geojson);
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => _allFeatures = allFeatures);
          if (allFeatures.isEmpty) {
            return const Center(child: Text('Sin lotes disponibles'));
          }

          final filtered = allFeatures.where((f) {
            final statusOk = _activeStatuses.contains(f.statusKey);
            final searchOk = _searchQuery.isEmpty ||
                f.codigo.toLowerCase().contains(_searchQuery.toLowerCase());
            return statusOk && searchOk;
          }).toList();

          // Auto-fit cuando el query cambia y hay resultados
          if (_searchQuery.isNotEmpty &&
              _searchQuery != _lastZoomedQuery &&
              filtered.isNotEmpty) {
            _lastZoomedQuery = _searchQuery;
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _zoomToFit(filtered));
          } else if (_searchQuery.isEmpty && _lastZoomedQuery.isNotEmpty) {
            _lastZoomedQuery = '';
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _zoomToFit(allFeatures));
          }

          // Auto-fit cuando cambian los filtros de estado
          final filterHash = (_activeStatuses.toList()..sort()).join(',');
          if (filterHash != _lastFilterHash) {
            _lastFilterHash = filterHash;
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _zoomToFit(filtered.isNotEmpty ? filtered : allFeatures));
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _computeCenter(allFeatures),
                  initialZoom: 17,
                  onTap: (_, latLng) => _onMapTap(latLng),
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                    scrollWheelVelocity: 0.005,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        _isSatellite ? _satelliteUrl : _osmUrl,
                    userAgentPackageName: 'com.plxmap.plx_app',
                    maxZoom: 20,
                  ),
                  PolygonLayer(
                    hitNotifier: _hitNotifier,
                    polygons: filtered.map((f) {
                      final isSelected = _selected == f;
                      final color = _lotColor(f.estado);
                      return Polygon(
                        points: f.points,
                        color: color.withValues(
                            alpha: isSelected ? 0.85 : 0.5),
                        borderColor: isSelected ? Colors.white : color,
                        borderStrokeWidth: isSelected ? 3.0 : 1.5,
                        hitValue: f,
                        label: f.codigo,
                        labelStyle: TextStyle(
                          fontSize: 9,
                          color: _isSatellite
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                    polygonLabels: true,
                  ),
                ],
              ),

              // Filter chips
              Positioned(
                top: 10,
                left: 8,
                right: 8,
                child: _FilterBar(
                  activeStatuses: _activeStatuses,
                  onToggle: (key) => setState(() {
                    if (_activeStatuses.contains(key)) {
                      if (_activeStatuses.length > 1) {
                        _activeStatuses = Set.from(_activeStatuses)..remove(key);
                      }
                    } else {
                      _activeStatuses = Set.from(_activeStatuses)..add(key);
                    }
                  }),
                ),
              ),

              // Legend + zoom controls
              Positioned(
                bottom: _selected != null ? 320 : 80,
                right: 12,
                child: const _Legend(),
              ),
              Positioned(
                bottom: _selected != null ? 320 : 80,
                left: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoom_in',
                      tooltip: 'Acercar',
                      onPressed: () => _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom + 1,
                      ),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 6),
                    FloatingActionButton.small(
                      heroTag: 'zoom_out',
                      tooltip: 'Alejar',
                      onPressed: () => _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom - 1,
                      ),
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(height: 6),
                    FloatingActionButton.small(
                      heroTag: 'zoom_fit',
                      tooltip: 'Encuadrar',
                      onPressed: () => _zoomToFit(allFeatures),
                      child: const Icon(Icons.fit_screen_outlined),
                    ),
                  ],
                ),
              ),

              // Lot detail panel
              if (_selected != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _LotPanel(
                    feature: _selected!,
                    tenant: t,
                    onClose: () => setState(() => _selected = null),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<_LotFeature> _parseFeatures(Map<String, dynamic> geojson) {
    final features = <_LotFeature>[];
    for (final raw in geojson['features'] as List? ?? []) {
      try {
        final f = raw as Map<String, dynamic>;
        final props =
            (f['properties'] as Map?)?.cast<String, dynamic>() ?? {};
        final geometry = f['geometry'] as Map<String, dynamic>;
        final type = geometry['type'] as String;

        List<LatLng> ring(List r) => r.map((c) {
              final coord = c as List;
              return LatLng(
                (coord[1] as num).toDouble(),
                (coord[0] as num).toDouble(),
              );
            }).toList();

        List<LatLng> points;
        if (type == 'Polygon') {
          points = ring((geometry['coordinates'] as List).first as List);
        } else if (type == 'MultiPolygon') {
          points = ring(
              ((geometry['coordinates'] as List).first as List).first as List);
        } else {
          continue;
        }
        if (points.isEmpty) continue;

        final estado = props['estado']?.toString() ??
            props['status']?.toString() ??
            'disponible';

        features.add(_LotFeature(
          id: props['id']?.toString(),
          codigo: props['codigo']?.toString() ??
              props['code']?.toString() ??
              '${features.length + 1}',
          estado: estado,
          statusKey: _statusKey(estado),
          area: props['area_m2']?.toString() ?? props['area']?.toString(),
          points: points,
        ));
      } catch (_) {}
    }
    return features;
  }

  LatLng _computeCenter(List<_LotFeature> features) {
    double lat = 0, lng = 0;
    int count = 0;
    for (final f in features) {
      for (final p in f.points) {
        lat += p.latitude;
        lng += p.longitude;
        count++;
      }
    }
    return count > 0 ? LatLng(lat / count, lng / count) : const LatLng(0, 0);
  }
}

// ── Lot panel (summary + full detail) ────────────────────────────────────────

class _LotPanel extends ConsumerWidget {
  final _LotFeature feature;
  final TenantOption tenant;
  final VoidCallback onClose;

  const _LotPanel({
    required this.feature,
    required this.tenant,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _lotColor(feature.estado);

    // If we have an id, fetch full details
    final detailAsync = feature.id != null
        ? ref.watch(lotDetailProvider(
            feature.id!,
            tenant.host,
            virtualProjectSlug: tenant.virtualProjectSlug,
          ))
        : null;

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lote ${feature.codigo}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Chip(
                    label: Text(
                      _statusLabel(feature.statusKey),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                    backgroundColor: color,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    tooltip: 'Compartir lote',
                    onPressed: () {
                      final profile = SessionStorage.activeProfile;
                      if (profile != null) {
                        shareLote(profile, feature.codigo);
                      }
                    },
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
            ),
            const Divider(height: 16),
            // Content
            Flexible(
              child: detailAsync == null
                  ? _BasicInfo(feature: feature)
                  : detailAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, _) => _BasicInfo(feature: feature),
                      data: (detail) => _FullDetail(
                            detail: detail,
                            tenant: tenant,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInfo extends StatelessWidget {
  final _LotFeature feature;
  const _BasicInfo({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          if (feature.area != null) ...[
            const Icon(Icons.square_foot_outlined, size: 16),
            const SizedBox(width: 6),
            Text('${feature.area} m²',
                style: const TextStyle(fontSize: 14)),
          ],
        ],
      ),
    );
  }
}

class _FullDetail extends StatefulWidget {
  final LotDetail detail;
  final TenantOption tenant;
  const _FullDetail({required this.detail, required this.tenant});

  @override
  State<_FullDetail> createState() => _FullDetailState();
}


class _FullDetailState extends State<_FullDetail> {
  int _photoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo carousel
          if (d.fotos.isNotEmpty) ...[
            SizedBox(
              height: 160,
              child: PageView.builder(
                itemCount: d.fotos.length,
                onPageChanged: (i) => setState(() => _photoIndex = i),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: d.fotos[i],
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (d.fotos.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  d.fotos.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 3, vertical: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _photoIndex
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],

          // Stats row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              if (d.areaM2 != null)
                _Stat(
                    icon: Icons.square_foot_outlined,
                    label: '${d.areaM2!.toStringAsFixed(2)} m²'),
              if (d.precio != null && d.precio! > 0)
                _Stat(
                    icon: Icons.attach_money,
                    label: '\$${_formatNum(d.precio!)}'),
              if (d.zona != null)
                _Stat(
                    icon: Icons.layers_outlined,
                    label: d.zona!.replaceAll('_', ' ')),
              if (d.etapa != null)
                _Stat(icon: Icons.flag_outlined, label: d.etapa!),
              if (d.valorArriendo != null && d.valorArriendo! > 0)
                _Stat(
                    icon: Icons.home_work_outlined,
                    label: 'Arriendo \$${_formatNum(d.valorArriendo!)}'),
            ],
          ),

          // Badges
          if (d.destacado || d.tienePh || d.hasTourVirtual) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (d.destacado)
                  const Chip(
                      label: Text('⭐ Destacado',
                          style: TextStyle(fontSize: 11))),
                if (d.tienePh)
                  Chip(
                      label: Text(
                          '${d.phCount} PH',
                          style: const TextStyle(fontSize: 11))),
                if (d.hasTourVirtual)
                  const Chip(
                      label: Text('🥽 Tour virtual',
                          style: TextStyle(fontSize: 11))),
              ],
            ),
          ],

          // Descripción
          if (d.descripcion != null && d.descripcion!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(d.descripcion!,
                style: TextStyle(
                    color: Colors.grey.shade700, fontSize: 13)),
          ],

          // Action buttons
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (d.estado.toLowerCase() == 'disponible' && d.id.isNotEmpty)
                FilledButton.icon(
                  onPressed: () => ReservaFlowSheet.show(
                    context,
                    lotId: d.id,
                    lotCodigo: d.codigo,
                    tenant: widget.tenant,
                  ),
                  icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                  label: const Text('Reservar'),
                ),
              if (d.hasTourVirtual && d.tourVirtualUrl != null)
                OutlinedButton.icon(
                  onPressed: () => _launch(d.tourVirtualUrl!),
                  icon: const Icon(Icons.vrpano_outlined, size: 18),
                  label: const Text('Tour virtual'),
                ),
              if (d.videos.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () => _launch(d.videos.first),
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: const Text('Video'),
                ),
              if (d.videoSobrevueloUrl != null)
                OutlinedButton.icon(
                  onPressed: () => _launch(d.videoSobrevueloUrl!),
                  icon: const Icon(Icons.flight_outlined, size: 18),
                  label: const Text('Sobrevuelo'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNum(double v) {
    if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}K';
    }
    return v.toStringAsFixed(0);
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Stat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      );
}

// ── Filter bar ────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final Set<String> activeStatuses;
  final void Function(String) onToggle;
  const _FilterBar({required this.activeStatuses, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _allStatuses.map((key) {
          final active = activeStatuses.contains(key);
          final color = _lotColor(key);
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(_statusLabel(key)),
              selected: active,
              onSelected: (_) => onToggle(key),
              selectedColor: color.withValues(alpha: 0.25),
              checkmarkColor: color,
              side:
                  BorderSide(color: active ? color : Colors.grey.shade400),
              labelStyle: TextStyle(
                fontSize: 11,
                color: active ? color : Colors.grey,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              visualDensity: VisualDensity.compact,
              backgroundColor: Colors.white.withValues(alpha: 0.9),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Legend ────────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Disponible', 'disponible'),
      ('Reservado', 'reservado'),
      ('Vendido', 'vendido'),
      ('No disponible', 'no_disponible'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: items
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _lotColor(e.$2).withValues(alpha: 0.7),
                            border: Border.all(color: _lotColor(e.$2)),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(e.$1, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final is402 = error is DioException &&
        (error as DioException).response?.statusCode == 402;
    String? detail;
    if (error is DioException) {
      final data = (error as DioException).response?.data;
      if (data is Map) detail = data['detail'] as String?;
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                is402 ? Icons.lock_outline_rounded : Icons.map_outlined,
                size: 56,
                color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              is402
                  ? 'Masterplan no disponible'
                  : 'No se pudo cargar el masterplan',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              detail ??
                  (is402
                      ? 'La suscripción está suspendida.'
                      : 'Error al obtener los datos.'),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (!is402) ...[
              const SizedBox(height: 16),
              FilledButton(
                  onPressed: onRetry, child: const Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}
