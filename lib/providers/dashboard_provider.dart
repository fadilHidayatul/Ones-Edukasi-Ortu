import 'dart:convert';

import 'package:edu_ready/main.dart';
import 'package:edu_ready/model/dashboard.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider with ChangeNotifier {
  late final List<Dashboard> _list = [];
  List<Dashboard> get getDashboard => _list;

  Uri urlMaster =
      Uri.parse("${MyApp.domain}/api/v1/dashboardAndroFix");
  // Uri urlMaster =
  //     Uri.parse("https://spas.ones-edu.com/getting/api/v1/dashboardAndroFix");
  String token = "";


  Future getDataDashboard() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = json.decode(sp.getString('user') ?? "");
    var gettoken = User.fromJson(userMap);
    token = gettoken.data!.token!;
    
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      var response = await http.get(urlMaster, headers: headers);

      if (response.statusCode == 200) {
        //add data to model dashboard
        var decodeData = json.decode(response.body);
        _list.add(Dashboard.fromJson(decodeData));
        
        notifyListeners();
        // print(getDashboard[0].absensi[1].namaguru);
      } else {
        // print(json.decode(response.body));
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
