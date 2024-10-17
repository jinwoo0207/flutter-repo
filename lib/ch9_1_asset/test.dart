import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// main() 함수: 앱이 실행될 때 제일 먼저 불리는 함수. MyApp 클래스를 시작함.
void main() {
  runApp(MyApp());
}

// MyApp 클래스: 앱의 메인 화면을 정의하는 부분.
class MyApp extends StatelessWidget {

  // useRootBundle() 함수: rootBundle을 사용해서 텍스트 파일 읽어오기.
  // 이 함수는 파일을 읽는 동안 기다리면서 앱이 멈추지 않게 해줌.
  Future<String> useRootBundle() async {
    // assets/text/my_text.txt 파일을 읽어서 텍스트로 반환함.
    // 텍스트 파일을 읽는 데 시간이 걸릴 수 있기 때문에, async await을 사용해 기다렸다가 완료되면 결과를 반환함.
    return await rootBundle.loadString('assets/text/my_text.txt');
  }

  // useDefaultAssetBundle() 함수: DefaultAssetBundle을 사용해서 텍스트 파일 읽어오기.
  // rootBundle이랑 비슷하지만 context(앱의 환경 정보)를 사용함.
  Future<String> useDefaultAssetBundle(BuildContext context) async {
    // asset/text/my_text.txt 파일을 읽어서 텍스트로 반환함.
    return await DefaultAssetBundle.of(context).loadString('assets/text/my_text.txt');
  }


  // build() 함수: 화면에 표시될 내용을 정의함.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱의 메인 화면 설정.
      home: Scaffold(
        // 화면 위에 표시될 상단바의 제목.
          appBar: AppBar(
            title: Text('asset test 202316003 안진우'),
          ),
          // 화면의 주요 내용들을 수직으로 나열함.
          body: Column(
            children: [
              // 'images/icon.jpg' 파일을 이미지로 화면에 띄움.
              Image.asset('images/icon.jpg'),
              // 'images/icon/user.png' 파일을 이미지로 화면에 띄움.
              Image.asset('images/icon/user.png'),

              // useRootBundle() 함수를 사용해 텍스트 파일 읽어서 화면에 표시.
              FutureBuilder(
                  future: useRootBundle(),
                  builder: (context, snapshot) {
                    // 데이터를 불러오는데 성공했으면 텍스트를 보여줌.
                    return Text('rootBundle : ${snapshot.data}');
                  }
              ),

              // useDefaultAssetBundle() 함수를 사용해 텍스트 파일 읽어서 화면에 표시.
              FutureBuilder(
                  future: useDefaultAssetBundle(context),
                  builder: (context, snapshot) {
                    // 데이터를 불러오는데 성공했으면 텍스트를 보여줌.
                    return Text('DefaultAssetBundle : ${snapshot.data}');
                  }
              )
            ],
          )),
    );
  }
}
