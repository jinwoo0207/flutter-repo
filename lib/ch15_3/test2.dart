import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 가져오기
import 'package:dio/dio.dart'; // Dio 패키지를 가져와서 HTTP 요청을 처리.

void main() {
  runApp(MyApp()); // MyApp 위젯을 실행하여 앱을 시작.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List', // 앱의 제목 설정.
      theme: ThemeData(
        primarySwatch: Colors.blue, // 기본 색상 테마 설정.
      ),
      home: UserListScreen(), // 홈 화면으로 UserListScreen 위젯을 설정.
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() =>
      _UserListScreenState(); // 상태를 관리하는 클래스 생성.
}

class _UserListScreenState extends State<UserListScreen> {
  final Dio _dio = Dio(); // Dio 인스턴스를 생성, API 요청을 수행할 준비.
  List<dynamic> _users = []; // 사용자 데이터를 저장할 리스트.
  bool _isLoading = true; // 로딩 상태를 나타내는 변수.
  String _errorMessage = ''; // 오류 메시지를 저장할 변수.

  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 호출
    _fetchAllUsers(); // 위젯이 생성될 때 모든 사용자 데이터를 가져오는 메서드 호출
  }

  // 모든 페이지의 사용자 데이터를 가져오는 비동기 메서드
  Future<void> _fetchAllUsers() async {
    int page = 1; // 시작 페이지 번호
    bool hasMore = true; // 더 많은 데이터가 있는지 확인하는 플래그

    try {
      List<dynamic> allUsers = []; // 모든 사용자 데이터를 저장할 리스트

      while (hasMore) {
        // GET 요청을 통해 현재 페이지의 사용자 목록 가져오기
        final response = await _dio.get('http://reqres.in/api/users?page=$page');

        if (response.statusCode == 200) {
          final data = response.data['data']; // 현재 페이지의 사용자 데이터
          allUsers.addAll(data); // 데이터를 리스트에 추가
          hasMore = data.isNotEmpty; // 데이터가 없으면 더 이상 요청하지 않음
          page++; // 다음 페이지로 이동
        } else {
          // 상태 코드가 200이 아닐 경우 루프 중단 및 오류 처리
          hasMore = false;
          setState(() {
            _errorMessage = '오류 발생 : ${response.statusCode}';
          });
        }
      }

      setState(() {
        _users = allUsers; // 모든 사용자 데이터를 상태에 저장
        _isLoading = false; // 로딩 상태를 false로 변경
      });
    } on DioError catch (e) {
      // DioError 발생 시 오류 처리
      setState(() {
        _errorMessage = '요청 중 오류 발생 : $e'; // 오류 메시지 저장
        _isLoading = false; // 로딩 상태를 false로 변경
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('202316003_안진우_Package'), // 앱바 제목 설정.
      ),
      body: _isLoading // 로딩 상태에 따라 다른 위젯을 표시.
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 로딩 인디케이터 표시
          : _errorMessage.isNotEmpty // 오류 메시지가 있을 경우.
          ? Center(child: Text(_errorMessage)) // 오류 발생 시 오류 메시지 표시.
          : ListView.separated(
        itemCount: _users.length,
        separatorBuilder: (context, index) =>
            Divider(), // 아이템 사이에 Divider 추가.
        itemBuilder: (context, index) {
          final user = _users[index]; // 현재 인덱스의 사용자 데이터 가져오기
          return ListTile(
            title: Text(user['first_name'] + ' ' + user['last_name']),
            // 사용자 이름 표시.
            subtitle: Text(user['email']),
            // 사용자 이메일 표시.
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  user['avatar']), // 아바타 이미지를 네트워크르 가져와 표시.
            ),
          );
        },
      ),
    );
  }
}
