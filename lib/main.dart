import 'package:flutter/material.dart';
import 'package:medapp/screen/first_login.dart';
import 'package:medapp/screen/home.dart';
import 'package:medapp/screen/login.dart';
import 'package:medapp/screen/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await getToken();
  runApp(MyApp(
    isLoggedIn: token != null,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token");
}
