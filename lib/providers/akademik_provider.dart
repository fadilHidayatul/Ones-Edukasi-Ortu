import 'dart:convert';

import 'package:edu_ready/model/akademik_khusus.dart';
import 'package:edu_ready/model/akademik_umum.dart';
import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AkademikProvider with ChangeNotifier {
  final List<AkademikUmum> _list1 = [];
  List<AkademikUmum> get listakaumum => _list1;
  final List<AkademikKhusus> _list2 = [];
  List<AkademikKhusus> get listakakhusus => _list2;

  String urlUmum = "";
  int lastpage = 0;

  String urlKhusus = "";
  int lastpagekhusus = 0;

  String token = "";
  String idortu = "";

  Future<void> getfirstakademikumum() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getUser = UserDomain.fromJson(user);
    var token = getUser.data!.token;
    var idortu = getUser.data!.user!.idnya;

    String urlDomain = sp.getString('domain') ?? "";
    urlUmum = "$urlDomain/api/v1/list-nilai-akademik-anak";
    Uri url = Uri.parse("$urlUmum?idortu=$idortu&page=1");

    Map<String, String> headers = {"Authorization": "Bearer $token"};

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
    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getUser = UserDomain.fromJson(user);
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
        print("gagal ambil page umum ke $page");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getfirstakademikkhusus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getuser = UserDomain.fromJson(user);
    token = getuser.data!.token!;
    idortu = getuser.data!.user!.idnya!;

    String urlDomain = sp.getString('domain') ?? "";
    urlKhusus = "$urlDomain/api/v1/list-nilai-tahfis-anak";
    Uri url = Uri.parse("$urlKhusus?idortu=$idortu&page=1");

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        _list2.clear();

        var decodeData = json.decode(response.body);
        _list2.add(AkademikKhusus.fromJson(decodeData));
        lastpagekhusus = listakakhusus[0].lastPage!;

        notifyListeners();
      } else {
        print("Data khusus gagal didapatkan");
        throw ("Error : ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> moreakademikkhusus(page) async {
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$urlKhusus?idortu=$idortu&page=$page");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        _list2.add(AkademikKhusus.fromJson(decodeData));

        notifyListeners();
      } else {
        print("Error ambil page ke$page ${response.statusCode}");
        throw ("Error : ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
