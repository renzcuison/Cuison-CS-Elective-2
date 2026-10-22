import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

final pokemonProvider =
    NotifierProvider<PokemonController, PokemonState>(PokemonController.new);
final pokemonServiceProvider = Provider<PokemonService>(
  (ref) => PokemonService(),
);

class PokemonState {
  PokemonState({
    List<Pokemon> pokemonList = const [],
    Set<int> favorites = const {},
    Map<int, String> nicknames = const {},
    this.searchQuery = '',
    this.selectedType,
    this.isLoading = false,
    this.errorMessage,
    this.selectedPokemon,
  }) : pokemonList = List.unmodifiable(pokemonList),
       favorites = Set.unmodifiable(favorites),
       nicknames = Map.unmodifiable(nicknames);

  final List<Pokemon> pokemonList;
  final Set<int> favorites;
  final Map<int, String> nicknames;
  final String searchQuery;
  final String? selectedType;
  final bool isLoading;
  final String? errorMessage;
  final Pokemon? selectedPokemon;

  List<Pokemon> get filteredPokemon {
    final query = searchQuery.trim().toLowerCase();
    return pokemonList.where((pokemon) {
      final matchesSearch =
          query.isEmpty ||
          pokemon.name.toLowerCase().contains(query) ||
          (nicknames[pokemon.id]?.toLowerCase().contains(query) ?? false);
      final matchesType =
          selectedType == null || pokemon.types.contains(selectedType);
      return matchesSearch && matchesType;
    }).toList();
  }

  List<Pokemon> get favoritePokemon =>
      pokemonList.where((pokemon) => favorites.contains(pokemon.id)).toList();

  bool isFavorite(Pokemon pokemon) => favorites.contains(pokemon.id);

  String? nicknameFor(Pokemon pokemon) => nicknames[pokemon.id];

  PokemonState copyWith({
    List<Pokemon>? pokemonList,
    Set<int>? favorites,
    Map<int, String>? nicknames,
    String? searchQuery,
    String? selectedType,
    bool clearSelectedType = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    Pokemon? selectedPokemon,
    bool clearSelectedPokemon = false,
  }) {
    return PokemonState(
      pokemonList: pokemonList ?? this.pokemonList,
      favorites: favorites ?? this.favorites,
      nicknames: nicknames ?? this.nicknames,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearSelectedType
          ? null
          : selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      selectedPokemon: clearSelectedPokemon
          ? null
          : selectedPokemon ?? this.selectedPokemon,
    );
  }
}

class PokemonController extends Notifier<PokemonState> {
  @override
  PokemonState build() {
    Future<void>.microtask(fetchPokemon);
    return PokemonState(isLoading: true);
  }

  Future<void> fetchPokemon() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      final pokemonList = await ref
          .read(pokemonServiceProvider)
          .fetchPokemonList();
      state = state.copyWith(
        pokemonList: pokemonList,
        isLoading: false,
        clearErrorMessage: true,
        clearSelectedPokemon:
            state.selectedPokemon != null &&
            !pokemonList.any(
              (pokemon) => pokemon.id == state.selectedPokemon!.id,
            ),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load Pokémon. Check your connection: $error',
      );
    }
  }

  void setSearch(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setTypeFilter(String? type) {
    state = type == null
        ? state.copyWith(clearSelectedType: true)
        : state.copyWith(selectedType: type);
  }

  void toggleFavorite(Pokemon pokemon) {
    final favorites = Set<int>.from(state.favorites);
    if (!favorites.add(pokemon.id)) {
      favorites.remove(pokemon.id);
    }
    state = state.copyWith(favorites: favorites);
  }

  void saveNickname(Pokemon pokemon, String nickname) {
    final normalized = nickname.trim();
    if (normalized.isEmpty) {
      removeNickname(pokemon);
      return;
    }
    state = state.copyWith(
      nicknames: {...state.nicknames, pokemon.id: normalized},
    );
  }

  void removeNickname(Pokemon pokemon) {
    final nicknames = Map<int, String>.from(state.nicknames)
      ..remove(pokemon.id);
    state = state.copyWith(nicknames: nicknames);
  }

  void selectPokemon(Pokemon pokemon) {
    state = state.copyWith(selectedPokemon: pokemon);
  }

  void clearSelectedPokemon() {
    state = state.copyWith(clearSelectedPokemon: true);
  }
}
