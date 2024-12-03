import 'dart:convert';
import 'package:jhein_beta/BaseUrl/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Model untuk User dan UserProfile
UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));
String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  User user;

  UserProfile({
    required this.user,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  String name;
  String email;
  dynamic photo;
  String phone;

  User({
    required this.name,
    required this.email,
    required this.photo,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    photo: json["photo"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "photo": photo,
    "phone": phone,
  };
}

// Fungsi untuk mengambil data pengguna
Future<UserProfile?> fetchUserProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('userToken');
  
  if (token == null) {
    // Handle the case where token is null
    return null;
  }

  final url = Uri.parse(Api.userProfile); // Ganti dengan endpoint yang benar
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userProfile = userProfileFromJson(response.body);
      return userProfile;
    } else {
      // Handle error response
      return null;
    }
  } catch (error) {
    // Handle network or other errors
    return null;
  }
}
