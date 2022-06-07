// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_ready/model/dashboard.dart';
import 'package:edu_ready/model/user_redirect.dart';
import 'package:edu_ready/pages/absensi/absensi_page.dart';
import 'package:edu_ready/pages/akademik/akademik_page.dart';
import 'package:edu_ready/pages/batasmateri/batas_materi_page.dart';
import 'package:edu_ready/pages/informasi/informasi_page.dart';
import 'package:edu_ready/pages/saldo/history_saldo_page.dart';
import 'package:edu_ready/pages/saldo/top_up_page.dart';
import 'package:edu_ready/providers/dashboard_provider.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/widgets/no_internet_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageSiswa extends StatefulWidget {
  const HomePageSiswa({Key? key}) : super(key: key);
  static const pageRoute = '/home';

  @override
  State<HomePageSiswa> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageSiswa> {
  bool firstinitdashboard = true;
  bool statusPenilaian = false;
  bool isInternet = true;

  String name = "";
  String statusErrorInit = "";

  String urlimage = "https://api-develop.ones-edu.com/api/get-stream?path=";

  late List<BarChartGroupData> showBarChartGroup;
  List<NilaiDashboardGrafik> grafik = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    cekInternet();
    initial();
  }

  void cekInternet() {
    InternetConnectionChecker().hasConnection.then((value) {
      setState(() {
        if (value == true) {
          isInternet = true;
          getfirstdatadashboard();
        }
      });
    });

    InternetConnectionChecker().onStatusChange.listen((event) {
      setState(() {
        switch (event) {
          case InternetConnectionStatus.connected:
            isInternet = true;
            getfirstdatadashboard();
            break;
          case InternetConnectionStatus.disconnected:
            isInternet = false;
            break;
        }
      });
    });
  }

  Future initial() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap =
        json.decode(sp.getString('user_domain') ?? "");
    var user = UserDomain.fromJson(userMap);

    if (!mounted) return;
    setState(() {
      name = user.data!.user!.name!;
    });
  }

  getfirstdatadashboard() {
    Provider.of<DashboardProvider>(context, listen: false)
        .getDataDashboard()
        .then((value) => setState(() {}))
        .catchError((onError) {
      setState(() {
        statusErrorInit = onError.toString();
      });

      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Error naide"),
            content: Text("$onError"),
          );
        },
      );
    });
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barsSpace: 8,
      showingTooltipIndicators: [0, 1],
      barRods: [
        BarChartRodData(
          y: (y1 == 0) ? 1 : y1,
          colors: [Color(0xFFFFA80F)],
          width: 12,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        BarChartRodData(
          y: (y2 == 0) ? 1 : y2,
          colors: [Color(0xFFFE8116)],
          width: 12,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      ],
    );
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
                                    child: Text("Yes"), onPressed: () {}),
                              ],
                            );
                          },
                        );
                      },
                      icon: Image.asset("assets/images/one_text.png"))
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, value, child) {
          var data = value.getDashboard;
          List<BarChartGroupData> items = [];
          int x = 0;
          grafik.clear();

          if (data.isNotEmpty) {
            for (var element in data[0].nilaiDashboardGrafik!) {
              items.add(
                makeGroupData(
                  x,
                  double.parse(element.mid.toString()),
                  double.parse(element.uas.toString()),
                ),
              );
              grafik.add(element); //untuk ambil nampel saja
              x++;
            }

            showBarChartGroup = items;
          }
          // print(isInternet);
          return (!isInternet)
              ? NoInternetWidget()
              : (data.isEmpty)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(
                                            CupertinoIcons
                                                .money_dollar_circle_fill,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                    image: AssetImage(
                                        "assets/images/ic_nodata.png"),
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
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 2));
                        // await getfirstdatadashboard();
                      },
                      child: ListView(
                        children: [
                          ////////////////////bagian card saldo///////////////////////////////
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/bg_saldo.png"),
                                    fit: BoxFit.cover)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Row(
                                    children: [
                                      //row saldo//
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: const [
                                                  Icon(
                                                    CupertinoIcons
                                                        .money_dollar_circle_fill,
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
                                                "${CurrencyFormat.convertToIdr(data[0].saldo!, 0)} ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      //row top up//
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    TopUpPage(),
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .tray_arrow_down,
                                                        color: Colors.white,
                                                      )),
                                                  Text(
                                                    "Top Up",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (context) =>
                                                                HistorySaldo(),
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        // Icons.history_edu,
                                                        CupertinoIcons
                                                            .doc_append,
                                                        color: Colors.white,
                                                      )),
                                                  Text(
                                                    "History",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          ///row menu atas///
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              akademik(context),
                                              absensi(context),
                                              informasi(context),
                                              materi(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          ///row menu bawah///
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              video(),
                                              tugas(),
                                              latihan(),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45),
                                                      child: Container(
                                                        color:
                                                            Color(0xFFFF8C00),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Image.asset(
                                                            "assets/images/ic_lainnya.png",
                                                            color: Colors.white,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) {
                                                          return DraggableScrollableSheet(
                                                            expand: false,
                                                            initialChildSize:
                                                                0.6,
                                                            minChildSize: 0,
                                                            maxChildSize: 0.96,
                                                            builder: (context,
                                                                    scrollController) =>
                                                                Container(
                                                              color:
                                                                  Colors.white,
                                                              child:
                                                                  SingleChildScrollView(
                                                                controller:
                                                                    scrollController,
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              10),
                                                                      child: Icon(
                                                                          CupertinoIcons
                                                                              .line_horizontal_3),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              6),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          akademik(
                                                                              context),
                                                                          absensi(
                                                                              context),
                                                                          informasi(
                                                                              context),
                                                                          materi(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              6),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          video(),
                                                                          tugas(),
                                                                          latihan(),
                                                                          pustaka()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              6),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          market(),
                                                                          donasi()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  Text("Lainnya")
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          ////////////////////////bagian card nilai umum/////////////////////////////
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  child: Row(
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
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  AkademikPage(),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: Color(0xFFFFA726),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 0.5,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: ////***cek data ini apakah null atau tidak****////
                                      Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /////****switch tampilan berdasarkan pilihan user****///////////
                                      (statusPenilaian == false)
                                          ? (data[0].nilaiDashboard == null)
                                              ? Center(
                                                  child: Text("Belum Ada Data"),
                                                )
                                              : Column(
                                                  children: [
                                                    ////header table////
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
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
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.7),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                    ),
                                                    ////body table////
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
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
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        10),
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
                                                                      "${data[0].nilaiDashboard![index].tipe}",
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
                                                                    data[0].nilaiDashboard![index].nilainya ==
                                                                            null
                                                                        ? "0"
                                                                        : "${data[0].nilaiDashboard![index].nilainya}",
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
                                          : (data[0].nilaiDashboardGrafik ==
                                                  null)
                                              ? Center(
                                                  child: Text("Belum Ada Data"),
                                                )
                                              : Column(
                                                  children: [
                                                    ////////grafik/////////
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Container(
                                                        width:
                                                            grafik.length * 70,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.62,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                2, 25, 0, 0),
                                                        child: BarChart(
                                                          BarChartData(
                                                            maxY: 100,
                                                            titlesData:
                                                                FlTitlesData(
                                                              show: true,
                                                              rightTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    false,
                                                              ),
                                                              topTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    false,
                                                              ),
                                                              leftTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    true,
                                                                reservedSize:
                                                                    30,
                                                                interval: 10,
                                                              ),
                                                              bottomTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    true,
                                                                getTitles:
                                                                    (value) {
                                                                  int i = value
                                                                      .toInt();
                                                                  return grafik[
                                                                          i]
                                                                      .namapel;
                                                                },
                                                              ),
                                                            ),
                                                            gridData:
                                                                FlGridData(
                                                              show: true,
                                                              drawHorizontalLine:
                                                                  true,
                                                              drawVerticalLine:
                                                                  false,
                                                            ),
                                                            borderData:
                                                                FlBorderData(
                                                              show: true,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black38,
                                                                ),
                                                              ),
                                                            ),
                                                            barTouchData:
                                                                BarTouchData(
                                                              enabled: false,
                                                              touchTooltipData:
                                                                  BarTouchTooltipData(
                                                                tooltipBgColor:
                                                                    Colors
                                                                        .transparent,
                                                                direction:
                                                                    TooltipDirection
                                                                        .top,
                                                                tooltipMargin:
                                                                    0,
                                                                tooltipPadding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                getTooltipItem:
                                                                    (
                                                                  group,
                                                                  groupIndex,
                                                                  rod,
                                                                  rodIndex,
                                                                ) {
                                                                  // print(group.x); // print(rod.y);
                                                                  int nilai = rod
                                                                      .y
                                                                      .toInt();
                                                                  return BarTooltipItem(
                                                                    (nilai == 1)
                                                                        ? "0"
                                                                        : nilai
                                                                            .toString(),
                                                                    TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            barGroups:
                                                                showBarChartGroup,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //////keterangan grafik///////////
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 6),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 10,
                                                                    height: 10,
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                6),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xFFFFA80F),
                                                                        borderRadius:
                                                                            BorderRadius.circular(4)),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                        "Ujian Tengah Semester"),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 10,
                                                                  height: 10,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              6),
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFFFE8116),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                ),
                                                                Flexible(
                                                                    child: Text(
                                                                        "Ujian Akhir Semester"))
                                                              ],
                                                            ))
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //////////////////////bagian card absensi//////////////////////////
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: Row(
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
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  AbsensiPage(),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: Color(0xFFFFA726),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  color: Colors.white,
                                  elevation: 0.5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        ////**** Cek data kehadiran anak ada atau null****////
                                        (data[0].absensi!.isEmpty)
                                            ? Center(
                                                child: Text("Belum ada data"),
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: const [
                                                      Text("Mata Pelajaran"),
                                                      Text("Kehadiran"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return Divider();
                                                    },
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        data[0].absensi!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            flex: 5,
                                                            child: Text(
                                                              data[0]
                                                                  .absensi![
                                                                      index]
                                                                  .namapel,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child:
                                                                CircularPercentIndicator(
                                                              radius: 50,
                                                              lineWidth: 7,
                                                              percent: double.parse(data[
                                                                          0]
                                                                      .absensi![
                                                                          index]
                                                                      .kehadiran) /
                                                                  double.parse(data[
                                                                          0]
                                                                      .absensi![
                                                                          index]
                                                                      .pertemuan),
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade300,
                                                              circularStrokeCap:
                                                                  CircularStrokeCap
                                                                      .round,
                                                              progressColor:
                                                                  Color(
                                                                      0xFFFFA726),
                                                              backgroundWidth:
                                                                  4,
                                                              center: Text(
                                                                "${(double.parse(data[0].absensi![index].kehadiran) / double.parse(data[0].absensi![index].pertemuan)) * 100} %",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                              ],
                            ),
                          ),

                          ////////////////////////bagian card nilai khusus/////////////////////////////
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Penilaian Khusus",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AkademikPage.pageRoute,
                                            arguments: 1,
                                          );
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  AkademikPage(),
                                              settings: RouteSettings(
                                                arguments: 1,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: Color(0xFFFFA726),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  color: Colors.white,
                                  elevation: 0.5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
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
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              Text("Tanggal"),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text("Surah"),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            "Ayat",
                                                            textAlign: TextAlign
                                                                .center,
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
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMM yyyy",
                                                                    "ID_id")
                                                                .format(data[0]
                                                                    .tahfis![0]
                                                                    .tgl),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 5,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                              data[0]
                                                                  .tahfis![0]
                                                                  .surah,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 2,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                              data[0]
                                                                  .tahfis![0]
                                                                  .ayat,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Color(
                                                                    0xFFFFA726),
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
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMM yyyy")
                                                                .format(data[0]
                                                                    .tahfis![1]
                                                                    .tgl),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 5,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                              data[0]
                                                                  .tahfis![1]
                                                                  .surah,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 2,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            data[0]
                                                                .tahfis![1]
                                                                .ayat,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0xFFFFA726),
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
                              ],
                            ),
                          ),

                          ////////////////////////bagian card batasan materi/////////////////////////////
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: Row(
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
                                          // Navigator.pushNamed(
                                          //     context, MateriPage.pageRoute);
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  MateriPage(),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: Color(0xFFFFA726),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  color: Colors.white,
                                  elevation: 0.5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        ////****Cek body data ini apakah ada atau null****////
                                        (data[0].batasmateri!.isEmpty)
                                            ? Center(
                                                child: Text("Belum Ada Data"),
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: const [
                                                      Flexible(
                                                          flex: 2,
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                Text("Tanggal"),
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
                                                                "Mata Pelajaran"),
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
                                                              "Materi",
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: data[0]
                                                        .batasmateri!
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Flexible(
                                                                flex: 2,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    DateFormat(
                                                                            "d MMM yyyy",
                                                                            'ID_id')
                                                                        .format(data[0]
                                                                            .batasmateri![index]
                                                                            .tanggal),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Flexible(
                                                                flex: 3,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    data[0]
                                                                        .batasmateri![
                                                                            index]
                                                                        .namapel,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Flexible(
                                                                flex: 2,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    data[0]
                                                                        .batasmateri![
                                                                            index]
                                                                        .materi,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style:
                                                                        TextStyle(
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
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Developed by ONE Dev Team | ALA Group",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
        },
      ),
    );
  }

  Column latihan() {
    return Column(
      children: [
        GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/ic_latihan.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          onTap: () {},
        ),
        Text("Latihan")
      ],
    );
  }

  Column tugas() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/ic_tugas.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
        Text("Tugas")
      ],
    );
  }

  Column video() {
    return Column(
      children: [
        GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/ic_video.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          onTap: () {},
        ),
        Text("Video")
      ],
    );
  }

  Column materi() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/ic_materi.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
        Text("Materi")
      ],
    );
  }

  Column informasi(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/informasi.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => InformasiPage(),
              ),
            );
          },
        ),
        Text("Informasi")
      ],
    );
  }

  Column absensi(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/absensi.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AbsensiPage(),
              ),
            );
          },
        ),
        Text("Absensi")
      ],
    );
  }

  Column akademik(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              color: Color(0xFFFF8C00),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/akademik.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AkademikPage(),
              ),
            );
          },
        ),
        Text("Akademik")
      ],
    );
  }

  Column pustaka() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Badge(
            badgeContent: Text(
              "Segera Hadir",
              style: TextStyle(fontSize: 8),
            ),
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(8),
            position: BadgePosition.topEnd(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                color: Colors.grey.shade600,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    child: Image.asset(
                      "assets/images/one_text.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text("Pustaka")
      ],
    );
  }

  Column market() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Badge(
            badgeContent: Text(
              "Segera Hadir",
              style: TextStyle(fontSize: 8),
            ),
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(8),
            position: BadgePosition.topEnd(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                color: Colors.grey.shade600,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    child: Image.asset(
                      "assets/images/one_text.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text("Market")
      ],
    );
  }

  Column donasi() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Badge(
            badgeContent: Text(
              "Segera Hadir",
              style: TextStyle(fontSize: 8),
            ),
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(8),
            position: BadgePosition.topEnd(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                color: Colors.grey.shade600,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    child: Image.asset(
                      "assets/images/ic_donasi.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text("Donasi")
      ],
    );
  }
}
