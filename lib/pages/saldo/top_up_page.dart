// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:edu_ready/widgets/card_select_money.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key? key}) : super(key: key);
  static const pageRoute = '/top-up';

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final ScrollController _controller = ScrollController();
  final ScrollController _dummycon1 = ScrollController();
  int nominal = 0;
  final TextEditingController _nominalctr = TextEditingController();

  File? pickedImage;

  _getfromgallery() async {
    pickedImage = null;
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1800,
      maxWidth: 1800,
    );

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  _getfromcamera() async {
    pickedImage = null;
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1800,
      maxWidth: 1800,
    );

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: CardAppBar(
          title: "Top Up",
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 9,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ListView(
                shrinkWrap: true,
                controller: _controller,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "Nominal : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: CupertinoTextField.borderless(
                            controller: _nominalctr,
                            keyboardType: TextInputType.number,
                            maxLength: 24,
                            textAlign: TextAlign.center,
                            placeholder: "Rp.0",
                            placeholderStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: (nominal < 3000)
                                  ? Colors.red[400]
                                  : Colors.green[500],
                            ),
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                  locale: 'id', decimalDigits: 0, symbol: 'Rp.')
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.length > 3) {
                                  nominal = int.parse(
                                    value
                                        .substring(3, value.length)
                                        .replaceAll(".", ""),
                                  );
                                } else {
                                  nominal = 0;
                                }
                                print(nominal);
                              });
                            },
                          ),
                        ),
                        (nominal < 3000)
                            ? Text(
                                "Top Up Minimal Rp.3000",
                                style: TextStyle(color: Colors.red[400]),
                              )
                            : Offstage(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _nominalctr.text =
                                      CurrencyFormat.convertToIdr(10000, 0);
                                  nominal = 10000;
                                });
                              },
                              child: SelectMoney(
                                money: "10.000",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _nominalctr.text =
                                      CurrencyFormat.convertToIdr(20000, 0);
                                  nominal = 20000;
                                });
                              },
                              child: SelectMoney(
                                money: "20.000",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _nominalctr.text =
                                      CurrencyFormat.convertToIdr(50000, 0);
                                  nominal = 50000;
                                });
                              },
                              child: SelectMoney(
                                money: "50.000",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _nominalctr.text =
                                      CurrencyFormat.convertToIdr(100000, 0);
                                  nominal = 100000;
                                });
                              },
                              child: SelectMoney(
                                money: "100.000",
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                "Bukti Transfer",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            //dicek image file sudah ada atau belum
                            (pickedImage == null)
                                ? Offstage()
                                : Stack(
                                    children: [
                                      Card(
                                        semanticContainer: true,
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(60, 10, 60, 20),
                                        child: Image.file(
                                          pickedImage!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(0.85, 0),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              pickedImage = null;
                                            });
                                          },
                                          icon: Icon(
                                            CupertinoIcons.clear_circled_solid,
                                            color: Color(0xFFFF8C00),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //////bagian tombol dibawah//////////
          Flexible(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ListView(
                shrinkWrap: true,
                controller: _dummycon1,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Catatan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "* Harap lampirkan bukti transfer, untuk selanjutnya dilakukan proses verifikasi",
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ///////button bukti transfer////////
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  final action = CupertinoActionSheet(
                                    message: Text(
                                      "Pilih bukti transfer melalui",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _getfromgallery();
                                        },
                                        child: Text(
                                          "Galeri",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _getfromcamera();
                                        },
                                        child: Text(
                                          "Kamera",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Batal",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );

                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => action,
                                  );
                                },
                                child: Container(
                                  constraints:
                                      BoxConstraints(maxWidth: double.infinity),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    gradient: LinearGradient(
                                        colors: const [
                                          Color(0xFFF8E2B0),
                                          Color(0xFFE1CFA6),
                                          Color(0xFFFEF0E2),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text(
                                        pickedImage == null
                                            ? "Bukti Transfer"
                                            : "Upload Ulang Bukti",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ///////button top up////////
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (nominal == 0) {
                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                            "Harap masukkan besaran Top Up",
                                          ),
                                        ),
                                      );
                                    } else if (nominal < 3000) {
                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                            "Top Up harus minimal Rp. 3000",
                                          ),
                                        ),
                                      );
                                    } else if (pickedImage == null) {
                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                            "Isi bukti Top Up terlebih dahulu",
                                          ),
                                        ),
                                      );
                                    } else {
                                      var sizemb = pickedImage!.lengthSync() /
                                          (1024 * 1024);
                                      print(sizemb);
                                      print(pickedImage!.path);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        gradient: LinearGradient(
                                            colors: const [
                                              Color(0xFFDF9F5F),
                                              Color(0xFFE8BF61)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Top Up Sekarang",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
