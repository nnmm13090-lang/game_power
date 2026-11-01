import 'package:flutter/material.dart';

class SeedOption {
  final String name;
  final Color color;
  const SeedOption(this.name, this.color);
}

const kSeedOptions = <SeedOption>[
  SeedOption('Indigo', Color(0xFF4F46E5)),
  SeedOption('Teal', Color(0xFF0D9488)),
  SeedOption('Emerald', Color(0xFF16A34A)),
  SeedOption('Orange', Color(0xFFEA580C)),
  SeedOption('Rose', Color(0xFFE11D48)),
  SeedOption('Violet', Color(0xFF7C3AED)),
];

class AppTheme {
  static ThemeData build(Color seed, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
