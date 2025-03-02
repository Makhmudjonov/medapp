import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medapp/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medapp/screen/home.dart';
import 'package:medapp/screen/signup.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, email va parolni kiriting!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final Uri url = Uri.parse("https://13.49.49.224:8080/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.body.toString();
        print(data.toString());
        String token = data.toString(); // API token qaytarishi kerak

        // Tokenni localda saqlash
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        // Muvaffaqiyatli login bo‘lsa, HomePage-ga o‘tish
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login xatosi: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login here",
                style: TextStyle(
                  color: Color(0xFF1F41BB),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Welcome back you've been missed!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.061),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "E-mail",
                  labelText: "E-mail",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Password",
                  labelText: "Password",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Confirm Password",
                  labelText: "Confirm Password",
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text("Forget your password?")],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F41BB),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Login account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
