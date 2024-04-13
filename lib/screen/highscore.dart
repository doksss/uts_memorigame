import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memorigame_project/main.dart';

String number1 = "";
String number2 = "";
String number3 = "";
String all_Leaderboard = "";

Future<String> checkLeaderboard() async {
  final prefs = await SharedPreferences.getInstance();
  String leaderboard = prefs.getString("leaderboard") ?? '';
  return leaderboard;
}

class Highscore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HighscoreState();
  }
}

class _HighscoreState extends State<Highscore> {
  void initState() {
    checkLeaderboard().then((value) => setState(() {
          all_Leaderboard = value;
        }));

    super.initState();
  }

  void sortingLeaderboard() {
    if (all_Leaderboard != "") {
      List<String> player = all_Leaderboard.split(",");
      String namaPlayer = "";
      String skor = "";
      for (int i = 1; i < player.length - 1; i += 2) {
        skor += player[i] + ",";
      }
      for (int i = 0; i < player.length - 1; i += 2) {
        namaPlayer += player[i] + ",";
      }

      List<String> listSkor = skor.split(",");
      List<String> listNama = namaPlayer.split(",");
      if (listSkor.length > 1) {
        for (int i = 0; i < listSkor.length - 1; i++) {
          for (int j = 0; j < listSkor.length - 2; j++) {
            if (int.parse(listSkor[j]) < int.parse(listSkor[j + 1])) {
              String namaTemp = listNama[j + 1];
              String skorTemp = listSkor[j + 1];
              listNama[j + 1] =listNama[j];
              listSkor[j + 1] = listSkor[j];
              listNama[j] = namaTemp;
              listSkor[j] = skorTemp;
            }
          }
        }
      }
      if (player.length < 4) {
          number1 = "1." + listNama[0] + "-" + listSkor[0];
        } else if (player.length < 6) {
          number1 = "1." + listNama[0] + "-" + listSkor[0];
          number2 = "2." + listNama[1] + "-" + listSkor[1];
        } else {
          number1 = "1." + listNama[0] + "-" + listSkor[0];
          number2 = "2." + listNama[1] + "-" + listSkor[1];
          number3 = "3." + listNama[2] + "-" + listSkor[2];
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    sortingLeaderboard();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("LEADERBOARD",
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
                      number1 + "\n" + number2 + "\n" + number3,
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
