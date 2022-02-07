// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_ready/model/user.dart';
import 'package:edu_ready/pages/absensi/absensi_page.dart';
import 'package:edu_ready/pages/akademik/akademik_page.dart';
import 'package:edu_ready/pages/batasmateri/batas_materi_page.dart';
import 'package:edu_ready/pages/informasi/informasi_page.dart';
import 'package:edu_ready/pages/saldo/history_saldo_page.dart';
import 'package:edu_ready/pages/welcome/login_page.dart';
import 'package:edu_ready/providers/dashboard_provider.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/widgets/data_siswa_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const pageRoute = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool firstinitdashboard = true;
  bool statusPenilaian = false;
  String name = "";
  String statusErrorInit = "";

  String urlimage = "https://api-develop.ones-edu.com/api/get-stream?path=";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    initial();
  }

  Future<void> initial() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap =
        jsonDecode(preferences.getString('user') ?? "");
    var user = User.fromJson(userMap);

    setState(() {
      name = user.data!.user!.name!;
    });
  }

  @override
  void didChangeDependencies() {
    if (firstinitdashboard) {
      Provider.of<DashboardProvider>(context, listen: false)
          .getDataDashboard()
          .then((value) => () {})
          .catchError((onError) {
        setState(() {
          statusErrorInit = onError.toString();
        });

        showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Error"),
              content: Text("$onError"),
            );
          },
        );
        // print(onError);
      });
      firstinitdashboard = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity,
            AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
        child: Container(
          color: Color(0xFFFF8C00),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.fromLTRB(
                10, MediaQuery.of(context).padding.top + 6, 10, 6),
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "  Halo $name!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("Logout"),
                              content: Text("Apakah Anda Ingin Keluar?"),
                              actions: [
                                CupertinoButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                CupertinoButton(
                                    child: Text("Yes"),
                                    onPressed: () async {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.clear();
                                      Provider.of<DashboardProvider>(context,
                                              listen: false)
                                          .getDashboard
                                          .clear();

                                      Navigator.pushReplacementNamed(
                                          context, LoginPage.pageRoute);
                                    }),
                              ],
                            );
                          },
                        );
                      },
                      icon: Image.asset("assets/images/splash.png"))
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, value, child) {
          var data = value.getDashboard;

          return (data.isEmpty)
              ? (statusErrorInit == "Saldo Anda Tidak Cukup")
                  ? ListView(
                      children: [
                        ////////////////////bagian card  0 saldo///////////////////////////////
                        SizedBox(
                          child: Card(
                            color: Color(0xFFFFB74D),
                            margin: EdgeInsets.all(25),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(65),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        CupertinoIcons.money_dollar_circle_fill,
                                        color: Colors.white,
                                      ),
                                      Text("Informasi Saldo",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                  Text(
                                    "Rp.0 ",
                                    style: TextStyle(
                                        color: Color(0xFF0277BD),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  CupertinoIcons
                                                      .tray_arrow_down,
                                                  color: Color(0xFFEF5350),
                                                )),
                                          ),
                                          Text(
                                            "Top Up",
                                            style: TextStyle(
                                                color: Color(0xFFEF5350),
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  // Icons.history_edu,
                                                  CupertinoIcons.doc_append,
                                                  color: Color(0xFFEF5350),
                                                )),
                                            backgroundColor: Colors.white,
                                          ),
                                          Text(
                                            "History",
                                            style: TextStyle(
                                                color: Color(0xFFEF5350),
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        ////////////////////bagian No Data///////////////////////////////
                        Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: Image(
                                image:
                                    AssetImage("assets/images/ic_nodata.png"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  "Oops!! Tidak ada data.\nSilahkan Top Up terlebih dahulu",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Center(
                      child: CupertinoActivityIndicator(),
                    )
              : ListView(
                  children: [
                    ////////////////////bagian card saldo///////////////////////////////
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                            Color(0xFFFF8C00),
                            Color(0xFFFFA726),
                          ])),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  CupertinoIcons.money_dollar_circle_fill,
                                  color: Colors.white,
                                ),
                                Text("Informasi Saldo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                            Text(
                              "${CurrencyFormat.convertToIdr(int.parse(data[0].saldo!), 0)} ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CupertinoIcons.tray_arrow_down,
                                          color: Colors.white,
                                        )),
                                    Text(
                                      "Top Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, HistorySaldo.pageRoute);
                                        },
                                        icon: Icon(
                                          // Icons.history_edu,
                                          CupertinoIcons.doc_append,
                                          color: Colors.white,
                                        )),
                                    Text(
                                      "History",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    ////////////////////bagian card nama siswa///////////////////////////////
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: GestureDetector(
                        onTap: () {
                          if (data[0].showtanggungan!.isNotEmpty) {
                            final popup = BeautifulPopup(
                                context: context, template: TemplateTerm);
                            popup.show(
                                title: 'Detail Data Siswa',
                                content: DataSiswaPopup(data: data),
                                barrierDismissible: true);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: Card(
                              color: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: (data[0].showtanggungan!.isEmpty)
                                    ? Center(
                                        child: Text("Tidak ada data"),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(48),
                                              child: SizedBox(
                                                width: 65,
                                                height: 65,
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "$urlimage${data[0].showtanggungan![0].ppsiswa}",
                                                    placeholder: (context, url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(CupertinoIcons.profile_circled),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Nama   :   ${data[0].showtanggungan![0].namasiswa}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "NIS / NISN    :   ${data[0].showtanggungan![0].noinduk} /  ${data[0].showtanggungan![0].nisn}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Kelas   :   ${data[0].showtanggungan![0].nama} - ${data[0].showtanggungan![0].namatingkat}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                              )),
                        ),
                      ),
                    ),

                    ///////////////////////bagian card menu/////////////////////////////////////
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              child: Container(
                                                color: Color(0xFFFF8C00),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Image.asset(
                                                    "assets/images/absensi.png",
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(context, AkademikPage.pageRoute);
                                            },
                                          ),
                                          Text("Akademik")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            child: Container(
                                              color: Color(0xFFFF8C00),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                  "assets/images/absensi.png",
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text("Pembayaran")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              child: Container(
                                                color: Color(0xFFFF8C00),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10.0),
                                                  child: Image.asset(
                                                    "assets/images/informasi.png",
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          onTap: (){
                                            Navigator.pushNamed(context, InformasiPage.pageRoute);
                                          },
                                          ),
                                          Text("Informasi")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              child: Container(
                                                color: Color(0xFFFF8C00),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Image.asset(
                                                    "assets/images/absensi.png",
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  AbsensiPage.pageRoute);
                                            },
                                          ),
                                          Text("Absensi")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /////////////////////////bagian card tagihan/////////////////////////
                    Container(
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Total Tagihan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "lihat detail",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFA726)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.7),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Bulan Ini :\n ${CurrencyFormat.convertToIdr(int.parse(data[0].bDepanSekarang![0].blnSekarang ?? "0"), 0)}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFA726)),
                                    )),
                                    Expanded(
                                        child: Text(
                                      "Bulan Depan : \n ${CurrencyFormat.convertToIdr(int.parse(data[0].bDepanSekarang![0].blnDepan ?? "0"), 0)}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    ////////////////////////bagian card nilai umum/////////////////////////////
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Penilaian",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //switch_mode
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          "tabel",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                        Transform.scale(
                                            scale: 0.6,
                                            child: CupertinoSwitch(
                                              activeColor: Color(0xFFFFA726),
                                              trackColor: Color(0xFFFFA726),
                                              value: statusPenilaian,
                                              onChanged: (value) {
                                                setState(() {
                                                  statusPenilaian =
                                                      !statusPenilaian;
                                                });
                                              },
                                            )),
                                        Text(
                                          "grafik",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, AkademikPage.pageRoute);
                                      },
                                      child: Text(
                                        "lihat detail",
                                        style: TextStyle(
                                            color: Color(0xFFFFA726),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.7),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                ),
                                ////***cek data ini apakah null atau tidak****////
                                (data[0].nilaiDashboard!.isEmpty)
                                    ? Center(
                                        child: Text("Belum Ada Data"),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /////****switch tampilan berdasarkan pilihan user****///////////
                                          (statusPenilaian == false)
                                              ? Column(
                                                  children: [
                                                    ////header table////
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: const [
                                                          Flexible(
                                                              flex: 3,
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  "Mata Pelajaran",
                                                                ),
                                                              )),
                                                          Expanded(
                                                              child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              "Jenis Tes",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )),
                                                          Expanded(
                                                              child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              "Nilai",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                    ////body table////
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      child: ListView.builder(
                                                        itemCount: data[0]
                                                            .nilaiDashboard!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Flexible(
                                                                    flex: 3,
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child: Text(
                                                                          data[0]
                                                                              .nilaiDashboard![
                                                                                  index]
                                                                              .realnamapel,
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold)),
                                                                    )),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                      "${data[0].nilaiDashboard![index].tipe?.name}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                )),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    "${data[0].nilaiDashboard![index].nilainya}",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFFFA726),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                )),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Text(
                                                  "Oops, data grafik belum tersedia",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54),
                                                ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    //////////////////////bagian card absensi//////////////////////////
                    Container(
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                ////title///
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Absensi",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AbsensiPage.pageRoute);
                                      },
                                      child: Text(
                                        "lihat detail",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFA726)),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.grey,
                                  margin: EdgeInsets.fromLTRB(0, 7, 0, 14),
                                ),
                                ////**** Cek data kehadiran anak ada atau null****////
                                (data[0].absensi!.isEmpty)
                                    ? Center(
                                        child: Text("Belum ada data"),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text("Mata Pelajaran"),
                                              Text("Kehadiran"),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                            shrinkWrap: true,
                                            itemCount: data[0].absensi!.length,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    flex: 5,
                                                    child: Text(
                                                      data[0].absensi![index].namapel,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: CircularPercentIndicator(
                                                      radius: 50,
                                                      lineWidth: 7,
                                                      percent: double.parse(
                                                              data[0]
                                                                  .absensi![index]
                                                                  .kehadiran) /
                                                          double.parse(data[0]
                                                              .absensi![index]
                                                              .pertemuan),
                                                      backgroundColor:
                                                          Colors.grey.shade300,
                                                      circularStrokeCap:
                                                          CircularStrokeCap.round,
                                                      progressColor:
                                                          Color(0xFFFFA726),
                                                      backgroundWidth: 4,
                                                      center: Text(
                                                        "${(double.parse(data[0].absensi![index].kehadiran) / double.parse(data[0].absensi![index].pertemuan)) * 100} %",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    ////////////////////////bagian card nilai khusus/////////////////////////////
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ////title////
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Penilaian Khusus",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, AkademikPage.pageRoute,arguments: 1);
                                      },
                                      child: Text(
                                        "lihat detail",
                                        style: TextStyle(
                                            color: Color(0xFFFFA726),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black,
                                  width: double.infinity,
                                  height: 0.2,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                ),
                                ////***cek data ini apakah null atau tidak****////
                                (data[0].tahfis!.isEmpty)
                                    ? Center(
                                        child: Text("Belum Ada Data"),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ////header table////
                                          Row(
                                            children: const [
                                              Flexible(
                                                flex: 2,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text("Tanggal"),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 4,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text("Surah"),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    "Ayat",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ////body table////
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    DateFormat("d MMM yyyy",
                                                            "ID_id")
                                                        .format(data[0]
                                                            .tahfis![0]
                                                            .tgl),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                      data[0].tahfis![0].surah,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                      data[0].tahfis![0].ayat,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFFFFA726),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    DateFormat("d MMM yyyy")
                                                        .format(data[0]
                                                            .tahfis![1]
                                                            .tgl),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                      data[0].tahfis![1].surah,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    data[0].tahfis![1].ayat,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Color(0xFFFFA726),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    ////////////////////////bagian card batasan materi/////////////////////////////
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      width: double.infinity,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                ////title////
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Batasan Materi",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, MateriPage.pageRoute);
                                      },
                                      child: Text(
                                        "lihat detail",
                                        style: TextStyle(
                                            color: Color(0xFFFFA726),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 0.2,
                                  color: Colors.black,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                ),
                                ////****Cek body data ini apakah ada atau null****////
                                (data[0].batasmateri!.isEmpty)
                                    ? Center(
                                        child: Text("Belum Ada Data"),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: const [
                                              Flexible(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Text("Tanggal"),
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child:
                                                        Text("Mata Pelajaran"),
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                      "Materi",
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                data[0].batasmateri!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(vertical: 8),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Flexible(
                                                        flex: 2,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMM yyyy",
                                                                    'ID_id')
                                                                .format(data[
                                                                        0]
                                                                    .batasmateri![
                                                                        index]
                                                                    .tanggal),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                        flex: 3,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            data[0]
                                                                .batasmateri![
                                                                    index]
                                                                .namapel,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                        flex: 2,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            data[0]
                                                                .batasmateri![
                                                                    index]
                                                                .materi,
                                                            textAlign:
                                                                TextAlign
                                                                    .justify,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFFFFA726),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Developed by Ala Dev Team",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400),
                          ),
                        ))
                  ],
                );
        },
      ),
    );
  }
}
