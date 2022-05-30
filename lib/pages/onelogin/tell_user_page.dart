// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TellUserEmailPage extends StatefulWidget {
  const TellUserEmailPage({Key? key}) : super(key: key);

  @override
  _TellUserEmailPageState createState() => _TellUserEmailPageState();
}

class _TellUserEmailPageState extends State<TellUserEmailPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).padding.top,
              color: Color(0xFFFFA726),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 30, left: 16),
                      child: Text(
                        "Konfirmasi Email",
                        style:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 50),
                      child: Image.asset(
                        "assets/images/email_verifikasi.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                      child: Text(
                        "Verifikasi sudah dikirimkan ke email yang anda daftarkan",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Harap buka dan cek email agar anda dapat melakukan verifikasi dan lanjut menggunakan aplikasi One Login",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(15, 80, 15, 15),
                      child: CupertinoButton(
                        child: Text(
                          "Selesai",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Color(0xFFFFA726),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
