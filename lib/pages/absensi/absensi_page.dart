// ignore_for_file: prefer_const_constructors

import 'package:dropdown_search/dropdown_search.dart';
import 'package:edu_ready/model/absensi_harian.dart';
import 'package:edu_ready/providers/absensi_provider.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:edu_ready/widgets/no_data_widget.dart';
import 'package:edu_ready/widgets/no_internet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({Key? key}) : super(key: key);
  static const pageRoute = '/absensi';

  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  bool isInternet = true;
  bool loading = true;
  bool isharian = true;

  List<String> selected = ["Harian", "Bulanan"];

  final ScrollController _scrollController = ScrollController();
  List<Datum> dayList = [];
  int countDay = 0;
  int lastpage = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    _checkInternet();
  }

  @override
  void didChangeDependencies() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getmorelist();
      }
    });

    super.didChangeDependencies();
  }

  _checkInternet() {
    InternetConnectionChecker().hasConnection.then((value) {
      if (!mounted) return;
      setState(() {
        isInternet = value;
        if (value == true) _getfirstlist();
      });
    });
    InternetConnectionChecker().onStatusChange.listen((event) {
      if (!mounted) return;
      setState(() {
        if (event == InternetConnectionStatus.connected) {
          isInternet = true;
          _getfirstlist();
        } else if (event == InternetConnectionStatus.disconnected) {
          isInternet = false;
        }
      });
    });
  }

  _getfirstlist() {
    loading = true;
    dayList.clear();

    Provider.of<AbsensiProvider>(context, listen: false)
        .getabsensiharian()
        .then((value) {
      dayList = Provider.of<AbsensiProvider>(context, listen: false)
          .listabsensiharian[0]
          .data!;
      countDay = dayList.length;
      lastpage = Provider.of<AbsensiProvider>(context, listen: false).lastpage;

      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }).catchError((onError) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    });

    Provider.of<AbsensiProvider>(context, listen: false)
        .getabsensibulanan()
        .then((value) {
      () {
        if (!mounted) return;
        setState(() {
          loading = false;
        });
      };
    }).catchError((onError) {
      if (mounted) return;
      setState(() {
        loading = false;
      });
    });
  }

  _getmorelist() {
    // print("last page : $lastpage");
    // print("page yg diambil saat ini : ${page + 2}");
    var prov = Provider.of<AbsensiProvider>(context, listen: false);
    int page = 1;

    if (page < lastpage) {
      prov.loadMoreAbsensiHarian(page + 1).then((value) {
        var newData = prov.listabsensiharian[page].data;

        for (var element in newData!) {
          dayList.add(element);
        }
        page++;

        //setstate untuk notice tampilan kalo loadmore udh jalan
        if (!mounted) return;
        setState(() {});
      }).catchError((onError) {
        // print(onError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: Container(
          color: Colors.grey.shade200,
          child: CardAppBar(title: "Absensi Siswa"),
        ),
      ),
      body: !isInternet
          ? NoInternetWidget()
          : Container(
              color: Colors.grey.shade100,
              child: (loading)
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : Column(
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              //card filter pilih harian / bulanan
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                child: DropdownSearch(
                                  mode: Mode.BOTTOM_SHEET,
                                  showSelectedItems: true,
                                  items: selected,
                                  selectedItem: selected[0],
                                  maxHeight: 160,
                                  dropdownSearchDecoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF8C00),
                                          width: 0.7,
                                        ),
                                      ),
                                      labelText: "Filter absensi",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: Colors.white),
                                  popupTitle: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Pilih data absensi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  popupShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  onChanged: (value) {
                                    if (value == "Bulanan") {
                                      setState(() {
                                        isharian = false;
                                      });
                                    } else if (value == "Harian") {
                                      setState(() {
                                        isharian = true;
                                      });
                                    }
                                  },
                                ),
                              ),

                              ////*****tampilan berdasarkan pilihan user */
                              (isharian)
                                  ? Consumer<AbsensiProvider>(
                                      builder: (context, value, child) {
                                        return Expanded(
                                          ////*****cek list kosong atau tidak*/
                                          child: (value.listabsensiharian[0]
                                                  .data!.isEmpty)
                                              ? NoDataWidget(
                                                  message:
                                                      "Tidak ada data Absensi Harian",
                                                )
                                              : Column(
                                                  children: [
                                                    ////header tabel harian
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                          children: const [
                                                            Flexible(
                                                                flex: 2,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    "Tanggal",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                )),
                                                            Flexible(
                                                                flex: 3,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    " Mata Pelajaran",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                )),
                                                            Flexible(
                                                                flex: 2,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    "Kehadiran",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                )),
                                                          ]),
                                                    ),
                                                    ////listview builder harian
                                                    Expanded(
                                                        child: RefreshIndicator(
                                                      onRefresh: () async {
                                                        await Future.delayed(
                                                            Duration(
                                                                seconds: 2));
                                                        await _getfirstlist();
                                                      },
                                                      child: ListView.builder(
                                                        controller:
                                                            _scrollController,
                                                        itemCount:
                                                            dayList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        6),
                                                            child: Card(
                                                              elevation: 2,
                                                              color:
                                                                  Colors.white,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    Flexible(
                                                                        flex: 2,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 3),
                                                                          child:
                                                                              Text(DateFormat("d MMMM yyyy", "id_ID").format(dayList[index].tanggal)),
                                                                        )),
                                                                    Flexible(
                                                                        flex: 3,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 3),
                                                                          child:
                                                                              Text(dayList[index].namapel),
                                                                        )),
                                                                    Flexible(
                                                                        flex: 2,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 3),
                                                                          child:
                                                                              Text(
                                                                            "${dayList[index].ket}",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: (dayList[index].ket == "Hadir")
                                                                                  ? Color(0xFF0066FF)
                                                                                  : (dayList[index].ket == "Tidak Hadir")
                                                                                      ? Color(0xFFEF5350)
                                                                                      : (dayList[index].ket == "Izin")
                                                                                          ? Color(0xFFFFB800)
                                                                                          : Color(0xFFFFFFFF),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                        );
                                      },
                                    )
                                  : Consumer<AbsensiProvider>(
                                      builder: (context, value, child) {
                                        ///**** mengambil data bulan ke krna response di model bentuk map****/
                                        List<String> bulanKe = [];
                                        var data;
                                        if (value
                                            .listabsensibulanan.isNotEmpty) {
                                          value.listabsensibulanan[0].data!
                                              .entries
                                              .map((e) {
                                            bulanKe.add(e.key);
                                          }).toList();
                                          data =
                                              value.listabsensibulanan[0].data;
                                        }

                                        return Expanded(
                                            child:
                                                (value.listabsensibulanan
                                                        .isEmpty)
                                                    ? NoDataWidget(
                                                        message:
                                                            "Tidak ada data Absensi Bulanan",
                                                      )
                                                    : Column(
                                                        children: [
                                                          ////header tabel bulanan
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        26),
                                                            child: Row(
                                                              children: const [
                                                                Flexible(
                                                                    flex: 3,
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Text(
                                                                        "Bulan",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    )),
                                                                Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Text(
                                                                        "Hadir",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    )),
                                                                Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Text(
                                                                        "Izin",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    )),
                                                                Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Text(
                                                                        "Absen",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                          ////listview builder bulanan
                                                          Expanded(
                                                            child:
                                                                RefreshIndicator(
                                                              onRefresh:
                                                                  () async {
                                                                await Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            2));
                                                                await _getfirstlist();
                                                              },
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: data!
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4),
                                                                    child: Card(
                                                                      elevation:
                                                                          2,
                                                                      color: Colors
                                                                          .white,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                15,
                                                                            horizontal:
                                                                                15),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Flexible(
                                                                                flex: 3,
                                                                                child: SizedBox(
                                                                                  width: double.infinity,
                                                                                  child: Text(
                                                                                    DateFormat("MMMM", "ID_id").format(
                                                                                      DateTime(0, data[bulanKe[index]]!.bulan ?? 0),
                                                                                    ),
                                                                                    // "${ bulan}",
                                                                                  ),
                                                                                )),
                                                                            Flexible(
                                                                                flex: 1,
                                                                                child: SizedBox(
                                                                                  width: double.infinity,
                                                                                  child: Text(
                                                                                    "${data[bulanKe[index]]!.hadir}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(color: Color(0xFF0066FF)),
                                                                                  ),
                                                                                )),
                                                                            Flexible(
                                                                                flex: 1,
                                                                                child: SizedBox(
                                                                                  width: double.infinity,
                                                                                  child: Text(
                                                                                    "${data[bulanKe[index]]!.izin}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(color: Color(0xFFFFB800)),
                                                                                  ),
                                                                                )),
                                                                            Flexible(
                                                                                flex: 1,
                                                                                child: SizedBox(
                                                                                  width: double.infinity,
                                                                                  child: Text(
                                                                                    "${data[bulanKe[index]]!.cabut}",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(color: Color(0xFFEF5350)),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ));
                                      },
                                    )
                            ],
                          ),
                        ))
                      ],
                    ),
            ),
    );
  }
}
