import 'package:flutter/material.dart';

class Login extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Login'),
    backgroundColor: Colors.cyan,
   ),
   body: Center(
    child: Image.network("https://i.pravatar.cc/300/img=30"),
   ),
  );
 }
}