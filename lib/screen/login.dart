// 🔑 LOGIN PAGE
import 'package:flutter/material.dart';
import 'package:medapp/screen/home.dart';
import 'package:medapp/screen/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, email va parolni kiriting!")),
      );
      return;
    }

    // Bu yerda autentifikatsiya kodini qo'shishingiz mumkin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text("Login here"),
              Text("Welcome back you've been missed!"),
              TextField(),
              TextField(),
              Row(
                children: [Text("Forget your password?")],
              ),
              Container(
                height: 10,
                width: 150,
                color: Colors.blue,
              ),
              Text("Create new account"),
            ],
          ),
        ),
      ),
    );
  }
}
