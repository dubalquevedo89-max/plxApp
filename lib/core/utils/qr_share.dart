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
  await Future.delayed(const Duration(milliseconds: 400));

  final boundary = repaintKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
  if (boundary == null) throw Exception('QR no encontrado en pantalla');

  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) throw Exception('No se pudo codificar la imagen');

  final tmp = await getTemporaryDirectory();
  final file = File('${tmp.path}/qr_pase.png');
  await file.writeAsBytes(byteData.buffer.asUint8List());

  try {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: shareText,
      ),
    );
  } catch (_) {
    // share_plus bug on Android: thrown when user dismisses the share sheet.
  }
}
