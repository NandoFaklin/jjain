import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jhein_beta/BaseUrl/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';


User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    bool success;
    String message;
    UserClass user;
    String token;

    User({
        required this.success,
        required this.message,
        required this.user,
        required this.token,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        success: json["success"],
        message: json["message"],
        user: UserClass.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user.toJson(),
        "token": token,
    };
}

class UserClass {
    int id;
    String name;
    String phone;
    String role;

    UserClass({
        required this.id,
        required this.name,
        required this.phone,
        required this.role,
    });

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "role": role,
    };
}


class AuthService {
  Future<void> login(String phone, String password) async {
    final url = Uri.parse(Api.login);
    final Map<String, String> data = {
      'phone': phone,
      'password': password,
    };

    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success']) {
        print('Login berhasil');
        print('User: ${responseData['user']['name']}');
        print('Token: ${responseData['token']}');
        saveUser(UserClass.fromJson(responseData['user']), responseData['token']);
      } else {
        print('Login gagal: ${responseData['message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void saveUser(UserClass user, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', user.id);
    prefs.setString('user_name', user.name);
    prefs.setString('user_phone', user.phone);
    prefs.setString('user_role', user.role);
    prefs.setString('user_token', token);
  }
}

