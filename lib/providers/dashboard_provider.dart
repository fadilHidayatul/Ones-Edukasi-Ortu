import 'dart:convert';

import 'package:edu_ready/model/dashboard.dart';
import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider with ChangeNotifier {
  late final List<Dashboard> _list = [];
  List<Dashboard> get getDashboard => _list;

  String token = "";

  Future getDataDashboard() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    
    Map<String, dynamic> userMap = json.decode(sp.getString('user_domain') ?? "");
    var gettoken = UserDomain.fromJson(userMap);
    token = gettoken.data!.token!;

    String urlDomain = sp.getString('domain') ?? "";
    Uri urlMaster =
      Uri.parse("$urlDomain/api/v1/dashboardAndroFix");
    
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      var response = await http.get(urlMaster, headers: headers);

      if (response.statusCode>= 200 && response.statusCode < 300) {
        //add data to model dashboard
        _list.clear();
        var decodeData = json.decode(response.body);
        _list.add(Dashboard.fromJson(decodeData));
        
        notifyListeners();
      } else {
        throw(json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
