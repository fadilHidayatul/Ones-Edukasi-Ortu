// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:edu_ready/model/detail_riwayat_pembayaran.dart';
import 'package:edu_ready/providers/pembayaran_provider.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PopUpDetail extends StatefulWidget {
  const PopUpDetail({
    Key? key,
    required this.detail,
    required this.status,
    required this.nokwitansi,
  }) : super(key: key);

  final List<DetailRiwayatPembayaran> detail;
  final String status;
  final String nokwitansi;

  @override
  State<PopUpDetail> createState() => _PopUpDetailState();
}

class _PopUpDetailState extends State<PopUpDetail> {
  final ScrollController _condetailitem = ScrollController();
  final ScrollController _conlv = ScrollController();

  File? filebukti;

  bool readyToSend = false;
  bool sending = false;

  _pickFromGallery() async {
    filebukti = null;

    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (image != null) {
      setState(() {
        filebukti = File(image.path);
        readyToSend = true;
      });
    }
  }

  _pickFromCamera() async {
    filebukti = null;

    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (image != null) {
      setState(() {
        filebukti = File(image.path);
        readyToSend = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: double.infinity,
          height:
              (widget.status == "lunas" && widget.detail[0].data!.length < 4)
                  ? MediaQuery.of(context).size.height * 0.35
                  : MediaQuery.of(context).size.height * 0.9,
          margin: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Detail Item Pembayaran",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: Icon(CupertinoIcons.clear),
                      onTap: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 0.2,
                color: Colors.black,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  controller: _conlv,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: (widget.detail[0].data!.length < 4)
                          ? MediaQuery.of(context).size.height * 0.3
                          : MediaQuery.of(context).size.height *
                              0.63, //height dibagi berdasarkan lenght data
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: _condetailitem,
                          itemCount: widget.detail[0].data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: Card(
                                color: Color(0xFFFFFFFF).withOpacity(0.92),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.5, horizontal: 8),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  widget.detail[0].data![index]
                                                      .judul!,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  ": ${CurrencyFormat.convertToIdr(widget.detail[0].data![index].nominal, 0)}",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                                width: double.infinity,
                                                child: Text("Status")),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                widget.detail[0].data![index]
                                                            .status ==
                                                        "butuh konfirmasi"
                                                    ? ": Menunggu Konfirmasi"
                                                    : widget
                                                                .detail[0]
                                                                .data![index]
                                                                .status ==
                                                            null
                                                        ? ": Ditolak"
                                                        : ": Lunas",
                                                style: TextStyle(
                                                  color: widget
                                                              .detail[0]
                                                              .data![index]
                                                              .status ==
                                                          "butuh konfirmasi"
                                                      ? Color(0xFFFF8C00)
                                                          .withOpacity(0.7)
                                                      : widget
                                                                  .detail[0]
                                                                  .data![index]
                                                                  .status ==
                                                              null
                                                          ? Colors.red
                                                              .withOpacity(0.7)
                                                          : Colors.blue
                                                              .withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text("Bulan")),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  widget.detail[0].data![index]
                                                              .nambul ==
                                                          null
                                                      ? ": -"
                                                      : ": ${widget.detail[0].data![index].nambul}",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    filebukti == null
                        ? Offstage()
                        : Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 200,
                                  child: Image.file(
                                    filebukti!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      filebukti = null;
                                      readyToSend = false;
                                    });
                                  },
                                  icon: Icon(
                                    CupertinoIcons.clear_circled_solid,
                                    color: Color(0xFFFF8C00),
                                  ),
                                ),
                              )
                            ],
                          ),
                    Container(
                      height: 0.2,
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(vertical: 8),
                    ),
                    widget.status == "lunas"
                        ? Offstage()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text("Total Bayar"),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      widget.detail[0].summary!.total == null
                                          ? ": -"
                                          : ": ${CurrencyFormat.convertToIdr(int.parse(widget.detail[0].summary!.total!), 0)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              widget.status == "lunas"
                  ? Offstage()
                  : readyToSend
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0, 24, 0, 8),
                          child: CupertinoButton(
                            minSize: 0,
                            color: Color(0xFFFF8C00).withOpacity(0.7),
                            padding: EdgeInsets.all(12),
                            child: (sending)
                                ? CupertinoActivityIndicator()
                                : Text("Kirim Bukti"),
                            onPressed: (sending)
                                ? null
                                : () {
                                    setState(() => sending = true);
                                    Provider.of<PembayaranProvider>(
                                      context,
                                      listen: false,
                                    )
                                        .sendRiwayatBuktiPembayaran(
                                      filebukti!,
                                      widget.nokwitansi,
                                    )
                                        .then((value) {
                                      setState(() => sending = false);

                                      Navigator.pop(context);

                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          Timer(Duration(seconds: 7), () {
                                            Navigator.pop(context);
                                          });
                                          return CupertinoAlertDialog(
                                            title: Text("Success"),
                                            content: Text(
                                              "Bukti bayar telah dikirim, silahkan tunggu verifikasi dari admin",
                                            ),
                                          );
                                        },
                                      );
                                    }).catchError((onError) {
                                      setState(() => sending = false);

                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                          Timer(
                                            Duration(seconds: 6),
                                            () => Navigator.pop(context),
                                          );
                                          return CupertinoAlertDialog(
                                            title: Text("Oops!"),
                                            content: Text(
                                              onError.toString(),
                                            ),
                                          );
                                        },
                                      );
                                    });
                                  },
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.fromLTRB(0, 24, 0, 8),
                          child: CupertinoButton(
                            minSize: 0,
                            color: Color(0xFFFF8C00).withOpacity(0.7),
                            padding: EdgeInsets.all(12),
                            child: Text(
                              (widget.status) == "butuh konfirmasi"
                                  ? "Tambah bukti bayar"
                                  : (widget.status) == ""
                                      ? "Silahkan kirim ulang bukti bayar"
                                      : "",
                            ),
                            onPressed: () {
                              var action = CupertinoActionSheet(
                                message: Text(
                                  "Ambil bukti bayar dari",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Text(
                                      "Galeri",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _pickFromGallery();
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text(
                                      "Kamera",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _pickFromCamera();
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              );

                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => action,
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _condetailitem.dispose();
    super.dispose();
  }
}


///////response kalo berhasil 201////////////
// {
//     "status": "success",
//     "header": "Berhasil!",
//     "message": "Bukti Pembayaran berhasil disimpan."
// }

///////response kalo gagal 422////////////
// {
//     "status": "error",
//     "exeption": "Validasi",
//     "message": "item sudah bayar."
// }
