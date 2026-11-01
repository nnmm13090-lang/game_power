import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_power/main.dart';
import 'package:game_power/providers/giveaway_providers.dart';
import 'package:game_power/providers/settings_provider.dart';

void main() {
  testWidgets('Free Games Hub opens with its navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          giveawaysProvider.overrideWith((ref) async => []),
        ],
        child: const FreeGamesApp(),
      ),
    );

    expect(find.text('Free Games'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Games'), findsOneWidget);
  });
}
