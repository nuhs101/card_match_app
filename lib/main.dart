import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CardGameProvider(),
      child: CardMatchingGame(),
    ),
  );
}

class CardMatchingGame extends StatelessWidget {
  const CardMatchingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Card Matching Game")),
        body: GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    var gameProvider = Provider.of<CardGameProvider>(context);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: gameProvider.cards.length,
            itemBuilder: (context, index) {
              return CardTile(index: index);
            },
          ),
        ),
        ElevatedButton(
          onPressed: () => gameProvider.resetGame(),
          child: Text("Restart Game"),
        ),
      ],
    );
  }
}
