import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData fromTenantColor(String hexColor) {
    final color = _hexToColor(hexColor);
    return FlexThemeData.light(
      colors: FlexSchemeColor.from(primary: color),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12,
        elevatedButtonRadius: 12,
        cardRadius: 16,
        appBarCenterTitle: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
    );
  }

  static ThemeData get fallback => fromTenantColor('#D4AF37');

  static Color _hexToColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
}
