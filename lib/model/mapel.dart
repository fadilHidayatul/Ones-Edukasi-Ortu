// To parse this JSON data, do
//
//     final mapel = mapelFromJson(jsonString);

import 'dart:convert';

Mapel mapelFromJson(String str) => Mapel.fromJson(json.decode(str));

String mapelToJson(Mapel data) => json.encode(data.toJson());

class Mapel {
    Mapel({
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
    List<Datum>? data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    dynamic nextPageUrl;
    String? path;
    int? perPage;
    String? prevPageUrl;
    int? to;
    int? total;

    factory Mapel.fromJson(Map<String, dynamic> json) => Mapel(
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
        this.namaguru,
        this.namakelas,
        this.namapel,
        this.materi,
        this.tugas,
        this.tanggal,
        this.semesterid,
    });

    String? namaguru;
    String? namakelas;
    String? namapel;
    String? materi;
    String? tugas;
    String? tanggal;
    int? semesterid;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        namaguru: json["namaguru"],
        namakelas: json["namakelas"],
        namapel: json["namapel"],
        materi: json["materi"],
        tugas: json["tugas"],
        tanggal: json["tanggal"],
        semesterid: json["semesterid"],
    );

    Map<String, dynamic> toJson() => {
        "namaguru": namaguru,
        "namakelas": namakelas,
        "namapel": namapel,
        "materi": materi,
        "tugas": tugas,
        "tanggal": tanggal,
        "semesterid": semesterid,
    };
}

