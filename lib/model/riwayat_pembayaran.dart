// To parse this JSON data, do
//
//     final riwayatPembayaran = riwayatPembayaranFromJson(jsonString);

import 'dart:convert';

RiwayatPembayaran riwayatPembayaranFromJson(String str) => RiwayatPembayaran.fromJson(json.decode(str));

String riwayatPembayaranToJson(RiwayatPembayaran data) => json.encode(data.toJson());

class RiwayatPembayaran {
    RiwayatPembayaran({
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
    List<DatumRiwayatBayar>? data = [];
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

    factory RiwayatPembayaran.fromJson(Map<String, dynamic> json) => RiwayatPembayaran(
        currentPage: json["current_page"],
        data: List<DatumRiwayatBayar>.from(json["data"].map((x) => DatumRiwayatBayar.fromJson(x))),
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

class DatumRiwayatBayar {
    DatumRiwayatBayar({
        this.idsiswaa,
        this.namaSiswa,
        this.realnoinduk,
        this.nama,
        this.tingkat,
        this.tahunajaran,
        this.tipesemester,
        this.status,
        this.nokwitansi,
    });

    int? idsiswaa;
    String? namaSiswa;
    String? realnoinduk;
    String? nama;
    String? tingkat;
    String? tahunajaran;
    String? tipesemester;
    dynamic status;
    String? nokwitansi;

    factory DatumRiwayatBayar.fromJson(Map<String, dynamic> json) => DatumRiwayatBayar(
        idsiswaa: json["idsiswaa"],
        namaSiswa: json["nama_siswa"],
        realnoinduk: json["realnoinduk"],
        nama: json["nama"],
        tingkat: json["tingkat"],
        tahunajaran: json["tahunajaran"],
        tipesemester: json["tipesemester"],
        status: json["status"],
        nokwitansi: json["nokwitansi"],
    );

    Map<String, dynamic> toJson() => {
        "idsiswaa": idsiswaa,
        "nama_siswa": namaSiswa,
        "realnoinduk": realnoinduk,
        "nama": nama,
        "tingkat": tingkat,
        "tahunajaran": tahunajaran,
        "tipesemester": tipesemester,
        "status": status,
        "nokwitansi": nokwitansi,
    };
}
