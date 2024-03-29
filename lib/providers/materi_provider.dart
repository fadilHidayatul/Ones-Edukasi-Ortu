import 'dart:convert';

import 'package:edu_ready/model/mapel.dart';
import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MateriProvider with ChangeNotifier {
  List<Mapel> listmp = [];
  List<Mapel> get listmapel => listmp;

  String urlmaster = "";
  int lastPageMP = 0;

  Future<void> getfirstmapel() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getUser = UserDomain.fromJson(user);
    var token = getUser.data!.token;

    String urlDomain = sp.getString('domain') ?? "";
    urlmaster = "$urlDomain/api/v1/list-batas-materi-Anakku-Detail";
    Uri url = Uri.parse("$urlmaster?page=1");

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        listmp.clear();

        final decodeData = jsonDecode(response.body);
        listmp.add(Mapel.fromJson(decodeData));
        lastPageMP = listmapel[0].lastPage!;

        // print(listmapel[0].data);
        notifyListeners();
      } else {
        print("Error provider ${response.statusCode}");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getmoremapel(page) async {
    Uri url = Uri.parse("$urlmaster?page=$page");

    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getUser = UserDomain.fromJson(user);
    var token = getUser.data!.token;

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        listmp.add(Mapel.fromJson(decodeData));

        // print("$listmapel");
        notifyListeners();
        // print("berhasil ambil data page ke $page");
      } else {
        print("error ${response.statusCode}");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
