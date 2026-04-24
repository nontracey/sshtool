import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssh_tool/models/app_settings.dart';
import 'package:ssh_tool/services/storage_service.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.read(storageServiceProvider));
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final StorageService _storage;
  
  SettingsNotifier(this._storage) : super(AppSettings()) {
    _loadSettings();
  }
  
  void _loadSettings() {
    state = _storage.getSettings();
  }
  
  Future<void> updateSettings(AppSettings settings) async {
    await _storage.saveSettings(settings);
    state = settings;
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    await updateSettings(state.copyWith(themeMode: mode));
  }
  
  Future<void> setThemeColor(String color) async {
    await updateSettings(state.copyWith(themeColor: color));
  }
  
  Future<void> setFontFamily(String fontFamily) async {
    await updateSettings(state.copyWith(fontFamily: fontFamily));
  }
  
  Future<void> setFontSize(double fontSize) async {
    await updateSettings(state.copyWith(fontSize: fontSize));
  }
  
  Future<void> setLineHeight(double lineHeight) async {
    await updateSettings(state.copyWith(lineHeight: lineHeight));
  }
  
  Future<void> setTerminalFontFamily(String fontFamily) async {
    await updateSettings(state.copyWith(terminalFontFamily: fontFamily));
  }
  
  Future<void> setTerminalFontSize(double fontSize) async {
    await updateSettings(state.copyWith(terminalFontSize: fontSize));
  }
}
