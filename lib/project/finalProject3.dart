import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gittest/firebase_options.dart';

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

class RegionSelectionScreen extends StatefulWidget {
  @override
  _RegionSelectionScreenState createState() => _RegionSelectionScreenState();
}

class _RegionSelectionScreenState extends State<RegionSelectionScreen> {
  String selectedRegion = '';

  final Map<String, IconData> regionIcons = {
    '강북구': FontAwesomeIcons.building,
    '강남구': FontAwesomeIcons.mapMarkedAlt,
    '홍대': FontAwesomeIcons.university,
    '이태원': FontAwesomeIcons.landmark,
    '명동': FontAwesomeIcons.shoppingBag,
    '서초구': FontAwesomeIcons.tree,
    '송파구': FontAwesomeIcons.water,
    '종로': FontAwesomeIcons.mapPin,
    '용산구': FontAwesomeIcons.umbrellaBeach,
    '마포구': FontAwesomeIcons.city,
    '광진구': FontAwesomeIcons.bridge,
    '부산': FontAwesomeIcons.city, // 추가된 지역
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('어디로 갈까요?')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '지역을 선택해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: regionIcons.keys.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 줄에 3개씩 표시
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                String region = regionIcons.keys.elementAt(index);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRegion = region;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategorySelectionScreen(region: selectedRegion),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(regionIcons[region], size: 30),
                      Text(region, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySelectionScreen extends StatefulWidget {
  final String region;
  CategorySelectionScreen({required this.region});

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String selectedCategory = '';

  final Map<String, IconData> categoryIcons = {
    '한식': FontAwesomeIcons.utensils,
    '중식': FontAwesomeIcons.bowlRice,
    '일식': FontAwesomeIcons.fish,
    '양식': FontAwesomeIcons.pizzaSlice,
    '분식': FontAwesomeIcons.hamburger,
    '디저트': FontAwesomeIcons.cookieBite,
    '치킨': FontAwesomeIcons.drumstickBite,
    '피자': FontAwesomeIcons.pizzaSlice,
    '커피': FontAwesomeIcons.coffee,
    '패스트푸드': FontAwesomeIcons.burger,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('검색할 맛집 카테고리 선택')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('지역: ${widget.region}', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: categoryIcons.keys.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 한 줄에 4개씩 표시
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                String category = categoryIcons.keys.elementAt(index);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantSearchScreen(
                          region: widget.region,
                          category: selectedCategory,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(categoryIcons[category], size: 30),
                      Text(category, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantSearchScreen extends StatefulWidget {
  final String region;
  final String category;

  RestaurantSearchScreen({
    required this.region,
    required this.category,
  });

  @override
  _RestaurantSearchScreenState createState() =>
      _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final String apiKey = 'ea86ea5ba43d9feb9730ec62b1fc0909';
  List<dynamic> restaurants = [];
  bool isLoading = false;

  final Map<String, Map<String, double>> regionCoordinates = {
    '강북구': {'latitude': 37.6392, 'longitude': 127.0254},
    '강남구': {'latitude': 37.5172, 'longitude': 127.0473},
    '홍대': {'latitude': 37.5524, 'longitude': 126.9248},
    '이태원': {'latitude': 37.5348, 'longitude': 126.9945},
    '명동': {'latitude': 37.5646, 'longitude': 126.9850},
    '서초구': {'latitude': 37.4837, 'longitude': 127.0320},
    '송파구': {'latitude': 37.5146, 'longitude': 127.1068},
    '종로': {'latitude': 37.5721, 'longitude': 126.9792},
    '용산구': {'latitude': 37.5344, 'longitude': 126.9779},
    '마포구': {'latitude': 37.5665, 'longitude': 126.9017},
    '광진구': {'latitude': 37.5375, 'longitude': 127.0477},
    '부산': {'latitude': 35.1796, 'longitude': 129.0756},
  };

  Future<void> fetchRestaurants() async {
    setState(() {
      isLoading = true;
    });

    final coordinates = regionCoordinates[widget.region];
    if (coordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('지역 정보를 찾을 수 없습니다.')));
      return;
    }

    final lat = coordinates['latitude'];
    final lon = coordinates['longitude'];

    final url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=${Uri.encodeComponent(widget.region)}%20${Uri.encodeComponent(widget.category)}&x=$lon&y=$lat&radius=2000';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'KakaoAK $apiKey',
    });

    if (response.statusCode == 200) {
      setState(() {
        restaurants = json.decode(response.body)['documents'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터를 불러오는데 실패했습니다.')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.region} - ${widget.category} 맛집')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          var restaurant = restaurants[index];
          return ListTile(
            title: Text(restaurant['place_name']),
            subtitle: Text(restaurant['address_name']),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(restaurant['place_name']),
                  content: Text(restaurant['address_name']),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('닫기'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
