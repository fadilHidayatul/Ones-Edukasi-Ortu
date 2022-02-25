import 'dart:convert';
import 'dart:io';

import 'package:edu_ready/main.dart';
import 'package:edu_ready/model/detail_riwayat_pembayaran.dart';
import 'package:edu_ready/model/pembayaran.dart';
import 'package:edu_ready/model/riwayat_pembayaran.dart';
import 'package:edu_ready/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PembayaranProvider with ChangeNotifier {
  final List<Pembayaran> _listbayar = [];
  List<Pembayaran> get listpembayaran => _listbayar;

  final List<RiwayatPembayaran> _listriwayat = [];
  List<RiwayatPembayaran> get listriwayatbayar => _listriwayat;

  final List<DetailRiwayatPembayaran> _listdetail = [];
  List<DetailRiwayatPembayaran> get listdetailriwayat => _listdetail;

  String urlmaster = "${MyApp.domain}/api/v1/alokasi-pembayaran-search-gani";
  String urlPost = "${MyApp.domain}/api/v1/pembayaran-siswa/storeAndro";
  String urlriwayat = "${MyApp.domain}/api/v1/riwayat-pembayaran-andro";
  String urlriwayatdetail = "${MyApp.domain}/api/v1/detail-pembayaran-andro";
  String urlPostBukti = "${MyApp.domain}/api/v1/pembayaran-siswa/storeBukti";
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

        notifyListeners();
      } else {
        print("Error ${response.statusCode}");
        // throw (json.decode(response.body)["message"]);
        throw (response.statusCode);
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

  Future<void> sendRingkasanPembayaran( List<Map<String, dynamic>> arrayItem) async {
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    Uri url = Uri.parse(urlPost);
    var body = {"items": arrayItem};

    try {
      var response =
          await http.post(url, body: json.encode(body), headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
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

  Future<void> getfirstriwayatpembayaran() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(sp.getString('user') ?? "");
    var getuser = User.fromJson(user);
    token = getuser.data!.token!;
    idortu = getuser.data!.user!.idnya!;

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$urlriwayat?ortu=$idortu&page=1");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _listriwayat.clear();

        var decodeData = json.decode(response.body);
        _listriwayat.add(RiwayatPembayaran.fromJson(decodeData));

        notifyListeners();
      } else {
        // print("${json.decode(response.body)["message"]}");
        throw(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getmoreriwayatpembayaran(int page) async {
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url = Uri.parse("$urlriwayat?ortu=$idortu&page=$page");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var decodeData = json.decode(response.body);
        _listriwayat.add(RiwayatPembayaran.fromJson(decodeData));

        notifyListeners();
      } else {
        print("${json.decode(response.body)["message"]}");
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getdetailriwayat(String nokwitansi) async {
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    Uri url =
        Uri.parse("$urlriwayatdetail?ortu=$idortu&nokwitansi=$nokwitansi");

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _listdetail.clear();
        var decodeData = json.decode(response.body);
        _listdetail.add(DetailRiwayatPembayaran.fromJson(decodeData));

        // print(listdetailriwayat[0].data![0]);
        notifyListeners();
      } else {
        print("Error => ${json.decode(response.body)["message"]}");
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendRiwayatBuktiPembayaran(File buktiBayarRiwayat, String nokwitansi) async {
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    Uri url = Uri.parse(urlPostBukti);

    Stream<List<int>> stream =
        http.ByteStream(buktiBayarRiwayat.openRead().cast());
    var length = await buktiBayarRiwayat.length();

    var request = http.MultipartRequest("POST", url);
    var multipartfilesign = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(buktiBayarRiwayat.path),
    );

    request.headers.addAll(headers);
    request.files.add(multipartfilesign);
    request.fields['nokwitansi'] = nokwitansi;

    try {
      var responseStream = await request.send();

      var response = await http.Response.fromStream(responseStream);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
      } else {
        throw ("${json.decode(response.body)["message"]}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
