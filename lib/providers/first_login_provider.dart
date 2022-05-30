import 'dart:convert';

import 'package:edu_ready/model/user_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FirstLoginProvider with ChangeNotifier {
  String urlLogin = "https://project-ala.net/get/api/auth/login";
  String urlRegister = "https://project-ala.net/get/api/auth/register";

  Future<void> doFirstLogin(String email, String password) async {
    Uri url = Uri.parse(urlLogin);

    try {
      Map<String, String> body = {"email": email, "password": password};

      var response = await http.post(url, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        var decodeData = json.decode(response.body);
        sp.clear();

        String user = json.encode(UserLogin.fromJson(decodeData));
        sp.setString('user', user);

        notifyListeners();
      } else {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> doRegisterUser(String agree, String email, String firstname,
      String lastname, String password) async {
    //response sama dengan login kecuali has, di register tidak ada has
    //bisa pakai model UserLogin untuk simpan SP, tapi cek berhasil atau tidak masuknya SP register
    //pake sp.clear biar sharedpreferences bersih dan bisa di tes di domain page

    Uri url = Uri.parse(urlRegister);
    try {
      Map<String, String> body = {
        "agree": agree,
        "email": email,
        "first_name": firstname,
        "last_name": lastname,
        "password": password
      };

      var response = await http.post(url, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {

        SharedPreferences sp = await SharedPreferences.getInstance();
        var decodeData = json.decode(response.body);

        sp.clear();
        String user = json.encode(UserLogin.fromJson(decodeData));
        sp.setString('user', user);

        notifyListeners();
      } else {
        throw(json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
