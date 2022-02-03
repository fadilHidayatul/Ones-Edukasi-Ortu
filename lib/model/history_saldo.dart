// To parse this JSON data, do
//
//     final historySaldo = historySaldoFromJson(jsonString);

import 'dart:convert';

HistorySaldo historySaldoFromJson(String str) => HistorySaldo.fromJson(json.decode(str));

String historySaldoToJson(HistorySaldo data) => json.encode(data.toJson());

class HistorySaldo {
    HistorySaldo({
        required this.currentPage,
        this.data,
        required this.firstPageUrl,
        this.from,
        required this.lastPage,
        required this.lastPageUrl,
        this.nextPageUrl,
        required this.path,
        required this.perPage,
        this.prevPageUrl,
        this.to,
        required this.total,
    });

    int currentPage;
    List<Datum>? data;
    String firstPageUrl;
    int? from;
    int lastPage;
    String lastPageUrl;
    dynamic nextPageUrl;
    String path;
    int perPage;
    String? prevPageUrl;
    int? to;
    int total;

    factory HistorySaldo.fromJson(Map<String, dynamic> json) => HistorySaldo(
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
        required this.statuskonfirmasi,
        required this.idcre,
        required this.creditin,
        required this.namaortu,
        required this.namasiswa,
        required this.email,
        required this.createdAt,
        required this.bukti,
        required this.fMBayar,
    });

    String statuskonfirmasi;
    int idcre;
    int creditin;
    String namaortu;
    String namasiswa;
    String email;
    DateTime createdAt;
    String bukti;
    String fMBayar;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        statuskonfirmasi: json["statuskonfirmasi"],
        idcre: json["idcre"],
        creditin: json["creditin"],
        namaortu: json["namaortu"],
        namasiswa: json["namasiswa"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        bukti: json["bukti"],
        fMBayar: json["f_m_bayar"],
    );

    Map<String, dynamic> toJson() => {
        "statuskonfirmasi": statuskonfirmasi,
        "idcre": idcre,
        "creditin": creditin,
        "namaortu": namaortu,
        "namasiswa": namasiswa,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "bukti": bukti,
        "f_m_bayar": fMBayar,
    };
}
