import 'dart:math';
import 'package:flutter/material.dart';
import '../models/resultado_arguments.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _jogar(BuildContext context, String escolhaUsuario) {
    List<String> opcoes = ['pedra', 'papel', 'tesoura'];
    String escolhaApp = opcoes[Random().nextInt(opcoes.length)];

    Navigator.pushNamed(
      context,
      '/resultado',
      arguments: ResultadoArguments(escolhaUsuario, escolhaApp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Pedra, Papel, Tesoura"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/padrao.png"),
          ),
          const SizedBox(height: 10),
          const Text("Escolha do APP (Aleatório)"),
          const SizedBox(height: 40),
          const Text("Escolha do usuário"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _jogar(context, "pedra"),
                child: Image.asset("assets/pedra.png", width: 80),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _jogar(context, "papel"),
                child: Image.asset("assets/papel.png", width: 80),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _jogar(context, "tesoura"),
                child: Image.asset("assets/tesoura.png", width: 80),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
