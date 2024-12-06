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
      title: 'Weather-based To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherTodoScreen(),
    );
  }
}

class WeatherTodoScreen extends StatefulWidget {
  @override
  _WeatherTodoScreenState createState() => _WeatherTodoScreenState();
}

class _WeatherTodoScreenState extends State<WeatherTodoScreen> {
  List<String> _tasks = [];
  String _weatherDescription = '';
  bool _isLoading = false;

  Future<void> fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = '19daf9cb6764529f4b2a7b9e3d0a441c'; // OpenWeatherMap API 키를 입력하세요
    final city = 'Seoul'; // 고정된 도시 이름 사용
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherDescription = data['weather'][0]['main'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherDescription = '날씨 정보를 불러올 수 없습니다.';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(); // 앱 시작 시 날씨 정보 로드
  }

  List<String> getRecommendedTasks() {
    if (_weatherDescription == 'Rain') {
      return ['독서하기', '집안 정리', '영화 감상'];
    } else if (_weatherDescription == 'Clear') {
      return ['산책하기', '운동하기', '자전거 타기'];
    } else {
      return ['요가하기', '온라인 강의 듣기', '취미 활동'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendedTasks = getRecommendedTasks();

    return Scaffold(
      appBar: AppBar(title: Text('날씨 기반 할 일 관리')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('오늘의 날씨: $_weatherDescription', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('추천 작업:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            for (var task in recommendedTasks)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tasks.add(task);
                  });
                },
                child: Text(task),
              ),
            Divider(height: 30),
            Text('내 할 일 목록:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
