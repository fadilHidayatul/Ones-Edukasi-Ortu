import 'dart:convert';

import 'package:edu_ready/model/history_saldo.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistorySaldoProvider with ChangeNotifier {
  final List<HistorySaldo> list = [];
  List<HistorySaldo> get listHistory => list;

  String url =
      "https://api-develop.ones-edu.com/api/v1/top-up/HistoryCall?page=";
  String token = "";

  int page = 1;
  int lastpage = 0;

  Future<void> getDataHistoryTopup() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getUser = User.fromJson(user);
    token = getUser.data!.token!;

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response =
          await http.get(Uri.parse("$url$page"), headers: headers);
      if (response.statusCode == 200) {
        list.clear();
        var decodeData = json.decode(response.body);
        list.add(HistorySaldo.fromJson(decodeData));

        lastpage = listHistory[0].lastPage;
        
        // print("${listHistory[1].currentPage}");
        notifyListeners();
      } else {
        // print(response.body);
        throw (jsonEncode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreData(page) async {
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response =
          await http.get(Uri.parse("$url$page"), headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        list.add(HistorySaldo.fromJson(decodeData));
        // print("load more success");

        notifyListeners();  
      } else {
        // print("load more error");
        throw (jsonEncode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }


}
