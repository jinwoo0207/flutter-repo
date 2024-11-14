import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 변환을 위한 라이브러리.

void main() {
  runApp(MyApp());
} // MyApp 위젯 실행.

// MyApp 클래스는 애플리케이션의 루트 위젯을 정의
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // materialApp으로 앱 구조 설정
    return const MaterialApp(home: HttpApp()); // HttpApp을 홈 위젯으로 설정.
  }
}

// HttpApp 클래스는 StatefulWidget으로 상태를 관리
class HttpApp extends StatefulWidget {
  const HttpApp({super.key});

  @override
  State<HttpApp> createState() => _HttpApp(); // 상태 객체 생성.
}

// HttpApp의 상태 정의
class _HttpApp extends State<HttpApp> {
  List<dynamic>? data; // API 데이터 저장할 리스트.
  TextEditingController _editingController =
      TextEditingController(); // 검색어 입력 컨트롤러.
  ScrollController _scrollController = ScrollController(); // 스크롤 이벤트 컨트롤러.
  int page = 1; // 현재 페이지 번호.

  @override
  void initState() {
    // 초기화 메서드
    super.initState();
    data = []; // 데이터 리스트 초기화
    // 스크롤 리스너 추가: 스크롤 끝에 도달 시 다음 페이지 요청.
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++;
        getJSONData(); // 페이지 번호를 증가시키고 다음 페이지 데이터 요청.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 UI 빌드
    return Scaffold(
      appBar: AppBar(
        // 검색 입력 필드 추가
        title: TextField(
          controller: _editingController, // 입력 컨트롤러 설정
          style: const TextStyle(color: Colors.blueAccent),
          decoration: const InputDecoration(hintText: "검색어를 입력하세요"),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0), // 패딩 추가
        child: Center(
          child: data!.isEmpty // 데이터 없을 경우
              ? const Text(
                  "데이터가 없습니다", // 데이터 없을 때 표시할 텍스트
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              : ListView.builder(
                  // 데이터 목록 빌드
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        children: <Widget>[
                          Image.network(data![index]['thumbnail'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain), // 썸네일 이미지
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(data![index]['title'].toString(),
                                    textAlign: TextAlign.center),
                                // 책 제목
                                Row(
                                  // 저자와 출판사 한 쌍
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '저자 : ${data![index]['authors'].toString()}'),
                                    Text(
                                        '출판사 : ${data![index]['publisher'].toString()}'),
                                  ],
                                ),
                                Row(
                                  // 정가와 판매가 한 쌍
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '정가 : ${data![index]['price'].toString()}'),
                                    Text(
                                        '판매가 : ${data![index]['sale_price'].toString()}'),
                                  ],
                                ),
                                Text(
                                    '판매중 : ${data![index]['status'].toString()}'),
                                // 판매 상태
                                Text(
                                    '출판날짜 : ${data![index]['datetime'].toString()}'),
                                // 출판 날짜
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  controller: _scrollController,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // FAB 클릭 시 새로고침
        onPressed: () {
          page = 1;
          data!.clear();
          getJSONData(); // JSON 데이터를 가져오는 비동기 함수로 새로운 데이터를 요청
        },
        child: const Icon(Icons.file_download), // 다운로드 아이콘
      ),
    );
  }

  // JSON 데이터를 가져오는 비동기 함수 정의
  Future<void> getJSONData() async {
    // kakao API 데이터 요청
    var url =
        'http://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${Uri.encodeQueryComponent(_editingController.text)}';
    try {
      // http GET 요청
      var response = await http.get(Uri.parse(url), headers: {
        "Authorization": "KakaoAK ea86ea5ba43d9feb9730ec62b1fc0909"
      }); // 위에서 복사한 REST API키로 변경
      if (response.statusCode == 200) {
        // response(응답) statusCode(상태 코드) 가 200일 경우
        setState(() {
          var dataConvertedToJSON = json.decode(response.body); // JSON 데이터 디코딩
          List<dynamic> result =
              dataConvertedToJSON['documents']; // documents 필드에서 데이터 추출 (책 데이터)
          data!.addAll(result); // 책 데이터를 리스트에 추가
        });
      } else {
        throw Exception('Failed to load data'); // 오류 처리
      }
    } catch (e) {
      print('Error: $e'); // 오류 메시지 출력
    }
  }
}
