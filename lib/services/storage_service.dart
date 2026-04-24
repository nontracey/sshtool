import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh_tool/models/ssh_host.dart';
import 'package:ssh_tool/models/app_settings.dart';

class StorageService {
  static const String hostsKey = 'ssh_hosts';
  static const String settingsKey = 'app_settings';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<SshHost> getAllHosts() {
    final jsonString = _prefs.getString(hostsKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => SshHost.fromJson(json)).toList();
  }

  List<SshHost> getHostsByGroup(String group) {
    return getAllHosts().where((host) => host.group == group).toList();
  }

  List<String> getAllGroups() {
    return getAllHosts().map((host) => host.group).toSet().toList();
  }

  Future<void> addHost(SshHost host) async {
    final hosts = getAllHosts();
    hosts.add(host);
    await _prefs.setString(hostsKey, jsonEncode(hosts.map((h) => h.toJson()).toList()));
  }

  Future<void> updateHost(SshHost host) async {
    final hosts = getAllHosts();
    final index = hosts.indexWhere((h) => h.id == host.id);
    if (index != -1) {
      hosts[index] = host;
      await _prefs.setString(hostsKey, jsonEncode(hosts.map((h) => h.toJson()).toList()));
    }
  }

  Future<void> deleteHost(String id) async {
    final hosts = getAllHosts();
    hosts.removeWhere((h) => h.id == id);
    await _prefs.setString(hostsKey, jsonEncode(hosts.map((h) => h.toJson()).toList()));
  }

  SshHost? getHost(String id) {
    return getAllHosts().firstWhere((h) => h.id == id, orElse: () => throw Exception('Not found'));
  }

  AppSettings getSettings() {
    final jsonString = _prefs.getString(settingsKey);
    if (jsonString == null) return AppSettings();
    return AppSettings.fromJson(jsonDecode(jsonString));
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(settingsKey, jsonEncode(settings.toJson()));
  }

  Future<void> clearAll() async {
    await _prefs.remove(hostsKey);
    await _prefs.remove(settingsKey);
  }
}
