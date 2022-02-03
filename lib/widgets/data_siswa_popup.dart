import 'package:edu_ready/model/dashboard.dart';
import 'package:flutter/material.dart';

class DataSiswaPopup extends StatelessWidget {
  const DataSiswaPopup({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<Dashboard> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("Nama"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].namasiswa}"))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("NIS / NISN"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].noinduk} / ${data[0].showtanggungan![0].nisn}"))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("Kelas"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].nama} / ${data[0].showtanggungan![0].namatingkat}"))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("Alamat"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].alamat}"))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("Tempat Lahir"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].tempatLahir}"))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("Jenis Kelamin"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].jenisKelamin}"))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Row(
            children:  [
              const Flexible(flex: 2,child: SizedBox(width: double.infinity,child: Text("Agama"))),
              Flexible(flex: 3,child: SizedBox(width: double.infinity,child: Text(": ${data[0].showtanggungan![0].agama}"))),
            ],
          ),
        ),
        
      ],
    );
  }
}