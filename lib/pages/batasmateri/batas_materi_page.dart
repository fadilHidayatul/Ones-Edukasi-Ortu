// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:edu_ready/model/mapel.dart';
import 'package:edu_ready/providers/materi_provider.dart';
import 'package:edu_ready/widgets/batas_materi_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MateriPage extends StatefulWidget {
  static const pageRoute = '/batasmateri';
  const MateriPage({Key? key}) : super(key: key);

  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  bool firstinitmapel = true;
  bool loading = false;

  List<String> mapel = [""];
  int page = 0;
  int lastPage = 0;
  String pilihanMatpel = "";

  List<Datum> batasmateri = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
  }

  @override
  void didChangeDependencies() {
    if (firstinitmapel) {
      loading = true;
      mapel.clear();
      batasmateri.clear();

      ////***ambil data mapel di page 1 */
      Provider.of<MateriProvider>(context, listen: false)
          .getfirstmapel()
          .then((value) {
        var getmp =
            Provider.of<MateriProvider>(context, listen: false).listmapel[page];
        lastPage =
            Provider.of<MateriProvider>(context, listen: false).lastPageMP;
        setState(() {
          pilihanMatpel = Provider.of<MateriProvider>(context, listen: false)
              .listmapel[page]
              .data![page]
              .namapel!;
        });

        /////***cek data duplicate di page 1 , add ke list mapel*/
        for (var element in getmp.data!) {
          if (mapel.contains(element.namapel)) {
            //  print("duplicate ${element.namapel }");
          } else {
            mapel.add(element.namapel ?? "");
          }
        }

        ///masukkan data ke list sesuai matpel yang dipilih pada page 1
        for (var element in getmp.data!) {
          // print("element : ${element}");
          if (element.namapel!.contains(pilihanMatpel)) {
            // print("ditambahkan");
            batasmateri.add(element);
          }
        }

        /////***ambil mata pelajaran lain jika page > 1 */
        if (lastPage > 1) {
          getmoremapel(lastPage);

          setState(() {
            loading = false;
          });
        }
      }).catchError((onError) {
        setState(() {
          loading = false;
        });
        
      });
      firstinitmapel = false;
    }

    super.didChangeDependencies();
  }

  getmoremapel(lastPage) {
    //mengambil api page berdasarkan i
    //mengambil data model berdasarkan page

    var prov = Provider.of<MateriProvider>(context, listen: false);
    for (var i = 2; i <= lastPage; i++) {
      prov.getmoremapel(i).then((value) {
        page++;
        // print("add data page ke $i");
        // print("array model $page");

        ///tambah mata pelajaran di page ke i
        for (var element in prov.listmapel[page].data!) {
          if (mapel.contains(element.namapel)) {
            //duplicate mapel
          } else {
            mapel.add(element.namapel!);
          }
          // print("element di model $page adalah ${element.namapel}");
        }
        //tambah list batas materi di page ke i
        for (var element in prov.listmapel[page].data!) {
          if (element.namapel!.contains(pilihanMatpel)) {
            batasmateri.add(element);
          }
        }

        setState(() {});
      }).catchError((onError) {
        print("error getmore mapel : $onError ");
      });
    }
  }

  addbatasmateritolist(matapelajaran) {
    var prov = Provider.of<MateriProvider>(context, listen: false);
    batasmateri.clear();
    // print("last page $lastPage");
    // print("data : ${ prov.listmapel }");

    //loop tiap page(array model)
    for (var i = 0; i < lastPage; i++) {
      ///cek "data" disetiap  page berdasarkan i, element=data
      for (var element in prov.listmapel[i].data!) {
        // print(element);
        if (element.namapel!.contains(matapelajaran)) {
          batasmateri.add(element);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: Container(
          color: Colors.grey.shade200,
          child: Card(
            color: Color(0xFFFF8C00).withOpacity(0.7),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.fromLTRB(
                10, MediaQuery.of(context).padding.top + 6, 10, 4),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Batasan Materi"),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                width: double.infinity,
            color: Colors.grey.shade200,
            child: (loading)
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : (mapel.isEmpty || batasmateri.isEmpty)
                    ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/ic_nodata.png",
                                width: 300,
                                height: 300,
                              ),
                              Text(
                                "Batasan Materi Belum Ada",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                    : Column(
                        children: [
                          ////header filter////
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
                            child: DropdownSearch(
                              mode: Mode.BOTTOM_SHEET,
                              items: mapel,
                              selectedItem: (mapel.isEmpty) ? "" : mapel[0],
                              showSelectedItems: true,
                              onChanged: (value) {
                                setState(() {
                                  pilihanMatpel = value.toString();
                                  addbatasmateritolist(value.toString());
                                });
                              },
                              popupTitle: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  "Pilih Batas Materi Pelajaran",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              popupShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                labelText: "Mata Pelajaran",
                                labelStyle: TextStyle(color: Colors.black87),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFF8C00), width: 0.8),
                                ),
                              ),
                            ),
                          ),

                          //listview builder batasan materi
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 8),
                              itemCount: batasmateri.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    AwesomeDialog(
                                            context: context,
                                            animType: AnimType.BOTTOMSLIDE,
                                            dialogType: DialogType.NO_HEADER,
                                            body: BatasMateriPopup(
                                              batasmateri: batasmateri,
                                              index: index,
                                            ),
                                            btnCancelText: "OK",
                                            btnCancelOnPress: () {},
                                            btnCancelColor: Color(0xFFFF8C00))
                                        .show();
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tanggal : ${(batasmateri[index].tanggal! == "0") ? "-" : DateFormat("d MMMM yyyy", "ID_id").format(DateTime.parse(batasmateri[index].tanggal!))}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Text(
                                              batasmateri[index].namapel!,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            batasmateri[index].materi!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
          ))
        ],
      ),
    );
  }
}
