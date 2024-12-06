import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Headlines',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<String> headlines = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final apiKey = 'e079e2fb550f4ba5b92ebec93902fdfc';
    final url = Uri.parse('https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        headlines = (data['articles'] as List).map((article) => article['title'] as String).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top News')),
      body: ListView.builder(
        itemCount: headlines.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(headlines[index]),
        ),
      ),
    );
  }
}
