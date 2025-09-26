import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApi {
  static const _base = 'https://pokeapi.co/api/v2';

  static Future<List<PokemonBasic>> fetchPokedex151() async {
    final uri = Uri.parse('$_base/pokemon?limit=151');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Falha ao carregar lista (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();
    return results.map((e) => PokemonBasic.fromJson(e)).toList();
  }

  static Future<PokemonDetail> fetchPokemonDetail(int id) async {
    final uri = Uri.parse('$_base/pokemon/$id');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Falha ao carregar detalhes (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return PokemonDetail.fromJson(data);
  }

  static Future<SpeciesInfo> fetchSpecies(int id) async {
    final uri = Uri.parse('$_base/pokemon-species/$id');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Falha ao carregar species (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return SpeciesInfo.fromJson(data);
  }
}
