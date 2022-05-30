// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/pages/onelogin/app_page.dart';
import 'package:edu_ready/pages/welcome/home_page.dart';
import 'package:edu_ready/providers/redirect_login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../welcome/home_page_siswa.dart';

class RedirectLoginPage extends StatefulWidget {
  final String keyDomain;
  const RedirectLoginPage({Key? key, required this.keyDomain})
      : super(key: key);

  @override
  _RedirectLoginPageState createState() => _RedirectLoginPageState();
}

class _RedirectLoginPageState extends State<RedirectLoginPage> {
  @override
  void didChangeDependencies() {
    String keyDomain = widget.keyDomain;
    generateDomain(keyDomain);
    super.didChangeDependencies();
  }

  void generateDomain([String? keyDomain]) {
    var prov = Provider.of<RedirectProvider>(context, listen: false);

    prov.generateLink(keyDomain!).then((value) {
      // print("berhasil generate");
      redirectDomain();
    }).catchError((onError) {
      // print("OnError generate: $onError");
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Gagal ketika redirect ke aplikasi harap pilih client lagi",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 6,
      );
    });
  }

  void redirectDomain() {
    var prov = Provider.of<RedirectProvider>(context, listen: false);
    prov.redirectLink().then((value) {
      //tambahkan pengecekan user global dengan cek domain sp
      getDetailUser();
    }).catchError((onError) {
      // print("$onError");
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Gagal redirect ke aplikasi harap ulang lagi",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 6,
      );
    });
  }

  void getDetailUser() {
    var prov = Provider.of<RedirectProvider>(context, listen: false);

    prov.detailUserLogin().then((value) {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          if (value == "3") {
            print("ini id role orang tua");
            return HomePage() ;
          }else if (value == "8") {
            print("ini id role siswa");
            return HomePageSiswa();
          }

          return AppPage(); //default
        },
      ));
    }).catchError((onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Detail user gagal, harap ulangi lagi",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 6,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).padding.top + 10, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Redirecting . . . ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Lottie.asset("assets/lottie/ic_redirect.json"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Harap tunggu, anda sedang dialihkan ke halaman aplikasi",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
