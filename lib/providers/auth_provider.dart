import 'dart:convert';

import 'package:edu_ready/main.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  Uri urlMaster = Uri.parse("${MyApp.domain}/api/v1/login");
  // Uri urlMaster = Uri.parse("https://spas.ones-edu.com/getting/api/v1/login");

  Future<void> loginUser(username, password) async {
    Uri url = Uri.parse("$urlMaster");

    try {
      var response = await http
          .post(url, body: {"username": username, "password": password});
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var decodeData =
            jsonDecode(response.body); 
        String user = jsonEncode(User.fromJson(decodeData));
        preferences.setString('user', user);

        notifyListeners();
      } else {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> haveLogged() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var chkdata = pref.getString('user'); //ini tidak bisa lngsung karena ada nullable tidak bisa di map

//berarti ini kalo data ada
    if (chkdata != null) {

      notifyListeners();
      return Future<bool>.value(true);
    }

    return Future<bool>.value(false);
  }
}
