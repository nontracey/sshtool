import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:ssh_tool/models/app_settings.dart';

class AppTheme {
  static Map<String, FlexScheme> colorSchemes = {
    'blue': FlexScheme.blue,
    'indigo': FlexScheme.indigo,
    'purple': FlexScheme.deepPurple,
    'pink': FlexScheme.sakura,
    'red': FlexScheme.red,
    'orange': FlexScheme.amber,
    'yellow': FlexScheme.amber,
    'green': FlexScheme.green,
    'teal': FlexScheme.tealM3,
    'cyan': FlexScheme.cyanM3,
  };

  static ThemeData getTheme(AppSettings settings) {
    final scheme = colorSchemes[settings.themeColor] ?? FlexScheme.blue;

    switch (settings.themeMode) {
      case ThemeMode.light:
        return FlexThemeData.light(
          scheme: scheme,
          useMaterial3: true,
        );
      case ThemeMode.dark:
        return FlexThemeData.dark(
          scheme: scheme,
          useMaterial3: true,
        );
      default:
        return FlexThemeData.light(
          scheme: FlexScheme.blue,
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
