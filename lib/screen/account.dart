import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    String? token = await getToken();
    if (token != null) {
      fetchUserProfile(token);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserProfile(String token) async {
    try {
      var response = await Dio().get(
        "http://13.49.49.224:8080/api/userInfo/userProfile",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 239, 237, 237),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator.adaptive()
            : userData == null
                ? Text("No data available")
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),

                          // **Asosiy Profil Ma’lumotlari**
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    child: Text(
                                      userData!['firstName'][0],
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                  title: Text(
                                    "${userData!['firstName']} ${userData!['lastName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    userData!['email'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.email_outlined,
                                      color: Colors.blue),
                                  title: Text("Email"),
                                  subtitle: Text(userData!['email']),
                                ),
                                Divider(),
                                ListTile(
                                  leading:
                                      Icon(Icons.phone, color: Colors.blue),
                                  title: Text("Telefon raqam"),
                                  subtitle: Text(userData!['phoneNumber']),
                                ),
                                Divider(),
                                ListTile(
                                  leading:
                                      Icon(Icons.person, color: Colors.blue),
                                  title: Text("Client ID"),
                                  subtitle:
                                      Text(userData!['clientId'].toString()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token");
}
