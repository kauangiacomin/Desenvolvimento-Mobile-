import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api.dart';
import '../theme/palette.dart';

class PokemonCard extends StatelessWidget {
  final PokemonBasic pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final bg = cardColorForId(pokemon.id);
    final artwork = officialArtworkFromId(pokemon.id);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showDialog(
        context: context,
        builder: (_) => _PokemonDetailDialog(id: pokemon.id),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // topo: nome + id
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _capitalize(pokemon.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  formatId(pokemon.id),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // ilustração
            Expanded(
              child: Center(
                child: Image.network(
                  artwork,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/placeholder.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ==== Dialog de detalhes (duas chamadas on-demand) ====
class _PokemonDetailDialog extends StatefulWidget {
  final int id;
  const _PokemonDetailDialog({required this.id});

  @override
  State<_PokemonDetailDialog> createState() => _PokemonDetailDialogState();
}

class _PokemonDetailDialogState extends State<_PokemonDetailDialog> {
  late Future<_DetailBundle> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DetailBundle> _load() async {
    final detail = await PokeApi.fetchPokemonDetail(widget.id);
    final species = await PokeApi.fetchSpecies(widget.id);
    return _DetailBundle(detail: detail, species: species);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: FutureBuilder<_DetailBundle>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 280,
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.hasError) {
            return SizedBox(
              width: 280,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Falha ao carregar detalhes.\n${snap.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          final bundle = snap.data!;
          final name = _capitalize(bundle.detail.name);
          final artwork = officialArtworkFromId(widget.id);
          final types = bundle.detail.types;
          final flavor = bundle.species.flavorEn ?? 'No description available.';

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 180,
                  child: Image.network(
                    artwork,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) {
                      final fallback = bundle.detail.frontDefault;
                      if (fallback != null) {
                        return Image.network(
                          fallback,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/placeholder.png',
                            fit: BoxFit.contain,
                          ),
                        );
                      }
                      return Image.asset('assets/placeholder.png',
                          fit: BoxFit.contain);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: types
                      .map(
                        (t) => Chip(
                          label: Text(_capitalize(t)),
                          backgroundColor:
                              Color(kTypeColorHex[t] ?? 0xFF9E9E9E),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  flavor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _DetailBundle {
  final PokemonDetail detail;
  final SpeciesInfo species;
  _DetailBundle({required this.detail, required this.species});
}
