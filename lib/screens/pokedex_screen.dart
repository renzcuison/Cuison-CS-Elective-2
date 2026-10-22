import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../state/pokemon_state.dart';
import '../theme/platinum_colors.dart';
import '../widgets/pokedex_tools_sheet.dart';
import '../widgets/pokemon_card.dart';

class PokedexScreen extends ConsumerStatefulWidget {
  const PokedexScreen({super.key});

  @override
  ConsumerState<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends ConsumerState<PokedexScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonProvider);
    final controller = ref.read(pokemonProvider.notifier);
    final pokemon = _selectedTab == 0
        ? state.filteredPokemon
        : state.favoritePokemon;
    final types =
        state.pokemonList.expand((entry) => entry.types).toSet().toList()
          ..sort();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [PlatinumColors.platinum, PlatinumColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: PlatinumColors.gold, width: 1.5),
              ),
              child: const Icon(
                Icons.catching_pokemon,
                color: PlatinumColors.ink,
                size: 20,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              _selectedTab == 0 ? 'Pokédex' : 'My Team',
              style: const TextStyle(
                color: PlatinumColors.platinum,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        actions: [
          if (_selectedTab == 0)
            IconButton(
              tooltip: 'Search and filter Pokémon',
              onPressed: () => _showTools(
                context,
                state.searchQuery,
                state.selectedType,
                types,
              ),
              icon: Icon(
                state.searchQuery.isEmpty && state.selectedType == null
                    ? Icons.search
                    : Icons.filter_alt,
                color: state.searchQuery.isEmpty && state.selectedType == null
                    ? PlatinumColors.platinum
                    : PlatinumColors.gold,
              ),
            ),
          IconButton(
            onPressed: state.isLoading ? null : controller.fetchPokemon,
            tooltip: 'Refresh Pokémon list',
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (state.isLoading && state.pokemonList.isNotEmpty)
              const LinearProgressIndicator(
                color: PlatinumColors.crimson,
                backgroundColor: PlatinumColors.raisedSurface,
              ),
            if (state.errorMessage != null && state.pokemonList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Color(0xFFFF8080)),
                ),
              ),
            if (_selectedTab == 0 &&
                (state.searchQuery.isNotEmpty || state.selectedType != null))
              _activeFilters(state, controller),
            if (_selectedTab == 1 && pokemon.isNotEmpty)
              _teamSummary(pokemon.length),
            Expanded(
              child: RefreshIndicator(
                color: PlatinumColors.crimson,
                backgroundColor: PlatinumColors.platinum,
                onRefresh: controller.fetchPokemon,
                child: state.isLoading && state.pokemonList.isEmpty
                    ? _messageList(
                        const CircularProgressIndicator(
                          color: PlatinumColors.gold,
                        ),
                      )
                    : state.errorMessage != null && state.pokemonList.isEmpty
                    ? _messageList(
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: PlatinumColors.crimson,
                            ),
                            const SizedBox(height: 12),
                            Text(state.errorMessage!),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: controller.fetchPokemon,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : pokemon.isEmpty
                    ? _emptyState(isTeam: _selectedTab == 1)
                    : _pokemonGrid(context, pokemon, state, controller),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        backgroundColor: PlatinumColors.surface,
        indicatorColor: PlatinumColors.darkCrimson,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Pokédex',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: 'My Team',
            tooltip: 'Your favorite Pokémon',
          ),
        ],
      ),
    );
  }

  Widget _activeFilters(PokemonState state, PokemonController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        children: [
          if (state.selectedType != null)
            _FilterChip(
              label: state.selectedType!.toUpperCase(),
              onRemove: () => controller.setTypeFilter(null),
            ),
          if (state.searchQuery.isNotEmpty)
            _FilterChip(
              label: '"${state.searchQuery}"',
              onRemove: () => controller.setSearch(''),
            ),
          const Spacer(),
          IconButton(
            tooltip: 'Clear filters',
            visualDensity: VisualDensity.compact,
            onPressed: () {
              controller.setSearch('');
              controller.setTypeFilter(null);
            },
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _teamSummary(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: PlatinumColors.crimson, size: 17),
          const SizedBox(width: 8),
          Text(
            '$count ${count == 1 ? 'POKÉMON' : 'POKÉMON'} ON YOUR TEAM',
            style: const TextStyle(
              color: PlatinumColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState({required bool isTeam}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 420,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: PlatinumColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: PlatinumColors.border),
                    ),
                    child: Icon(
                      isTeam ? Icons.favorite_border : Icons.search_off,
                      color: PlatinumColors.gold,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isTeam ? 'Your team is waiting' : 'No Pokémon found',
                    style: const TextStyle(
                      color: PlatinumColors.platinum,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    isTeam
                        ? 'Tap the heart on any Pokémon to add it here.'
                        : 'Try another name or clear your filters.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: PlatinumColors.muted,
                      fontSize: 13,
                    ),
                  ),
                  if (isTeam) ...[
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _selectedTab = 0),
                      icon: const Icon(Icons.grid_view_rounded),
                      label: const Text('Browse Pokédex'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pokemonGrid(
    BuildContext context,
    List<Pokemon> pokemon,
    PokemonState state,
    PokemonController controller,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1400
            ? 9
            : constraints.maxWidth >= 1100
            ? 7
            : constraints.maxWidth >= 800
            ? 5
            : constraints.maxWidth >= 520
            ? 4
            : constraints.maxWidth >= 360
            ? 3
            : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 18,
          ),
          itemCount: pokemon.length,
          itemBuilder: (context, index) {
            final entry = pokemon[index];
            return GestureDetector(
              onTap: () {
                controller.selectPokemon(entry);
                Navigator.pushNamed(context, '/pokemon-detail');
              },
              child: PokemonCard(
                pokemon: entry,
                nickname: state.nicknameFor(entry),
                isFavorite: state.isFavorite(entry),
                onToggleFavorite: () => controller.toggleFavorite(entry),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showTools(
    BuildContext context,
    String searchQuery,
    String? selectedType,
    List<String> types,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: PlatinumColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PokedexToolsSheet(
        searchQuery: searchQuery,
        selectedType: selectedType,
        types: types,
        onSearchChanged: ref.read(pokemonProvider.notifier).setSearch,
        onTypeChanged: ref.read(pokemonProvider.notifier).setTypeFilter,
      ),
    );
  }

  Widget _messageList(Widget content) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [SizedBox(height: 300, child: Center(child: content))],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InputChip(
        label: Text(label),
        onDeleted: onRemove,
        deleteIconColor: PlatinumColors.gold,
        backgroundColor: PlatinumColors.surface,
        side: const BorderSide(color: PlatinumColors.border),
        labelStyle: const TextStyle(
          color: PlatinumColors.platinum,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
