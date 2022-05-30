// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:edu_ready/widgets/no_data_widget.dart';
import 'package:edu_ready/widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({Key? key}) : super(key: key);

  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  bool isInternet = true;

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  checkInternet() {
    InternetConnectionChecker().hasConnection.then((value) {
      if (!mounted) return;
      setState(() {
        isInternet = true;
      });
    });

    InternetConnectionChecker().onStatusChange.listen((event) {
      if (!mounted) return;
      setState(() {
        if (event == InternetConnectionStatus.connected) {
          isInternet = true;
        } else if (event == InternetConnectionStatus.disconnected) {
          isInternet = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          color: Colors.grey.shade100,
          child: CardAppBar(title: "Materi"),
        ),
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
      ),
      body: !isInternet
          ? NoInternetWidget()
          : Column(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.grey.shade100,
                  child: NoDataWidget(message: "Data Materi Kosong"),
                ))
              ],
            ),
    );
  }
}
