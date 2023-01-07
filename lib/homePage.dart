import 'package:audioplayers/audioplayers.dart';
import 'package:drag_drop_game/Model.dart';
import 'package:flutter/material.dart';

class DragDropGame extends StatefulWidget {
  const DragDropGame({Key? key}) : super(key: key);

  @override
  State<DragDropGame> createState() => _DragDropGameState();
}

class _DragDropGameState extends State<DragDropGame> {
  var player = AudioCache(prefix: 'assets/audio/');
  List<Model> items1 = [];
  List<Model> items2 = [];
  late int score;
  late bool gameOver;

  initGame() {
    gameOver = false;
    score = 0;

    items1 = [
      Model(name: 'camel', image: 'assets/images/camel.png', value: 'camel'),
      Model(name: 'cat', image: 'assets/images/cat.png', value: 'cat'),
      Model(name: 'dog', image: 'assets/images/dog.png', value: 'dog'),
      Model(name: 'fox', image: 'assets/images/fox.png', value: 'fox'),
      Model(name: 'hen', image: 'assets/images/hen.png', value: 'hen'),
      Model(name: 'horse', image: 'assets/images/horse.png', value: 'horse'),
      Model(name: 'lion', image: 'assets/images/lion.png', value: 'lion'),
      Model(name: 'panda', image: 'assets/images/panda.png', value: 'panda'),
      Model(name: 'sheep', image: 'assets/images/sheep.png', value: 'sheep'),
      Model(name: 'cow', image: 'assets/images/cow.png', value: 'cow'),
    ];
    items2 = List<Model>.from(items1);
    items1.shuffle(); //to set items of list random
    items2.shuffle(); //to set items of list random
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (items1.isEmpty) gameOver = true;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Score : ',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    TextSpan(
                      text: ' ${score.toString()}',
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          ?.copyWith(color: Colors.teal),
                    ),
                  ],
                ),
              ),
              if (!gameOver)
                Row(
                  children: [
                    Spacer(),
                    Column(
                      children: items1.map((item) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Draggable<Model>(
                            data: item,
                            childWhenDragging: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              backgroundImage: AssetImage(item.image),
                            ),
                            feedback: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              backgroundImage: AssetImage(item.image),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              backgroundImage: AssetImage(item.image),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                      children: items2.map((item) {
                        return DragTarget<Model>(onAccept: (recievedItem) {
                          if (item.value == recievedItem.value) {
                            setState(() {
                              items1.remove(recievedItem);
                              items2.remove(item);
                              player.play('true.wav');
                            });
                            score += 10;
                            item.accepted = false;
                          } else {
                            setState(() {
                              score -= 5;
                              item.accepted = false;
                              player.play('false.wav');
                            });
                          }
                        }, onWillAccept: (acceptItem) {
                          setState(() {
                            item.accepted = true;
                          });
                          return true;
                        }, onLeave: (acceptItem) {
                          setState(() {
                            item.accepted = false;
                          });
                        }, builder: (context, candidateData, rejectedData) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: item.accepted
                                    ? Colors.grey[400]
                                    : Colors.grey[200]),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width / 6.5,
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.all(8),
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          );
                        });
                      }).toList(),
                    ),
                    Spacer(),
                  ],
                ),

              ///
              ///
              ///
              ///
              if (gameOver)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Game Over',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          result(),
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.teal,
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                initGame();
                              });
                            },
                            child: Text('Play Again',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                ),

              ///
              ///
              ///
            ],
          ),
        )),
      ),
    );
  }

  result() {
    if (score == 100) {
      player.play('success.wav');
      return "Awesome!";
    } else {
      player.play('tryAgain.wav');
      return "Try Again";
    }
  }
}
