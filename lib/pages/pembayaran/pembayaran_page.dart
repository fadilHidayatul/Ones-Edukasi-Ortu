// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/utils/currency.dart';
import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PembayaranPage extends StatefulWidget {
  static const pageRoute = '/pembayaran';
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  int groupvalue = 0;
  int tempTotal = 0;
  int testharga = 1000;

  bool firstinit = true;

  List<bool> isChecked = [];

  @override
  void didChangeDependencies() {
    if (firstinit) {
      isChecked = List<bool>.filled(10, false);

      firstinit = false;
    }
    super.didChangeDependencies();
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
                            shrinkWrap: true,
                            itemCount: 10,
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
                                      const EdgeInsets.fromLTRB(0, 10, 4, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            value: isChecked[index],
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked[index] = value!;
                                                // print(
                                                //   "yang ke $index  == ${isChecked[index]}",
                                                // );
                                                (isChecked[index] == true)
                                                    ? tempTotal += testharga
                                                    : tempTotal -= testharga;
                                                print(tempTotal);
                                                //kalo print diatas jalan => temp + ischeck[index], sblm itu cek nilainya true/false
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
                                            children: const [
                                              Text(
                                                "Uang API ",
                                              ),
                                              Text(
                                                "Jenis pembayaran : XXX",
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
                                                testharga, 0),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
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
                                "Total Bayar : ${CurrencyFormat.convertToIdr(10000, 0)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: CupertinoButton(
                                  onPressed: () {},
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
}
