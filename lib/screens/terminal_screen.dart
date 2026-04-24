import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssh_tool/models/ssh_host.dart';
import 'package:ssh_tool/models/app_settings.dart';
import 'package:ssh_tool/providers/settings_provider.dart';
import 'package:ssh_tool/services/ssh_service.dart';
import 'package:ssh_tool/theme/terminal_colors.dart';

class TerminalScreen extends ConsumerStatefulWidget {
  final SshHost host;
  
  const TerminalScreen({super.key, required this.host});

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _focusNode = FocusNode();
  
  late SshService _sshService;
  late AppSettings _settings;
  
  String _output = '';
  bool _isConnected = false;
  bool _isConnecting = false;
  String _statusMessage = '';
  
  StreamSubscription<String>? _outputSubscription;
  StreamSubscription<String>? _errorSubscription;

  @override
  void initState() {
    super.initState();
    _sshService = SshService();
    _settings = ref.read(settingsProvider);
    _connect();
  }

  @override
  void dispose() {
    _outputSubscription?.cancel();
    _errorSubscription?.cancel();
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _sshService.disconnect();
    super.dispose();
  }

  Future<void> _connect() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Connecting to ${widget.host.name}...';
    });

    try {
      await _sshService.connect(widget.host);
      await _sshService.startShell();
      
      _outputSubscription = _sshService.output.listen((data) {
        setState(() {
          _output += data;
        });
        _scrollToBottom();
      });

      _errorSubscription = _sshService.error.listen((data) {
        setState(() {
          _output += data;
        });
        _scrollToBottom();
      });

      setState(() {
        _isConnected = true;
        _isConnecting = false;
        _statusMessage = 'Connected to ${widget.host.name}';
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isConnecting = false;
        _statusMessage = 'Connection failed: $e';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendCommand(String command) {
    if (!_isConnected) return;
    
    _sshService.write(command);
    
    setState(() {
      _output += command;
    });
    
    _inputController.clear();
    _scrollToBottom();
  }

  void _handleKey(LogicalKeyboardKey key) {
    if (!_isConnected) return;
    
    String? sequence;
    
    switch (key) {
      case LogicalKeyboardKey.enter:
        sequence = '\n';
        break;
      case LogicalKeyboardKey.tab:
        sequence = '\t';
        break;
      case LogicalKeyboardKey.escape:
        sequence = '\x1b';
        break;
      case LogicalKeyboardKey.arrowUp:
        sequence = '\x1b[A';
        break;
      case LogicalKeyboardKey.arrowDown:
        sequence = '\x1b[B';
        break;
      case LogicalKeyboardKey.arrowRight:
        sequence = '\x1b[C';
        break;
      case LogicalKeyboardKey.arrowLeft:
        sequence = '\x1b[D';
        break;
      case LogicalKeyboardKey.home:
        sequence = '\x1b[H';
        break;
      case LogicalKeyboardKey.end:
        sequence = '\x1b[F';
        break;
      default:
        return;
    }
    
    if (sequence != null) {
      _sshService.write(sequence);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.host.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isConnected ? () {
              setState(() {
                _output = '';
              });
            } : null,
          ),
          IconButton(
            icon: Icon(
              _isConnected ? Icons.link : Icons.link_off,
              color: _isConnected ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              if (_isConnected) {
                _sshService.disconnect();
                setState(() {
                  _isConnected = false;
                  _statusMessage = 'Disconnected';
                });
              } else {
                _connect();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusBar(),
          Expanded(
            child: _buildTerminal(),
          ),
          _buildInputBar(),
          _buildKeyboardShortcuts(),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isConnected 
              ? Icons.check_circle 
              : _isConnecting 
                ? Icons.pending 
                : Icons.error,
            size: 16,
            color: _isConnected 
              ? Colors.green 
              : _isConnecting 
                ? Colors.orange 
                : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            '${widget.host.username}@${widget.host.host}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminal() {
    return Container(
      color: TerminalColors.background,
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              _handleKey(event.logicalKey);
            }
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            child: SelectableText(
              _output.isEmpty ? 'Waiting for output...' : _output,
              style: TextStyle(
                fontFamily: _settings.terminalFontFamily,
                fontSize: _settings.terminalFontSize,
                height: _settings.lineHeight,
                color: TerminalColors.foreground,
                backgroundColor: TerminalColors.background,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewPadding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              enabled: _isConnected,
              style: TextStyle(
                fontFamily: _settings.terminalFontFamily,
                fontSize: _settings.terminalFontSize,
              ),
              decoration: InputDecoration(
                hintText: 'Enter command',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: _sendCommand,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isConnected 
              ? () => _sendCommand(_inputController.text)
              : null,
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardShortcuts() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildShortcutButton('ESC', () => _handleKey(LogicalKeyboardKey.escape)),
          _buildShortcutButton('TAB', () => _handleKey(LogicalKeyboardKey.tab)),
          _buildShortcutButton('↑', () => _handleKey(LogicalKeyboardKey.arrowUp)),
          _buildShortcutButton('↓', () => _handleKey(LogicalKeyboardKey.arrowDown)),
          _buildShortcutButton('←', () => _handleKey(LogicalKeyboardKey.arrowLeft)),
          _buildShortcutButton('→', () => _handleKey(LogicalKeyboardKey.arrowRight)),
        ],
      ),
    );
  }

  Widget _buildShortcutButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
