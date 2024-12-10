import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gittest/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 토스트 메시지를 화면에 표시하는 함수
showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg, // 표시할 메시지
    toastLength: Toast.LENGTH_SHORT, // 메시지 표시 시간
    gravity: ToastGravity.CENTER, // 화면에서의 위치
    timeInSecForIosWeb: 1, // iOS 및 웹에서의 지속 시간
    backgroundColor: Colors.red, // 배경 색상
    textColor: Colors.white, // 텍스트 색상
    fontSize: 16.0, // 텍스트 크기
  );
}

// 앱의 진입점
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 프레임워크 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 플랫폼 별 Firebase 초기화 옵션
  );
  runApp(MyApp()); // MyApp 위젯 실행
}

// 앱의 메인 위젯
class MyApp extends StatelessWidget {
  // const MyApp({super.key}); // 생성자

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // 앱 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 색상 테마
      ),
      home: AuthWidget(), // 초기 화면 설정
    );
  }
}

// 인증 화면을 담당하는 StatefulWidget
class AuthWidget extends StatefulWidget {
  // const AuthWidget({super.key}); // 생성자
  @override
  AuthWidgetState createState() => AuthWidgetState(); // 상태 생성
}

// 인증 로직 및 UI 관리를 위한 상태 클래스
class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리하기 위한 키

  late String email; // 입력받은 이메일
  late String password; // 입력받은 비밀번호
  bool isInput = true; // 현재 화면 상태: true면 입력 화면, false면 결과 화면
  bool isSignIn = true; // 현재 작업 상태: true면 로그인, false면 회원가입

  // 로그인 처리 함수
  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value); // 로그인 성공 정보 출력
        if (value.user!.emailVerified) { // 이메일 인증 여부 확인
          setState(() {
            isInput = false; // 결과 화면으로 전환
          });
        } else {
          showToast('emailVerified error'); // 인증 실패 메시지 출력
        }
        return value; // 반환값
      });
    } on FirebaseAuthException catch (error) {
      // Firebase 인증 관련 예외 처리
      if (error.code == 'user-not-found') {
        showToast(error.code); // 사용자 없음 메시지
      } else if (error.code == 'wrong-password') {
        showToast(error.code); // 비밀번호 오류 메시지
      } else {
        print(error.code); // 기타 오류 코드 출력
      }
    }
  }

  // 로그아웃 처리 함수
  signOut() async {
    await FirebaseAuth.instance.signOut(); // Firebase에서 로그아웃 처리
    setState(() {
      isInput = true; // 입력 화면으로 복귀
    });
  }

  // 회원가입 처리 함수
  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.email != null) { // 이메일이 유효하면
          FirebaseAuth.instance.currentUser?.sendEmailVerification(); // 이메일 인증 요청
          setState(() {
            isInput = false; // 결과 화면으로 전환
          });
        }
        return value; // 반환값
      });
    } on FirebaseAuthException catch (error) {
      // Firebase 인증 관련 예외 처리
      if (error.code == 'weak-password') {
        showToast(error.code); // 비밀번호 보안 약함 메시지
      } else if (error.code == 'email-already-in-use') {
        showToast(error.code); // 중복된 이메일 메시지
      } else {
        showToast('other error'); // 기타 오류 메시지
        print(error.code); // 오류 코드 출력
      }
    } catch (error) {
      print(error.toString()); // 예외 발생 시 출력
    }
  }

  // 입력 화면 위젯 목록 생성
  List<Widget> getInputWidget() {
    return [
      Text(
        isSignIn ? "로그인" : "회원가입", // 작업 상태에 따라 텍스트 변경
        style: const TextStyle(
          color: Colors.indigo, // 텍스트 색상
          fontWeight: FontWeight.bold, // 텍스트 굵기
          fontSize: 20, // 텍스트 크기
        ),
        textAlign: TextAlign.center, // 중앙 정렬
      ),
      Form(
        key: _formKey, // 폼 키 설정
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'email'), // 입력 필드 레이블
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter email'; // 유효성 검사 메시지
                }
                return null; // 유효성 통과
              },
              onSaved: (String? value) {
                email = value ?? ""; // 이메일 저장
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'password', // 입력 필드 레이블
              ),
              obscureText: true, // 입력 내용 숨김
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter password'; // 유효성 검사 메시지
                }
                return null; // 유효성 통과
              },
              onSaved: (String? value) {
                password = value ?? ""; // 비밀번호 저장
              },
            ),
          ],
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) { // 폼 유효성 검사
            _formKey.currentState?.save(); // 입력 데이터 저장
            print('email: $email, password : $password'); // 디버깅 출력
            if (isSignIn) {
              signIn(); // 로그인 처리
            } else {
              signUp(); // 회원가입 처리
            }
          }
        },
        child: Text(isSignIn ? "로그인" : "회원가입"), // 버튼 텍스트
      ),
      RichText(
        textAlign: TextAlign.right, // 텍스트 정렬
        text: TextSpan(
          text: 'GO', // 안내 텍스트
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: isSignIn ? "회원가입" : "로그인", // 상태에 따라 텍스트 변경
              style: const TextStyle(
                color: Colors.blue, // 텍스트 색상
                fontWeight: FontWeight.bold, // 텍스트 굵기
                decoration: TextDecoration.underline, // 밑줄
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isSignIn = !isSignIn; // 상태 변경
                  });
                },
            ),
          ],
        ),
      ),
    ];
  }

  // 결과 화면 위젯 목록 생성
  List<Widget> getResltWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!; // 사용자 이메일 가져오기
    return [
      Text(
        isSignIn
            ? "$resultEmail 로 로그인 하셨습니다.!" // 로그인 성공 메시지
            : "$resultEmail 로 회원가입 하셨습니다.! 이메일 인증을 거쳐야 로그인이 가능합니다.", // 회원가입 성공 메시지
        style: const TextStyle(
          color: Colors.black54, // 텍스트 색상
          fontWeight: FontWeight.bold, // 텍스트 굵기
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (isSignIn) {
            signOut(); // 로그아웃 처리
          } else {
            setState(() {
              isInput = true; // 입력 화면으로 전환
              isSignIn = true; // 상태 초기화
            });
          }
        },
        child: Text(isSignIn ? "로그아웃" : "로그인"), // 버튼 텍스트
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("인증테스트 인덕대 202316003 안진우"), // 앱 제목
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 정렬 설정
        children: isInput ? getInputWidget() : getResltWidget(), // 현재 상태에 따라 위젯 선택
      ),
    );
  }
}
