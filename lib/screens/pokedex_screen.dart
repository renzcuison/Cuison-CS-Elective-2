import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();
    final pokemonList = provider.filteredPokemon;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: provider.loadPokemon,
            tooltip: 'Refresh Pokémon list',
            icon: const Icon(Icons.refresh),
          ),
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2F2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  '${provider.favorites.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2A44),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      offset: const Offset(0, 6),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search Pokémon...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: provider.setSearch,
                ),
              ),
            ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          Text(provider.errorMessage!),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: provider.loadPokemon,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : pokemonList.isEmpty
                  ? const Center(child: Text('No Pokémon found.'))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: pokemonList.length,
                      itemBuilder: (context, index) {
                        final pokemon = pokemonList[index];
                        return GestureDetector(
                          onTap: () {
                            provider.selectPokemon(pokemon);
                            Navigator.pushNamed(context, '/pokemon-detail');
                          },
                          child: PokemonCard(
                            pokemon: pokemon,
                            isFavorite: provider.isFavorite(pokemon),
                            onToggleFavorite: () =>
                                provider.toggleFavorite(pokemon),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
