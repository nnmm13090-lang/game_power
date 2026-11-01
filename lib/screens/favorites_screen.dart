import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/giveaway_providers.dart';
import '../widgets/giveaway_grid.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final favIds = ref.watch(favoritesProvider);
    final all = ref.watch(giveawaysProvider).value ?? const [];
    final saved = all.where((g) => favIds.contains(g.id)).toList();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'Saved',
              style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: saved.isEmpty
                ? const MessageView(
                    icon: Icons.favorite_border,
                    title: 'Nothing saved yet',
                    subtitle: 'Tap the heart on any giveaway to keep it here.',
                  )
                : GiveawayGrid(items: saved),
          ),
        ],
      ),
    );
  }
}
