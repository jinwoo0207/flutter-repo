import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('test 202316003 안진우'),
        ),
        body: Column(children: [
          Image.asset('images/icon1.jpg'),
          Image.asset('images/icon2.jpg'),
          Image.asset('images/sub1/icon3.jpg'),
        ],),
      ),
    );
  }
}