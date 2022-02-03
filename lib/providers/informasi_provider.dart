import 'dart:convert';

import 'package:edu_ready/model/informasi.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class InformasiProvider with ChangeNotifier {
  final List<Informasi> _list = [];
  List<Informasi> get listInformasi => _list;
  
  String masterURL = "https://api-develop.ones-edu.com/api/v1/list-informasi-umum-andro";
  String singleUrl = "https://api-develop.ones-edu.com/api/v1/informasi/informasi-detail";

  var token;

  Future<void> getalllistinformasi() async {
    Uri url = Uri.parse(masterURL);

    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String,dynamic> user = json.decode(sp.getString('user') ?? "");
    var getUser = User.fromJson(user);
    token = getUser.data!.token;

    Map<String,String> headers = {
      "Authorization" : "Bearer $token",
    };

    try {
      var response = await http.get(url,headers: headers);
      if (response.statusCode == 200) {
        _list.clear();
        var decodeData = json.decode(response.body);
        _list.add(Informasi.fromJson(decodeData));
        notifyListeners();

        
      } else {
        print("${ response.statusCode } tidak bisa ambil informasi");
        throw(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }

  }
  
  Future<void> getinformasibyid(id) async {
    Uri url = Uri.parse("$singleUrl/$id");

    Map<String,String> headers = {
      "Authorization" : "Bearer $token"
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print("detail informasi berhasil dikirim");
        
      }else{
        print("detail informasi gagal dikirim");
        throw(response.statusCode);
      }

    } catch (e) {
      rethrow;
    }

  }
}