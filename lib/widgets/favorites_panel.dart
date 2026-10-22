import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/pokemon_state.dart';
import '../theme/platinum_colors.dart';

class FavoritesPanel extends ConsumerWidget {
  const FavoritesPanel({super.key, this.initiallyExpanded = false});

  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(
      pokemonProvider.select((state) => state.favoritePokemon),
    );
    final nicknames = ref.watch(
      pokemonProvider.select((state) => state.nicknames),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      decoration: BoxDecoration(
        color: PlatinumColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: PlatinumColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 13),
          childrenPadding: const EdgeInsets.only(bottom: 6),
          leading: Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: PlatinumColors.darkCrimson,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.favorite,
              color: PlatinumColors.platinum,
              size: 17,
            ),
          ),
          title: const Text(
            'FIELD TEAM',
            style: TextStyle(
              color: PlatinumColors.platinum,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          subtitle: Text(
            '${favorites.length} POKÉMON REGISTERED',
            style: const TextStyle(
              color: PlatinumColors.muted,
              fontSize: 9,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            if (favorites.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
                child: Text(
                  'No Pokémon on your team yet. Tap a heart to add one.',
                  style: TextStyle(color: PlatinumColors.muted, fontSize: 12),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 210),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final pokemon in favorites)
                      ListTile(
                        dense: true,
                        leading: Image.network(
                          pokemon.imageUrl,
                          width: 38,
                          height: 38,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.catching_pokemon,
                                color: PlatinumColors.gold,
                              ),
                        ),
                        title: Text(
                          nicknames[pokemon.id] ?? pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            color: PlatinumColors.platinum,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: nicknames.containsKey(pokemon.id)
                            ? Text(
                                pokemon.name.toUpperCase(),
                                style: const TextStyle(
                                  color: PlatinumColors.muted,
                                  fontSize: 10,
                                ),
                              )
                            : null,
                        trailing: IconButton(
                          tooltip: 'Remove from favorites',
                          onPressed: () => ref
                              .read(pokemonProvider.notifier)
                              .toggleFavorite(pokemon),
                          icon: const Icon(
                            Icons.favorite,
                            color: PlatinumColors.crimson,
                          ),
                        ),
                        onTap: () {
                          ref
                              .read(pokemonProvider.notifier)
                              .selectPokemon(pokemon);
                          Navigator.pushNamed(context, '/pokemon-detail');
                        },
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
