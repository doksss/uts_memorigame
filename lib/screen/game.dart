import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memorigame_project/class/questionObj.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:memorigame_project/screen/hasil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveScoreSementara(int score_temp) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt("score_sementara", score_temp);
}

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  bool runOnce = false;
  int _point = 0;
  int _jumlahquest = 1;
  int _questno = 0;
  int _maxTime = 30;
  int _hitung = 0;
  bool animated = false;
  bool animatedWidget = true;
  late Timer _timer;
  late Timer _timerProgress;
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
  int _NumSoal = 0; //untuk di setstate

  void initState() {
    _hitung = _maxTime;
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

  void startTimer() {
    _hitung = _maxTime;
    _timerProgress = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_hitung == 0) {
          _questno++;
          _jumlahquest++;
          _hitung = _maxTime;
        } else {
          _hitung--;
        }
        if (_jumlahquest > 5) {
          finishQuiz();
        }
      });
    });
  }

  finishQuiz() {
    _timerProgress.cancel();
    _jumlahquest = 0;
    _questno = 0;
    saveScoreSementara(_point);
    Navigator.pop(context); //menutup layar ini
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Hasil())); //membuka layar hasil
  }

  void checkAnswer(String answer) {
    setState(() {
      if (answer == _question[_questno].answer) {
        _point += 1;
      }
      _jumlahquest++;
      _questno++;
      if (_jumlahquest > 5) finishQuiz();
      _hitung = _maxTime;
    });
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
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
    if (runOnce == false) {
      startTimer();
      runOnce = true;
    }
    return Container(
      height: 300,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Which card have you seen before?"),
          Expanded(
              child: GridView.count(crossAxisCount: 2, children: [
            InkWell(
              splashColor: Colors.black26,
              onTap: () {
                checkAnswer(_question[_questno].option_a);
              },
              child: Ink.image(
                image:
                    AssetImage("assets/images/" + _question[_questno].option_a),
                height: 150,
                width: 150,
              ),
            ),
            InkWell(
              splashColor: Colors.black26,
              onTap: () {
                checkAnswer(_question[_questno].option_b);
              },
              child: Ink.image(
                image:
                    AssetImage("assets/images/" + _question[_questno].option_b),
                height: 150,
                width: 150,
              ),
            ),
            InkWell(
              splashColor: Colors.black26,
              onTap: () {
                checkAnswer(_question[_questno].option_c);
              },
              child: Ink.image(
                image:
                    AssetImage("assets/images/" + _question[_questno].option_c),
                height: 150,
                width: 150,
              ),
            ),
            InkWell(
              splashColor: Colors.black26,
              onTap: () {
                checkAnswer(_question[_questno].option_d);
              },
              child: Ink.image(
                image:
                    AssetImage("assets/images/" + _question[_questno].option_d),
                height: 150,
                width: 150,
              ),
            ),
          ]))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Memori',
        style: TextStyle(
      fontWeight: FontWeight.bold, // Memberikan gaya tebal pada teks
    ),),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 20.0,
            percent: 1 - (_hitung / _maxTime),
            center: Text(formatTime(_hitung)),
            progressColor: Colors.green,
            backgroundColor: Colors.red,
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: animatedWidget ? widget1() : widget2(),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
