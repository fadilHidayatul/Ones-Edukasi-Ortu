// To parse this JSON data, do
//
//     final pembayaran = pembayaranFromJson(jsonString);

import 'dart:convert';

Pembayaran pembayaranFromJson(String str) => Pembayaran.fromJson(json.decode(str));

String pembayaranToJson(Pembayaran data) => json.encode(data.toJson());

class Pembayaran {
    Pembayaran({
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
    List<DatumBayar>? data = [];
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    dynamic nextPageUrl;
    String? path;
    int? perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

    factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
        currentPage: json["current_page"],
        data: List<DatumBayar>.from(json["data"].map((x) => DatumBayar.fromJson(x))),
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

class DatumBayar {
    DatumBayar({
        this.deskripsi,
        this.norek,
        this.idsiswaa,
        this.idortu,
        this.namaortu,
        this.namaSiswa,
        this.realnoinduk,
        this.nama,
        this.tingkat,
        this.judul,
        this.tahunajaran,
        this.tipesemester,
        this.bayarNominal,
        this.nominal,
        this.tipeid,
        this.nambul,
        this.semester,
        this.tahun,
        this.alokasiid,
        this.createdat,
        this.status,
        this.nokwitansi,
    });

    String? deskripsi;
    String? norek;
    int? idsiswaa;
    int? idortu;
    String? namaortu;
    String? namaSiswa;
    String? realnoinduk;
    String? nama;
    String? tingkat;
    String? judul;
    String? tahunajaran;
    String? tipesemester;
    int? bayarNominal;
    int? nominal;
    int? tipeid;
    String? nambul;
    String? semester;
    int? tahun;
    int? alokasiid;
    DateTime? createdat;
    String? status;
    String? nokwitansi;

    factory DatumBayar.fromJson(Map<String, dynamic> json) => DatumBayar(
        deskripsi: json["deskripsi"],
        norek: json["norek"],
        idsiswaa: json["idsiswaa"],
        idortu: json["idortu"],
        namaortu: json["namaortu"],
        namaSiswa: json["nama_siswa"],
        realnoinduk: json["realnoinduk"],
        nama: json["nama"],
        tingkat: json["tingkat"],
        judul: json["judul"],
        tahunajaran: json["tahunajaran"],
        tipesemester: json["tipesemester"],
        bayarNominal: json["bayar_nominal"],
        nominal: json["nominal"],
        tipeid: json["tipeid"],
        nambul: json["nambul"],
        semester: json["semester"],
        tahun: json["tahun"],
        alokasiid: json["alokasiid"],
        createdat: DateTime.parse(json["createdat"]),
        status: json["status"],
        nokwitansi: json["nokwitansi"],
    );

    Map<String, dynamic> toJson() => {
        "deskripsi": deskripsi,
        "norek": norek,
        "idsiswaa": idsiswaa,
        "idortu": idortu,
        "namaortu": namaortu,
        "nama_siswa": namaSiswa,
        "realnoinduk": realnoinduk,
        "nama": nama,
        "tingkat": tingkat,
        "judul": judul,
        "tahunajaran": tahunajaran,
        "tipesemester": tipesemester,
        "bayar_nominal": bayarNominal,
        "nominal": nominal,
        "tipeid": tipeid,
        "nambul": nambul,
        "semester": semester,
        "tahun": tahun,
        "alokasiid": alokasiid,
        "createdat": createdat!.toIso8601String(),
        "status": status,
        "nokwitansi": nokwitansi,
    };
}
