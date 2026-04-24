import 'package:hive_flutter/hive_flutter.dart';
import 'package:ssh_tool/models/ssh_host.dart';
import 'package:ssh_tool/models/app_settings.dart';

class StorageService {
  static const String hostsBox = 'ssh_hosts';
  static const String settingsBox = 'app_settings';
  
  late Box<SshHost> _hostsBox;
  late Box<AppSettings> _settingsBox;
  
  Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(SshHostAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    
    _hostsBox = await Hive.openBox<SshHost>(hostsBox);
    _settingsBox = await Hive.openBox<AppSettings>(settingsBox);
  }

  List<SshHost> getAllHosts() {
    return _hostsBox.values.toList();
  }

  List<SshHost> getHostsByGroup(String group) {
    return _hostsBox.values.where((host) => host.group == group).toList();
  }

  List<String> getAllGroups() {
    return _hostsBox.values.map((host) => host.group).toSet().toList();
  }

  Future<void> addHost(SshHost host) async {
    await _hostsBox.put(host.id, host);
  }

  Future<void> updateHost(SshHost host) async {
    await _hostsBox.put(host.id, host);
  }

  Future<void> deleteHost(String id) async {
    await _hostsBox.delete(id);
  }

  SshHost? getHost(String id) {
    return _hostsBox.get(id);
  }

  AppSettings getSettings() {
    return _settingsBox.get('settings') ?? AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('settings', settings);
  }

  Future<void> clearAll() async {
    await _hostsBox.clear();
    await _settingsBox.clear();
  }
}
