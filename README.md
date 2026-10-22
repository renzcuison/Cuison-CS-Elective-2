# Pokédex

A Flutter Pokédex powered by Riverpod and PokéAPI.

## Features

- Loads Pokémon and their actual types from PokéAPI, with loading, error, retry,
  refresh, and pull-to-refresh states.
- Searches by original name or custom nickname and filters by Pokémon type.
- Adds, edits, and removes nicknames while keeping each Pokémon's original name.
- Uses bottom navigation to switch between the Pokédex and a dedicated My Team
  collection of favorited Pokémon.
- Manages favorites with live heart indicators and an expandable favorites panel
  on the detail screen.

## Run

```sh
flutter pub get
flutter run
```

All Pokémon list, search, type-filter, nickname, favorite, and selection state is
managed by the `PokemonController` Riverpod notifier in `lib/state/pokemon_state.dart`.
