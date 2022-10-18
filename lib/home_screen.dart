import 'package:first_game_app/game_logic.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String activePlayer = 'X';
  String result = 'xxxxxxxxxxxxxxx';
  int Turn = 0;
  bool GameOver = false;
  bool isSwitched = false;
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    final isportrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: isportrait
              ? Column(
                  children: [
                    ...firstbloc(),
                    _expanded(16, context),
                    ...secondbloc(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstbloc(),
                        ...secondbloc(),
                      ],
                    )),
                    _expanded(50, context),
                  ],
                )),
    );
  }

  List<Widget> firstbloc() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'turn on/off two player',
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (bool value) {
          setState(() {
            isSwitched = value;
          });
        },
      )
    ];
  }

  List<Widget> secondbloc() {
    return [
      Text(
        'IT\'S $activePlayer Turn',
        style: TextStyle(color: Colors.white, fontSize: 28),
        textAlign: TextAlign.center,
      ),
      Text(
        result,
        style: TextStyle(color: Colors.white, fontSize: 28),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            GameOver = false;
            Turn = 0;
            result = '';
          });
        },
        icon: Icon(Icons.replay),
        label: Text('Repeat the Game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      ),
    ];
  }

  Expanded _expanded(double x, BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.all(x),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8.0,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: GameOver ? null : () => _onTap(index),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'X'
                      : Player.playerO.contains(index)
                          ? 'O'
                          : '',
                  style: TextStyle(
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.pink,
                    fontSize: 42,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updatestate();
      if (!isSwitched && !GameOver && Turn != 9) {
        await game.autoplay(activePlayer);
        updatestate();
      }
    }
  }

  void updatestate() {
    return setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        result = "the winner is  $winnerPlayer";
      } else {
        result = "it's draw";
      }
    });
  }
}

/* 
 setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
    }); */
