// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardAppBar extends StatelessWidget {
  const CardAppBar({
    Key? key, required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color(0xFFFF8C00).withOpacity(0.7),
      margin: EdgeInsets.fromLTRB(
          10, MediaQuery.of(context).padding.top + 6, 10, 6),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Akademik",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
