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
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login here",style: TextStyle(
                      color: Color(0xFF1F41BB),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,),
                Text("Welcome back you've been missed!",style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      // fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.061),
                TextField(  keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),hintText: "E-mail",labelText: "E-mail",),),
                SizedBox(height: 10,),
                TextField(obscureText: true,decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),hintText: "Password",labelText: "Password"),),
                SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Forget your password?")],
                ),
                SizedBox(height: 10,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: 150,
                  color: Color(0xFF1F41BB)
                ),
                SizedBox(height: 10,),
                Text("Create new account"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
