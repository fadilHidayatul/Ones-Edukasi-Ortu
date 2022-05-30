// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/pages/onelogin/list_domain_page.dart';
import 'package:edu_ready/providers/first_login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstnamecontrol = TextEditingController();
  TextEditingController lastnamecontrol = TextEditingController();
  TextEditingController phonecontrol = TextEditingController();
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passcontrol = TextEditingController();

  GoogleTranslator translator = GoogleTranslator();

  bool agree = false;
  bool loading = false;

  void starmovepage(FirstLoginProvider prov) {
    if (!mounted) return;
    setState(() => loading = true);

    prov
        .doRegisterUser(agree.toString(), emailcontrol.text,
            firstnamecontrol.text, lastnamecontrol.text, passcontrol.text)
        .then((value) {
      if (!mounted) return;
      setState(() => loading = false);

      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
        return ListDomainPage();
      }));
    }).catchError((onError) async {
      if (!mounted) return;
      setState(() => loading = false);

      final String err = onError.toString().replaceAll(RegExp(r'<br/>'), '\n');
      // var translation = await translator.translate(err,from: 'en', to: 'id');

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
    firstnamecontrol.dispose();
    lastnamecontrol.dispose();
    phonecontrol.dispose();
    emailcontrol.dispose();
    passcontrol.dispose();
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
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 35),
                      child: Image.asset(
                        "assets/images/one_text.png",
                        width: 125,
                        height: 125,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 12, left: 12),
                      child: Text(
                        "Bring new account for connected to us. Make your activity easier and simple",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    CupertinoTextField(
                      controller: firstnamecontrol,
                      keyboardAppearance: Brightness.light,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      placeholder: "First Name",
                      keyboardType: TextInputType.name,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.person,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    CupertinoTextField(
                      controller: lastnamecontrol,
                      keyboardAppearance: Brightness.light,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      placeholder: "Last Name",
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.person_2,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoTextField(
                      controller: phonecontrol,
                      keyboardAppearance: Brightness.light,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      placeholder: "Phone Number (optional)",
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.phone,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CupertinoTextField(
                      controller: emailcontrol,
                      keyboardAppearance: Brightness.light,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
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
                    SizedBox(height: 10),
                    CupertinoTextField(
                      controller: passcontrol,
                      keyboardAppearance: Brightness.light,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      obscureText: true,
                      placeholder: "Password",
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.lock,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = !agree;
                            });
                          },
                        ),
                        Expanded(child: Text("I agree with Privacy Policy"))
                      ],
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        child: loading
                            ? CupertinoActivityIndicator()
                            : Text(
                                "Register",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                        onPressed: loading
                            ? () {}
                            : () {
                                agree
                                    ? starmovepage(prov)
                                    : showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text("Warning"),
                                            content: Text(
                                                "Harap ceklis Privacy Policy agar dapat melanjutkan"),
                                          );
                                        },
                                      );
                              },
                        color: Color(0xFFFFA726),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sudah ada One Login?  "),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Color(0xFFFFA726),
                                  fontWeight: FontWeight.bold),
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
