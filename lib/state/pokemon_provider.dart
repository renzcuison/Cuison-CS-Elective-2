import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();

  List<Pokemon> _pokemonList = [];
  List<Pokemon> get pokemonList => _pokemonList;

  final Set<int> _favorites = {};
  Set<int> get favorites => _favorites;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Pokemon? _selectedPokemon;
  Pokemon? get selectedPokemon => _selectedPokemon;

  Future<void> loadPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemonList = await _pokemonService.fetchPokemonList();
      if (_selectedPokemon != null &&
          !_pokemonList.any((pokemon) => pokemon.id == _selectedPokemon!.id)) {
        _selectedPokemon = null;
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void toggleFavorite(Pokemon pokemon) {
    if (_favorites.contains(pokemon.id)) {
      _favorites.remove(pokemon.id);
    } else {
      _favorites.add(pokemon.id);
    }
    notifyListeners();
  }

  bool isFavorite(Pokemon pokemon) {
    return _favorites.contains(pokemon.id);
  }

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }

  void clearSelectedPokemon() {
    _selectedPokemon = null;
    notifyListeners();
  }

  List<Pokemon> get filteredPokemon {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _pokemonList;
    }

    return _pokemonList
        .where((pokemon) => pokemon.name.toLowerCase().contains(query))
        .toList();
  }
}
