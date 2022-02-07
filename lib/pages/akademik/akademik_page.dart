// ignore_for_file: prefer_const_constructors

import 'package:dropdown_search/dropdown_search.dart';
import 'package:edu_ready/model/akademik_khusus.dart';
import 'package:edu_ready/model/akademik_umum.dart';
import 'package:edu_ready/providers/akademik_provider.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AkademikPage extends StatefulWidget {
  static const pageRoute = '/akademik';
  const AkademikPage({Key? key}) : super(key: key);

  @override
  _AkademikPageState createState() => _AkademikPageState();
}

class _AkademikPageState extends State<AkademikPage> {
  bool firstinit = true;
  bool isloading = false;

  int groupvalue = 0;
  int lastpage = 0;
  int page = 0;
  int lastpagekhusus = 0;
  int pagekhusus = 0;

  List<String> thn = ["2021/2022"];
  List<String> nilai = ["SEMUA", "ULANGAN HARIAN", "MID", "UAS"];
  String selectedthn = "2021/2022";
  String selectedNilai = "SEMUA";

  List<Datum> dataakaumum = [];
  List<Datum> dataumumfiltered = [];

  List<DatumKhusus> dataakakhusus = [];

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting("id_ID");
  }

  @override
  void didChangeDependencies() {
    if (firstinit) {
      isloading = true;
      var prov = Provider.of<AkademikProvider>(context, listen: false);
      dataakaumum.clear();
      dataakakhusus.clear();

      prov.getfirstakademikumum().then((value) {
        setState(() {
          lastpage = prov.lastpage;
        });

        for (var element in prov.listakaumum[page].data!) {
          dataakaumum.add(element);
        }

        if (lastpage > 1) {
          getmoreakademikumum(lastpage);
        }
      }).catchError((onError) {
        setState(() {
          isloading = false;
        });
        print("first init gagal");
      });

      /////////get akademik khusus here////////
      prov.getfirstakademikkhusus().then((value) {
        setState(() {
          lastpagekhusus = prov.lastpagekhusus;
        });

        for (var element in prov.listakakhusus[pagekhusus].data!) {
          dataakakhusus.add(element);
        }

        setState(() {
          isloading = false;
        });
      }).catchError((onError) {
        setState(() {
          isloading = false;
        });
        print("init khusus gagal $onError");
      });

      firstinit = false;
    }

    ///scroll controller untuk list khusus
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getmoreakademikkhusus();
      }
    });

    super.didChangeDependencies();
  }

  getmoreakademikumum(lastpage) {
    var prov = Provider.of<AkademikProvider>(context, listen: false);

    // print("ambil data page $i tampilkan array aka ke$page");
    for (var i = 2; i <= lastpage; i++) {
      prov.getmoreakademikumum(i).then((value) {
        page++;
        for (var element in prov.listakaumum[page].data!) {
          dataakaumum.add(element);
        }
        setState(() {});
      }).catchError((onError) {
        print("error $onError umum page $i");
      });
    }
  }

  changelistfiltered(String tipe) {
    dataumumfiltered.clear();

    for (var element in dataakaumum) {
      if (element.tipe!.contains(tipe)) {
        dataumumfiltered.add(element);
      }
      setState(() {});
    }
  }

  _getmoreakademikkhusus() {
    var prov = Provider.of<AkademikProvider>(context, listen: false);

    if (pagekhusus < lastpagekhusus) {
      prov.moreakademikkhusus(pagekhusus + 2).then((value) {
        var newdata = prov.listakakhusus[pagekhusus + 1].data;

        int iteration = 0;
        for (var i = dataakakhusus.length;
            i < dataakakhusus.length + newdata!.length;
            i++) {
          dataakakhusus.add(newdata[iteration]);
          iteration++;
        }
        pagekhusus++;
        setState(() {});
      }).catchError((onError) {
        print("gagal menambahkan page ke ${pagekhusus + 2}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      setState(() => groupvalue = args as int);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: CardAppBar(
          title: "Akademik",
        ),
      ),
      body: (isloading)
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ////Slider umum khusus
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                      child: CupertinoSlidingSegmentedControl(
                        children: {
                          0: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Umum",
                              style: TextStyle(
                                  color: (groupvalue == 0)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          1: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Khusus",
                              style: TextStyle(
                                  color: (groupvalue == 1)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          )
                        },
                        onValueChanged: (value) {
                          setState(() {
                            groupvalue = value as int;
                          });
                        },
                        groupValue: groupvalue,
                        thumbColor: Color(0xFFFF8C00).withOpacity(0.7),
                        backgroundColor: Colors.white,
                      ),
                    ))
                  ],
                ),

                ////dropdown
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownSearch(
                        mode: Mode.MENU,
                        items: thn,
                        selectedItem: thn[0],
                        maxHeight: 50,
                        onChanged: (value) {
                          setState(() {
                            selectedthn = value.toString();
                          });
                        },
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          labelText: "Tahun Ajaran",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFFFF8C00),
                              width: 0.8,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                Visibility(
                  visible: (groupvalue == 1) ? false : true,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownSearch(
                          mode: Mode.MENU,
                          items: nilai,
                          selectedItem: nilai[0],
                          onChanged: (value) {
                            setState(() {
                              selectedNilai = value.toString();
                              changelistfiltered(selectedNilai);
                            });
                          },
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: "Tipe Nilai",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFFF8C00),
                                width: 0.8,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                ////content
                (groupvalue == 0)
                    ? Expanded(
                        child: Card(
                        color: Colors.white,
                        elevation: 2,
                        semanticContainer: false,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Mata Pelajaran"),
                                  Text("Nilai"),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 0.5,
                              color: Color(0xFFFF8C00),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: (selectedNilai == "SEMUA")
                                    ? dataakaumum.length
                                    : dataumumfiltered.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 13),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 9,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text((selectedNilai == "SEMUA")
                                                  ? dataakaumum[index].namapel!
                                                  : dataumumfiltered[index]
                                                      .namapel!),
                                              Row(
                                                children: [
                                                  Text(
                                                    (selectedNilai == "SEMUA")
                                                        ? "${DateFormat("d MMMM yyyy", "ID_id").format(dataakaumum[index].tanggal!)}   "
                                                        : "${DateFormat("d MMMM yyyy", "ID_id").format(dataumumfiltered[index].tanggal!)}   ",
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  Text(
                                                    (selectedNilai == "SEMUA")
                                                        ? dataakaumum[index]
                                                            .tipe!
                                                        : dataumumfiltered[
                                                                index]
                                                            .tipe!,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFF8C00),
                                                        fontSize: 13),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child: Text((selectedNilai ==
                                                    "SEMUA")
                                                ? "${dataakaumum[index].nilainya}"
                                                : "${dataumumfiltered[index].nilainya}"))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                    : Expanded(
                        child: Card(
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: const [
                                    Flexible(
                                        flex: 9,
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Text("Surah"))),
                                    Flexible(
                                        flex: 2,
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              "Ayat",
                                              textAlign: TextAlign.center,
                                            ))),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 0.4,
                                color: Color(0xFFFF8C00),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: _controller,
                                  shrinkWrap: true,
                                  itemCount: dataakakhusus.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                              flex: 9,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dataakakhusus[index]
                                                          .surah!,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "Pengajar : ${dataakakhusus[index].nama}"),
                                                    Text(DateFormat(
                                                            "d MMMM yyyy",
                                                            "ID_id")
                                                        .format(
                                                            dataakakhusus[index]
                                                                .tgl!)),
                                                  ],
                                                ),
                                              )),
                                          Flexible(
                                              flex: 2,
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    dataakakhusus[index].ayat!,
                                                    textAlign: TextAlign.center,
                                                  ))),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
