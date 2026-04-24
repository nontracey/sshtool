import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'package:ssh_tool/models/ssh_host.dart';

class SshService {
  SSHClient? _client;
  SSHSession? _shellSession;
  StreamController<String>? _outputController;
  StreamController<String>? _errorController;

  Stream<String> get output => _outputController?.stream ?? const Stream.empty();
  Stream<String> get error => _errorController?.stream ?? const Stream.empty();

  bool get isConnected => _client != null;

  Future<void> connect(SshHost host) async {
    try {
      _outputController = StreamController<String>.broadcast();
      _errorController = StreamController<String>.broadcast();

      final socket = await SSHSocket.connect(
        host.host,
        host.port,
        timeout: const Duration(seconds: 30),
      );

      _client = SSHClient(
        socket,
        username: host.username,
        onPasswordRequest: () => host.password,
      );

      _outputController?.add('Connected to ${host.name}\n');
    } catch (e) {
      _errorController?.add('Connection failed: $e\n');
      rethrow;
    }
  }

  Future<void> startShell() async {
    if (_client == null) throw Exception('Not connected');

    _shellSession = await _client!.shell(
      pty: const SSHPtyConfig(
        width: 80,
        height: 24,
      ),
    );

    _shellSession!.stdout
        .map((data) => utf8.decode(data))
        .listen((data) {
          _outputController?.add(data);
        });

    _shellSession!.stderr
        .map((data) => utf8.decode(data))
        .listen((data) {
          _errorController?.add(data);
        });
  }

  void write(String data) {
    if (_shellSession == null) return;
    _shellSession!.write(utf8.encode(data));
  }

  void resize(int width, int height) {
    if (_shellSession == null) return;
    _shellSession!.resizeTerminal(width, height);
  }

  Future<void> disconnect() async {
    _shellSession?.stdin.close();
    _client?.socket.close();

    _shellSession = null;
    _client = null;

    await _outputController?.close();
    await _errorController?.close();
    _outputController = null;
    _errorController = null;
  }

  Future<String> executeCommand(String command) async {
    if (_client == null) throw Exception('Not connected');

    final output = await _client!.run(command);
    return utf8.decode(output);
  }
}
