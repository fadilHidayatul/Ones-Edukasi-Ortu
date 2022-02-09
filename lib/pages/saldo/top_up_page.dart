// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key? key}) : super(key: key);
  static const pageRoute = '/top-up';

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
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
        children: [
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              height: 300,
              color: Colors.deepOrangeAccent,
              child: Text("kotak top up dan pilihan"),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 700,
              color: Colors.green,
              child: Text("preview gambar"),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 330,
              color: Colors.blue,
              child: Text("Button"),
            ),
          ),
          
        ],
      ),
    );
  }
}
