import 'dart:async';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:ssh_tool/models/ssh_host.dart';

class SshService {
  SSHClient? _client;
  SSHSession? _session;
  StreamController<String>? _outputController;
  StreamController<String>? _errorController;
  
  Stream<String> get output => _outputController?.stream ?? const Stream.empty();
  Stream<String> get error => _errorController?.stream ?? const Stream.empty();
  
  bool get isConnected => _client != null && _session != null;

  Future<void> connect(SshHost host) async {
    try {
      _outputController = StreamController<String>.broadcast();
      _errorController = StreamController<String>.broadcast();
      
      final socket = await SSHSocket.connect(
        host.host,
        host.port,
        timeout: Duration(seconds: 30),
      );

      final client = SSHClient(
        socket,
        username: host.username,
        password: host.password,
        identities: host.privateKey != null 
            ? [SSHKey.fromPem(host.privateKey!)]
            : null,
      );

      await client.authenticated;
      _client = client;
      
      _outputController?.add('Connected to ${host.name}\n');
    } catch (e) {
      _errorController?.add('Connection failed: $e\n');
      rethrow;
    }
  }

  Future<void> startShell() async {
    if (_client == null) throw Exception('Not connected');
    
    _session = await _client!.shell(
      pty: SSHPtyConfig(
        width: 80,
        height: 24,
        modes: {
          SSHPtyMode.ECHO: 1,
          SSHPtyMode.OCRNL: 0,
        },
      ),
    );

    _session!.stdout.listen((data) {
      _outputController?.add(String.fromCharCodes(data));
    });

    _session!.stderr.listen((data) {
      _errorController?.add(String.fromCharCodes(data));
    });
  }

  void write(String data) {
    if (_session == null) return;
    _session!.write(Uint8List.fromList(data.codeUnits));
  }

  void resize(int width, int height) {
    if (_session == null) return;
    _session!.setPtySize(width, height);
  }

  Future<void> disconnect() async {
    await _session?.close();
    _client?.close();
    await _client?.done;
    
    _session = null;
    _client = null;
    
    await _outputController?.close();
    await _errorController?.close();
    _outputController = null;
    _errorController = null;
  }

  Future<String> executeCommand(String command) async {
    if (_client == null) throw Exception('Not connected');
    
    final session = await _client!.execute(command);
    final output = await session.stdout.join();
    await session.close();
    
    return String.fromCharCodes(output);
  }
}
