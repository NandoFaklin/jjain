import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jhein_beta/BaseUrl/Api.dart';

import '../UI/Auth/Register/AccountCreated_6.dart';

class UserClass {
  int id;
  String name;
  String email;
  int role;
  String phone;
  String cardId;
  String gender;
  String daerah;
  String alamat;

  UserClass({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.cardId,
    required this.gender,
    required this.daerah,
    required this.alamat,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"],
        cardId: json["card_id"],
        gender: json["gender"],
        daerah: json["daerah_id"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "card_id": cardId,
        "gender": gender,
        "daerah_id": daerah,
        "alamat": alamat,
      };
}

class AuthService {
  Future<Map<String, dynamic>> register(
      BuildContext context,
      String name,
      String email,
      String phone,
      String cardId,
      String gender,
      String daerah,
      String alamat,
      VoidCallback clearForm) async {
    final url = Uri.parse(Api.register);

    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'card_id': cardId,
      'gender': gender,
      'daerah_id': daerah,
      'alamat': alamat,
    };

    print(
        'Data yang dikirim: $data'); // Cetak data yang dikirim untuk pemeriksaan

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );

    print('Response status: ${response.statusCode}'); // Cetak status respons
    print('Response body: ${response.body}'); // Cetak isi respons

    if (response.statusCode == 201) {
      // Berubah dari 200 menjadi 201 sesuai dengan status code registrasi berhasil
      final Map<String, dynamic> responseData = json.decode(response.body);
      _showDialog(
          context, 'Registrasi Berhasil', responseData['message'], clearForm);
      return responseData;
    } else {
      _showDialog(
          context,
          'Registrasi Gagal',
          'Request failed with status: ${response.statusCode}\n${response.body}',
          clearForm);
      return {
        'success': false,
        'message': 'Request failed with status: ${response.statusCode}',
      };
    }
  }

  void _showDialog(BuildContext context, String title, String message,
      VoidCallback clearForm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                clearForm();
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: const AccountCreatedScreen(),
                    );
                  },
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
