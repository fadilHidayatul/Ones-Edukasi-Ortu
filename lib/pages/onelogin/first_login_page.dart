// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/pages/onelogin/register_page.dart';
import 'package:edu_ready/providers/first_login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edu_ready/pages/onelogin/list_domain_page.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import 'list_domain_page.dart';

class FirstLoginPage extends StatefulWidget {
  const FirstLoginPage({Key? key}) : super(key: key);

  @override
  _FirstLoginPageState createState() => _FirstLoginPageState();
}

class _FirstLoginPageState extends State<FirstLoginPage> {
  bool obscure = true;
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GoogleTranslator translator = GoogleTranslator();

  void startMovePage(FirstLoginProvider prov) async {
    if (!mounted) return;
    setState(() => isLoading = true);

    // await Future.delayed(Duration(seconds: 3));

    prov
        .doFirstLogin(emailController.text, passwordController.text)
        .then((value) {
      if (!mounted) return;
      setState(() => isLoading = false);

      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          return ListDomainPage();
        },
      ));
    }).catchError((onError) async {
      if (!mounted) return;
      setState(() => isLoading = false);

      final String err = onError.toString().replaceAll(RegExp(r'<br/>'), '\n');
      //  var translation = await translator.translate(err,from: 'en', to: 'id');

      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Error"),
            content: Text(err),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<FirstLoginProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Colors.blue.shade900,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/images/one_text.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8, left: 12),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    CupertinoTextField(
                      controller: emailController,
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      placeholder: "Email",
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.at,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    CupertinoTextField(
                      controller: passwordController,
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      placeholder: "Password",
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      obscureText: obscure,
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.lock,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      suffix: IconButton(
                        onPressed: () {
                          if (!mounted) return;
                          setState(() => obscure = !obscure);
                        },
                        icon: obscure
                            ? Icon(CupertinoIcons.eye_slash)
                            : Icon(CupertinoIcons.eye),
                        iconSize: 22,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        onPressed: isLoading
                            ? () {}
                            : () {
                                startMovePage(prov);
                              },
                        child: isLoading
                            ? CupertinoActivityIndicator()
                            : Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        color: Color(0xFFFFA726),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(-0.9, 0),
                              child: Image.asset(
                                "assets/images/google.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Login dengan Google",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Baru di One Login?  "),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, CupertinoPageRoute(
                                builder: (context) {
                                  return RegisterPage();
                                },
                              ));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Color(0xFFFFA726),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          'assets/images/one_text.png',
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          "ⓒ 2022 One DevTim | ALA Team",
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
