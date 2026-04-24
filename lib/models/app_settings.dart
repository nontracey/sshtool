import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
class AppSettings extends HiveObject {
  @HiveField(0)
  ThemeMode themeMode;

  @HiveField(1)
  String themeColor;

  @HiveField(2)
  String fontFamily;

  @HiveField(3)
  double fontSize;

  @HiveField(4)
  double lineHeight;

  @HiveField(5)
  int cursorStyle;

  @HiveField(6)
  bool bellSound;

  @HiveField(7)
  bool vibrateOnBell;

  @HiveField(8)
  int scrollbackLines;

  @HiveField(9)
  bool keepScreenOn;

  @HiveField(10)
  bool fullscreenMode;

  @HiveField(11)
  String terminalFontFamily;

  @HiveField(12)
  double terminalFontSize;

  @HiveField(13)
  bool showLineNumbers;

  @HiveField(14)
  String encoding;

  @HiveField(15)
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
}

enum ThemeMode {
  system,
  light,
  dark,
}
