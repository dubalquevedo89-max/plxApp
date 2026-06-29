import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareQrFromKey(
  GlobalKey repaintKey, {
  String shareText = 'Pase QR',
}) async {
  // Espera que el frame actual termine de pintarse
  await Future.delayed(const Duration(milliseconds: 50));

  final boundary = repaintKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
  if (boundary == null) throw Exception('QR no encontrado en pantalla');
  if (boundary.debugNeedsPaint) {
    throw Exception('El QR aún no se ha pintado');
  }

  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) throw Exception('No se pudo codificar la imagen');

  final tmp = await getTemporaryDirectory();
  final file = File('${tmp.path}/qr_pase.png');
  await file.writeAsBytes(byteData.buffer.asUint8List());

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'image/png')],
      text: shareText,
    ),
  );
}
