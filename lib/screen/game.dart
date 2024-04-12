import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          children: [Text("Hai")],
        ),
      ),
    );
  }
}
