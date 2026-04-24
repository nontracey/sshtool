import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:ssh_tool/models/ssh_host.dart';

class SshService {
  SSHClient? _client;
  SSHChannel? _shellChannel;
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

    _shellChannel = _client!.shell(
      pty: const SSHPtyConfig(
        width: 80,
        height: 24,
      ),
    );

    _shellChannel!.stdout
        .transform(utf8.decoder)
        .listen((data) {
          _outputController?.add(data);
        });

    _shellChannel!.stderr
        .transform(utf8.decoder)
        .listen((data) {
          _errorController?.add(data);
        });
  }

  void write(String data) {
    if (_shellChannel == null) return;
    _shellChannel!.write(utf8.encode(data));
  }

  void resize(int width, int height) {
    if (_shellChannel == null) return;
    _shellChannel!.resizeTerminal(width, height, 0, 0);
  }

  Future<void> disconnect() async {
    _shellChannel?.close();
    _client?.close();

    _shellChannel = null;
    _client = null;

    await _outputController?.close();
    await _errorController?.close();
    _outputController = null;
    _errorController = null;
  }

  Future<String> executeCommand(String command) async {
    if (_client == null) throw Exception('Not connected');

    final channel = _client!.run(command);
    final output = await channel.stdout.transform(utf8.decoder).join();
    channel.close();

    return output;
  }
}
