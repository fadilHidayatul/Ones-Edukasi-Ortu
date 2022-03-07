// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edu_ready/model/pembayaran.dart';
import 'package:edu_ready/model/riwayat_pembayaran.dart';
import 'package:edu_ready/providers/pembayaran_provider.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/utils/string_cap.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:edu_ready/widgets/detail_pembayaran_popup.dart';
import 'package:edu_ready/widgets/no_data_widget.dart';
import 'package:edu_ready/widgets/no_internet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class PembayaranPage extends StatefulWidget {
  static const pageRoute = '/pembayaran';
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final ScrollController _controllerBayar = ScrollController();
  final ScrollController _controllerRiwayat = ScrollController();

  int groupvalue = 0;
  int tempTotal = 0;

  int lastpage = 0;
  int lastPageRiwayat = 0;

  bool firstloading = true;
  bool loadingconfirm = false;
  bool stoploadmore = false;
  bool isInternet = true;

  List<bool> isChecked = [];
  List<DatumBayar> allbayar = [];
  List<DatumBayar> selectedBayar = [];
  List<Map<String, dynamic>> sendToAPI = [];
  List<DatumRiwayatBayar> allriwayat = [];

  File? filebukti;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  @override
  void didChangeDependencies() {
    _controllerBayar.addListener(() {
      if (_controllerBayar.position.pixels ==
          _controllerBayar.position.maxScrollExtent) {
        _getmorepembayaran();
      }
    });

    _controllerRiwayat.addListener(() {
      if (_controllerRiwayat.position.pixels ==
          _controllerRiwayat.position.maxScrollExtent) {
        _getmoreriwayatpembayaran();
      } 
    });
    super.didChangeDependencies();
  }

  _checkInternet() {
    InternetConnectionChecker().hasConnection.then((value) {
      if (!mounted) return;
      setState(() {
        isInternet = value;
        if (value == true) {
          _getfirstpembayaran();
          _getfirstriwayatpembayaran();
        }
      });
    });

    InternetConnectionChecker().onStatusChange.listen((event) {
      if (!mounted) return;
      setState(() {
        if (event == InternetConnectionStatus.connected) {
          isInternet = true;
          _getfirstpembayaran();
          _getfirstriwayatpembayaran();
        } else if (event == InternetConnectionStatus.disconnected) {
          isInternet = false;
        }
      });
    });
  }

  _getfirstpembayaran() {
    var prov = Provider.of<PembayaranProvider>(context, listen: false);
    setState(() => firstloading = true);

    prov.getfirstpembayaran().then((value) {
      if (prov.listpembayaran.isNotEmpty) {
        allbayar.clear();
        selectedBayar.clear();
        sendToAPI.clear();
        tempTotal = 0;
        lastpage = prov.listpembayaran[0].lastPage!;

        for (var element in prov.listpembayaran[0].data!) {
          allbayar.add(element);
        }

        if (!mounted) return;
        setState(() => firstloading = false);
      }
      isChecked = List<bool>.filled(allbayar.length, false);
    }).catchError((onError) {
      if (!mounted) return;
      setState(() => firstloading = false);
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Error $onError"),
          content: Text("Terjadi error saat mengambil data pembayaran"),
        ),
      );
    });
  }

  _getmorepembayaran() {
    var prov = Provider.of<PembayaranProvider>(context, listen: false);
    int page = 1;

    if (page < lastpage) {
      prov.getmorepembayaran(page + 1).then((value) {
        var newdata = prov.listpembayaran[page].data!;

        for (var element in newdata) {
          allbayar.add(element);
        }
        page++;

        setState(() {});
      }).catchError((onError) {
        print("error load more");
      });
    }
  }

  _getfirstriwayatpembayaran() {
    var prov = Provider.of<PembayaranProvider>(context, listen: false);
    setState(() => firstloading = true);

    prov.getfirstriwayatpembayaran().then((value) {
      if (prov.listriwayatbayar.isNotEmpty) {
        allriwayat.clear();
        lastPageRiwayat = prov.listriwayatbayar[0].lastPage!;

        for (var element in prov.listriwayatbayar[0].data!) {
          allriwayat.add(element);
        }

        ///ini untuk ambil page 1+1
        // pageRiwayat++;

        if (!mounted) return;
        setState(() => firstloading = false);
      }
    }).catchError((onError) {
      if (!mounted) return;
      setState(() => firstloading = false);
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Error $onError"),
          content: Text("Terjadi error saat mengambil data riwayat pembayaran"),
        ),
      );
    });
  }

  _getmoreriwayatpembayaran() async {
    var prov = Provider.of<PembayaranProvider>(context, listen: false);
    int pageRiwayat = 1;

    if (pageRiwayat < lastPageRiwayat) {
      await prov.getmoreriwayatpembayaran(pageRiwayat + 1).then((value) {
        var newdata = prov.listriwayatbayar[pageRiwayat].data!;

        for (var element in newdata) {
          allriwayat.add(element);
        }
        pageRiwayat++;

        if (!mounted) return;
        setState(() {});
      }).catchError((onError) {
        // print("ERror saat page $pageRiwayat  =  $onError");
      });
      pageRiwayat++;
    } else {
      setState(() {
        stoploadmore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: CardAppBar(title: "Pembayaran"),
      ),
      body: !isInternet
          ? NoInternetWidget()
          : (firstloading)
              ? Center(child: CupertinoActivityIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ////////segmented slide pembayaran//////////
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                            child: CupertinoSlidingSegmentedControl(
                              children: {
                                0: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Pembayaran",
                                    style: TextStyle(
                                      color: (groupvalue == 0)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                1: Text(
                                  "Riwayat Pembayaran",
                                  style: TextStyle(
                                    color: (groupvalue == 1)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              },
                              onValueChanged: (value) {
                                setState(() {
                                  groupvalue = value as int;
                                });
                              },
                              groupValue: groupvalue,
                              thumbColor: Color(0xFFFF8C00).withOpacity(0.8),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    (groupvalue == 0)
                        ? (allbayar.isEmpty)
                            ? Expanded(
                                child: NoDataWidget(
                                  message: "Tidak ada data pembayaran",
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          await Future.delayed(
                                              Duration(seconds: 2));
                                          await _getfirstpembayaran();
                                        },
                                        child: ListView.builder(
                                          controller: _controllerBayar,
                                          shrinkWrap: true,
                                          itemCount: allbayar.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              color: Colors.white
                                                  .withOpacity(0.85),
                                              margin: EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 4, 4, 4),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: CheckboxListTile(
                                                          contentPadding:
                                                              EdgeInsets.all(0),
                                                          activeColor: Color(
                                                                  0xFFFF8C00)
                                                              .withOpacity(0.7),
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          value:
                                                              isChecked[index],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isChecked[index] =
                                                                  value!;

                                                              if (isChecked[
                                                                      index] ==
                                                                  true) {
                                                                selectedBayar.add(
                                                                    allbayar[
                                                                        index]);

                                                                tempTotal +=
                                                                    allbayar[
                                                                            index]
                                                                        .nominal!;

                                                                Map<String,
                                                                        dynamic>
                                                                    mapping = {
                                                                  "nominal": allbayar[
                                                                          index]
                                                                      .nominal,
                                                                  "idakun": allbayar[
                                                                          index]
                                                                      .alokasiid,
                                                                  "id": allbayar[
                                                                          index]
                                                                      .idsiswaa
                                                                };
                                                                sendToAPI.add(
                                                                    mapping);
                                                              } else {
                                                                selectedBayar.removeWhere((element) =>
                                                                    element
                                                                        .alokasiid ==
                                                                    allbayar[
                                                                            index]
                                                                        .alokasiid);

                                                                tempTotal -=
                                                                    allbayar[
                                                                            index]
                                                                        .nominal!;

                                                                sendToAPI.removeWhere(
                                                                    (element) =>
                                                                        element.containsValue(
                                                                            allbayar[index].nominal));
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 5,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              allbayar[index]
                                                                  .judul!,
                                                            ),
                                                            Text(
                                                              (allbayar[index]
                                                                          .tipeid ==
                                                                      1)
                                                                  ? "Semester : " +
                                                                      "${allbayar[index].tipesemester}"
                                                                          .capitalize()
                                                                  : (allbayar[index]
                                                                              .tipeid ==
                                                                          2)
                                                                      ? "Bulan : " +
                                                                          "${allbayar[index].nambul}"
                                                                              .capitalize()
                                                                      : "Uang Tahunan",
                                                              softWrap: true,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Text(
                                                          CurrencyFormat
                                                              .convertToIdr(
                                                            allbayar[index]
                                                                .nominal,
                                                            0,
                                                          ),
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    ////bagian card total
                                    Card(
                                      color: Colors.white.withOpacity(0.85),
                                      margin: EdgeInsets.fromLTRB(10, 2, 10, 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total Bayar : ${CurrencyFormat.convertToIdr(tempTotal, 0)}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: CupertinoButton(
                                                onPressed: () {
                                                  if (selectedBayar.isEmpty) {
                                                    showCupertinoDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text("Oops!"),
                                                          content: Text(
                                                            "Silahkan pilih pembayaran terlebih dahulu",
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    selectedBayar.sort((a, b) =>
                                                        a.alokasiid!.compareTo(
                                                            b.alokasiid!));

                                                    AwesomeDialog(
                                                      context: context,
                                                      animType:
                                                          AnimType.BOTTOMSLIDE,
                                                      dialogType:
                                                          DialogType.NO_HEADER,
                                                      showCloseIcon: true,
                                                      body: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: const [
                                                              Text(
                                                                "Ringkasan Pembayaran",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 0.3,
                                                            color: Colors.black,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                              vertical: 4,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.4,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  selectedBayar
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          8,
                                                                          5,
                                                                          8),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Flexible(
                                                                        flex: 2,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Text(
                                                                            selectedBayar[index].judul!,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Text(
                                                                            CurrencyFormat.convertToIdr(selectedBayar[index].nominal,
                                                                                0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                flex: 3,
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          5),
                                                                  child: Text(
                                                                    "Jumlah Pembayaran",
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          5,
                                                                          5),
                                                                  child: Text(
                                                                    CurrencyFormat
                                                                        .convertToIdr(
                                                                            tempTotal,
                                                                            0),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.7),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 0.3,
                                                            color: Colors.black,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                              vertical: 4,
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              "Transfer ke",
                                                              style: TextStyle(
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              "Rekening Sekolah\na/n",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 6),
                                                            child: Center(
                                                              child: Text(
                                                                  selectedBayar[
                                                                          0]
                                                                      .deskripsi!),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 6),
                                                            child: Center(
                                                              child: Text(
                                                                selectedBayar[0]
                                                                    .norek!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                              vertical: 12,
                                                            ),
                                                            child:
                                                                CupertinoButton(
                                                              minSize: 0,
                                                              color: Color(
                                                                      0xFFFF8C00)
                                                                  .withOpacity(
                                                                      0.7),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                vertical: 12,
                                                                horizontal: 24,
                                                              ),
                                                              child: (loadingconfirm)
                                                                  ? CupertinoActivityIndicator()
                                                                  : Text(
                                                                      "KONFIRMASI",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                              onPressed:
                                                                  (loadingconfirm)
                                                                      ? null
                                                                      : () {
                                                                          setState(
                                                                              () {
                                                                            loadingconfirm =
                                                                                true;
                                                                          });

                                                                          Provider.of<PembayaranProvider>(context, listen: false)
                                                                              .sendRingkasanPembayaran(sendToAPI)
                                                                              .then((value) {
                                                                            setState(() {
                                                                              loadingconfirm = false;
                                                                            });
                                                                            _getfirstpembayaran();
                                                                            Navigator.pop(context);
                                                                            showCupertinoDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                Timer(Duration(seconds: 3), () => Navigator.pop(context));
                                                                                return CupertinoAlertDialog(
                                                                                  content: Text("Pembayaran berhasil dilakukan"),
                                                                                );
                                                                              },
                                                                            );
                                                                          }).catchError((onError) {
                                                                            showCupertinoDialog(
                                                                              context: context,
                                                                              builder: (context) => CupertinoAlertDialog(
                                                                                title: Text("Error"),
                                                                                content: Text(onError),
                                                                              ),
                                                                            );
                                                                          });
                                                                        },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ).show();
                                                  }
                                                },
                                                child: Text(
                                                  "BAYAR",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 16,
                                                ),
                                                minSize: 0,
                                                color: Color(0xFFFF8C00)
                                                    .withOpacity(0.7),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : (allriwayat.isEmpty)
                            ? Expanded(
                                child: NoDataWidget(
                                  message: "TIdak ada riwayat pembayaran",
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 9,
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Text("Siswa : "),
                                          Text(
                                            allriwayat[0].namaSiswa!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFF8C00),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          await Future.delayed(
                                              Duration(seconds: 2));
                                          await _getfirstriwayatpembayaran();
                                        },
                                        child: ListView.builder(
                                          controller: _controllerRiwayat,
                                          shrinkWrap: false,
                                          itemCount: allriwayat.length,
                                          itemBuilder: (context, index) {
                                            ///untuk pengecekan load more dibawah list
                                            var tot = index + 1;
                                            if (allriwayat.length >= 10) {
                                              if (!stoploadmore) {
                                                if (tot == allriwayat.length) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4),
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  );
                                                }
                                              }
                                            }
                                            return GestureDetector(
                                              child: Card(
                                                margin: EdgeInsets.fromLTRB(
                                                    8, 2, 8, 12),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 12, 3, 14),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "No Kwitansi :",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                              Divider(
                                                                thickness: 0,
                                                                color: Colors
                                                                    .transparent,
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                allriwayat[
                                                                        index]
                                                                    .nokwitansi!,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 3,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            allriwayat[index]
                                                                        .status ==
                                                                    "butuh konfirmasi"
                                                                ? "Menunggu Konfirmasi"
                                                                : allriwayat[index]
                                                                            .status ==
                                                                        null
                                                                    ? "Ditolak"
                                                                    : "Lunas",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: allriwayat[
                                                                              index]
                                                                          .status ==
                                                                      "butuh konfirmasi"
                                                                  ? Color(0xFFFF8C00)
                                                                      .withOpacity(
                                                                          0.7)
                                                                  : allriwayat[index]
                                                                              .status ==
                                                                          null
                                                                      ? Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.7)
                                                                      : Colors
                                                                          .blue
                                                                          .withOpacity(
                                                                              0.7),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                Provider.of<PembayaranProvider>(
                                                        context,
                                                        listen: false)
                                                    .getdetailriwayat(
                                                        allriwayat[index]
                                                            .nokwitansi!)
                                                    .then((value) {
                                                  var detail = Provider.of<
                                                      PembayaranProvider>(
                                                    context,
                                                    listen: false,
                                                  ).listdetailriwayat;

                                                  if (detail != []) {
                                                    String status = "";
                                                    status = allriwayat[index]
                                                            .status ??
                                                        "";
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return PopUpDetail(
                                                            detail: detail,
                                                            status: status,
                                                            nokwitansi:
                                                                allriwayat[
                                                                        index]
                                                                    .nokwitansi!,
                                                          );
                                                        });
                                                  }
                                                }).catchError((onError) {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: Text("Error"),
                                                        content: Text(
                                                            onError.toString()),
                                                      );
                                                    },
                                                  );
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _controllerBayar.dispose();
    _controllerRiwayat.dispose();
    super.dispose();
  }
}
