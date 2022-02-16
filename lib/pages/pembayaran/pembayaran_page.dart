// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edu_ready/model/pembayaran.dart';
import 'package:edu_ready/providers/pembayaran_provider.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/utils/string_cap.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PembayaranPage extends StatefulWidget {
  static const pageRoute = '/pembayaran';
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final ScrollController _controllerBayar = ScrollController();

  int groupvalue = 0;
  int tempTotal = 0;
  int page = 0;
  int lastpage = 0;

  bool firstinit = true;
  bool loadingconfirm = false;

  List<bool> isChecked = [];
  List<DatumBayar> allbayar = [];
  List<DatumBayar> selectedBayar = [];
  List<Map<String, dynamic>> sendToAPI = [];

  @override
  void didChangeDependencies() {
    if (firstinit) {
      _getfirstpembayaran();
      firstinit = false;
    }

    _controllerBayar.addListener(() {
      if (_controllerBayar.position.pixels ==
          _controllerBayar.position.maxScrollExtent) {
        _getmore();
      }
    });
    super.didChangeDependencies();
  }

  _getfirstpembayaran() {
    var prov = Provider.of<PembayaranProvider>(context, listen: false);

    prov.getfirstpembayaran().then((value) {
      if (prov.listpembayaran.isNotEmpty) {
        allbayar.clear();
        selectedBayar.clear();
        sendToAPI.clear();
        tempTotal = 0;
        lastpage = prov.listpembayaran[page].lastPage!;

        for (var element in prov.listpembayaran[page].data!) {
          allbayar.add(element);
        }

        setState(() {});
      }
      isChecked = List<bool>.filled(allbayar.length, false);
    }).catchError((onError) {
      print("Errornya : $onError");
    });
  }

  _getmore() {
    var prov = Provider.of<PembayaranProvider>(context, listen: false);

    if (page < lastpage) {
      prov.getmorepembayaran(page + 2).then((value) {
        var newdata = prov.listpembayaran[page + 1].data;

        var iteration = 0;
        for (var i = allbayar.length;
            i < allbayar.length + newdata!.length;
            i++) {
          allbayar.add(newdata[iteration]);
          iteration++;
        }
        page++;

        setState(() {});
      }).catchError((onError) {
        print("error load more");
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
      body: Column(
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
                            color:
                                (groupvalue == 0) ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      1: Text(
                        "Riwayat Pembayaran",
                        style: TextStyle(
                          color:
                              (groupvalue == 1) ? Colors.white : Colors.black,
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
              ? Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ListView.builder(
                            controller: _controllerBayar,
                            shrinkWrap: true,
                            itemCount: allbayar.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white.withOpacity(0.85),
                                margin: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 4, 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            activeColor: Color(0xFFFF8C00)
                                                .withOpacity(0.7),
                                            visualDensity:
                                                VisualDensity.compact,
                                            value: isChecked[index],
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked[index] = value!;

                                                if (isChecked[index] == true) {
                                                  selectedBayar
                                                      .add(allbayar[index]);

                                                  tempTotal +=
                                                      allbayar[index].nominal!;

                                                  Map<String, dynamic> mapping =
                                                      {
                                                    "nominal":
                                                        allbayar[index].nominal,
                                                    "idakun": allbayar[index]
                                                        .alokasiid,
                                                    "id":
                                                        allbayar[index].idsiswaa
                                                  };
                                                  sendToAPI.add(mapping);
                                                } else {
                                                  selectedBayar.removeWhere(
                                                      (element) =>
                                                          element.alokasiid ==
                                                          allbayar[index]
                                                              .alokasiid);

                                                  tempTotal -=
                                                      allbayar[index].nominal!;

                                                  sendToAPI.removeWhere(
                                                      (element) =>
                                                          element.containsValue(
                                                              allbayar[index]
                                                                  .nominal));
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
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                allbayar[index].judul!,
                                              ),
                                              Text(
                                                (allbayar[index].tipeid == 1)
                                                    ? "Semester : " +
                                                        "${allbayar[index].tipesemester}"
                                                            .capitalize()
                                                    : (allbayar[index].tipeid ==
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
                                            CurrencyFormat.convertToIdr(
                                              allbayar[index].nominal,
                                              0,
                                            ),
                                            softWrap: true,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                          a.alokasiid!.compareTo(b.alokasiid!));

                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.BOTTOMSLIDE,
                                        dialogType: DialogType.NO_HEADER,
                                        showCloseIcon: true,
                                        body: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: const [
                                                Text(
                                                  "Ringkasan Pembayaran",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 0.3,
                                              color: Colors.black,
                                              margin: EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: ListView.builder(
                                                itemCount: selectedBayar.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 8, 5, 8),
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
                                                              selectedBayar[
                                                                      index]
                                                                  .judul!,
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              CurrencyFormat.convertToIdr(
                                                                  selectedBayar[
                                                                          index]
                                                                      .nominal,
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
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                    child: Text(
                                                      "Jumlah Pembayaran",
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 5, 5, 5),
                                                    child: Text(
                                                      CurrencyFormat
                                                          .convertToIdr(
                                                              tempTotal, 0),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 0.3,
                                              color: Colors.black,
                                              margin: EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "Transfer ke",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                "Rekening Sekolah\na/n",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 6),
                                              child: Center(
                                                child: Text(selectedBayar[0]
                                                    .deskripsi!),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 6),
                                              child: Center(
                                                child: Text(
                                                  selectedBayar[0].norek!,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: CupertinoButton(
                                                minSize: 0,
                                                color: Color(0xFFFF8C00)
                                                    .withOpacity(0.7),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 24,
                                                ),
                                                child: (loadingconfirm)
                                                    ? CupertinoActivityIndicator()
                                                    : Text(
                                                        "KONFIRMASI",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                onPressed: (loadingconfirm)
                                                    ? null
                                                    : () {
                                                        setState(() {
                                                          loadingconfirm = true;
                                                        });

                                                        Provider.of<PembayaranProvider>(
                                                                context,
                                                                listen: false)
                                                            .sendRingkasanPembayaran(
                                                                sendToAPI)
                                                            .then((value) {
                                                          setState(() {
                                                            loadingconfirm =
                                                                false;
                                                          });
                                                          _getfirstpembayaran();
                                                          Navigator.pop(
                                                              context);
                                                          showCupertinoDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              Timer(
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                                  () => Navigator
                                                                      .pop(
                                                                          context));
                                                              return CupertinoAlertDialog(
                                                                content: Text(
                                                                    "Pembayaran berhasil dilakukan"),
                                                              );
                                                            },
                                                          );
                                                        }).catchError(
                                                                (onError) {
                                                          showCupertinoDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                CupertinoAlertDialog(
                                                              title:
                                                                  Text("Error"),
                                                              content:
                                                                  Text(onError),
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  minSize: 0,
                                  color: Color(0xFFFF8C00).withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: Text(
                          "Nama siswa",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.fromLTRB(8, 2, 8, 8),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 12, 3, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text("No Kwitansi :"),
                                            Text(
                                              "K0912UIN123J89102JU6G7D3M",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "Menunggu Konfirmasi",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.amber),
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
                    ],
                  ),
                )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllerBayar.dispose();
    super.dispose();
  }
}
