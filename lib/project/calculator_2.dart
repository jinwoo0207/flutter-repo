import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp()); // 앱이 시작될 때 가장 먼저 실행되는 함수
}

// 메인 어플리케이션 위젯 - 앱 실행 시 가장 먼저 실행되는 위젯
class MyApp extends StatelessWidget {
  static const String _title = '202316003 안진우 계산기 예제'; // 앱의 제목을 상수로 설정

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title, // 앱의 제목 설정
      home: CalculatorApp(), // 메인 화면으로 CalculatorApp 위젯을 호출
    );
  }
}

// 계산기 앱을 위한 StatefulWidget - 상태를 유지하고 변경 가능한 위젯
class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() {
    return _CalculatorAppState(); // 상태를 관리하는 _CalculatorAppState를 생성하여 반환
  }
}

// 계산기 앱의 상태를 관리하는 클래스
class _CalculatorAppState extends State<CalculatorApp> {
  String result = ''; // 계산 결과를 저장하는 변수
  String operationResult = ''; // 선택된 연산자의 이름을 저장하는 변수
  TextEditingController value1 = TextEditingController(); // 첫 번째 숫자 입력 필드를 제어하는 컨트롤러
  TextEditingController value2 = TextEditingController(); // 두 번째 숫자 입력 필드를 제어하는 컨트롤러
  String operation = '+'; // 기본 연산자를 덧셈으로 설정

  // 거듭제곱 연산을 수행하는 함수
  // base는 밑수, exponent는 지수를 의미
  double power(double base, int exponent) {
    double result = 1;
    // exponent만큼 base를 곱하여 거듭제곱 계산을 구현
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result; // 결과 반환
  }

  // 입력된 값들을 바탕으로 계산을 수행하는 함수
  void calculate() {
    // 입력된 첫 번째 숫자와 두 번째 숫자를 double로 변환
    double? num1 = double.tryParse(value1.text);
    double? num2 = double.tryParse(value2.text);

    // 입력된 값이 숫자가 아니면 에러 메시지 출력
    if (num1 == null || num2 == null) {
      setState(() {
        result = '유효한 숫자를 입력하세요'; // 에러 메시지 설정
      });
      return; // 계산을 중단
    }

    // 숫자가 유효하면 선택된 연산을 수행
    setState(() {
      switch (operation) {
        case '+':
          result = (num1 + num2).toString(); // 덧셈 연산
          operationResult = '덧셈'; // 연산자 설명 저장
          break;
        case '-':
          result = (num1 - num2).toString(); // 뺄셈 연산
          operationResult = '뺄셈'; // 연산자 설명 저장
          break;
        case '*':
          result = (num1 * num2).toString(); // 곱셈 연산
          operationResult = '곱셈'; // 연산자 설명 저장
          break;
        case '/':
          if (num2 != 0) { // 0으로 나누는 경우 방지
            result = (num1 / num2).toString(); // 나눗셈 연산
            operationResult = '나눗셈'; // 연산자 설명 저장
          } else {
            result = '0으로 나눌 수 없음'; // 에러 메시지
          }
          break;
        case '%':
          if (num2 != 0) { // 0으로 나머지 계산 방지
            result = (num1 % num2).toString(); // 나머지 연산
            operationResult = '나머지'; // 연산자 설명 저장
          } else {
            result = '0으로 나머지를 구할 수 없음'; // 에러 메시지
          }
          break;
        case '^':
          result = power(num1, num2.toInt()).toString(); // 거듭제곱 연산
          operationResult = '거듭제곱'; // 연산자 설명 저장
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
        title: const Text('202316003 안진우 계산기 예제'), // 상단 앱바에 표시될 제목
      ),
      body: Center(
        child: Column( // 여러 위젯을 수직으로 배치하는 컬럼
          mainAxisAlignment: MainAxisAlignment.center, // 모든 위젯을 중앙 정렬
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '안진우의 플러터 계산기', // 계산기 제목
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
              ),
            ),
            // 첫 번째 숫자 입력 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.number, // 숫자 입력 전용 키보드
                controller: value1, // 첫 번째 숫자 입력 필드를 제어하는 컨트롤러
                decoration: const InputDecoration(
                  labelText: '첫 번째 숫자를 입력하세요', // 입력 필드의 안내 문구
                  border: OutlineInputBorder(), // 입력 필드에 테두리 추가
                ),
              ),
            ),
            const SizedBox(height: 15), // 첫 번째와 두 번째 입력 필드 사이의 간격
            // 두 번째 숫자 입력 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.number, // 숫자 입력 전용 키보드
                controller: value2, // 두 번째 숫자 입력 필드를 제어하는 컨트롤러
                decoration: const InputDecoration(
                  labelText: '두 번째 숫자를 입력하세요', // 입력 필드의 안내 문구
                  border: OutlineInputBorder(), // 입력 필드에 테두리 추가
                ),
              ),
            ),
            const SizedBox(height: 15), // 두 번째 입력 필드와 연산자 선택 드롭다운 사이의 간격
            // 연산자 선택 드롭다운 메뉴
            DropdownButton<String>(
              value: operation, // 현재 선택된 연산자
              // 드롭다운 메뉴에 사용할 연산자 목록
              items: <String>['+', '-', '*', '/', '%', '^']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value, // 연산자 값 설정
                  child: Text(value), // 화면에 표시될 텍스트
                );
              }).toList(),
              // 연산자가 변경되었을 때 호출되는 함수
              onChanged: (String? newValue) {
                setState(() {
                  operation = newValue!; // 선택된 연산자를 상태에 저장
                });
              },
            ),
            const SizedBox(height: 15), // 드롭다운과 계산 버튼 사이의 간격
            // 계산 버튼
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: calculate, // 버튼을 눌렀을 때 계산 수행
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼의 배경색 설정
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // 버튼 크기 설정
                ),
                child: const Text(
                  '계산하기', // 버튼에 표시될 텍스트
                  style: TextStyle(fontSize: 18), // 버튼 텍스트 스타일 설정
                ),
              ),
            ),
            // 계산 결과를 화면에 표시
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '$operationResult 결과 : $result', // 연산자와 계산 결과를 함께 표시
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 결과 텍스트 스타일 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
