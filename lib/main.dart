import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
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

class CardModel {
  String value;
  bool isFaceUp;
  bool isMatched;
  CardModel({
    required this.value,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class CardGameProvider extends ChangeNotifier {
  List<CardModel> _cards = [];
  List<CardModel> get cards => _cards;

  CardModel? firstSelected;
  int? firstIndex;

  CardGameProvider() {
    _initializeCards();
  }

  void _initializeCards() {
    List<String> values = [
      "A",
      "A",
      "B",
      "B",
      "C",
      "C",
      "D",
      "D",
      "E",
      "E",
      "F",
      "F",
      "G",
      "G",
      "H",
      "H",
    ];
    values.shuffle();
    _cards = values.map((val) => CardModel(value: val)).toList();
    notifyListeners();
  }

  void flipCard(int index) {
    if (_cards[index].isMatched || _cards[index].isFaceUp) return;

    _cards[index].isFaceUp = true;
    notifyListeners();

    if (firstSelected == null) {
      firstSelected = _cards[index];
      firstIndex = index;
    } else {
      if (firstSelected!.value == _cards[index].value && firstIndex != index) {
        _cards[index].isMatched = true;
        _cards[firstIndex!].isMatched = true;
      } else {
        Future.delayed(Duration(seconds: 1), () {
          _cards[index].isFaceUp = false;
          _cards[firstIndex!].isFaceUp = false;
          notifyListeners();
        });
      }
      firstSelected = null;
      firstIndex = null;
    }
    notifyListeners();

    if (_cards.every((card) => card.isMatched)) {
      Future.delayed(Duration(milliseconds: 500), () {
        showWinDialog();
      });
    }
  }

  void showWinDialog() {
    log("You won!");
  }

  void resetGame() {
    firstSelected = null;
    firstIndex = null;
    _initializeCards();
    notifyListeners();
  }
}
