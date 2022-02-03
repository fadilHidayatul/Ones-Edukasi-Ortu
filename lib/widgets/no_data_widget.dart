// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key, required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/ic_nodata.png",
            width: 200,
            height: 200,
          ),
          Text(
            message,
            style: TextStyle(
                fontWeight: FontWeight.bold),
          ),
        ],
      );
  }
}
