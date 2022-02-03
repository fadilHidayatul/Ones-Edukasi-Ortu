// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/model/mapel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BatasMateriPopup extends StatelessWidget {
  const BatasMateriPopup({
    Key? key,
    required this.batasmateri, required this.index,
  }) : super(key: key);

  final List<Datum> batasmateri;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("Tanggal"),
                    )),
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                        ": ${
                                    (batasmateri[index].tanggal! == "0") ? "-" :
                                    DateFormat("d MMMM yyyy", "ID_id").format(DateTime.parse(batasmateri[index].tanggal!))
                                    
                                    }"),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("Mata Pelajaran"),
                    )),
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                        ": ${ batasmateri[index].namapel }"),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("Batas Materi"),
                    )),
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                        ": ${ batasmateri[index].materi }"),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("Tugas"),
                    )),
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                        ": ${ (batasmateri[index].tugas!.contains("0"))? "Tidak ada tugas":batasmateri[index].tugas }"),
                  ),
                )
              ],
            ),
          ),                                     
        ],
      ),
    );
  }
}
