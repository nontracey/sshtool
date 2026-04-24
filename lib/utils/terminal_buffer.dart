import 'dart:math';

class TerminalBuffer {
  final List<String> _lines = [];
  int _cursorX = 0;
  int _cursorY = 0;
  int _scrollOffset = 0;
  final int maxLines;

  TerminalBuffer({this.maxLines = 10000});

  List<String> get lines => _lines;
  int get cursorX => _cursorX;
  int get cursorY => _cursorY;
  int get scrollOffset => _scrollOffset;
  int get lineCount => _lines.length;

  void write(String data) {
    for (int i = 0; i < data.length; i++) {
      final char = data[i];
      
      if (char == '\n') {
        _cursorY++;
        _cursorX = 0;
        if (_cursorY >= _lines.length) {
          _lines.add('');
          if (_lines.length > maxLines) {
            _lines.removeAt(0);
            _cursorY--;
          }
        }
      } else if (char == '\r') {
        _cursorX = 0;
      } else if (char == '\x08') {
        if (_cursorX > 0) _cursorX--;
      } else if (char == '\x1b') {
        i = _parseEscapeSequence(data, i);
      } else {
        if (_cursorY >= _lines.length) {
          _lines.add('');
        }
        
        final line = _cursorY < _lines.length ? _lines[_cursorY] : '';
        final newLine = _insertChar(line, char, _cursorX);
        
        if (_cursorY < _lines.length) {
          _lines[_cursorY] = newLine;
        } else {
          _lines.add(newLine);
        }
        
        _cursorX++;
      }
    }
  }

  String _insertChar(String line, String char, int pos) {
    if (pos >= line.length) {
      return line + char;
    }
    return line.substring(0, pos) + char + line.substring(pos + 1);
  }

  int _parseEscapeSequence(String data, int start) {
    if (start + 1 >= data.length) return start;
    
    final next = data[start + 1];
    
    if (next == '[') {
      int i = start + 2;
      String params = '';
      
      while (i < data.length && !_isLetter(data[i])) {
        params += data[i];
        i++;
      }
      
      if (i < data.length) {
        final cmd = data[i];
        _handleCSI(cmd, params);
        return i;
      }
    }
    
    return start + 1;
  }

  bool _isLetter(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  void _handleCSI(String cmd, String params) {
    final args = params.split(';').map((s) => int.tryParse(s) ?? 0).toList();
    
    switch (cmd) {
      case 'A':
        _cursorY = (_cursorY - (args.isNotEmpty ? args[0] : 1)).clamp(0, _lines.length - 1);
        break;
      case 'B':
        _cursorY = (_cursorY + (args.isNotEmpty ? args[0] : 1)).clamp(0, _lines.length - 1);
        break;
      case 'C':
        _cursorX += args.isNotEmpty ? args[0] : 1;
        break;
      case 'D':
        _cursorX = (_cursorX - (args.isNotEmpty ? args[0] : 1)).clamp(0, 999);
        break;
      case 'H':
        _cursorY = (args.isNotEmpty ? args[0] - 1 : 0).clamp(0, _lines.length - 1);
        _cursorX = args.length > 1 ? args[1] - 1 : 0;
        break;
      case 'J':
        if (args.isEmpty || args[0] == 0) {
          for (int i = _cursorY; i < _lines.length; i++) {
            _lines[i] = '';
          }
        } else if (args[0] == 2) {
          _lines.clear();
          _lines.add('');
          _cursorX = 0;
          _cursorY = 0;
        }
        break;
      case 'K':
        if (_cursorY < _lines.length) {
          if (args.isEmpty || args[0] == 0) {
            _lines[_cursorY] = _lines[_cursorY].substring(0, _cursorX);
          } else if (args[0] == 1) {
            _lines[_cursorY] = ' ' * _cursorX + _lines[_cursorY].substring(_cursorX);
          } else if (args[0] == 2) {
            _lines[_cursorY] = '';
          }
        }
        break;
    }
  }

  void clear() {
    _lines.clear();
    _lines.add('');
    _cursorX = 0;
    _cursorY = 0;
  }

  void scroll(int offset) {
    _scrollOffset = (_scrollOffset + offset).clamp(0, max(_lines.length - 25, 0));
  }
}
