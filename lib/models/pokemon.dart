class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract numerical ID from PokéAPI resource URL (e.g., https://pokeapi.co/api/v2/pokemon/1/)
    final String url = json['url'];
    final Uri uri = Uri.parse(url);
    final List<String> segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final int id = int.parse(segments.last);

    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }
}