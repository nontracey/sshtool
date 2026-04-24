import 'package:flutter/material.dart';

class AppSettings {
  ThemeMode themeMode;
  String themeColor;
  String fontFamily;
  double fontSize;
  double lineHeight;
  int cursorStyle;
  bool bellSound;
  bool vibrateOnBell;
  int scrollbackLines;
  bool keepScreenOn;
  bool fullscreenMode;
  String terminalFontFamily;
  double terminalFontSize;
  bool showLineNumbers;
  String encoding;
  int connectionTimeout;

  AppSettings({
    this.themeMode = ThemeMode.system,
    this.themeColor = 'blue',
    this.fontFamily = 'Roboto',
    this.fontSize = 14.0,
    this.lineHeight = 1.5,
    this.cursorStyle = 0,
    this.bellSound = true,
    this.vibrateOnBell = false,
    this.scrollbackLines = 10000,
    this.keepScreenOn = true,
    this.fullscreenMode = false,
    this.terminalFontFamily = 'JetBrainsMono',
    this.terminalFontSize = 14.0,
    this.showLineNumbers = false,
    this.encoding = 'UTF-8',
    this.connectionTimeout = 30,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values.byName(json['themeMode'] ?? 'system'),
      themeColor: json['themeColor'] ?? 'blue',
      fontFamily: json['fontFamily'] ?? 'Roboto',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.5,
      cursorStyle: json['cursorStyle'] ?? 0,
      bellSound: json['bellSound'] ?? true,
      vibrateOnBell: json['vibrateOnBell'] ?? false,
      scrollbackLines: json['scrollbackLines'] ?? 10000,
      keepScreenOn: json['keepScreenOn'] ?? true,
      fullscreenMode: json['fullscreenMode'] ?? false,
      terminalFontFamily: json['terminalFontFamily'] ?? 'JetBrainsMono',
      terminalFontSize: (json['terminalFontSize'] as num?)?.toDouble() ?? 14.0,
      showLineNumbers: json['showLineNumbers'] ?? false,
      encoding: json['encoding'] ?? 'UTF-8',
      connectionTimeout: json['connectionTimeout'] ?? 30,
    );
  }

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? themeColor,
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    int? cursorStyle,
    bool? bellSound,
    bool? vibrateOnBell,
    int? scrollbackLines,
    bool? keepScreenOn,
    bool? fullscreenMode,
    String? terminalFontFamily,
    double? terminalFontSize,
    bool? showLineNumbers,
    String? encoding,
    int? connectionTimeout,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      cursorStyle: cursorStyle ?? this.cursorStyle,
      bellSound: bellSound ?? this.bellSound,
      vibrateOnBell: vibrateOnBell ?? this.vibrateOnBell,
      scrollbackLines: scrollbackLines ?? this.scrollbackLines,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      fullscreenMode: fullscreenMode ?? this.fullscreenMode,
      terminalFontFamily: terminalFontFamily ?? this.terminalFontFamily,
      terminalFontSize: terminalFontSize ?? this.terminalFontSize,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      encoding: encoding ?? this.encoding,
      connectionTimeout: connectionTimeout ?? this.connectionTimeout,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'themeColor': themeColor,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'cursorStyle': cursorStyle,
      'bellSound': bellSound,
      'vibrateOnBell': vibrateOnBell,
      'scrollbackLines': scrollbackLines,
      'keepScreenOn': keepScreenOn,
      'fullscreenMode': fullscreenMode,
      'terminalFontFamily': terminalFontFamily,
      'terminalFontSize': terminalFontSize,
      'showLineNumbers': showLineNumbers,
      'encoding': encoding,
      'connectionTimeout': connectionTimeout,
    };
  }
}
