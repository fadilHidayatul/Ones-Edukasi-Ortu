import 'dart:convert';
import 'dart:io';

import 'package:edu_ready/model/informasi.dart';
import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformasiProvider with ChangeNotifier {
  final List<Informasi> _list = [];
  List<Informasi> get listInformasi => _list;

  String token = "";
  String singleUrl = "";

  Future<void> getalllistinformasi() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getUser = UserDomain.fromJson(user);
    token = getUser.data!.token!;

    String urlDomain = sp.getString('domain') ?? "";
    String masterURL = "$urlDomain/api/v1/list-informasi-umum-andro";
    singleUrl = "$urlDomain/api/v1/informasi/informasi-detail";
    Uri url = Uri.parse(masterURL);

    Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        _list.clear();
        var decodeData = json.decode(response.body);
        _list.add(Informasi.fromJson(decodeData));
        notifyListeners();
      } else {
        print("${response.statusCode} tidak bisa ambil informasi");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getinformasibyid(id) async {
    Uri url = Uri.parse("$singleUrl/$id");

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print("detail informasi berhasil dikirim");
      } else {
        print("detail informasi gagal dikirim");
        throw (response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<File> getfilepdf(String urlpdf, int index) async {
    try {
      Uri url = Uri.parse(urlpdf);
      var response = await http.get(url);
      var bytes = response.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/mypdfonline$index.pdf");
      File urlFile = await file.writeAsBytes(bytes);

      return urlFile;
    } catch (e) {
      throw Exception("Error open pdf file");
    }
  }
}
