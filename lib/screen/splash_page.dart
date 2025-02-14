import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medapp/screen/first_login.dart';
import 'package:medapp/screen/login.dart';

class FirstLogin extends StatefulWidget {
  const FirstLogin({super.key});

  @override
  State<FirstLogin> createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
  @override
  void initState() {
    super.initState();
    // 4 soniyadan keyin Login sahifasiga o'tish
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: Duration(seconds: 5),
      color: Color(0xFFeef6fc),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 300,
              width: 300,
            ),
          ],
        ),
      ),
    );
  }
}
