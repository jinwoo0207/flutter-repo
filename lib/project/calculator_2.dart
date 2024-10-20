import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp());
}

// 메인 어플리케이션 위젯 - 앱 실행 시 가장 먼저 실행되는 위젯
class MyApp extends StatelessWidget {
  static const String _title = '202316003 안진우 계산기 예제'; // 앱의 제목

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: CalculatorApp(), // 메인 화면을 표시하는 CalculatorApp 호출
    );
  }
}

// 계산기 앱을 위한 StatefulWidget
// 상태를 가지는 위젯으로 화면이 업데이트 될 수 있도록 설정
class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() {
    return _CalculatorAppState();
  }
}

class _CalculatorAppState extends State<CalculatorApp> {
  String result = ''; // 계산 결과를 저장하는 변수
  String operationResult = ''; // 선택된 연산자를 저장하는 변수
  TextEditingController value1 = TextEditingController(); // 첫 번째 숫자 입력 컨트롤러
  TextEditingController value2 = TextEditingController(); // 두 번째 숫자 입력 컨트롤러
  String operation = '+'; // 기본 연산자는 덧셈으로 설정

  // 거듭제곱 연산을 위한 함수
  // base: 밑(첫 번째 숫자 입력), exponent: 지수(두 번째 숫자 입력)
  double power(double base, int exponent) {
    double result = 1;
    // exponent만큼 base를 곱함으로써 거듭제곱 구현
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result; // 결과 반환
  }

  // 계산을 수행하는 함수
  void calculate() {
    // 첫 번째 숫자와 두 번째 숫자를 입력받아 double로 변환
    double? num1 = double.tryParse(value1.text);
    double? num2 = double.tryParse(value2.text);

    // 입력값이 숫자가 아닐 경우 에러 메시지 표시
    if (num1 == null || num2 == null) {
      setState(() {
        result = '유효한 숫자를 입력하세요'; // 에러 메시지 설정
      });
      return; // 더 이상 진행하지 않음
    }

    // 유효한 숫자가 입력되었을 때 각 연산 수행
    setState(() {
      switch (operation) {
        case '+':
          result = (num1 + num2).toString(); // 덧셈 연산
          operationResult = '덧셈'; // 연산자 명 저장
          break;
        case '-':
          result = (num1 - num2).toString(); // 뺄셈 연산
          operationResult = '뺄셈'; // 연산자 명 저장
          break;
        case '*':
          result = (num1 * num2).toString(); // 곱셈 연산
          operationResult = '곱셈'; // 연산자 명 저장
          break;
        case '/':
          if (num2 != 0) { // 두 번째 숫자가 0이 아닌 경우만 나눗셈 수행
            result = (num1 / num2).toString(); // 나눗셈 연산
            operationResult = '나눗셈'; // 연산자 명 저장
          } else {
            result = '0으로 나눌 수 없음'; // 0으로 나누는 경우 에러 메시지
          }
          break;
        case '%':
          if (num2 != 0) { // 두 번째 숫자가 0이 아닌 경우만 나머지 연산 수행
            result = (num1 % num2).toString(); // 나머지 연산
            operationResult = '나머지'; // 연산자 명 저장
          } else {
            result = '0으로 나머지를 구할 수 없음'; // 0으로 나누는 경우 에러 메시지
          }
          break;
        case '^':
          result = power(num1, num2.toInt()).toString(); // 거듭제곱 연산
          operationResult = '거듭제곱'; // 연산자 명 저장
          break;
        default:
          result = '알 수 없는 연산자'; // 잘못된 연산자 처리
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('202316003 안진우 계산기 예제'), // 앱바에 표시되는 제목
      ),
      body: Center(
        child: SingleChildScrollView( // 화면이 작은 경우 스크롤 가능하도록 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  '안진우의 플러터 계산기', // 앱의 제목 텍스트
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일
                ),
              ),
              // 첫 번째 숫자 입력 필드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.number, // 숫자만 입력할 수 있도록 설정
                  controller: value1, // 첫 번째 숫자를 입력하는 컨트롤러
                  decoration: const InputDecoration(
                    labelText: '첫 번째 숫자를 입력하세요', // 입력 필드에 표시되는 라벨
                    border: OutlineInputBorder(), // 입력 필드에 테두리 추가
                  ),
                ),
              ),
              const SizedBox(height: 15), // 입력 필드 간격 추가
              // 두 번째 숫자 입력 필드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.number, // 숫자만 입력할 수 있도록 설정
                  controller: value2, // 두 번째 숫자를 입력하는 컨트롤러
                  decoration: const InputDecoration(
                    labelText: '두 번째 숫자를 입력하세요', // 입력 필드에 표시되는 라벨
                    border: OutlineInputBorder(), // 입력 필드에 테두리 추가
                  ),
                ),
              ),
              const SizedBox(height: 15), // 입력 필드 간격 추가
              // 연산자를 선택하는 드롭다운 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    value: operation, // 현재 선택된 연산자
                    // 연산자 리스트 생성
                    items: <String>['+', '-', '*', '/', '%', '^'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value, // 연산자 값 설정
                        child: Text(value), // 화면에 표시되는 텍스트
                      );
                    }).toList(),
                    onChanged: (String? newValue) { // 선택된 연산자 변경 시 호출
                      setState(() {
                        operation = newValue!; // 선택된 연산자를 상태에 저장
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15), // 버튼과 간격 추가
              // 계산 버튼
              Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: calculate, // 계산 버튼 클릭 시 계산 로직 호출
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경색 설정
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // 버튼 크기 설정
                  ),
                  child: const Text(
                    '계산하기', // 버튼 텍스트
                    style: TextStyle(fontSize: 18), // 텍스트 스타일
                  ),
                ),
              ),
              // 결과 표시
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  '$operationResult 결과 : $result', // 연산 결과 텍스트
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 결과 텍스트 스타일
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
