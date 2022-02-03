// To parse this JSON data, do
//
//     final absensiBulanan = absensiBulananFromJson(jsonString);

import 'dart:convert';

AbsensiBulanan absensiBulananFromJson(String str) => AbsensiBulanan.fromJson(json.decode(str));

String absensiBulananToJson(AbsensiBulanan data) => json.encode(data.toJson());

class AbsensiBulanan {
    AbsensiBulanan({
        this.data,
    });

    Map<String, Datum>? data;

    factory AbsensiBulanan.fromJson(Map<String, dynamic> json) => AbsensiBulanan(
        data: Map.from(json["data"]).map((k, v) => MapEntry<String, Datum>(k, Datum.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Datum {
    Datum({
        this.hadir,
        this.cabut,
        this.izin,
        this.idsiswa,
        this.namaSiswa,
        this.kelas,
        this.tingkat,
        this.namapel,
        this.namaguru,
        this.bulan,
    });

    String? hadir;
    String? cabut;
    String? izin;
    int? idsiswa;
    String? namaSiswa;
    String? kelas;
    int? tingkat;
    String? namapel;
    String? namaguru;
    int? bulan;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hadir: json["hadir"],
        cabut: json["cabut"],
        izin: json["izin"],
        idsiswa: json["idsiswa"],
        namaSiswa: json["nama_siswa"],
        kelas: json["kelas"],
        tingkat: json["tingkat"],
        namapel: json["namapel"],
        namaguru: json["namaguru"],
        bulan: json["bulan"],
    );

    Map<String, dynamic> toJson() => {
        "hadir": hadir,
        "cabut": cabut,
        "izin": izin,
        "idsiswa": idsiswa,
        "nama_siswa": namaSiswa,
        "kelas": kelas,
        "tingkat": tingkat,
        "namapel": namapel,
        "namaguru": namaguru,
        "bulan": bulan,
    };
}
