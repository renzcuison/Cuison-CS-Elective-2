class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? _idFromUrl(json['url'] as String);
    final types = (json['types'] as List<dynamic>? ?? [])
        .map(
          (entry) =>
              (entry as Map<String, dynamic>)['type']['name'] as String,
        )
        .toList();

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      types: List.unmodifiable(types),
    );
  }

  static int _idFromUrl(String url) {
    final segments = Uri.parse(url).pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();
    if (segments.isEmpty) {
      throw const FormatException('Pokémon API result did not include an ID.');
    }
    return int.parse(segments.last);
  }
}