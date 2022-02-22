// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/pages/pembayaran/pembayaran_page.dart';
import 'package:edu_ready/pages/welcome/home_page.dart';
import 'package:edu_ready/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const pageRoute = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Flexible(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35)),
                          child: Container(
                            color: Color(0xFFFFA726),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/splash.png"),
                                  width: 150,
                                  height: 150,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "Login Page",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, bottom: 10),
                                    child: Text(
                                      "Silahkan login untuk masuk ke aplikasi",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            children: [
                              Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Card(
                                      margin: EdgeInsets.all(25),
                                      color: Color(0xFFFFA726),
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(25),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CupertinoTextField(
                                              controller: txtUsername,
                                              maxLines: 1,
                                              textInputAction:
                                                  TextInputAction.next,
                                              prefix: Icon(
                                                Icons.person,
                                                color: Color(0xFFFFA726),
                                              ),
                                              placeholder: "Username",
                                              clearButtonMode:
                                                  OverlayVisibilityMode.editing,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              // decoration: InputDecoration(
                                              //     labelText: "Username",
                                              //     prefixIcon:
                                              //         Icon(Icons.person)),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            CupertinoTextField(
                                              controller: txtPassword,
                                              maxLines: 1,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              obscureText: true,
                                              obscuringCharacter: '*',
                                              placeholder: "Password",
                                              clearButtonMode:
                                                  OverlayVisibilityMode.editing,
                                              prefix: Icon(
                                                Icons.password,
                                                color: Color(0xFFFFA726),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: CupertinoButton(
                                          onPressed: () {
                                            authProv
                                                .loginUser(txtUsername.text,
                                                    txtPassword.text)
                                                .then(
                                                  (value) => Navigator
                                                      .pushReplacement(context, CupertinoPageRoute(builder: (context) {
                                                        return HomePage();
                                                      },))
                                                )
                                                .catchError((onerror) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text("Error : $onerror"),
                                              ));
                                            });
                                          },
                                          child: Text(
                                            "Login Me",
                                          ),
                                          color: Color(0xFFFFA726),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // style: ElevatedButton.styleFrom(
                                          //   shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(16)
                                          //   ),
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: 60,
                                          //         vertical: 18)),
                                        )),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                          "Belum punya akun?\nSilahkan Hubungi bagian administrasi",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24, bottom: 6),
                                      child: Text(
                                        "Developed by Ala Dev Team",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade300),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
