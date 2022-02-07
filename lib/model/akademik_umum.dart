// To parse this JSON data, do
//
//     final akademikUmum = akademikUmumFromJson(jsonString);

import 'dart:convert';

AkademikUmum akademikUmumFromJson(String str) => AkademikUmum.fromJson(json.decode(str));

String akademikUmumToJson(AkademikUmum data) => json.encode(data.toJson());

class AkademikUmum {
    AkademikUmum({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    int? currentPage;
    List<Datum>? data = [];
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    String? nextPageUrl;
    String? path;
    int? perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

    factory AkademikUmum.fromJson(Map<String, dynamic> json) => AkademikUmum(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
    Datum({
        this.idsiswa,
        this.tahun,
        this.nama,
        this.namapel,
        this.nilainya,
        this.tanggal,
        this.tipe,
        this.idmpel,
        this.idguru,
    });

    int? idsiswa;
    int? tahun;
    String? nama;
    String? namapel;
    int? nilainya;
    DateTime? tanggal;
    String? tipe;
    int? idmpel;
    int? idguru;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idsiswa: json["idsiswa"],
        tahun: json["tahun"],
        nama: json["nama"],
        namapel: json["namapel"],
        nilainya: json["nilainya"],
        tanggal: DateTime.parse(json["tanggal"]),
        tipe: json["tipe"],
        idmpel: json["idmpel"],
        idguru: json["idguru"],
    );

    Map<String, dynamic> toJson() => {
        "idsiswa": idsiswa,
        "tahun": tahun,
        "nama": nama,
        "namapel": namapel,
        "nilainya": nilainya,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "tipe": tipe,
        "idmpel": idmpel,
        "idguru": idguru,
    };
}