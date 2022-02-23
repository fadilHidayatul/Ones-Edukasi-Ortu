// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:edu_ready/pages/welcome/home_page.dart';
import 'package:edu_ready/pages/welcome/login_page.dart';
import 'package:edu_ready/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const pageRoute = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUser() async {
    bool authData = await Provider.of<AuthProvider>(context, listen: false).haveLogged();

    if (authData) {
      Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) {
                  return HomePage();
                },
              ),
            );
      
    }else{
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
      Duration(seconds: 3),
      () => checkUser()
    );
  }

  @override
  Widget build(BuildContext context) {
    final allWidth = MediaQuery.of(context).size.width;
    final allHeight = MediaQuery.of(context).size.height;
    final bodyHeight = allHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SizedBox(
        width: allWidth,
        height: bodyHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 100),
                width: allWidth * 0.4,
                height: bodyHeight,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image(
                      image: AssetImage("assets/images/splash.png"),
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(
                      height: double.maxFinite,
                      child: Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Aplikasi Tes",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "untuk pendidikan",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: CupertinoActivityIndicator())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
