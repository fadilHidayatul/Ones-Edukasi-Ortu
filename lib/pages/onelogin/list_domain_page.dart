// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_ready/model/domain.dart';
import 'package:edu_ready/model/user_login.dart';
import 'package:edu_ready/pages/onelogin/redirect_login_page.dart';
import 'package:edu_ready/pages/onelogin/tell_user_page.dart';
import 'package:edu_ready/providers/list_domain_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_login_page.dart';

class ListDomainPage extends StatefulWidget {
  const ListDomainPage({Key? key}) : super(key: key);

  @override
  _ListDomainPageState createState() => _ListDomainPageState();
}

class _ListDomainPageState extends State<ListDomainPage> {
  List<Color> colors = [
    Colors.deepOrangeAccent.shade100, // **
    Colors.orangeAccent.shade100, //##
    Colors.deepOrange.shade100, //*
    Colors.orange.shade100, //#
  ];

  List<DomainElement> allDomain = [];

  String email = "";
  String nama = "";
  String accessToken = "";
  bool isVerified = false;
  bool loadingVerified = false;

  @override
  void initState() {
    super.initState();
    initial();
  }

  Future<void> initial() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> userJSON = jsonDecode(sp.getString('user') ?? "");
    var userData = UserLogin.fromJson(userJSON);

    if (!mounted) return;
    setState(() {
      nama =
          "${userData.data!.detail!.firstName} ${userData.data!.detail!.lastName}";
      email = userData.data!.detail!.email!;
      isVerified = userData.data!.detail!.isVerified!;
      accessToken = userData.data!.accessToken!;
    });

    if (!isVerified) {
      AwesomeDialog(
        context: context,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              Text(
                "Email anda belum terverifikasi, harap verifikasi e-mail untuk dapat melanjutkan",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                child: CupertinoButton(
                  child: Text(
                    "Verifikasi E-mail",
                    style: TextStyle(color: Colors.white),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  minSize: 0,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  color: Color(0xFFFFA726),
                  onPressed: () {
                    //panggil API verify
                    Provider.of<ListDomainProvider>(context, listen: false)
                        .verifyEmailUser(accessToken)
                        .then((value) {
                      Navigator.pop(context);
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) {
                          return TellUserEmailPage();
                        },
                      ));
                    }).catchError((onError) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            content: Text(onError.toString()),
                          );
                        },
                      );
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ).show();
    }

    getListDomain();
  }

  void getListDomain() {
    var prov = Provider.of<ListDomainProvider>(context, listen: false);

    prov.getAllDomain(accessToken).then((value) {
      allDomain.clear();
      for (var element in prov.listDomain[0].domains!) {
        allDomain.add(element);
      }

      if (!mounted) return;
      setState(() {});
    }).catchError((onError) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Error"),
            content: Text("$onError"),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime preBackspace = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(preBackspace);
        final cantExit = timegap >= Duration(seconds: 2);

        preBackspace = DateTime.now();
        if (cantExit) {
          Fluttertoast.showToast(
              msg: "Tekan lagi untuk keluar", toastLength: Toast.LENGTH_SHORT);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.fromLTRB(
              5, MediaQuery.of(context).padding.top + 5, 5, 0),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/frame_profil.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      child: Text(
                                        "Apakah anda ingin logout?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                            "Pastikan semua telah selesai. Terima kasih telah mengakses One Login")),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      width: double.infinity,
                                      child: CupertinoButton(
                                        child: Text(
                                          "Log Out",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        minSize: 0,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        color:
                                            Color(0xFFFFA726).withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                        onPressed: () async {
                                          SharedPreferences sp =
                                              await SharedPreferences
                                                  .getInstance();
                                          sp.remove('user');

                                          Navigator.pop(context);

                                          Navigator.pushReplacement(context,
                                              CupertinoPageRoute(
                                            builder: (context) {
                                              return FirstLoginPage();
                                            },
                                          ));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: SizedBox(
                            width: 85,
                            height: 85,
                            child: Image.asset("assets/images/one_text.png")),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "User",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                nama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                email,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 4),
                child: Text(
                  "List Domain",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              ///bagian list domain///
              allDomain.isEmpty
                  ? Expanded(
                      child: Center(
                      child: Text(
                        "Belum ada domain untuk anda",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ))
                  : Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: allDomain.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.BOTTOMSLIDE,
                                title: "Pilihan Domain",
                                customHeader: Image.asset(
                                  "assets/images/one_text.png",
                                  width: 75,
                                  height: 75,
                                ),
                                body: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: Text(
                                    "Anda memilih client ${allDomain[index].client} pada aplikasi ${allDomain[index].application!.name}. \n\n\nKlik OK untuk lanjut ke link  ${allDomain[index].domain}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                btnOk: CupertinoButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green.shade300,
                                  minSize: 0,
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  onPressed: () {
                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return RedirectLoginPage(
                                            keyDomain: allDomain[index].key!,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                btnCancel: CupertinoButton(
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.red.shade300,
                                  minSize: 0,
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                dismissOnTouchOutside: false,
                              ).show();
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (index % 4 == 0)
                                    ? colors[0]
                                    : (index % 4 == 1)
                                        ? colors[1]
                                        : (index % 4 == 2)
                                            ? colors[2]
                                            : colors[3],
                                // image: DecorationImage(
                                //     image: NetworkImage(
                                //         "https://project-ala.net${allDomain[index].application!.bannerPath!}"),
                                //     fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Card(
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            index % 2 == 0
                                                ? Icons.architecture
                                                : Icons.animation_outlined,
                                            color: (index % 4 == 0)
                                                ? colors[0]
                                                : (index % 4 == 1)
                                                    ? colors[1]
                                                    : (index % 4 == 2)
                                                        ? colors[2]
                                                        : colors[3],
                                          ),
                                        ),
                                      ),
                                      Icon(CupertinoIcons.arrow_right_circle)
                                    ],
                                  ),
                                  Text(
                                    "${allDomain[index].application!.name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    "Client : ${allDomain[index].client}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${allDomain[index].application!.descriptions}",
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
