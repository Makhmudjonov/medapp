import 'package:flutter/material.dart';
import 'package:medapp/screen/first_login.dart';
import 'package:medapp/screen/home.dart';
import 'package:medapp/screen/login.dart';
import 'package:medapp/screen/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isValid = await isTokenValid();
  runApp(MyApp(
    isLoggedIn: isValid != null,
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

Future<bool> isTokenValid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  int? expiryTime = prefs.getInt("expiry");

  if (token == null || expiryTime == null)
    return false; // Token yo‘q yoki muddati yo‘q

  int currentTime = DateTime.now().millisecondsSinceEpoch;
  return currentTime <
      expiryTime; // True: Token hali yaroqli, False: Token eskirgan
}
