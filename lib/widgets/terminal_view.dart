import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh_tool/models/app_settings.dart';
import 'package:ssh_tool/theme/terminal_colors.dart';
import 'package:ssh_tool/utils/keyboard_utils.dart';

class TerminalView extends StatefulWidget {
  final String output;
  final Function(String) onInput;
  final AppSettings settings;
  final VoidCallback? onDisconnect;

  const TerminalView({
    super.key,
    required this.output,
    required this.onInput,
    required this.settings,
    this.onDisconnect,
  });

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _autoScroll = true;

  @override
  void didUpdateWidget(TerminalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_autoScroll && widget.output != oldWidget.output) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
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

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      
      String? sequence = KeyboardUtils.getSequence(
        key,
        shift: HardwareKeyboard.instance.isShiftPressed,
        ctrl: HardwareKeyboard.instance.isControlPressed,
        alt: HardwareKeyboard.instance.isAltPressed,
      );
      
      if (sequence != null) {
        widget.onInput(sequence);
      } else if (key == LogicalKeyboardKey.keyC && HardwareKeyboard.instance.isControlPressed) {
        widget.onInput('\x03');
      } else if (key == LogicalKeyboardKey.keyD && HardwareKeyboard.instance.isControlPressed) {
        widget.onInput('\x04');
      } else if (key == LogicalKeyboardKey.keyZ && HardwareKeyboard.instance.isControlPressed) {
        widget.onInput('\x1a');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TerminalColors.background,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: KeyboardListener(
                focusNode: _focusNode,
                onKeyEvent: _handleKeyEvent,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final maxScroll = _scrollController.position.maxScrollExtent;
                      final currentScroll = _scrollController.position.pixels;
                      setState(() {
                        _autoScroll = (maxScroll - currentScroll) < 50;
                      });
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.output.isEmpty ? 'Waiting for output...' : widget.output,
                      style: TextStyle(
                        fontFamily: widget.settings.terminalFontFamily,
                        fontSize: widget.settings.terminalFontSize,
                        height: widget.settings.lineHeight,
                        color: TerminalColors.foreground,
                        backgroundColor: TerminalColors.background,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildQuickButton('ESC', () => widget.onInput('\x1b')),
          _buildQuickButton('TAB', () => widget.onInput('\t')),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up),
            onPressed: () => widget.onInput('\x1b[A'),
            tooltip: 'Arrow Up',
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () => widget.onInput('\x1b[B'),
            tooltip: 'Arrow Down',
          ),
          IconButton(
            icon: Icon(_autoScroll ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                _autoScroll = !_autoScroll;
              });
            },
            tooltip: _autoScroll ? 'Auto-scroll ON' : 'Auto-scroll OFF',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
