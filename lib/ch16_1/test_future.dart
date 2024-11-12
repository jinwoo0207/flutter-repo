import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<int> sum() {
    return Future<int>(() {
      var sum = 0;
      Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      for (int i = 0; i < 500000000; i++) {
        sum += i;
      }
      stopwatch.stop();
      print("${stopwatch.elapsed}, result: $sum");
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test 202316003 안진우'),
        ),
        body: FutureBuilder(future: sum(),
            builder: (context, snapshot){
          if (snapshot.hasData) {
            return Center(
              child: Text(
                '${snapshot.data}',
                style: const TextStyle(
                  color: Colors.black, fontSize: 30
                ),
              ),
            );
          }
          return const Center(
            child: Text('waiting',style: TextStyle(color: Colors.black, fontSize: 30),),
          );
            }),
      ),
    );
  }
}


