import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  onPressed() {
    print('아이콘 버튼을 클릭했습니다');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: const Text('아이콘 예제 202316003 안진우'), centerTitle: true),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.alarm,
                  size: 100,
                  color: Colors.red,
                ),
                IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.alarm,
                      size: 100,
                    )),
                const FaIcon(
                  FontAwesomeIcons.bell,
                  size: 100,
                )
              ])),
    );
  }
}
