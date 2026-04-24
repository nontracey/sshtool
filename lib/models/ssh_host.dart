class SshHost {
  String id;
  String name;
  String host;
  int port;
  String username;
  String? password;
  String? privateKey;
  String group;
  DateTime createdAt;
  DateTime lastConnected;
  int connectionCount;
  String? color;
  String? icon;

  SshHost({
    required this.id,
    required this.name,
    required this.host,
    this.port = 22,
    required this.username,
    this.password,
    this.privateKey,
    this.group = 'default',
    DateTime? createdAt,
    DateTime? lastConnected,
    this.connectionCount = 0,
    this.color,
    this.icon,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastConnected = lastConnected ?? DateTime.now();

  factory SshHost.fromJson(Map<String, dynamic> json) {
    return SshHost(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      host: json['host'] ?? '',
      port: json['port'] ?? 22,
      username: json['username'] ?? '',
      password: json['password'],
      privateKey: json['privateKey'],
      group: json['group'] ?? 'default',
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastConnected: DateTime.parse(json['lastConnected'] as String),
      connectionCount: json['connectionCount'] ?? 0,
      color: json['color'],
      icon: json['icon'],
    );
  }

  SshHost copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? username,
    String? password,
    String? privateKey,
    String? group,
    DateTime? createdAt,
    DateTime? lastConnected,
    int? connectionCount,
    String? color,
    String? icon,
  }) {
    return SshHost(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      privateKey: privateKey ?? this.privateKey,
      group: group ?? this.group,
      createdAt: createdAt ?? this.createdAt,
      lastConnected: lastConnected ?? this.lastConnected,
      connectionCount: connectionCount ?? this.connectionCount,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'privateKey': privateKey,
      'group': group,
      'createdAt': createdAt.toIso8601String(),
      'lastConnected': lastConnected.toIso8601String(),
      'connectionCount': connectionCount,
      'color': color,
      'icon': icon,
    };
  }
}
