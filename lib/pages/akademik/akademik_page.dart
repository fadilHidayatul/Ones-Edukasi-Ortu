// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/widgets/card_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AkademikPage extends StatefulWidget {
  static const pageRoute = '/akademik';
  const AkademikPage({Key? key}) : super(key: key);

  @override
  _AkademikPageState createState() => _AkademikPageState();
}

class _AkademikPageState extends State<AkademikPage> {
  int groupvalue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
        child: CardAppBar(title: "Akademik",),
      ),
      body: Column(
        children: [
          ///Slider umum khusus
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                child: CupertinoSlidingSegmentedControl(
                  children: {
                    0: Text(
                      "Umum",
                      style: TextStyle(
                          color:
                              (groupvalue == 0) ? Colors.white : Colors.black),
                    ),
                    1: Text(
                      "Khusus",
                      style: TextStyle(
                          color:
                              (groupvalue == 1) ? Colors.white : Colors.black),
                    )
                  },
                  onValueChanged: (value) {
                    setState(() {
                      groupvalue = value as int;
                    });
                  },
                  groupValue: groupvalue,
                  thumbColor: Color(0xFFFF8C00).withOpacity(0.7),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}

