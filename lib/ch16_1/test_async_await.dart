import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<int> funA() {
    return Future.delayed(Duration(seconds: 3), () {
      return 10;
    });
  }

  Future<int> funB(int arg) {
    return Future.delayed(Duration(seconds: 2), () {
      return arg * arg;
    });
  }

  Future<int> calFun() async {
    int aresult = await funA();
    int bresult = await funB(aresult);
    return bresult;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test 202316003 안진우'),
        ),
        body: FutureBuilder(future: calFun(),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                    Text(
                      'waiting...',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
