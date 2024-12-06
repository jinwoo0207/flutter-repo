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
      title: 'Weather and Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: WeatherScheduleScreen(),
    );
  }
}

class WeatherScheduleScreen extends StatefulWidget {
  @override
  _WeatherScheduleScreenState createState() => _WeatherScheduleScreenState();
}

class _WeatherScheduleScreenState extends State<WeatherScheduleScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  String _weatherDescription = '';
  bool _isRaining = false;
  String _temperature = '';

  Future<void> fetchWeather(String city) async {
    final apiKey = '19daf9cb6764529f4b2a7b9e3d0a441c'; // OpenWeatherMap API 키
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherDescription = data['weather'][0]['description'];
        _temperature = data['main']['temp'].toString();
        _isRaining = data['weather'][0]['main'] == 'Rain';
      });
    } else {
      setState(() {
        _weatherDescription = '날씨 정보를 불러올 수 없습니다.';
        _temperature = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('날씨와 일정')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: '도시 입력',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _scheduleController,
              decoration: InputDecoration(
                labelText: '일정 입력',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  fetchWeather(_cityController.text);
                },
                icon: Icon(Icons.cloud),
                label: Text('날씨 확인'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (_weatherDescription.isNotEmpty)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(
                    _isRaining ? Icons.umbrella : Icons.wb_sunny,
                    color: _isRaining ? Colors.blue : Colors.orange,
                    size: 40,
                  ),
                  title: Text(
                    '날씨: $_weatherDescription',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '온도: $_temperature°C',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: _isRaining
                      ? Icon(Icons.warning, color: Colors.red)
                      : Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
