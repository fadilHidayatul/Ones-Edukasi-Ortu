import 'dart:convert';

import 'package:edu_ready/model/absensi_bulanan.dart';
import 'package:edu_ready/model/absensi_harian.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AbsensiProvider with ChangeNotifier {
  final List<AbsensiHarian> _listharian = [];
  List<AbsensiHarian> get listabsensiharian => _listharian;
  final List<AbsensiBulanan> _listbulanan = [];
  List<AbsensiBulanan> get listabsensibulanan => _listbulanan;

  String urlHarian = "https://api-develop.ones-edu.com/api/v1/list-absen-anak";
  String urlBulanan =
      "https://api-develop.ones-edu.com/api/v1/list-absen-anak-andro";

  String token = "";
  String idOrtu = "";

  int lastpage = 0;

  Future<void> getabsensiharian() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getUser = User.fromJson(user);
    token = getUser.data!.token!;
    idOrtu = getUser.data!.user!.idnya!;

    var url = Uri.parse("$urlHarian?idortu=$idOrtu&page=1");
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      _listharian.clear();
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        _listharian.add(AbsensiHarian.fromJson(decodeData));
        lastpage = listabsensiharian[0].lastPage;

        // print("berhasil ambil data harian page 1");
        notifyListeners();
      } else {
        // print("${response.statusCode} error ambil data 1" );
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreAbsensiHarian(page) async {
    var url = Uri.parse("$urlHarian?idortu=$idOrtu&page=$page");
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        // print("berhasil ambil data page ke $page ");
        var decodeData = json.decode(response.body);
        _listharian.add(AbsensiHarian.fromJson(decodeData));

        notifyListeners();
      } else {
        // print(json.decode(response.body)["message"]);
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getabsensibulanan() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var userdata = User.fromJson(user);
    String? tokenb = userdata.data!.token;
    String? idortub = userdata.data!.user!.idnya;

    var url = Uri.parse("$urlBulanan?idortu=$idortub");
    Map<String, String> headers = {"Authorization": "Bearer $tokenb"};

    try {
      _listbulanan.clear();
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);

        if (decodeData["data"].toString().contains("[]")) {
        }else{
          _listbulanan.add(AbsensiBulanan.fromJson(decodeData));
          notifyListeners();
        }

        // print("berhasil ambil data absen bulanan");
        // print("${ json.decode(response.body)["data"] }");

      } else {
        // print("${response.statusCode} error ambil data bulanan" );
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
