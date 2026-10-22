import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon?limit=30';

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon list from PokéAPI');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    final pokemon = await Future.wait(
      results.map((item) async {
        final listEntry = item as Map<String, dynamic>;
        final detailResponse = await http.get(
          Uri.parse(listEntry['url'] as String),
        );
        if (detailResponse.statusCode != 200) {
          throw Exception('Failed to load Pokémon details from PokéAPI');
        }
        return Pokemon.fromJson(
          jsonDecode(detailResponse.body) as Map<String, dynamic>,
        );
      }),
    );
    return pokemon;
  }
}
