import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// QR con el logo de la urbanización centrado.
/// Envolver en RepaintBoundary para capturar como imagen.
class QrWithLogo extends StatelessWidget {
  final String data;
  final double size;
  final String? logoUrl;

  const QrWithLogo({
    super.key,
    required this.data,
    this.size = 240,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size * 0.22;
    final innerPad = logoSize * 0.08;
    final radius = logoSize * 0.14;

    final qr = QrImageView(
      data: data.isEmpty ? 'invalid' : data,
      version: QrVersions.auto,
      size: size,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );

    if (logoUrl == null || logoUrl!.isEmpty) return qr;

    return Stack(
      alignment: Alignment.center,
      children: [
        qr,
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(innerPad),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius * 0.7),
            child: CachedNetworkImage(
              imageUrl: logoUrl!,
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 150),
              placeholder: (_, _) => const SizedBox.shrink(),
              errorWidget: (_, _, _) => Icon(
                Icons.apartment_rounded,
                size: logoSize * 0.5,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
