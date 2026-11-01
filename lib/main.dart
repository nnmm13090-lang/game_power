import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/settings_provider.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const FreeGamesApp(),
    ),
  );
}

class FreeGamesApp extends ConsumerWidget {
  const FreeGamesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final seed = kSeedOptions[settings.colorIndex].color;

    return MaterialApp(
      title: 'Free Games Hub',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: AppTheme.build(seed, Brightness.light),
      darkTheme: AppTheme.build(seed, Brightness.dark),
      home: const HomeShell(),
    );
  }
}
