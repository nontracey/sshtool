import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssh_tool/screens/host_list_screen.dart';
import 'package:ssh_tool/screens/terminal_screen.dart';
import 'package:ssh_tool/screens/settings_screen.dart';
import 'package:ssh_tool/providers/settings_provider.dart';
import 'package:ssh_tool/providers/hosts_provider.dart';
import 'package:ssh_tool/services/storage_service.dart';
import 'package:ssh_tool/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = StorageService();
  await storageService.init();
  
  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const SshToolApp(),
    ),
  );
}

class SshToolApp extends ConsumerWidget {
  const SshToolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    return MaterialApp(
      title: 'SSH Tool',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(settings.copyWith(themeMode: ThemeMode.light)),
      darkTheme: AppTheme.getTheme(settings.copyWith(themeMode: ThemeMode.dark)),
      themeMode: settings.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const HostListScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/terminal') {
          final host = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) => TerminalScreen(host: host),
          );
        }
        return null;
      },
    );
  }
}
