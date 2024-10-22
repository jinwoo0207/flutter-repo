import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = '안진우 아이폰 스타일 계산기';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  CalculatorAppState createState() => CalculatorAppState();
}

class CalculatorAppState extends State<CalculatorApp> {
  String output = '0'; // 계산기 화면에 표시될 출력 값
  String input = ''; // 입력 값 저장용 변수
  double num1 = 0; // 첫 번째 숫자 저장
  double num2 = 0; // 두 번째 숫자 저장
  String operation = ''; // 연산자 저장

  // 거듭제곱 연산을 수행하는 함수
  double power(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result; // 결과 반환
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        output = '0'; // 초기화
        input = '';
        num1 = 0;
        num2 = 0;
        operation = '';
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "*" ||
          buttonText == "/" ||
          buttonText == "^" ||
          buttonText == "%") {
        num1 = double.parse(input); // 첫 번째 숫자 저장
        operation = buttonText; // 연산자 저장
        input = '';
      } else if (buttonText == "=") {
        num2 = double.parse(input); // 두 번째 숫자 저장

        if (operation == "+") {
          output = (num1 + num2).toString();
        } else if (operation == "-") {
          output = (num1 - num2).toString();
        } else if (operation == "*") {
          output = (num1 * num2).toString();
        } else if (operation == "/") {
          if (num2 != 0) {
            output = (num1 / num2).toString();
          } else {
            output = '0으로 나눌 수 없음';
          }
        } else if (operation == "^") {
          output = power(num1, num2.toInt()).toString();
        } else if (operation == "%") {
          if (num2 != 0) {
            output = (num1 % num2).toString();
          } else {
            output = '0으로 나눌 수 없음';
          }
        }

        num1 = 0; // 계산 완료 후 초기화
        num2 = 0;
        operation = '';
        input = output;
      } else {
        input += buttonText; // 숫자 입력
        output = input;
      }
    });
  }

  // 버튼 디자인
  Widget buildButton(String buttonText, Color bgColor, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: const EdgeInsets.all(22.0),
            shape: const CircleBorder(),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24, color: textColor),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('안진우 아이폰 스타일 계산기', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              output, // 현재 출력할 값
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Expanded(child: Divider()), // 화면과 키패드를 분리하는 구분선
          Column(children: [
            Row(
              children: <Widget>[
                buildButton("7", Colors.grey[850]!, Colors.white),
                buildButton("8", Colors.grey[850]!, Colors.white),
                buildButton("9", Colors.grey[850]!, Colors.white),
                buildButton("/", Colors.orange, Colors.white),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("4", Colors.grey[850]!, Colors.white),
                buildButton("5", Colors.grey[850]!, Colors.white),
                buildButton("6", Colors.grey[850]!, Colors.white),
                buildButton("*", Colors.orange, Colors.white),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("1", Colors.grey[850]!, Colors.white),
                buildButton("2", Colors.grey[850]!, Colors.white),
                buildButton("3", Colors.grey[850]!, Colors.white),
                buildButton("-", Colors.orange, Colors.white),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton(".", Colors.grey[850]!, Colors.white),
                buildButton("0", Colors.grey[850]!, Colors.white),
                buildButton("00", Colors.grey[850]!, Colors.white),
                buildButton("+", Colors.orange, Colors.white),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("C", Colors.grey, Colors.black),
                buildButton("=", Colors.orange, Colors.white),
                buildButton("^", Colors.orange, Colors.white),
                buildButton("%", Colors.orange, Colors.white),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
