import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/giveaway_providers.dart';
import '../widgets/giveaway_grid.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(giveawaysProvider);
    final filtered = ref.watch(filteredGiveawaysProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Free Games',
              style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
            child: Text(
              'Giveaways, DLC and loot all free to claim',
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: _SearchField(),
          ),
          const _FilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: async.when(
              loading: () => const GiveawayGridSkeleton(),
              error: (e, _) => MessageView(
                icon: Icons.wifi_off_rounded,
                title: 'Could not load giveaways',
                subtitle: '$e',
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(giveawaysProvider),
              ),
              data: (_) => RefreshIndicator(
                onRefresh: () => ref.refresh(giveawaysProvider.future),
                child: filtered.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 80),
                          MessageView(
                            icon: Icons.search_off_rounded,
                            title: 'No results',
                            subtitle: 'Try a different search or filter.',
                          ),
                        ],
                      )
                    : GiveawayGrid(items: filtered),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search giveaways',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(typeFilterProvider);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: kTypeFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final label = kTypeFilters[i];
          return ChoiceChip(
            label: Text(label),
            selected: selected == label,
            showCheckmark: false,
            onSelected: (_) =>
                ref.read(typeFilterProvider.notifier).state = label,
          );
        },
      ),
    );
  }
}
