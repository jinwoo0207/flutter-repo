import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MyApp>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tab Test 202316003 안진우'),
          bottom: TabBar(
            controller: controller,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.looks_one),
                text: 'One',
              ),
              Tab(
                icon: Icon(Icons.looks_two),
                text: 'Two',
              ),
              Tab(
                icon: Icon(Icons.looks_3),
                text: 'Three',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            tabContent('One Screen', '이곳은 첫 번째 화면입니다.', Colors.blue),
            tabContent('Two Screen', '이곳은 두 번째 화면입니다.', Colors.green),
            tabContent('Three Screen', '이곳은 세 번째 화면입니다.', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget tabContent(String title, String description, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title 버튼 클릭됨!')),
            );
          },
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: Text('클릭하세요'),
          ),
        ],
      ),
    );
  }
}
