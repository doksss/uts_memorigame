import 'package:flutter/material.dart';
import 'package:memorigame_project/screen/game.dart';
import 'package:memorigame_project/main.dart';
import 'package:memorigame_project/screen/highscore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
int skor_sementara = 0;
String all_Leaderboard = "";
// String testing = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

Future<int> checkSkorSementara() async {
  //ambil score dari game.dart
  final prefs = await SharedPreferences.getInstance();
  int skor_temp = prefs.getInt("score_sementara") ?? 0;
  return skor_temp;
}

Future<String> checkLeaderboard() async {
  final prefs = await SharedPreferences.getInstance();
  String leaderboard = prefs.getString("leaderboard") ?? '';
  return leaderboard;
}

// Future<String> checkLeaderboard2() async {
//   final prefs = await SharedPreferences.getInstance();
//   String leaderboard = prefs.getString("leaderboard") ?? '';
//   return leaderboard;
// }

void saveLeaderboard(String player) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("leaderboard", player);
}

void checkingLeaderboard() {
  bool namaDitemukan = false;
  if (all_Leaderboard == "") {
    String player = active_user + "," + skor_sementara.toString() + ",";
    saveLeaderboard(player);
  } else {
    List<String> player = all_Leaderboard.split(",");
    for (int i = 0; i < player.length; i += 2) {
      if (player[i] == active_user) {
        namaDitemukan = true;
        if (int.parse(player[i + 1]) < skor_sementara) {
          player[i + 1] = skor_sementara.toString();
        }
        break;
      }
    }
    if (namaDitemukan == false) {
      String players = "";
      for (int i = 0; i < player.length-1; i ++) {
        players += player[i] + ",";
      }
      players += active_user + "," + skor_sementara.toString() + ",";
      hapusPrefLeaderboard();
      saveLeaderboard(players);
    }else{
      String players = "";
      for (int i = 0; i < player.length-1; i ++) {
        players += player[i] + ",";
      }
      hapusPrefLeaderboard();
      saveLeaderboard(players);
    }
  }
}

void hapusPrefLeaderboard() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("leaderboard");
}

String getGelar(int skor) {
  checkingLeaderboard();
  String gelar = "";
  if (skor == 5) {
    gelar = " Maestro dell'Indovinello\n(Master of Riddles)";
  } else if (skor == 4) {
    gelar = "Esperto dell'Indovinello\n(Expert of Riddles)";
  } else if (skor == 3) {
    gelar = "Abile Indovinatore\n(Skillful Guesser)";
  } else if (skor == 2) {
    gelar = "Principiante dell'Indovinello\n(Riddle Beginner)";
  } else if (skor == 1) {
    gelar = "Neofita dell'Indovinello\n(Riddle Novice)";
  } else {
    gelar = "Sfortunato Indovinatore\n(Unlucky Guesser)";
  }
  return gelar;
}

class Hasil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HasilState();
  }
}

class _HasilState extends State<Hasil> {
  void initState() {
    checkUser().then((value) => setState(
          () {
            active_user = value;
          },
        ));
    checkSkorSementara().then((value) => setState(() {
          skor_sementara = value;
        }));
    checkLeaderboard().then((value) => setState(() {
          all_Leaderboard = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("YOUR RESULT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                width: 600,
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SCORE " +
                          skor_sementara.toString() +
                          "/5\n" +
                          getGelar(skor_sementara),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); //menutup layar ini
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Game())); //membuka layar GAME
                            },
                            child: Text("PLAY AGAIN")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); //menutup layar ini
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Highscore())); //membuka layar HIGHSCORE
                            },
                            child: Text("HIGH SCORES")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); //menutup layar ini
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyApp())); //membuka layar hasil UTAMA
                            },
                            child: Text("MAIN MENU")),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
