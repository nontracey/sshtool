import 'package:flutter/material.dart';

class CommandInput extends StatefulWidget {
  final Function(String) onSend;
  final bool enabled;
  final String? fontFamily;
  final double fontSize;

  const CommandInput({
    super.key,
    required this.onSend,
    this.enabled = true,
    this.fontFamily,
    this.fontSize = 14,
  });

  @override
  State<CommandInput> createState() => _CommandInputState();
}

class _CommandInputState extends State<CommandInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final List<String> _history = [];
  int _historyIndex = -1;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendCommand() {
    final command = _controller.text;
    if (command.isEmpty) return;

    _history.add(command);
    _historyIndex = _history.length;
    
    widget.onSend(command);
    _controller.clear();
  }

  void _navigateHistory(int direction) {
    if (_history.isEmpty) return;

    _historyIndex += direction;
    _historyIndex = _historyIndex.clamp(-1, _history.length - 1);

    if (_historyIndex == -1 || _historyIndex == _history.length) {
      _controller.clear();
    } else {
      _controller.text = _history[_historyIndex];
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              style: TextStyle(
                fontFamily: widget.fontFamily,
                fontSize: widget.fontSize,
              ),
              decoration: InputDecoration(
                hintText: 'Enter command',
                prefixIcon: Icon(
                  Icons.terminal,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendCommand(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: widget.enabled ? () => _navigateHistory(-1) : null,
            tooltip: 'Previous command',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: widget.enabled ? () => _navigateHistory(1) : null,
            tooltip: 'Next command',
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: widget.enabled ? _sendCommand : null,
            tooltip: 'Send',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
