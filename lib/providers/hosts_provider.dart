import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:ssh_tool/models/ssh_host.dart';
import 'package:ssh_tool/services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final hostsProvider = StateNotifierProvider<HostsNotifier, List<SshHost>>((ref) {
  return HostsNotifier(ref.read(storageServiceProvider));
});

class HostsNotifier extends StateNotifier<List<SshHost>> {
  final StorageService _storage;
  
  HostsNotifier(this._storage) : super([]) {
    _loadHosts();
  }
  
  void _loadHosts() {
    state = _storage.getAllHosts();
  }
  
  Future<void> addHost(SshHost host) async {
    final newHost = host.copyWith(id: const Uuid().v4());
    await _storage.addHost(newHost);
    state = [...state, newHost];
  }
  
  Future<void> updateHost(SshHost host) async {
    await _storage.updateHost(host);
    state = state.map((h) => h.id == host.id ? host : h).toList();
  }
  
  Future<void> deleteHost(String id) async {
    await _storage.deleteHost(id);
    state = state.where((h) => h.id != id).toList();
  }
  
  List<SshHost> getHostsByGroup(String group) {
    return state.where((h) => h.group == group).toList();
  }
  
  List<String> getGroups() {
    return state.map((h) => h.group).toSet().toList();
  }
}
