import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/pokedex_screen.dart';
import 'screens/pokemon_detail_screen.dart';
import 'state/pokemon_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonProvider()..loadPokemon(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokédex',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F7FB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F2A44),
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        home: const PokedexScreen(),
        routes: {'/pokemon-detail': (context) => const PokemonDetailScreen()},
      ),
    );
  }
}
