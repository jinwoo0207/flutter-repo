import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gittest/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWidget(),
    );
  }
}

class AuthWidget extends StatefulWidget {
  // const AuthWidget({super.key});
  @override
  AuthWidgetState createState() => AuthWidgetState();
}

class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  bool isInput = true;
  bool isSignIn = true;

  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value){
            print(value);
            if (value.user!.emailVerified){
              setState(() {
                isInput = false;
              });
            } else {
              showToast('emailVerified error');
            }
            return value;
      });
    } on FirebaseAuthException catch(error) {
      if (error.code == 'user-not-found'){
        showToast(error.code);
      } else if (error.code == 'wrong-found'){
        showToast(error.code);
      } else {
        print(error.code);
      }
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isInput = true;
    });
  }

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value){
        if (value.user!.email != null){
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          setState(() {
            isInput = false;
          });
        }
        return value;
      });
    } on FirebaseAuthException catch(error) {
      if (error.code == 'weak-password'){
        showToast(error.code);
      } else if (error.code == 'email-already-in-use'){
        showToast(error.code);
      } else {
        showToast('other error');
        print(error.code);
      }
    } catch(error){
      print(error.toString());
    }
  }

  List<Widget> getInputWidget() {
    return [
      Text(
        isSignIn ? "로그인" : "회원가입",
        style: const TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),

      Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'email'),
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  email = value ?? "";
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'password',
                ),
                obscureText: true,
                validator: (value){
                  if (value?.isEmpty ?? false) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onSaved: (String? value){
                  password = value ?? "";
                },
              ),
            ],
          ),
      ),

      ElevatedButton(onPressed: (){
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          print('email: $email, password : $password');
          if (isSignIn){
            signIn();
          } else {
            signUp();
          }
        }
      },
        child: Text(isSignIn ? "로그인" : "회원가입"),
      ),

      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: 'GO',
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan> [
            TextSpan(
              text: isSignIn ? "회원가입" : "로그인",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                setState(() {
                  isSignIn = !isSignIn;
                });
                }
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> getResltWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!;
    return [
      Text(
        isSignIn
          ? "$resultEmail 로 로그인 하셨습니다.!"
          : "$resultEmail 로 회원가입 하셨습니다.! 이메일 인증을 거쳐야 로그인이 가능합니다.",
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),

      ElevatedButton(onPressed: (){
        if (isSignIn){
          signOut();
        } else {
          setState(() {
            isInput = true;
            isSignIn = true;
          });
        }
      }, child: Text(isSignIn ? "로그아웃" : "로그인"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("인증테스트 인덕대 202316003"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isInput ? getInputWidget() : getResltWidget(),
      ),
    );
  }
}



