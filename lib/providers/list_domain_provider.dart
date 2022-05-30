import 'dart:convert';

import 'package:edu_ready/model/domain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListDomainProvider with ChangeNotifier {
  final List<Domain> _list = [];
  List<Domain> get listDomain => _list;

  String urlDomain = "https://project-ala.net/get/api/domains";
  String urlVerify =
      "https://project-ala.net/get/api/auth/email/verification-notify";

  Future<void> getAllDomain(String accessToken) async {
    Uri url = Uri.parse(urlDomain);

    Map<String, String> headers = {"Authorization": "Bearer $accessToken"};

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _list.clear();
        var decodeData = json.decode(response.body);
        _list.add(Domain.fromJson(decodeData));

        notifyListeners();
      } else {
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyEmailUser(String accesToken) async {
    Uri url = Uri.parse(urlVerify);

    Map<String, String> headers = {
      "Authorization": "Bearer $accesToken",
      "Accept": "application/json",
    };

    try {
      var response = await http.post(url, headers: headers);
      if (response.statusCode >=200 && response.statusCode < 300) {
        notifyListeners();
      } else {
        // throw ("sc : ${response.statusCode} & msg: ${json.decode(response.body)}");
        throw(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
