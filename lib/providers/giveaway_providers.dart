import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../models/giveaway.dart';
import '../services/giveaway_api.dart';
import 'settings_provider.dart';

final giveawayApiProvider = Provider<GiveawayApi>((ref) => GiveawayApi());

/// Fetches all giveaways. Use `ref.invalidate(giveawaysProvider)` to reload.
final giveawaysProvider = FutureProvider<List<Giveaway>>((ref) {
  return ref.watch(giveawayApiProvider).fetchGiveaways();
});

const kTypeFilters = ['All', 'Game', 'DLC', 'Early Access'];

final searchQueryProvider = StateProvider<String>((ref) => '');
final typeFilterProvider = StateProvider<String>((ref) => 'All');

/// Giveaways after applying the search text and the type filter.
final filteredGiveawaysProvider = Provider<List<Giveaway>>((ref) {
  final items = ref.watch(giveawaysProvider).value ?? const [];
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final type = ref.watch(typeFilterProvider);

  return items.where((g) {
    final typeOk = type == 'All' || g.type == type;
    final queryOk = query.isEmpty || g.title.toLowerCase().contains(query);
    return typeOk && queryOk;
  }).toList();
});

/// Favorite giveaway ids, persisted locally.
class FavoritesNotifier extends Notifier<Set<int>> {
  static const _key = 'favorites';

  @override
  Set<int> build() {
    final saved = ref.read(sharedPrefsProvider).getStringList(_key) ?? [];
    return saved.map(int.tryParse).whereType<int>().toSet();
  }

  void toggle(int id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
    ref
        .read(sharedPrefsProvider)
        .setStringList(_key, next.map((e) => '$e').toList());
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);
