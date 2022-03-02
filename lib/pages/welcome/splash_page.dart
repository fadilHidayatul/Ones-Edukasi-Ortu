// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:edu_ready/pages/welcome/home_page.dart';
import 'package:edu_ready/pages/welcome/login_page.dart';
import 'package:edu_ready/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const pageRoute = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUser() async {
    bool authData =
        await Provider.of<AuthProvider>(context, listen: false).haveLogged();

    if (authData) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return LoginPage();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => checkUser()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFFFF8C00).withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(52),
                  bottomRight: Radius.circular(52),
                ),
                
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFFFFA726),
                    Color(0xFFFF8C00),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 0.2),
                    child: Image.asset(
                      "assets/images/one_text.png",
                      width: 145,
                      height: 145,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.5),
                    child: Text(
                      "Ones Edukasi",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.65),
                    child: Text(
                      "Orang Tua",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/lottie/ic_splash.json"),
                  ),
                  Align(
                    alignment: Alignment(0, 0.95),
                    child: Text(
                      "versi 0.0.1",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
