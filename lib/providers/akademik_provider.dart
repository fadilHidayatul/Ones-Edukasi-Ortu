import 'dart:convert';

import 'package:edu_ready/model/akademik_umum.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AkademikProvider with ChangeNotifier {
  final List<AkademikUmum> _list1 = [];
  List<AkademikUmum> get listakaumum => _list1;

  String urlUmum =
      "https://api-develop.ones-edu.com/api/v1/list-nilai-akademik-anak";
  int lastpage = 0;

  Future<void> getfirstakademikumum() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getUser = User.fromJson(user);
    var token = getUser.data!.token;
    var idortu = getUser.data!.user!.idnya;

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$urlUmum?idortu=$idortu&page=1");

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        _list1.clear();

        var decodeData = jsonDecode(response.body);
        _list1.add(AkademikUmum.fromJson(decodeData));
        lastpage = listakaumum[0].lastPage!;

        notifyListeners();
      } else {
        print("${response.statusCode} akademik umum 1 gagal");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getmoreakademikumum(page) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getUser = User.fromJson(user);
    var token = getUser.data!.token;
    var idortu = getUser.data!.user!.idnya;

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$urlUmum?idortu=$idortu&page=$page");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        _list1.add(AkademikUmum.fromJson(decodeData));

        notifyListeners();
      } else {
        print("gagal ambil page ke $page");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
