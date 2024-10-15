import 'package:flutter/material.dart';

// 애플리케이션 시작점
void main() {
  runApp(MyApp());
}

// MyApp은 앱의 기본 구조를 만듦
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // AppBar 제목 설정
          title: Text('stateful Test 202316003 안진우'),
        ),
        // 앱의 본문에 MyWidget을 넣음
        body: MyWidget(),
      ),
    );
  }
}

// MyWidget은 상태(State)를 가질 수 있는 위젯
class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // 상태 관리할 _MyWidgetState 생성
    return _MyWidgetState();
  }
}

// _MyWidgetState는 MyWidget의 상태를 관리
class _MyWidgetState extends State<MyWidget> {
  bool enabled = false;  // 체크박스가 활성화되었는지 여부
  String stateText = "disabled";  // 현재 상태를 표시할 텍스트

  // 체크박스를 클릭하면 호출되는 함수
  void changeCheck() {
    setState(() {
      // 상태를 변경: 활성화/비활성화
      if (enabled) {
        stateText = "disabled";  // 비활성화 상태
        enabled = false;  // enabled를 false로 설정
      } else {
        stateText = "enabled";  // 활성화 상태
        enabled = true;  // enabled를 true로 설정
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // 아이콘과 텍스트를 중앙에 배치
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬
        children: [
          // 체크박스 아이콘 버튼
          IconButton(
            icon: (enabled
                ? Icon(
              Icons.check_box,  // 활성화된 체크박스
              size: 20,
            )
                : Icon(
              Icons.check_box_outline_blank,  // 비활성화된 체크박스
              size: 20,
            )),
            color: Colors.red,  // 빨간색 아이콘
            onPressed: changeCheck,  // 버튼 클릭 시 changeCheck 함수 호출
          ),
          // 상태 텍스트를 표시하는 컨테이너
          Container(
            padding: EdgeInsets.only(left: 16),  // 텍스트 왼쪽에 여백 추가
            child: Text(
              '$stateText',  // 활성화/비활성화 상태 표시
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),  // 굵고 큰 텍스트
            ),
          )
        ],
      ),
    );
  }
}
