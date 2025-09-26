class PokemonBasic {
  final String name;
  final String url;
  final int id;

  PokemonBasic({required this.name, required this.url, required this.id});

  factory PokemonBasic.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = extractIdFromUrl(url);
    return PokemonBasic(name: json['name'], url: url, id: id);
  }
}

class PokemonDetail {
  final String name;
  final List<String> types;
  final String? frontDefault;

  PokemonDetail({
    required this.name,
    required this.types,
    this.frontDefault,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final types = (json['types'] as List)
        .map((e) => (e['type']['name'] as String))
        .toList();
    final frontDefault = json['sprites']?['front_default'] as String?;
    return PokemonDetail(name: name, types: types, frontDefault: frontDefault);
  }
}

class SpeciesInfo {
  final String? flavorEn;

  SpeciesInfo({this.flavorEn});

  factory SpeciesInfo.fromJson(Map<String, dynamic> json) {
    final entries = (json['flavor_text_entries'] as List?) ?? [];
    String? en;
    for (final e in entries) {
      if (e['language']?['name'] == 'en') {
        en = (e['flavor_text'] as String?) ?? '';
        break;
      }
    }
    return SpeciesInfo(flavorEn: sanitizeFlavorText(en));
  }
}

// ---------- Helpers ----------
int extractIdFromUrl(String url) {
  final reg = RegExp(r'/pokemon/(\d+)/?$');
  final m = reg.firstMatch(url);
  if (m != null) return int.parse(m.group(1)!);
  throw FormatException('Não foi possível extrair o id da URL: $url');
}

String spriteFromId(int id) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

String officialArtworkFromId(int id) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

String? sanitizeFlavorText(String? text) {
  if (text == null) return null;
  return text.replaceAll(RegExp(r'[\n\f]+'), ' ').trim();
}

// Mapa tipo -> cor (ARGB) p/ chips no modal
const Map<String, int> kTypeColorHex = {
  'normal': 0xFFA8A878,
  'fire': 0xFFF08030,
  'water': 0xFF6890F0,
  'electric': 0xFFF8D030,
  'grass': 0xFF78C850,
  'ice': 0xFF98D8D8,
  'fighting': 0xFFC03028,
  'poison': 0xFFA040A0,
  'ground': 0xFFE0C068,
  'flying': 0xFFA890F0,
  'psychic': 0xFFF85888,
  'bug': 0xFFA8B820,
  'rock': 0xFFB8A038,
  'ghost': 0xFF705898,
  'dragon': 0xFF7038F8,
  'dark': 0xFF705848,
  'steel': 0xFFB8B8D0,
  'fairy': 0xFFEE99AC,
};
