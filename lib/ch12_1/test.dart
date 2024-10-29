import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  String name;
  String phone;
  String email;
  User(this.name, this.phone, this.email);
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  List<User> users = [
    User('인덕대1', '010101', 'a@induk.ac.kr'), User('인덕대2', '010101', 'a@induk.ac.kr'),
    User('인덕대3', '010101', 'a@induk.ac.kr'), User('인덕대4', '010101', 'a@induk.ac.kr'),
    User('인덕대5', '010101', 'a@induk.ac.kr'), User('인덕대6', '010101', 'a@induk.ac.kr'),
    User('인덕대7', '010101', 'a@induk.ac.kr'), User('인덕대8', '010101', 'a@induk.ac.kr'),
    User('인덕대9', '010101', 'a@induk.ac.kr'), User('인덕대10', '010101', 'a@induk.ac.kr'),
    User('인덕대11', '010101', 'a@induk.ac.kr'), User('인덕대12', '010101', 'a@induk.ac.kr'),
    User('인덕대13', '010101', 'a@induk.ac.kr'), User('인덕대14', '010101', 'a@induk.ac.kr'),
    User('인덕대15', '010101', 'a@induk.ac.kr'), User('인덕대16', '010101', 'a@induk.ac.kr'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('202316003 안진우 Test'),),
        body: ListView.separated(
            itemBuilder: (context, index){
              return ListTile(
                leading: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('images/induk.png'),
                ),
                title: Text(users[index].name),
                subtitle: Text(users[index].phone),
                trailing: Icon(Icons.more_vert),
                onTap: () {
                  print(users[index].name);
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 2, color: Colors.red,);
            },
            itemCount: users.length
        ),
      ),
    );
  }
}

