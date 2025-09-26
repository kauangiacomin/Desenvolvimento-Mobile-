import 'package:flutter/material.dart';
import 'pages/pokedex_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex 151',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokedexPage(),
    );
  }
}
