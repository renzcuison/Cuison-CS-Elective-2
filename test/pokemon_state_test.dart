import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/services/pokemon_service.dart';
import 'package:pokedex_app/screens/pokedex_screen.dart';
import 'package:pokedex_app/state/pokemon_state.dart';

void main() {
  final pikachu = Pokemon(
    id: 25,
    name: 'pikachu',
    imageUrl: 'https://example.com/25.png',
    types: const ['electric'],
  );
  final bulbasaur = Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl: 'https://example.com/1.png',
    types: const ['grass', 'poison'],
  );

  test(
    'controller loads and manages search, type, favorites, and nicknames',
    () async {
      final container = ProviderContainer(
        overrides: [
          pokemonServiceProvider.overrideWithValue(
            _FakePokemonService([pikachu, bulbasaur]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(pokemonProvider.notifier);
      await controller.fetchPokemon();

      expect(container.read(pokemonProvider).pokemonList, [pikachu, bulbasaur]);

      controller.setTypeFilter('electric');
      expect(container.read(pokemonProvider).filteredPokemon, [pikachu]);
      controller.setTypeFilter(null);

      controller.saveNickname(pikachu, 'Sparky');
      controller.setSearch('sparky');
      expect(container.read(pokemonProvider).filteredPokemon, [pikachu]);

      controller.toggleFavorite(pikachu);
      expect(container.read(pokemonProvider).favoritePokemon, [pikachu]);
      controller.removeNickname(pikachu);
      controller.toggleFavorite(pikachu);

      final state = container.read(pokemonProvider);
      expect(state.nicknameFor(pikachu), isNull);
      expect(state.favoritePokemon, isEmpty);
    },
  );

  test('Pokemon parses actual type data and ID from a PokéAPI response', () {
    final pokemon = Pokemon.fromJson({
      'id': 4,
      'name': 'charmander',
      'types': [
        {
          'type': {'name': 'fire'},
        },
      ],
    });

    expect(pokemon.id, 4);
    expect(pokemon.types, ['fire']);
  });

  testWidgets('My Team tab shows empty and populated favorite states', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        pokemonServiceProvider.overrideWithValue(
          _FakePokemonService([pikachu, bulbasaur]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: PokedexScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Team'));
    await tester.pumpAndSettle();
    expect(find.text('Your team is waiting'), findsOneWidget);

    container.read(pokemonProvider.notifier).toggleFavorite(pikachu);
    await tester.pumpAndSettle();
    expect(find.text('PIKACHU'), findsOneWidget);
    expect(find.text('1 POKÉMON ON YOUR TEAM'), findsOneWidget);
  });
}

class _FakePokemonService extends PokemonService {
  _FakePokemonService(this.pokemon);

  final List<Pokemon> pokemon;

  @override
  Future<List<Pokemon>> fetchPokemonList() async => pokemon;
}
