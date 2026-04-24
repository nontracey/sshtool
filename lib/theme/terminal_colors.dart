import 'dart:ui';

class TerminalColors {
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFCD0000);
  static const Color green = Color(0xFF00CD00);
  static const Color yellow = Color(0xFFCDCD00);
  static const Color blue = Color(0xFF0000EE);
  static const Color magenta = Color(0xFFCD00CD);
  static const Color cyan = Color(0xFF00CDCD);
  static const Color white = Color(0xFFE5E5E5);
  
  static const Color brightBlack = Color(0xFF7F7F7F);
  static const Color brightRed = Color(0xFFFF0000);
  static const Color brightGreen = Color(0xFF00FF00);
  static const Color brightYellow = Color(0xFFFFFF00);
  static const Color brightBlue = Color(0xFF5C5CFF);
  static const Color brightMagenta = Color(0xFFFF00FF);
  static const Color brightCyan = Color(0xFF00FFFF);
  static const Color brightWhite = Color(0xFFFFFFFF);
  
  static const List<Color> defaultColorScheme = [
    black, red, green, yellow, blue, magenta, cyan, white,
    brightBlack, brightRed, brightGreen, brightYellow,
    brightBlue, brightMagenta, brightCyan, brightWhite,
  ];
  
  static const Color background = Color(0xFF1E1E1E);
  static const Color foreground = Color(0xFFD4D4D4);
  static const Color cursor = Color(0xFFD4D4D4);
  static const Color selection = Color(0xFF264F78);
}
