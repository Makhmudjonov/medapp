class User {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String id; // Faqat o‘qiladigan maydon

  User(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phoneNumber'],
      id: json['clientId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone,
      'clientdId': id,
    };
  }
}
