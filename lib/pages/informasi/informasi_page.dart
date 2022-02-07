// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:edu_ready/model/informasi.dart';
import 'package:edu_ready/pages/informasi/informasi_pdf.dart';
import 'package:edu_ready/providers/informasi_provider.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:edu_ready/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InformasiPage extends StatefulWidget {
  static const pageRoute = '/informasi';
  const InformasiPage({Key? key}) : super(key: key);

  @override
  State<InformasiPage> createState() => _InformasiPageState();
}

class _InformasiPageState extends State<InformasiPage> {
  bool firstinit = true;
  bool isloading = false;

  int? groupValue = 0;
  List<String> item = ["Terbaru", "Riwayat Informasi"];
  String selectedFilter = "Terbaru";

  List<InformasiUmum> listumumterbaru = [];
  List<InformasiUmum> listumumriwayat = [];
  List<InformasiKhusus> listkhususterbaru = [];
  List<InformasiKhusus> listkhususriwayat = [];

  String urlimage = "https://api-develop.ones-edu.com/api/get-stream?path=";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting("id_ID");
  }

  @override
  void didChangeDependencies() {
    var prov = Provider.of<InformasiProvider>(context, listen: false);
    if (firstinit) {
      isloading = true;
      listkhususriwayat.clear();
      listkhususterbaru.clear();
      listumumriwayat.clear();
      listumumterbaru.clear();

      prov.getalllistinformasi().then((value) {
        ////pengolahan data informasi umum////
        if (prov.listInformasi[0].informasiUmum!.isNotEmpty) {
          for (var item in prov.listInformasi[0].informasiUmum!) {
            if (item.telahusai == 1) {
              listumumriwayat.add(item);
            } else {
              listumumterbaru.add(item);
            }
          }
        }

        ////pengolahan data informasi khusus////
        if (prov.listInformasi[0].informasiKhusus!.isNotEmpty) {
          for (var item in prov.listInformasi[0].informasiKhusus!) {
            if (item.telahusai == 1) {
              listkhususriwayat.add(item);
            } else {
              listkhususterbaru.add(item);
            }
          }
        }

        setState(() {
          isloading = false;
        });
      }).catchError((onError) {
        print("on error init $onError");
        setState(() {
          isloading = false;
        });
      });

      firstinit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, AppBar().preferredSize.height),
          child: CardAppBar(title: "Informasi Siswa"),
        ),
        body: (isloading)
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ////Pilihan Slide Informasi
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: CupertinoSlidingSegmentedControl(
                          children: {
                            0: Text(
                              "Umum",
                              style: TextStyle(
                                  color: (groupValue == 0)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            1: Text(
                              "Khusus",
                              style: TextStyle(
                                  color: (groupValue == 1)
                                      ? Colors.white
                                      : Colors.black),
                            )
                          },
                          onValueChanged: (value) {
                            setState(() => groupValue = value as int);
                          },
                          groupValue: groupValue,
                          padding: EdgeInsets.fromLTRB(10, 14, 10, 0),
                          thumbColor: Color(0xFFFF8C00).withOpacity(0.8),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  ////Filter Dropdown////
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
                    child: DropdownSearch(
                      maxHeight: 120,
                      mode: Mode.MENU,
                      items: item,
                      selectedItem: item[0],
                      showSelectedItems: true,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value.toString();
                        });
                      },
                      popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        labelText: "Filter Informasi",
                        labelStyle: TextStyle(color: Colors.black87),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xFFFF8C00), width: 0.8),
                        ),
                      ),
                    ),
                  ),

                  ////Content Informasi////
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ///0 == umum///
                        if (groupValue == 0) ...[
                          Expanded(
                            child: (selectedFilter == "Terbaru")
                                ?

                                ///cek data kosong terbaru///
                                (listumumterbaru.isEmpty)
                                    ? NoDataWidget(
                                        message:
                                            "Informasi Umum Terbaru Belum Adaa",
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listumumterbaru.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Provider.of<InformasiProvider>(
                                                      context,
                                                      listen: false)
                                                  .getinformasibyid(
                                                      listumumterbaru[index]
                                                          .informasiid);
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
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Text(
                                                            "Detail Informasi",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 0.2,
                                                        color: Colors.black,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(DateFormat(
                                                                  "d MMMM yyyy",
                                                                  "ID_id")
                                                              .format(
                                                                  listumumterbaru[
                                                                          index]
                                                                      .tglmulai!))
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        child: Text(
                                                          "${listumumterbaru[index].judul}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                              "${listumumterbaru[index].deskripsi} ")),
                                                      Visibility(
                                                        visible: (listumumterbaru[
                                                                        index]
                                                                    .pathDokumen ==
                                                                null)
                                                            ? false
                                                            : true,
                                                        child: (listumumterbaru[
                                                                        index]
                                                                    .pathDokumen
                                                                    ?.split('.')
                                                                    .last ==
                                                                "pdf")
                                                            ? Image.asset(
                                                                "assets/images/splash.png")
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    "$urlimage${listumumterbaru[index].pathDokumen}",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    CupertinoActivityIndicator(),
                                                                errorWidget:
                                                                    (context,
                                                                            url,
                                                                            error) =>
                                                                        Row(
                                                                  children: [
                                                                    Icon(CupertinoIcons
                                                                        .nosign),
                                                                    Text(
                                                                      "Dokumen gagal ditampilkan",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            "Nama Penulis : ${listumumterbaru[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45),
                                                          ))
                                                    ],
                                                  )).show();
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              margin: EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${listumumterbaru[index].judul}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3),
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMMM yyyy",
                                                                    "ID_id")
                                                                .format(listumumterbaru[
                                                                        index]
                                                                    .tglmulai!),
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Text(
                                                            "Post Oleh  :${listumumterbaru[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ],
                                                    )),
                                                    Icon(
                                                      CupertinoIcons
                                                          .checkmark_alt,
                                                      color: (listumumterbaru[
                                                                      index]
                                                                  .pembeda ==
                                                              "R")
                                                          ? Color(0xFFFF8C00)
                                                          : Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                :

                                ///cek data kosong riwayat///
                                (listumumriwayat.isEmpty)
                                    ? NoDataWidget(
                                        message:
                                            "Riwayat Informasi Umum Belum Ada")
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listumumriwayat.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Provider.of<InformasiProvider>(
                                                      context,
                                                      listen: false)
                                                  .getinformasibyid(
                                                      listumumriwayat[index]
                                                          .informasiid);
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
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Text(
                                                            "Detail Informasi",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 0.2,
                                                        color: Colors.black,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(DateFormat(
                                                                  "d MMMM yyyy",
                                                                  "ID_id")
                                                              .format(
                                                                  listumumriwayat[
                                                                          index]
                                                                      .tglmulai!))
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        child: Text(
                                                          "${listumumriwayat[index].judul}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                              "${listumumriwayat[index].deskripsi}")),
                                                      Visibility(
                                                          visible: (listumumriwayat[
                                                                          index]
                                                                      .pathDokumen ==
                                                                  null)
                                                              ? false
                                                              : true,
                                                          child: (listumumriwayat[
                                                                          index]
                                                                      .pathDokumen
                                                                      ?.split(
                                                                          '.')
                                                                      .last ==
                                                                  "pdf")
                                                              ? Image.asset(
                                                                  "assets/images/splash.png")
                                                              : CachedNetworkImage(
                                                                  imageUrl:
                                                                      "$urlimage${listumumriwayat[index].pathDokumen}",
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      CupertinoActivityIndicator(),
                                                                  errorWidget:
                                                                      (context,
                                                                              url,
                                                                              error) =>
                                                                          Row(
                                                                    children: [
                                                                      Icon(CupertinoIcons
                                                                          .nosign),
                                                                      Text(
                                                                        "Dokumen gagal ditampilkan",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            "Nama Penulis : ${listumumriwayat[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45),
                                                          ))
                                                    ],
                                                  )).show();
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              margin: EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${listumumriwayat[index].judul}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3),
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMMM yyyy",
                                                                    "ID_id")
                                                                .format(listumumriwayat[
                                                                        index]
                                                                    .tglmulai!),
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Text(
                                                            "Post Oleh :${listumumriwayat[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ],
                                                    )),
                                                    Icon(
                                                      CupertinoIcons
                                                          .checkmark_alt,
                                                      color: (listumumriwayat[
                                                                      index]
                                                                  .pembeda ==
                                                              "R")
                                                          ? Color(0xFFFF8C00)
                                                          : Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                          )

                          ///1 == khusus///
                        ] else if (groupValue == 1) ...[
                          Expanded(
                            child: (selectedFilter == "Terbaru")
                                ? (listkhususterbaru.isEmpty)
                                    ? NoDataWidget(
                                        message:
                                            "Informasi Khusus Terbaru Belum Ada")
                                    : ListView.builder(
                                        itemCount: listkhususterbaru.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Provider.of<InformasiProvider>(
                                                      context,
                                                      listen: false)
                                                  .getinformasibyid(
                                                      listkhususterbaru[index]
                                                          .informasiid);
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
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Text(
                                                            "Detail Informasi",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 0.2,
                                                        color: Colors.black,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(DateFormat(
                                                                  "d MMMM yyyy",
                                                                  "ID_id")
                                                              .format(
                                                                  listkhususterbaru[
                                                                          index]
                                                                      .tglmulai!))
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        child: Text(
                                                          "${listkhususterbaru[index].judul}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                              "${listkhususterbaru[index].deskripsi}")),
                                                      Visibility(
                                                        visible: (listkhususterbaru[
                                                                        index]
                                                                    .pathDokumen ==
                                                                null)
                                                            ? false
                                                            : true,
                                                        child: (listkhususterbaru[
                                                                        index]
                                                                    .pathDokumen
                                                                    ?.split('.')
                                                                    .last ==
                                                                "pdf")
                                                            ? Image.asset(
                                                                "assets/images/splash.png")
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    "$urlimage${listkhususterbaru[index].pathDokumen}",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    CupertinoActivityIndicator(),
                                                                errorWidget:
                                                                    (context,
                                                                            url,
                                                                            error) =>
                                                                        Row(
                                                                  children: [
                                                                    Icon(CupertinoIcons
                                                                        .nosign),
                                                                    Text(
                                                                      "Dokumen gagal ditampilkan",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            "Nama Penulis : ${listkhususterbaru[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45),
                                                          ))
                                                    ],
                                                  )).show();
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              margin: EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${listkhususterbaru[index].judul}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3),
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMMM yyyy",
                                                                    "ID_id")
                                                                .format(listkhususterbaru[
                                                                        index]
                                                                    .tglmulai!),
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Text(
                                                            "Post oleh : ${listkhususterbaru[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ],
                                                    )),
                                                    Icon(
                                                      CupertinoIcons
                                                          .checkmark_alt,
                                                      color: (listkhususterbaru[
                                                                      index]
                                                                  .pembeda ==
                                                              "R")
                                                          ? Color(0xFFFF8C00)
                                                          : Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                : (listkhususriwayat.isEmpty)
                                    ? NoDataWidget(
                                        message:
                                            "Riwayat Informasi Khusus Belum Ada")
                                    : ListView.builder(
                                        itemCount: listkhususriwayat.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Provider.of<InformasiProvider>(
                                                      context,
                                                      listen: false)
                                                  .getinformasibyid(
                                                      listkhususriwayat[index]
                                                          .informasiid);
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
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Text(
                                                            "Detail Informasi",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 0.2,
                                                        color: Colors.black,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(DateFormat(
                                                                  "d MMMM yyyy",
                                                                  "ID_id")
                                                              .format(
                                                                  listkhususriwayat[
                                                                          index]
                                                                      .tglmulai!))
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        child: Text(
                                                          "${listkhususriwayat[index].judul}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                              "${listkhususriwayat[index].deskripsi}")),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Visibility(
                                                          visible: (listkhususriwayat[
                                                                          index]
                                                                      .pathDokumen ==
                                                                  null)
                                                              ? false
                                                              : true,
                                                          child: (listkhususriwayat[
                                                                          index]
                                                                      .pathDokumen
                                                                      ?.split(
                                                                          '.')
                                                                      .last ==
                                                                  "pdf")
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Provider.of<InformasiProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getfilepdf(
                                                                            "$urlimage${listkhususriwayat[index].pathDokumen}",
                                                                            index).then((value){
                                                                              if (value!=null) {
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                  return InformasiPdfDetail(path: value.path,title: listkhususriwayat[index].judul,);
                                                                                },));
                                                                              }
                                                                            });
                                                                  },
                                                                  child: Text(
                                                                    "Lihat file PDF",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Color(
                                                                            0xFFFF8C00)),
                                                                  ))
                                                              : CachedNetworkImage(
                                                                  imageUrl:
                                                                      "$urlimage${listkhususriwayat[index].pathDokumen}",
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      CupertinoActivityIndicator(),
                                                                  errorWidget:
                                                                      (context,
                                                                              url,
                                                                              error) =>
                                                                          Row(
                                                                    children: [
                                                                      Icon(CupertinoIcons
                                                                          .nosign),
                                                                      Text(
                                                                        "Dokumen gagal ditampilkan",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            "Nama Penulis : ${listkhususriwayat[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45),
                                                          ))
                                                    ],
                                                  )).show();
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              margin: EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${listkhususriwayat[index].judul}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3),
                                                          child: Text(
                                                            DateFormat(
                                                                    "d MMMM yyyy",
                                                                    "ID_id")
                                                                .format(listkhususriwayat[
                                                                        index]
                                                                    .tglmulai!),
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Text(
                                                            "Post oleh : ${listkhususriwayat[index].jabatan}",
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ],
                                                    )),
                                                    Icon(
                                                      CupertinoIcons
                                                          .checkmark_alt,
                                                      color: (listkhususriwayat[
                                                                      index]
                                                                  .pembeda ==
                                                              "R")
                                                          ? Color(0xFFFF8C00)
                                                          : Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ));
  }
}
