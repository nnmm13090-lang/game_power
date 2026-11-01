import 'package:flutter/material.dart';

/// Loads the preferred giveaway image and tries a second URL if it fails.
class GiveawayImage extends StatelessWidget {
  final String url;
  final String? fallbackUrl;

  const GiveawayImage({
    super.key,
    required this.url,
    this.fallbackUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final urls = <String>[
      url.trim(),
      if (fallbackUrl != null) fallbackUrl!.trim(),
    ].where((value) => value.isNotEmpty).toSet().toList(growable: false);

    final fallback = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: scheme.onSurfaceVariant,
      ),
    );

    Widget loadImage(int index) {
      if (index >= urls.length) return fallback;

      return Image.network(
        urls[index],
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return ColoredBox(color: scheme.surfaceContainerHighest);
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Could not load giveaway image ${urls[index]}: $error');
          return loadImage(index + 1);
        },
      );
    }

    return loadImage(0);
  }
}
