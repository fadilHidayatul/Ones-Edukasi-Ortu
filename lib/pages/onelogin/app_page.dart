// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:edu_ready/model/user_redirect.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPage extends StatefulWidget {
  const AppPage({ Key? key }) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  String tokenDomain = "";

  @override
  Future<void> initState() async {
    super.initState();
    SharedPreferences sp = await SharedPreferences.getInstance(); 
    Map<String, String> user = json.decode(sp.getString('user_domain') ?? "");
    var userData = UserDomain.fromJson(user);
    tokenDomain = userData.data!.token!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Text("basic redirect"),
          Text(tokenDomain)
        ],
      ),
      
    );
  }
}