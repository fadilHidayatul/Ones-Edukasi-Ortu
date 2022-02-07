// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class InformasiPdfDetail extends StatefulWidget {
  final String? path, title;
  const InformasiPdfDetail({Key? key, this.path,  this.title})
      : super(key: key);
  static const pageRoute = '/detail-pdf';

  @override
  _InformasiPdfDetailState createState() => _InformasiPdfDetailState();
}

class _InformasiPdfDetailState extends State<InformasiPdfDetail> {
  bool pdfready = false;
  int totalpages = 0;
  late PDFViewController _pdfviewcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, AppBar().preferredSize.height),
          child: CardAppBar(title: "Dokumen ${widget.title}"),
        ),
        body: Stack(
          children: [
            PDFView(
              filePath: widget.path,
              autoSpacing: true,
              swipeHorizontal: true,
              pageSnap: true,
              onError: (error) {
                print(error);
              },
              onRender: (pages) {
                setState(() {
                  totalpages = pages!;
                  pdfready = true;
                });
              },
              onViewCreated: (controller) {
                _pdfviewcon = controller;
              },
              onPageChanged: (page, total) {},
              onPageError: (page, error) {},
            ),
            !pdfready
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Offstage()
          ],
        ));
  }
}
