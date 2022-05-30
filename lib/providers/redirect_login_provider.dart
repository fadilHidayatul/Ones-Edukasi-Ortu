import 'dart:convert';

import 'package:edu_ready/model/user_login.dart';
import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RedirectProvider with ChangeNotifier {
  String urlGenerate = "https://project-ala.net/get/api/domain/token/";

  String accessToken = "";

  String domain = "";
  int key = 0;
  String token = "";
  int expires = 0;
  String signature = "";

  String tokenDomain = "";

  Future<void> generateLink(String keyDomain) async {
    Uri url = Uri.parse("$urlGenerate$keyDomain/generate");

    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getUser = UserLogin.fromJson(user);
    accessToken = getUser.data!.accessToken!;

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Accept": "application/json",
    };

    try {
      var response = await http.post(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var decodeData = json.decode(response.body);
        var data = decodeData["data"];

        domain = data["domain"];
        key = data["key"];
        token = data["token"];
        expires = data["expires"];
        signature = data["signature"];

        notifyListeners();
      } else {
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> redirectLink() async {
    Uri url = Uri.parse("$domain/$key/$token?expire=$expires&sign=$signature");

    Map<String, String> headers = {"Authorization": "Bearer $accessToken"};

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        var decodeData = json.decode(response.body);

        tokenDomain = decodeData["data"]["token"];

        String userDomain = json.encode(UserDomain.fromJson(decodeData));
        sp.setString('user_domain', userDomain);
        sp.setString('domain',domain);

        notifyListeners();
      } else {
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> detailUserLogin() async {
    Uri url = Uri.parse("$domain/api/v1/details");

    Map<String, String> headers = {"Authorization": "Bearer $tokenDomain"};

    try {
      var response = await http.post(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var decodeData = json.decode(response.body);

        notifyListeners();
        return decodeData["data"]["id_role"];
      } else {
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
