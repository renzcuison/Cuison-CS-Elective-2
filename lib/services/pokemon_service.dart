import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon?limit=30';

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Pokémon list from PokéAPI');
    }
  }
}
