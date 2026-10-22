import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../theme/platinum_colors.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final String? nickname;
  final VoidCallback? onToggleFavorite;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    this.nickname,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isEmpty ? null : pokemon.types.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: PlatinumColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF484951)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            PlatinumColors.raisedSurface,
                            PlatinumColors.surface,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 9,
                    child: Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: const TextStyle(
                        color: PlatinumColors.gold,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3,
                    right: 3,
                    child: IconButton(
                      tooltip: isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: onToggleFavorite,
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFavorite
                            ? PlatinumColors.crimson
                            : PlatinumColors.silver,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 20, 5, 5),
                    child: Hero(
                      tag: 'pokemon-${pokemon.id}',
                      child: Image.network(
                        pokemon.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image_outlined,
                              size: 38,
                              color: PlatinumColors.muted,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 7, 3, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  nickname ?? pokemon.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PlatinumColors.platinum,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (primaryType != null)
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: PlatinumColors.darkCrimson,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    primaryType.toUpperCase(),
                    style: const TextStyle(
                      color: PlatinumColors.platinum,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (nickname != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 2, 3, 0),
            child: Text(
              pokemon.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PlatinumColors.muted,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
