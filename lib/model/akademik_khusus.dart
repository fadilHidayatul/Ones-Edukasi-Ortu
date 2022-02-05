// To parse this JSON data, do
//
//     final akademikKhusus = akademikKhususFromJson(jsonString);

import 'dart:convert';

AkademikKhusus akademikKhususFromJson(String str) => AkademikKhusus.fromJson(json.decode(str));

String akademikKhususToJson(AkademikKhusus data) => json.encode(data.toJson());

class AkademikKhusus {
    AkademikKhusus({
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
    List<DatumKhusus>? data = [];
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    dynamic? nextPageUrl;
    String? path;
    int? perPage;
    dynamic? prevPageUrl;
    int? to;
    int? total;

    factory AkademikKhusus.fromJson(Map<String, dynamic> json) => AkademikKhusus(
        currentPage: json["current_page"],
        data: List<DatumKhusus>.from(json["data"].map((x) => DatumKhusus.fromJson(x))),
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

class DatumKhusus {
    DatumKhusus({
        this.ayat,
        this.nama,
        this.idsiswa,
        this.surah,
        this.tgl,
    });

    String? ayat;
    String? nama;
    int? idsiswa;
    String? surah;
    DateTime? tgl;

    factory DatumKhusus.fromJson(Map<String, dynamic> json) => DatumKhusus(
        ayat: json["ayat"],
        nama: json["nama"],
        idsiswa: json["idsiswa"],
        surah: json["surah"],
        tgl: DateTime.parse(json["tgl"]),
    );

    Map<String, dynamic> toJson() => {
        "ayat": ayat,
        "nama": nama,
        "idsiswa": idsiswa,
        "surah": surah,
        "tgl": "${tgl!.year.toString().padLeft(4, '0')}-${tgl!.month.toString().padLeft(2, '0')}-${tgl!.day.toString().padLeft(2, '0')}",
    };
}
