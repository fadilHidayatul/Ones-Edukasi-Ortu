// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SelectMoney extends StatelessWidget {
  const SelectMoney({
    Key? key, required this.money,
  }) : super(key: key);

  final String money;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 60,
      child: Card(
        color: Color(0xFFFFA726),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            money,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}