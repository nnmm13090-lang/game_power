import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

/// Overridden in main() with the real instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider must be overridden'),
);

class SettingsState {
  final ThemeMode themeMode;
  final int colorIndex;
  const SettingsState({required this.themeMode, required this.colorIndex});

  SettingsState copyWith({ThemeMode? themeMode, int? colorIndex}) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        colorIndex: colorIndex ?? this.colorIndex,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _kMode = 'themeMode';
  static const _kColor = 'colorIndex';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  SettingsState build() {
    final mode = (_prefs.getInt(_kMode) ?? 0)
        .clamp(0, ThemeMode.values.length - 1)
        .toInt();
    final color = (_prefs.getInt(_kColor) ?? 0)
        .clamp(0, kSeedOptions.length - 1)
        .toInt();
    return SettingsState(themeMode: ThemeMode.values[mode], colorIndex: color);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _prefs.setInt(_kMode, mode.index);
  }

  void setColorIndex(int index) {
    state = state.copyWith(colorIndex: index);
    _prefs.setInt(_kColor, index);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
