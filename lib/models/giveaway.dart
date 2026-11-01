class Giveaway {
  final int id;
  final String title;
  final String worth;
  final String thumbnail;
  final String image;
  final String description;
  final List<String> steps;
  final String openUrl;
  final DateTime? publishedAt;
  final DateTime? endsAt;
  final String type;
  final List<String> platforms;
  final int users;
  final String status;

  const Giveaway({
    required this.id,
    required this.title,
    required this.worth,
    required this.thumbnail,
    required this.image,
    required this.description,
    required this.steps,
    required this.openUrl,
    required this.publishedAt,
    required this.endsAt,
    required this.type,
    required this.platforms,
    required this.users,
    required this.status,
  });

  bool get hasWorth => worth.isNotEmpty && worth.toUpperCase() != 'N/A';

  /// Title without the trailing "Giveaway" word, for cleaner cards.
  String get shortTitle =>
      title.replaceFirst(RegExp(r'\s+Giveaway$', caseSensitive: false), '');

  String get platformLabel => platforms.isEmpty
      ? '—'
      : platforms.length > 1
          ? '${platforms.first} +${platforms.length - 1}'
          : platforms.first;

  factory Giveaway.fromJson(Map<String, dynamic> j) {
    final rawSteps = _clean(j['instructions'])
        .split('\n')
        .map((s) => s.replaceAll(RegExp(r'<[^>]*>'), '').trim())
        .map((s) => s.replaceFirst(RegExp(r'^\d+\.\s*'), ''))
        .where((s) => s.isNotEmpty)
        .toList();

    return Giveaway(
      id: j['id'] as int,
      title: _clean(j['title']),
      worth: _clean(j['worth']),
      thumbnail: _clean(j['thumbnail']),
      image: _clean(j['image']),
      description: _clean(j['description']),
      steps: rawSteps,
      openUrl: _clean(j['open_giveaway_url']),
      publishedAt: _date(j['published_date']),
      endsAt: _date(j['end_date']),
      type: _clean(j['type']),
      platforms: _clean(j['platforms'])
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      users: (j['users'] as num?)?.toInt() ?? 0,
      status: _clean(j['status']),
    );
  }

  static String _clean(Object? v) => (v ?? '')
      .toString()
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('\r\n', '\n')
      .trim();

  static DateTime? _date(Object? v) {
    final s = (v ?? '').toString();
    if (s.isEmpty || s.toUpperCase() == 'N/A') return null;
    return DateTime.tryParse(s.replaceFirst(' ', 'T'));
  }
}
