import 'dart:convert';

import 'package:edu_ready/model/pembayaran.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PembayaranProvider with ChangeNotifier {
  final List<Pembayaran> _listbayar = [];
  List<Pembayaran> get listpembayaran => _listbayar;

  String urlmaster =
      "https://api-develop.ones-edu.com/api/v1/alokasi-pembayaran-search-gani";
  String urlPost =
      "https://api-develop.ones-edu.com/api/v1/pembayaran-siswa/storeAndro";
  String token = "";
  String idortu = "";

  Future<void> getfirstpembayaran() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getuser = User.fromJson(user);
    token = getuser.data!.token!;
    idortu = getuser.data!.user!.idnya!;

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$urlmaster?idortu=$idortu&page=1");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        _listbayar.clear();

        var decodeData = json.decode(response.body);
        _listbayar.add(Pembayaran.fromJson(decodeData));

        // print(decodeData);

        notifyListeners();
      } else {
        print("Error ${response.statusCode}");
        throw ("Error ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getmorepembayaran(int page) async {
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Uri url = Uri.parse("$urlmaster?idortu=$idortu&page=$page");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        _listbayar.add(Pembayaran.fromJson(decodeData));

        notifyListeners();
      } else {
        // print("Error ${response.body}");
        throw ("Error ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendRingkasanPembayaran(
      List<Map<String, dynamic>> arrayItem) async {
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    Uri url = Uri.parse(urlPost);
    var body = {"items": arrayItem};

    try {
      var response =
          await http.post(url, body: json.encode(body), headers: headers);
      if (response.statusCode>= 200 && response.statusCode < 300) {
        // print("Berhasil kirim data ke API");

        notifyListeners();
      } else {
        // print("${json.decode(response.body)["message"]}");
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
