import 'dart:convert';
import 'dart:io';

import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopupProvider with ChangeNotifier {
  senddatatopup(int uang, File imageBukti) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> user = json.decode(sp.getString('user_domain') ?? "");
    var getuser = UserDomain.fromJson(user);
    var token = getuser.data!.token;
    var idortu = getuser.data!.user!.idnya;

    String urlDomain = sp.getString('domain') ?? "";
    String masterurl = "$urlDomain/api/v1/top-up/pitimasuak";
    Uri url = Uri.parse("$masterurl?idortu=$idortu&pitih=$uang");

    Map<String, String> headers = {"Authentication": "Bearer $token"};

    Stream<List<int>> stream = http.ByteStream(imageBukti.openRead()).cast();
    var length = await imageBukti.length();

    var request = http.MultipartRequest("POST", url);
    var multipartfilesign = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageBukti.path),
    );

    request.headers.addAll(headers);
    request.files.add(multipartfilesign);

    //add parameter jika ada
    // request.fields['keypost'] = '12';

    //sending data
    var response = await request.send();
    // print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((event) {
      // print(event);
    });
  }
}
