import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssh_tool/models/app_settings.dart';
import 'package:ssh_tool/providers/settings_provider.dart';
import 'package:ssh_tool/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection('Appearance', [
            _buildThemeModeTile(settings),
            _buildThemeColorTile(settings),
            _buildFontFamilyTile(settings),
          ]),
          _buildSection('Terminal', [
            _buildTerminalFontTile(settings),
            _buildTerminalFontSizeTile(settings),
            _buildLineHeightTile(settings),
            _buildCursorStyleTile(settings),
          ]),
          _buildSection('Behavior', [
            _buildSwitchTile(
              'Keep Screen On',
              'Prevent screen from turning off during session',
              settings.keepScreenOn,
              (value) => ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(keepScreenOn: value),
              ),
            ),
            _buildSwitchTile(
              'Bell Sound',
              'Play sound on terminal bell',
              settings.bellSound,
              (value) => ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(bellSound: value),
              ),
            ),
            _buildSwitchTile(
              'Vibrate on Bell',
              'Vibrate device on terminal bell',
              settings.vibrateOnBell,
              (value) => ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(vibrateOnBell: value),
              ),
            ),
          ]),
          _buildSection('Advanced', [
            _buildSliderTile(
              'Scrollback Lines',
              'Number of lines to keep in scrollback buffer',
              settings.scrollbackLines.toDouble(),
              1000,
              50000,
              (value) => ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(scrollbackLines: value.toInt()),
              ),
            ),
            _buildSliderTile(
              'Connection Timeout',
              'Seconds to wait for connection',
              settings.connectionTimeout.toDouble(),
              5,
              60,
              (value) => ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(connectionTimeout: value.toInt()),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildThemeModeTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Theme Mode'),
      subtitle: Text(_getThemeModeLabel(settings.themeMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeModeDialog(settings),
    );
  }

  Widget _buildThemeColorTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Theme Color'),
      subtitle: Text(settings.themeColor.toUpperCase()),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getThemeColor(settings.themeColor),
          shape: BoxShape.circle,
        ),
      ),
      onTap: () => _showThemeColorDialog(settings),
    );
  }

  Widget _buildFontFamilyTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.font_download),
      title: const Text('UI Font'),
      subtitle: Text(settings.fontFamily),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showFontFamilyDialog(settings),
    );
  }

  Widget _buildTerminalFontTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.code),
      title: const Text('Terminal Font'),
      subtitle: Text(settings.terminalFontFamily),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showTerminalFontDialog(settings),
    );
  }

  Widget _buildTerminalFontSizeTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.format_size),
      title: const Text('Terminal Font Size'),
      subtitle: Text('${settings.terminalFontSize.toInt()} sp'),
      onTap: () => _showFontSizeDialog(
        'Terminal Font Size',
        settings.terminalFontSize,
        8,
        32,
        (value) => ref.read(settingsProvider.notifier).setTerminalFontSize(value),
      ),
    );
  }

  Widget _buildLineHeightTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.format_line_spacing),
      title: const Text('Line Height'),
      subtitle: Text(settings.lineHeight.toStringAsFixed(1)),
      onTap: () => _showFontSizeDialog(
        'Line Height',
        settings.lineHeight,
        1.0,
        3.0,
        (value) => ref.read(settingsProvider.notifier).setLineHeight(value),
      ),
    );
  }

  Widget _buildCursorStyleTile(AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.keyboard),
      title: const Text('Cursor Style'),
      subtitle: Text(_getCursorStyleLabel(settings.cursorStyle)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showCursorStyleDialog(settings),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
          Text('Current: ${value.toInt()}'),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  Color _getThemeColor(String colorName) {
    final colors = {
      'blue': Colors.blue,
      'indigo': Colors.indigo,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'red': Colors.red,
      'orange': Colors.orange,
      'yellow': Colors.amber,
      'green': Colors.green,
      'teal': Colors.teal,
      'cyan': Colors.cyan,
    };
    return colors[colorName] ?? Colors.blue;
  }

  String _getCursorStyleLabel(int style) {
    const styles = ['Block', 'Underline', 'Bar'];
    return styles[style];
  }

  void _showThemeModeDialog(AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeModeLabel(mode)),
              value: mode,
              groupValue: settings.themeMode,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeColorDialog(AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppTheme.colorSchemes.keys.map((color) {
            return InkWell(
              onTap: () {
                ref.read(settingsProvider.notifier).setThemeColor(color);
                Navigator.pop(context);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getThemeColor(color),
                  shape: BoxShape.circle,
                  border: settings.themeColor == color
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showFontFamilyDialog(AppSettings settings) {
    final fonts = [
      'Roboto',
      'OpenSans',
      'Lato',
      'Montserrat',
      'SourceSansPro',
      'Nunito',
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('UI Font'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fonts.map((font) {
              return RadioListTile<String>(
                title: Text(font, style: TextStyle(fontFamily: font)),
                value: font,
                groupValue: settings.fontFamily,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setFontFamily(value!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showTerminalFontDialog(AppSettings settings) {
    final fonts = [
      'JetBrainsMono',
      'FiraCode',
      'Monaco',
      'Consolas',
      'SourceCodePro',
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminal Font'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fonts.map((font) {
              return RadioListTile<String>(
                title: Text(font),
                value: font,
                groupValue: settings.terminalFontFamily,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setTerminalFontFamily(value!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showFontSizeDialog(
    String title,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    double tempValue = value;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: tempValue,
                  min: min,
                  max: max,
                  divisions: ((max - min) * 2).toInt(),
                  onChanged: (value) {
                    setState(() {
                      tempValue = value;
                    });
                  },
                ),
                Text('Current: ${tempValue.toStringAsFixed(1)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  onChanged(tempValue);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCursorStyleDialog(AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cursor Style'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0, 1, 2].map((style) {
            return RadioListTile<int>(
              title: Text(_getCursorStyleLabel(style)),
              value: style,
              groupValue: settings.cursorStyle,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                  settings.copyWith(cursorStyle: value),
                );
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
