import 'package:flutter/services.dart';

class KeyboardUtils {
  static final Map<LogicalKeyboardKey, String> specialKeys = {
    LogicalKeyboardKey.escape: '\x1b',
    LogicalKeyboardKey.tab: '\t',
    LogicalKeyboardKey.enter: '\n',
    LogicalKeyboardKey.backspace: '\x7f',
  };

  static final Map<LogicalKeyboardKey, String> arrowSequences = {
    LogicalKeyboardKey.arrowUp: '\x1b[A',
    LogicalKeyboardKey.arrowDown: '\x1b[B',
    LogicalKeyboardKey.arrowRight: '\x1b[C',
    LogicalKeyboardKey.arrowLeft: '\x1b[D',
  };

  static final Map<LogicalKeyboardKey, String> functionSequences = {
    LogicalKeyboardKey.f1: '\x1bOP',
    LogicalKeyboardKey.f2: '\x1bOQ',
    LogicalKeyboardKey.f3: '\x1bOR',
    LogicalKeyboardKey.f4: '\x1bOS',
    LogicalKeyboardKey.f5: '\x1b[15~',
    LogicalKeyboardKey.f6: '\x1b[17~',
    LogicalKeyboardKey.f7: '\x1b[18~',
    LogicalKeyboardKey.f8: '\x1b[19~',
    LogicalKeyboardKey.f9: '\x1b[20~',
    LogicalKeyboardKey.f10: '\x1b[21~',
    LogicalKeyboardKey.f11: '\x1b[23~',
    LogicalKeyboardKey.f12: '\x1b[24~',
  };

  static String? getSequence(LogicalKeyboardKey key, {bool shift = false, bool ctrl = false, bool alt = false}) {
    if (specialKeys.containsKey(key)) {
      return specialKeys[key];
    }

    if (arrowSequences.containsKey(key)) {
      String seq = arrowSequences[key]!;
      
      if (shift) {
        seq = seq.replaceFirst('[', '[1;2');
      } else if (alt) {
        seq = seq.replaceFirst('[', '[1;3');
      } else if (ctrl) {
        seq = seq.replaceFirst('[', '[1;5');
      }
      
      return seq;
    }

    if (functionSequences.containsKey(key)) {
      return functionSequences[key];
    }

    if (key == LogicalKeyboardKey.home) {
      return '\x1b[H';
    }

    if (key == LogicalKeyboardKey.end) {
      return '\x1b[F';
    }

    if (key == LogicalKeyboardKey.insert) {
      return '\x1b[2~';
    }

    if (key == LogicalKeyboardKey.delete) {
      return '\x1b[3~';
    }

    if (key == LogicalKeyboardKey.pageUp) {
      return '\x1b[5~';
    }

    if (key == LogicalKeyboardKey.pageDown) {
      return '\x1b[6~';
    }

    return null;
  }
}
