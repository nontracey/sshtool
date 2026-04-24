import 'package:ssh_tool/models/ssh_host.dart';

export 'ssh_host.dart';
export 'app_settings.dart';

class HostGroup {
  final String name;
  final List<SshHost> hosts;
  final bool isExpanded;

  HostGroup({
    required this.name,
    required this.hosts,
    this.isExpanded = true,
  });

  HostGroup copyWith({
    String? name,
    List<SshHost>? hosts,
    bool? isExpanded,
  }) {
    return HostGroup(
      name: name ?? this.name,
      hosts: hosts ?? this.hosts,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class ConnectionSession {
  final SshHost host;
  final DateTime connectedAt;
  final String sessionId;

  ConnectionSession({
    required this.host,
    required this.connectedAt,
    required this.sessionId,
  });
}
