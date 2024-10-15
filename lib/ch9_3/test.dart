import 'package:flutter/material.dart';
import 'package:gittest/ch2/test_50.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('이미지 애셋 예제 202316003 안진우'),
        ),
        body: Column(children: [
          Image(
            image: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ),
          Container(
            color: Colors.red,
            child: Image.asset(
              'images/big.jpeg',
              width: 200,
              height: 100,
              fit: BoxFit.fill,
            ),
          )
        ]),
      ),
    );
  }
}
