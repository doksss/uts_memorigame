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
              listNama[j + 1] = listNama[j];
              listSkor[j + 1] = listSkor[j];
              listNama[j] = namaTemp;
              listSkor[j] = skorTemp;
            }
          }
        }
      }
      if (player.length < 4) {
        number1 = listNama[0] + "-" + listSkor[0];
      } else if (player.length < 6) {
        number1 = listNama[0] + "-" + listSkor[0];
        number2 = listNama[1] + "-" + listSkor[1];
      } else {
        number1 = listNama[0] + "-" + listSkor[0];
        number2 = listNama[1] + "-" + listSkor[1];
        number3 = listNama[2] + "-" + listSkor[2];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sortingLeaderboard();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result Page',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Memberikan gaya tebal pada teks
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "LEADERBOARD",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HighScoreCard(rankImage: "assets/images/rank-2.png", playerName: number2),
                HighScoreCard(rankImage: "assets/images/rank-1.png", playerName: number1),
                HighScoreCard(rankImage: "assets/images/rank-3.png", playerName: number3),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); //menutup layar ini
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                ); //membuka layar hasil UTAMA
              },
              child: Text("MAIN MENU"),
            ),
          ],
        ),
      ),
    );
  }
}

class HighScoreCard extends StatelessWidget {
  final String rankImage;
  final String playerName;

  HighScoreCard({required this.rankImage, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Lebar card
      height: 300, // Tinggi card
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView( // Tambahkan SingleChildScrollView di sini
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  rankImage,
                  height: 50, // Ubah tinggi gambar di sini
                  width: 50, // Ubah lebar gambar di sini
                ), // Tambahkan gambar peringkat di sini
                SizedBox(height: 5), // Ruang kosong vertikal
                Divider(), // Pembatas garis
                SizedBox(height: 5), // Ruang kosong vertikal
                Text(playerName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
