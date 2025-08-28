import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/resultado_page.dart';
import 'models/resultado_arguments.dart';

void main() {
  runApp(const PedraPapelTesouraApp());
}

class PedraPapelTesouraApp extends StatelessWidget {
  const PedraPapelTesouraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/resultado': (context) => const ResultadoPage(),
      },
      // Para facilitar debug de argumentos
      onGenerateRoute: (settings) {
        if (settings.name == '/resultado') {
          final args = settings.arguments as ResultadoArguments;
          return MaterialPageRoute(
            builder: (context) {
              return ResultadoPage(args: args);
            },
          );
        }
        return null;
      },
    );
  }
}
