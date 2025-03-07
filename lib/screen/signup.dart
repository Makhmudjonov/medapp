import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:medapp/screen/login.dart';
import 'package:medapp/screen/pinPut.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medapp/screen/home.dart';
import 'package:medapp/screen/signup.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future sendCode() async {
    String email = emailController.text;
    // String password = passwordController.text.trim();

    // if (email.isEmpty || password.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Iltimos, email va parolni kiriting!")),
    //   );
    //   // return;
    // }

    setState(() {
      isLoading = true;
    });

    final Uri url =
        Uri.parse("http://13.49.49.224:8080/api/email/send-code?email=$email");

    try {
      final response = await http.post(
        url,
        headers: {"accept": "*/*"},
        // body: jsonEncode({
        //   "email": email,
        //   // "password": password,
        // }),
      );

      if (response.statusCode == 200) {
        // final data = response.body.toString();
        return 200;
        // print(data.toString());
        // String token = data.toString(); // API token qaytarishi kerak

        // // Tokenni localda saqlash
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString("token", token);

        // Muvaffaqiyatli login bo‘lsa, HomePage-ga o‘tish
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Login xatosi: ${response.body}")),
        //   );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
    return 400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                  TextFormField(
                    controller: firstName,
                    // keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name kiriting';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "First name",
                      labelText: "First name",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: lastName,
                    // keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name kiriting';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Last name",
                      labelText: "Last name",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumber,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number kiriting';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Phone number",
                      labelText: "Phone number",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Emailni kiriting';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Yaroqli email kiriting';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "E-mail",
                      labelText: "E-mail",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Parolni kiriting';
                      }
                      if (value.length < 8) {
                        return 'Parol kamida 8 ta belgidan iborat bo‘lishi kerak';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Password",
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Parolni tasdiqlashni kiriting';
                      }
                      if (value != passwordController.text) {
                        return 'Parollar bir xil emas!';
                      }
                      return null;
                    },
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
                    onPressed: () {
                      sendCode().then(
                        (value) {
                          _formKey.currentState!.validate() && value == 200
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyCode(
                                      mail: emailController.text,
                                      password: passwordController.text,
                                      firstName: firstName.text,
                                      lastName: lastName.text,
                                      phoneNumber: phoneNumber.text,
                                    ),
                                  ))
                              : isLoading = false;
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1F41BB),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign up", style: TextStyle(fontSize: 18)),
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
        ),
      ),
    );
  }
}

_onCustomAnimationAlertPressed(context) {
  Alert(
      context: context,
      title: "Verify email",
      desc: "Enter the code sent to your email.",
      alertAnimation: fadeAlertAnimation,
      content: Center(
        child: TextField(),
      )).show();
}

Widget fadeAlertAnimation(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
