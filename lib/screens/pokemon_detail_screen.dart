import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../state/pokemon_state.dart';
import '../theme/platinum_colors.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_dialog.dart';

class PokemonDetailScreen extends ConsumerWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);
    final controller = ref.read(pokemonProvider.notifier);
    final pokemon = state.selectedPokemon;

    if (pokemon == null) {
      return const Scaffold(body: Center(child: Text('No Pokémon selected.')));
    }

    final nickname = state.nicknameFor(pokemon);
    final isFavorite = state.isFavorite(pokemon);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlatinumColors.surface,
        toolbarHeight: 68,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              'SINNOH FIELD RECORD  #${pokemon.id.toString().padLeft(3, '0')}',
              style: const TextStyle(
                color: PlatinumColors.gold,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        leading: IconButton(
          tooltip: 'Back to Pokédex',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.clearSelectedPokemon();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () => controller.toggleFavorite(pokemon),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? PlatinumColors.crimson : null,
            ),
          ),
          IconButton(
            tooltip: 'Open favorites',
            onPressed: () => _showFavorites(context),
            icon: Badge(
              label: Text('${state.favorites.length}'),
              backgroundColor: PlatinumColors.crimson,
              child: const Icon(
                Icons.groups_2_outlined,
                color: PlatinumColors.platinum,
              ),
            ),
          ),
          IconButton(
            tooltip: nickname == null ? 'Add nickname' : 'Edit nickname',
            onPressed: () => _editNickname(context, ref, pokemon, nickname),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                PlatinumColors.platinum,
                                PlatinumColors.silver,
                                Color(0xFFAAA9A5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: PlatinumColors.platinum,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x66020C18),
                                offset: Offset(0, 8),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 18,
                                left: 18,
                                child: Text(
                                  'NO. ${pokemon.id.toString().padLeft(3, '0')}',
                                  style: const TextStyle(
                                    color: PlatinumColors.ink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 18,
                                right: 18,
                                child: Container(
                                  width: 11,
                                  height: 11,
                                  decoration: const BoxDecoration(
                                    color: PlatinumColors.crimson,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x88C52D35),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'pokemon-${pokemon.id}',
                                child: Image.network(
                                  pokemon.imageUrl,
                                  height: 235,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image_outlined,
                                        size: 100,
                                        color: PlatinumColors.border,
                                      ),
                                ),
                              ),
                              Positioned(
                                bottom: 14,
                                child: Text(
                                  'SINNOH REGIONAL DATABASE',
                                  style: TextStyle(
                                    color: PlatinumColors.ink.withValues(
                                      alpha: 0.75,
                                    ),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: PlatinumColors.surface,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: PlatinumColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nickname == null
                                    ? pokemon.name.toUpperCase()
                                    : nickname.toUpperCase(),
                                style: const TextStyle(
                                  color: PlatinumColors.platinum,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              if (nickname != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'SPECIES: ${pokemon.name.toUpperCase()}',
                                  style: const TextStyle(
                                    color: PlatinumColors.muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 14),
                              const Text(
                                'TYPE',
                                style: TextStyle(
                                  color: PlatinumColors.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  for (final type in pokemon.types)
                                    _TypeBadge(type: type),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _ActionButton(
                                      icon: isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      label: isFavorite
                                          ? 'IN FIELD TEAM'
                                          : 'ADD TO TEAM',
                                      active: isFavorite,
                                      onPressed: () =>
                                          controller.toggleFavorite(pokemon),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _ActionButton(
                                      icon: Icons.edit_outlined,
                                      label: nickname == null
                                          ? 'ADD NICKNAME'
                                          : 'EDIT NICKNAME',
                                      onPressed: () => _editNickname(
                                        context,
                                        ref,
                                        pokemon,
                                        nickname,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFavorites(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: PlatinumColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.72,
        child: SafeArea(
          child: SingleChildScrollView(
            child: FavoritesPanel(initiallyExpanded: true),
          ),
        ),
      ),
    );
  }

  Future<void> _editNickname(
    BuildContext context,
    WidgetRef ref,
    Pokemon pokemon,
    String? nickname,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => NicknameDialog(initialNickname: nickname),
    );
    if (result == null || !context.mounted) {
      return;
    }
    if (result.trim().isEmpty) {
      ref.read(pokemonProvider.notifier).removeNickname(pokemon);
    } else {
      ref.read(pokemonProvider.notifier).saveNickname(pokemon, result);
    }
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: PlatinumColors.raisedSurface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: PlatinumColors.gold),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: PlatinumColors.platinum,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final foreground = active
        ? PlatinumColors.crimson
        : PlatinumColors.gold;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        side: BorderSide(
          color: active ? PlatinumColors.crimson : PlatinumColors.border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
  }
}
