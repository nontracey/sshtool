import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssh_tool/models/app_settings.dart';

class AppTheme {
  static const Map<String, FlexScheme> colorSchemes = {
    'blue': FlexScheme.blue,
    'indigo': FlexScheme.indigo,
    'purple': FlexScheme.purple,
    'pink': FlexScheme.pink,
    'red': FlexScheme.red,
    'orange': FlexScheme.orange,
    'yellow': FlexScheme.amber,
    'green': FlexScheme.green,
    'teal': FlexScheme.teal,
    'cyan': FlexScheme.cyan,
  };

  static ThemeData getTheme(AppSettings settings) {
    final scheme = colorSchemes[settings.themeColor] ?? FlexScheme.blue;
    
    switch (settings.themeMode) {
      case ThemeMode.light:
        return FlexThemeData.light(
          scheme: scheme,
          useMaterial3: true,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          appBarElevation: 0,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnContainer: false,
            useM2StyleDividerInM3: true,
            thickBorderWidth: 2,
            elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
            elevatedButtonBorderSchemeColor: SchemeColor.primaryContainer,
            outlinedButtonOutlineSchemeColor: SchemeColor.primary,
            toggleButtonsBorderSchemeColor: SchemeColor.primary,
            segmentedButtonSchemeColor: SchemeColor.primary,
            bottomAppBarOpacity: 0.95,
            navigationBarOpacity: 0.95,
            navigationRailOpacity: 0.95,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          fontFamily: settings.fontFamily,
        );
      case ThemeMode.dark:
        return FlexThemeData.dark(
          scheme: scheme,
          useMaterial3: true,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          appBarElevation: 0,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            blendOnContainer: false,
            useM2StyleDividerInM3: true,
            thickBorderWidth: 2,
            elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
            elevatedButtonBorderSchemeColor: SchemeColor.primaryContainer,
            outlinedButtonOutlineSchemeColor: SchemeColor.primary,
            toggleButtonsBorderSchemeColor: SchemeColor.primary,
            segmentedButtonSchemeColor: SchemeColor.primary,
            bottomAppBarOpacity: 0.95,
            navigationBarOpacity: 0.95,
            navigationRailOpacity: 0.95,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          fontFamily: settings.fontFamily,
        );
      default:
        return FlexThemeData.light(
          scheme: scheme,
          useMaterial3: true,
        );
    }
  }

  static TextStyle getTerminalTextStyle(AppSettings settings) {
    return TextStyle(
      fontFamily: settings.terminalFontFamily,
      fontSize: settings.terminalFontSize,
      height: settings.lineHeight,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
    );
  }
}
