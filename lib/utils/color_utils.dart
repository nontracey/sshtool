import 'package:flutter/material.dart';

class ColorUtils {
  static const Map<String, Color> predefinedColors = {
    'blue': Color(0xFF2196F3),
    'indigo': Color(0xFF3F51B5),
    'purple': Color(0xFF9C27B0),
    'pink': Color(0xFFE91E63),
    'red': Color(0xFFF44336),
    'orange': Color(0xFFFF9800),
    'yellow': Color(0xFFFFC107),
    'green': Color(0xFF4CAF50),
    'teal': Color(0xFF009688),
    'cyan': Color(0xFF00BCD4),
  };

  static Color parseColor(String? colorString) {
    if (colorString == null) return Colors.blue;
    
    if (predefinedColors.containsKey(colorString)) {
      return predefinedColors[colorString]!;
    }
    
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  static String colorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
