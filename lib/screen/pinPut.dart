import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:medapp/screen/login.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

/// This is the basic usage of Pinput
/// For more examples check out the demo directory
class VerifyCode extends StatefulWidget {
  String mail;
  String password;
  String firstName;
  String lastName;
  String phoneNumber;

  VerifyCode(
      {super.key,
      required this.mail,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  // late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  bool isLoading = true;

  Future<Object> verifyCode() async {
    // String email = emailController.text.trim();
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

    final Uri url = Uri.parse("http://13.49.49.224:8080/api/email/verify");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.mail,
          "code": pinController.text,
          // "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.body.toString();
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

  Future<Object> register() async {
    // String email = emailController.text.trim();
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

    final Uri url = Uri.parse("http://13.49.49.224:8080/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.mail,
          "password": widget.password,
          "firstName": widget.firstName,
          "lastName": widget.lastName,
          "phoneNumber": widget.phoneNumber,
          // "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.body.toString();
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
  void initState() {
    super.initState();
    // On web, disable the browser's context menu since this example uses a custom
    // Flutter-rendered context menu.
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter the code sent to your email.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(
                height: 50,
              ),
              Directionality(
                // Specify direction if desired
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  // You can pass your own SmsRetriever implementation based on any package
                  // in this example we are using the SmartAuth
                  // smsRetriever: smsRetriever,
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  validator: (value) {
                    return 'Code is incorrect';
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    // debugPrint('onCompleted: $pin');
                    verifyCode().then(
                      (value) {
                        if (value != 200) {
                          register().then(
                            (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          );
                        } else {
                          formKey.currentState!.validate();
                        }
                      },
                    );
                  },
                  onChanged: (value) {
                    // debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     focusNode.unfocus();
              //     formKey.currentState!.validate();
              //   },
              //   child: const Text('Validate'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
