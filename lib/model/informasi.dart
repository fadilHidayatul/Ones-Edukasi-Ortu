// To parse this JSON data, do
//
//     final informasi = informasiFromJson(jsonString);

import 'dart:convert';

Informasi informasiFromJson(String str) => Informasi.fromJson(json.decode(str));

String informasiToJson(Informasi data) => json.encode(data.toJson());

class Informasi {
    Informasi({
        this.informasiUmum,
        this.informasiKhusus,
    });

    List<InformasiUmum>? informasiUmum = [];
    List<InformasiKhusus>? informasiKhusus = [];

    factory Informasi.fromJson(Map<String, dynamic> json) => Informasi(
        informasiUmum: List<InformasiUmum>.from(json["informasiUmum"].map((x) => InformasiUmum.fromJson(x))),
        informasiKhusus: List<InformasiKhusus>.from(json["informasiKhusus"].map((x) => InformasiKhusus.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "informasiUmum": List<dynamic>.from(informasiUmum!.map((x) => x.toJson())),
        "informasiKhusus": List<dynamic>.from(informasiKhusus!.map((x) => x.toJson())),
    };
}

class InformasiKhusus {
    InformasiKhusus({
        this.pembeda,
        this.informasiid,
        this.judul,
        this.deskripsi,
        this.pathDokumen,
        this.jabatan,
        this.tglmulai,
        this.tglakhir,
        this.telahmulai,
        this.telahusai,
        this.author,
        this.tipe,
        this.idpenerima,
        this.idortu,
        this.reference,
        this.id,
    });

    String? pembeda;
    int? informasiid;
    String? judul;
    String? deskripsi;
    String? pathDokumen;
    String? jabatan;
    DateTime? tglmulai;
    DateTime? tglakhir;
    int? telahmulai;
    int? telahusai;
    int? author;
    int? tipe;
    int? idpenerima;
    int? idortu;
    int? reference;
    int? id;

    factory InformasiKhusus.fromJson(Map<String, dynamic> json) => InformasiKhusus(
        pembeda: json["pembeda"],
        informasiid: json["informasiid"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        pathDokumen: json["path_dokumen"],
        jabatan: json["jabatan"],
        tglmulai: DateTime.parse(json["tglmulai"]),
        tglakhir: DateTime.parse(json["tglakhir"]),
        telahmulai: json["telahmulai"],
        telahusai: json["telahusai"],
        author: json["author"],
        tipe: json["tipe"],
        idpenerima: json["idpenerima"],
        idortu: json["idortu"],
        reference: json["reference"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "pembeda": pembeda,
        "informasiid": informasiid,
        "judul": judul,
        "deskripsi": deskripsi,
        "path_dokumen": pathDokumen,
        "jabatan": jabatan,
        "tglmulai": "${tglmulai!.year.toString().padLeft(4, '0')}-${tglmulai!.month.toString().padLeft(2, '0')}-${tglmulai!.day.toString().padLeft(2, '0')}",
        "tglakhir": "${tglakhir!.year.toString().padLeft(4, '0')}-${tglakhir!.month.toString().padLeft(2, '0')}-${tglakhir!.day.toString().padLeft(2, '0')}",
        "telahmulai": telahmulai,
        "telahusai": telahusai,
        "author": author,
        "tipe": tipe,
        "idpenerima": idpenerima,
        "idortu": idortu,
        "reference": reference,
        "id": id,
    };
}

class InformasiUmum {
    InformasiUmum({
        this.informasiid,
        this.pembeda,
        this.judul,
        this.deskripsi,
        this.pathDokumen,
        this.jabatan,
        this.tglmulai,
        this.tglakhir,
        this.telahmulai,
        this.telahusai,
        this.author,
        this.tipe,
        this.idpenerima,
        this.idortu,
        this.reference,
        this.id,
    });

    int? informasiid;
    String? pembeda;
    String? judul;
    String? deskripsi;
    String? pathDokumen;
    String? jabatan;
    DateTime? tglmulai;
    DateTime? tglakhir;
    int? telahmulai;
    int? telahusai;
    int? author;
    int? tipe;
    String? idpenerima;
    int? idortu;
    int? reference;
    int? id;

    factory InformasiUmum.fromJson(Map<String, dynamic> json) => InformasiUmum(
        informasiid: json["informasiid"],
        pembeda: json["pembeda"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        pathDokumen: json["path_dokumen"],
        jabatan: json["jabatan"],
        tglmulai: DateTime.parse(json["tglmulai"]),
        tglakhir: DateTime.parse(json["tglakhir"]),
        telahmulai: json["telahmulai"],
        telahusai: json["telahusai"],
        author: json["author"],
        tipe: json["tipe"],
        idpenerima: json["idpenerima"],
        idortu: json["idortu"],
        reference: json["reference"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "informasiid": informasiid,
        "pembeda": pembeda,
        "judul": judul,
        "deskripsi": deskripsi,
        "path_dokumen": pathDokumen,
        "jabatan": jabatan,
        "tglmulai": "${tglmulai!.year.toString().padLeft(4, '0')}-${tglmulai!.month.toString().padLeft(2, '0')}-${tglmulai!.day.toString().padLeft(2, '0')}",
        "tglakhir": "${tglakhir!.year.toString().padLeft(4, '0')}-${tglakhir!.month.toString().padLeft(2, '0')}-${tglakhir!.day.toString().padLeft(2, '0')}",
        "telahmulai": telahmulai,
        "telahusai": telahusai,
        "author": author,
        "tipe": tipe,
        "idpenerima": idpenerima,
        "idortu": idortu,
        "reference": reference,
        "id": id,
    };
}