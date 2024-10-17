import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("아이콘 중앙 정렬 202316003 안진우"),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.alarm,
                size: 100,
                color: Colors.red,
              ),
              FaIcon(
                FontAwesomeIcons.bell,
                size: 100,
              ),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.alarm,
                    size: 100,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

void onPressed() {
  print('아이콘 버튼을 클릭했습니다');
}
