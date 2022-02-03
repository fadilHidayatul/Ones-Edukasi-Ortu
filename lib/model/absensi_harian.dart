// To parse this JSON data, do
//
//     final absensiHarian = absensiHarianFromJson(jsonString);

import 'dart:convert';

AbsensiHarian absensiHarianFromJson(String str) => AbsensiHarian.fromJson(json.decode(str));

String absensiHarianToJson(AbsensiHarian data) => json.encode(data.toJson());

class AbsensiHarian {
    AbsensiHarian({
        required this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        required this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        required this.perPage,
        this.prevPageUrl,
        this.to,
        required this.total,
    });

    int currentPage;
    List<Datum>? data;
    String? firstPageUrl;
    int? from;
    int lastPage;
    String? lastPageUrl;
    String? nextPageUrl;
    String? path;
    int perPage;
    dynamic prevPageUrl;
    int? to;
    int total;

    factory AbsensiHarian.fromJson(Map<String, dynamic> json) => AbsensiHarian(
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
        required this.idsiswa,
        this.namatingkat,
        required this.namaSiswa,
        required this.kelas,
        required this.tingkat,
        required this.ket,
        required this.idmapel,
        required this.namapel,
        required this.namaguru,
        required this.tanggal,
    });

    int? idsiswa;
    String? namatingkat;
    String? namaSiswa;
    String? kelas;
    int? tingkat;
    String? ket;
    int idmapel;
    String namapel;
    String namaguru;
    DateTime tanggal;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idsiswa: json["idsiswa"],
        namatingkat: json["namatingkat"],
        namaSiswa: json["nama_siswa"],
        kelas: json["kelas"],
        tingkat: json["tingkat"],
        ket: json["ket"],
        idmapel: json["idmapel"],
        namapel: json["namapel"],
        namaguru: json["namaguru"],
        tanggal: DateTime.parse(json["tanggal"]),
    );

    Map<String, dynamic> toJson() => {
        "idsiswa": idsiswa,
        "namatingkat": namatingkat,
        "nama_siswa": namaSiswa,
        "kelas": kelas,
        "tingkat": tingkat,
        "ket": ket,
        "idmapel": idmapel,
        "namapel": namapel,
        "namaguru": namaguru,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
    };
}
