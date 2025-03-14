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

class CardTile extends StatelessWidget {
  final int index;
  const CardTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var gameProvider = Provider.of<CardGameProvider>(context);
    var card = gameProvider.cards[index];

    return GestureDetector(
      onTap: () => gameProvider.flipCard(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: card.isMatched ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child:
              card.isFaceUp || card.isMatched
                  ? Text(
                    card.value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  : Icon(Icons.question_mark, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
