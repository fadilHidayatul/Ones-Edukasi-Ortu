// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_ready/model/history_saldo.dart';
import 'package:edu_ready/providers/history_saldo_provider.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:edu_ready/widgets/no_data_widget.dart';
import 'package:edu_ready/widgets/no_internet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistorySaldo extends StatefulWidget {
  static const pageRoute = '/history-saldo';
  const HistorySaldo({Key? key}) : super(key: key);

  @override
  _HistorySaldoState createState() => _HistorySaldoState();
}

class _HistorySaldoState extends State<HistorySaldo> {
  bool loadingfirst = true;
  bool isInternet = true;

  final ScrollController _scrollController = ScrollController();
  late List<Datum> dummy = [];
  // int currentmax = 10;
  int currentmax = 0;
  int lastpage = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _checkinternet();
  }

  @override
  void didChangeDependencies() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });

    super.didChangeDependencies();
  }

  _checkinternet() {
    InternetConnectionChecker().hasConnection.then((value) {
      if (!mounted) return;
      setState(() {
        isInternet = value;
        if(value == true) _getFirstList();
      });
    });
    InternetConnectionChecker().onStatusChange.listen((event) {
      if (!mounted) return;
      setState(() {
        if (event == InternetConnectionStatus.connected) {
          isInternet = true;
          _getFirstList();
        } else if (event == InternetConnectionStatus.disconnected) {
          isInternet = false;
        }
      });
    });
  }

  _getFirstList() {
    loadingfirst = true;
    Provider.of<HistorySaldoProvider>(context, listen: false)
        .getDataHistoryTopup()
        .then((value) {
      //generate data page 1 ke list ini
      dummy = Provider.of<HistorySaldoProvider>(context, listen: false)
          .listHistory[0]
          .data!;
      currentmax = dummy.length;
      lastpage =
          Provider.of<HistorySaldoProvider>(context, listen: false).lastpage;
      setState(() {
        loadingfirst = false;
      });
    }).catchError((onError) {
      // print("first init gagal $onError");
      setState(() {
        loadingfirst = false;
      });
    });
  }

  _getMoreList() {
    //karena data per page, maka harus di tambah2 agar data bertukar
    var getprov = Provider.of<HistorySaldoProvider>(context, listen: false);
    int page = 1;

    //kemungkinan tambah API disini
    //panggil api
    //ambil currentmax untuk cek dan tambah lenght data sesuai data baru
    //pengecekan if di awal untuk mencegah data diambil terus karena load more
    //***tambah data ke list local masih gagal */

    if (page < lastpage) {
      getprov.loadMoreData(page + 1).then((value) {
        var newdata = getprov.listHistory[page].data!;
        // var newlenghtdata = getprov.listHistory[page].data!.length;

        // var iteration = 0;
        // for (var i = currentmax; i < currentmax + newlenghtdata; i++) {
        //   dummy.add(newdata[iteration]);
        //   print("${ newdata[iteration] }");
        //   print("iterate : $iteration");
        //   iteration++;
        // }
        // currentmax = currentmax + newlenghtdata;
        // page = page + 1;

        // print(dummy.length);

        for (var element in newdata) {
          dummy.add(element);
        }
        page++;

        setState(() {});
      });
    }

    // for (var i = currentmax; i < currentmax + 10; i++) {
    //   dummy.add("item : ${i + 1}");
    // }
    // currentmax = currentmax + 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: CardAppBar(title: "History Top Up"),
      ),
      body: !isInternet
          ? NoInternetWidget()
          : Column(
              children: [
                ////body////
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  child: Consumer<HistorySaldoProvider>(
                    builder: (context, value, child) {
                      return (loadingfirst)
                          ? Center(
                              child: CupertinoActivityIndicator(),
                            )
                          : (dummy.isEmpty)
                              ? NoDataWidget(message: "Tidak ada data history")
                              : ListView.builder(
                                  controller: _scrollController,
                                  itemCount: dummy.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.white,
                                      elevation: 2,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              CupertinoIcons.tray_arrow_down,
                                              color: Color(0xFFFFB74D),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          "Top Up : ${CurrencyFormat.convertToIdr(dummy[index].creditin, 0)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                            "Tanggal : ${DateFormat("d MMMM yyyy", "ID_id").format(dummy[index].createdAt)}"),
                                        trailing: Text(
                                          dummy[index].statuskonfirmasi,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: (dummy[index]
                                                          .statuskonfirmasi) ==
                                                      "Butuh Konfirmasi"
                                                  ? Color(0xFFFFA726)
                                                  : (dummy[index]
                                                              .statuskonfirmasi ==
                                                          "Ditolak")
                                                      ? Color(0xFFEF5350)
                                                      : Colors.green),
                                        ),
                                        onTap: () {
                                          AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.NO_HEADER,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  body: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://api-develop.ones-edu.com/api/get-stream?path=${dummy[index].bukti}",
                                                      placeholder: (context,
                                                              url) =>
                                                          CupertinoActivityIndicator(),
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Icon(
                                                            CupertinoIcons
                                                                .nosign);
                                                      },
                                                    ),
                                                  ),
                                                  btnCancelOnPress: () {},
                                                  btnCancelColor:
                                                      Color(0xFFFFA726),
                                                  btnCancelText: "Selesai")
                                              .show();
                                        },
                                      ),
                                    );
                                  },
                                );
                    },
                  ),
                )),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
