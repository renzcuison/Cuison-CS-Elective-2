import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/pokedex_screen.dart';
import 'screens/pokemon_detail_screen.dart';
import 'theme/platinum_colors.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PlatinumColors.crimson,
          brightness: Brightness.dark,
          surface: PlatinumColors.surface,
          primary: PlatinumColors.crimson,
          secondary: PlatinumColors.gold,
        ),
        scaffoldBackgroundColor: PlatinumColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: PlatinumColors.surface,
          foregroundColor: PlatinumColors.platinum,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: PlatinumColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: PlatinumColors.muted),
          hintStyle: const TextStyle(color: PlatinumColors.muted),
          prefixIconColor: PlatinumColors.gold,
          filled: true,
          fillColor: PlatinumColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: PlatinumColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: PlatinumColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: PlatinumColors.gold, width: 1.5),
          ),
        ),
      ),
      home: const PokedexScreen(),
      routes: {'/pokemon-detail': (context) => const PokemonDetailScreen()},
    );
  }
}
