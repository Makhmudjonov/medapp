import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController clientId = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Tokenni olish va foydalanuvchi ma'lumotlarini yuklash
  void loadUserData() async {
    String? token = await getToken();
    if (token != null) {
      await fetchUserData();
    } else {
      setState(() {
        isLoading = false;
      });
      // Agar token bo‘lmasa, login sahifaga yo‘naltirish
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // API orqali foydalanuvchi ma'lumotlarini olish
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
        Uri.parse("http://13.49.49.224:8080/api/userInfo/userProfile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          email.text = data['email'];
          firstName.text = data['firstName'];
          lastName.text = data['lastName'];
          phoneNumber.text = data['phoneNumber'].toString();
          clientId.text = data['clientId'].toString();
          userData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Foydalanuvchi ma’lumotlarini olishda xatolik!')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator.adaptive()
            : userData == null
                ? Text("No data available")
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Avatar
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white, // Oq fon
                                      border: Border.all(
                                        color:
                                            Color(0xFF1F41BB), // Chegara rangi
                                        width: 3.0, // Chegara qalinligi
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.all(4), // Ichki bo‘shliq
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          "https://cdn3d.iconscout.com/3d/premium/thumb/man-3d-icon-download-in-png-blend-fbx-gltf-file-formats--male-person-happy-people-human-avatar-pack-icons-7590876.png?f=webp"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${userData!['firstName']} ${userData!['lastName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "Id: ${userData!['clientId'].toString()}",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Text Fields
                            buildTextField("Client ID", clientId, true),
                            // Row(
                            //   children: [
                                buildTextField("First Name", firstName, false),
                                buildTextField("Last Name", lastName, false),
                            //   ],
                            // ),
                            buildTextField("Email", email, true),
                            buildTextField("Phone Number", phoneNumber, false),

                            SizedBox(height: 20),
                            // Save button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: Color(0xFF1F41BB),
                                  child: Center(child: Text("Saqlash"),),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  // TextField yaratish uchun funksiya
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

  // Tokenni olish
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Foydalanuvchi ma'lumotlarini yangilash
  Future<void> updateUserProfile() async {
    String? token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token topilmadi, iltimos qayta kiring!')),
      );
      return;
    }

    Map<String, dynamic> updatedData = {
      "firstName": firstName.text,
      "lastName": lastName.text,
      "email": email.text,
      "phone": phoneNumber.text,
    };

    try {
      final response = await http.put(
        Uri.parse("http://13.49.49.224:8080/api/userInfo/updateProfile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profil muvaffaqiyatli yangilandi!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xatolik yuz berdi!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: $e')),
      );
    }
  }
}
