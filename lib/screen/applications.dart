import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medapp/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Applications extends StatefulWidget {
  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController clientId = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  List? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Получение токена и загрузка данных пользователя
  void loadUserData() async {
    String? token = await getToken();
    if (token != null) {
      await fetchUserData();
    } else {
      setState(() {
        isLoading = false;
      });
      // Если токен отсутствует, перенаправить на страницу входа
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Получение данных пользователя через API
  Future<void> fetchUserData() async {
    String? token = await getToken();

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("http://13.49.49.224:8080/api/userInfo/getUserInfo"),
        headers: {
          // "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(utf8.decode(response.bodyBytes));
        print(response.body.toString());
        print(data.toString());
        userData = data;
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при получении данных пользователя!')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Заявки"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator.adaptive()
            : userData == null
                ? Text("Нет доступных данных")
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        // reverse: true ni olib tashlash
                        itemCount: userData?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.withOpacity(0.1),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                buildCard(
                                  Icons.person,
                                  "Рекомендация ${index + 1}",
                                  "Пол: ${userData?[index]["gender"]}\nВозраст: ${userData?[index]["age"]}\nРост: ${userData?[index]["height"]} см\nВес: ${userData?[index]["weight"]} кг\nАртериальное давление: ${userData?[index]["systolic"]}/${userData?[index]["diastolic"]}\nПульс в покое: ${userData?[index]["restingHeartRate"]}",
                                  Colors.blueAccent,
                                ),
                                buildCard(
                                  Icons.fitness_center,
                                  "Рекомендуемые упражнения",
                                  userData?[index]["recommendation"]
                                      ["exerciseDescriptions"],
                                  Colors.green,
                                ),
                                buildCard(
                                  Icons.access_time,
                                  "Время для упражнений",
                                  userData?[index]["recommendation"]
                                      ["recommendedDuration"],
                                  Colors.orange,
                                ),
                                buildCard(
                                  Icons.assignment,
                                  "Дополнительные рекомендации",
                                  userData?[index]["recommendation"]
                                      ["additionalInstructions"],
                                  Colors.purple,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget buildCard(IconData icon, String title, String content, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}

// Функция для создания TextField
Widget buildTextField(
    String label, TextEditingController controller, bool readOnly) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

// Получение токена
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token");
}

Future<Future<bool>> remoweToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove('token');
}
