import 'package:flutter/material.dart';
import 'package:memorigame_project/screen/game.dart';
import 'package:memorigame_project/screen/highscore.dart';
import 'package:memorigame_project/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Image Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Memory Image Game'),
      routes: {
        'highscore': (context) => Highscore(),
        'login': (context) => Login(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget funWidgetDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(active_user),
            accountEmail: Text(""),
          ),
          ListTile(
            title: new Text("High Score"),
            leading: new Icon(Icons.leaderboard),
            onTap: () {
              Navigator.popAndPushNamed(context, 'highscore');
            },
          ),
          ListTile(
            title: new Text("Logout"),
            leading: new Icon(Icons.logout),
            onTap: () {
              doLogout();
            },
          )
        ],
      ),
    );
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              width: 300,
              height: 300,
            ),
            Expanded(
              child: TutorialCard(),
            ),
          ],
        ),
      ),
      drawer: funWidgetDrawer(),
    );
  }
}

class TutorialCard extends StatelessWidget {
  const TutorialCard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tutorial',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              '1. Pertama kali game akan menampilkan 5 gambar secara acak dan bergantian dan harus diingat oleh pemain\n'+
              '2.  sistem akan menampilkan 4 opsi gambar yang harus ditebak oleh user. Salah satu dari 4 opsi yang tersedia merupakan\n'+
              'gambar yang harus diingat pemain, sedangkan 3 gambar lainnya hanyalah pengecoh/tipuan\n'+
              '3. Setiap pertanyaan hanya diberikan waktu 30 detik dan jika waktu habis maka akan menampilkan pertanyaan selanjutnya\n'+
              '4. Jawaban benar akan bernilai 1 point dan jika salah maka bernilai 0 point',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Game()),
                );
              },
              child: Text('Play GAME'),
            ),
          ],
        ),
      ),
    );
  }
}
