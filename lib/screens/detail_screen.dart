import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/giveaway.dart';
import '../providers/giveaway_providers.dart';
import '../utils/format.dart';
import '../widgets/giveaway_image.dart';

class DetailScreen extends ConsumerWidget {
  final Giveaway item;
  const DetailScreen({super.key, required this.item});

  Future<void> _open(BuildContext context) async {
    final ok = await launchUrl(
      Uri.parse(item.openUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the giveaway link')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final isFav = ref.watch(favoritesProvider.select((f) => f.contains(item.id)));

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: () => _open(context),
            icon: const Icon(Icons.card_giftcard),
            label: const Text('Claim giveaway'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: IconButton.filledTonal(
                  onPressed: () =>
                      ref.read(favoritesProvider.notifier).toggle(item.id),
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : null,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'giveaway-${item.id}',
                child: GiveawayImage(
                  url: item.image,
                  fallbackUrl: item.thumbnail,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.shortTitle,
                    style: text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(item.type, filled: true),
                      _Tag(item.status),
                      ...item.platforms.map(_Tag.new),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _StatsRow(item: item),
                  const SizedBox(height: 28),
                  _Section(title: 'About', child: Text(item.description, style: text.bodyLarge?.copyWith(height: 1.5))),
                  if (item.steps.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    _Section(
                      title: 'How to claim',
                      child: Column(
                        children: [
                          for (var i = 0; i < item.steps.length; i++)
                            _Step(number: i + 1, label: item.steps[i]),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool filled;
  const _Tag(this.label, {this.filled = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? scheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: filled ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Giveaway item;
  const _StatsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stats = <(String, String)>[
      ('Worth', item.hasWorth ? item.worth : 'Free'),
      ('Claimed', compactNumber(item.users)),
      ('Ends', item.endsAt != null ? formatDate(item.endsAt!) : 'Ongoing'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) VerticalDivider(width: 1, color: scheme.outlineVariant),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stats[i].$2,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stats[i].$1,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String label;
  const _Step({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              '$number',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }
}
