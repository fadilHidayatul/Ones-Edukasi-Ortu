// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:edu_ready/pages/onelogin/first_login_page.dart';
import 'package:edu_ready/pages/onelogin/list_domain_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    checkLogin();
  }

  checkLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var chkdata = sp.getString('user');

    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context, CupertinoPageRoute(
              builder: (context) {
                if (chkdata != null) {
                  return ListDomainPage();
                } else {
                  return FirstLoginPage();
                }
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade400, Colors.orange.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
              opacity: _animation,
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/images/one_text.png"),
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
