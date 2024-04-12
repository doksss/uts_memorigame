import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memorigame_project/class/questionObj.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  bool animated = false;
  bool animatedWidget = true;
  late Timer _timer;
  List<int> _KategoriSoal = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
  ];
  List<int> _OpsiSoal = [1, 2, 3, 4, 1, 2, 3, 4];
  List<QuestionObj> _question = [];
  double opacityLevel = 0;
  String firstImg = "";
  int _NumSoal = 1; //untuk di setstate

  void initState() {
    _KategoriSoal.shuffle();
    _OpsiSoal.shuffle();
    opacityLevel = 1 - opacityLevel;
    for (int i = 0; i < 5; i++) {
      _question.add(QuestionObj(
          'c-' + _KategoriSoal[i].toString() + '-1.png',
          'c-' + _KategoriSoal[i].toString() + '-2.png',
          'c-' + _KategoriSoal[i].toString() + '-3.png',
          'c-' + _KategoriSoal[i].toString() + '-4.png',
          'c-' +
              _KategoriSoal[i].toString() +
              '-' +
              _OpsiSoal[i].toString() +
              '.png'));
    }
    firstImg = "assets/images/" + _question[0].answer;

    _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      setState(() {
        if (_NumSoal < 5) {
          firstImg = "assets/images/" + _question[_NumSoal].answer;
          _NumSoal++;
          animated = !animated;
        } else {
          animatedWidget = false;
        }
      });
    });
    super.initState();
  }

  Widget widget1() {
    return Column(
      children: [
        Text("Remember the image"),
        AnimatedCrossFade(
          duration: const Duration(seconds: 3),
          firstChild: Image.asset(firstImg),
          secondChild: Image.asset(firstImg),
          crossFadeState:
              animated ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        )
      ],
    );
  }

  Widget widget2() {
    return Container(
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Which card have you seen before?"),
          Expanded(
              child: GridView.count(crossAxisCount: 2, children: [
            Image.asset("assets/images/" + _question[0].option_a),
            Image.asset("assets/images/" + _question[0].option_b),
            Image.asset("assets/images/" + _question[0].option_c),
            Image.asset("assets/images/" + _question[0].option_d),
          ]))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Memori'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // return RotationTransition(child: child, turns: animation);
              return ScaleTransition(child: child, scale: animation);
            },
            child: animatedWidget ? widget1() : widget2(),
          )

          // Image.asset("assets/images/" + _question[0].option_a),
          // Image.asset("assets/images/" + _question[0].option_b),
          // Image.asset("assets/images/" + _question[0].option_c),
          // Image.asset("assets/images/" + _question[0].option_d),
        ],
      )),
    );
  }
}
