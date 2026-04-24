import 'package:hive/hive.dart';

part 'ssh_host.g.dart';

@HiveType(typeId: 0)
class SshHost extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String host;

  @HiveField(3)
  int port;

  @HiveField(4)
  String username;

  @HiveField(5)
  String? password;

  @HiveField(6)
  String? privateKey;

  @HiveField(7)
  String group;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime lastConnected;

  @HiveField(10)
  int connectionCount;

  @HiveField(11)
  String? color;

  @HiveField(12)
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
}
