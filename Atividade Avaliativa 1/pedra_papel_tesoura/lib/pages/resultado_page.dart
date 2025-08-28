import 'package:flutter/material.dart';
import '../models/resultado_arguments.dart';

class ResultadoPage extends StatelessWidget {
  final ResultadoArguments? args;

  const ResultadoPage({super.key, this.args});

  String _verificarResultado(String usuario, String app) {
    if (usuario == app) return "Empate!";
    if ((usuario == 'pedra' && app == 'tesoura') ||
        (usuario == 'papel' && app == 'pedra') ||
        (usuario == 'tesoura' && app == 'papel')) {
      return "Você venceu!";
    }
    return "Você perdeu!";
  }

  Widget _iconeResultado(String usuario, String app) {
    if (usuario == app) {
      return Image.asset("assets/icons8-aperto-de-mãos-100.png", width: 80);
    } else if ((usuario == 'pedra' && app == 'tesoura') ||
        (usuario == 'papel' && app == 'pedra') ||
        (usuario == 'tesoura' && app == 'papel')) {
      return Image.asset("assets/icons8-vitória-48.png", width: 80);
    } else {
      return Image.asset("assets/icons8-perder-48.png", width: 80);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultado = args ?? ModalRoute.of(context)!.settings.arguments as ResultadoArguments;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Resultado"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/${resultado.escolhaApp}.png", width: 80),
          const Text("Escolha do APP"),
          const SizedBox(height: 30),
          Image.asset("assets/${resultado.escolhaUsuario}.png", width: 80),
          const Text("Sua Escolha"),
          const SizedBox(height: 30),
          _iconeResultado(resultado.escolhaUsuario, resultado.escolhaApp),
          const SizedBox(height: 10),
          Text(
            _verificarResultado(resultado.escolhaUsuario, resultado.escolhaApp),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Jogar novamente"),
          )
        ],
      ),
    );
  }
}
