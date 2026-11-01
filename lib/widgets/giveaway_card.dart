import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/giveaway.dart';
import '../providers/giveaway_providers.dart';
import '../screens/detail_screen.dart';
import 'giveaway_image.dart';

class GiveawayCard extends ConsumerWidget {
  final Giveaway item;
  const GiveawayCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isFav = ref.watch(favoritesProvider.select((f) => f.contains(item.id)));

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant.withOpacity(0.6)),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailScreen(item: item)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'giveaway-${item.id}',
                    child: GiveawayImage(
                      url: item.thumbnail,
                      fallbackUrl: item.image,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _Badge(label: item.type, scheme: scheme),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.35),
                      ),
                      onPressed: () =>
                          ref.read(favoritesProvider.notifier).toggle(item.id),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFav ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.shortTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.platformLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                        if (item.hasWorth) ...[
                          Text(
                            item.worth,
                            style: text.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          'FREE',
                          style: text.labelMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final ColorScheme scheme;
  const _Badge({required this.label, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

