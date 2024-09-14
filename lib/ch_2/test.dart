import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hello, induk!',
            ),
            Text(
                '정보통신공학과 202316003 안진우'
            ),
            ],
          ),
        ),
      ),
    )
  );
}