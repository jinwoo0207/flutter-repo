import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class Todo {
  int id;
  String title;
  bool completed;

  Todo(this.id, this.title, this.completed);

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        completed = json['completed'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'completed': completed};
}

class _MyAppState extends State<MyApp> {
  String jsonStr = '{"id": 1, "title": "인덕대", "completed": false}';
  Todo? todo;
  String result = '';

  void onPressDecode() {
    Map<String, dynamic> map = jsonDecode(jsonStr);
    todo = Todo.fromJson(map);
    setState(() {
      result = "Decoded: id: ${todo?.id}, title: ${todo?.title}, completed: ${todo?.completed}";
    });
  }

  void onPressEncode() {
    setState(() {
      if (todo != null) {
        result = "Encoded: ${jsonEncode(todo)}";
      } else {
        result = "No Todo to encode";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test 안진우 202316003'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressDecode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 30),
                ),
                child: const Text('Decode'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressEncode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 30),
                ),
                child: const Text('Encode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}