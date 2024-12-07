import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'finalProject3.dart'; // RegionSelectionScreen을 사용하기 위해 import
import 'package:gittest/firebase_options.dart'; // Firebase 초기화 설정 파일

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 위젯 바인딩을 보장
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Firebase 초기화
  );
  runApp(AuthApp());
}

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '로그인 & 회원가입',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWidget(),
    );
  }
}

class AuthWidget extends StatefulWidget {
  @override
  AuthWidgetState createState() => AuthWidgetState();
}

class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  bool isSignIn = true;

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegionSelectionScreen()),
          );
        } else {
          showToast('이메일 인증이 필요합니다.');
        }
      });
    } on FirebaseAuthException catch (error) {
      showToast('오류: ${error.message}');
    }
  }

  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          showToast('회원가입 성공! 이메일 인증 후 로그인하세요.');
        }
      });
    } on FirebaseAuthException catch (error) {
      showToast('오류: ${error.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSignIn ? '로그인' : '회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) => password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    isSignIn ? signIn() : signUp();
                  }
                },
                child: Text(isSignIn ? '로그인' : '회원가입'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isSignIn = !isSignIn;
                  });
                },
                child: Text(isSignIn ? '회원가입으로 전환' : '로그인으로 전환'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
