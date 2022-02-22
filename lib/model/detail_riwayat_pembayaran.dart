// To parse this JSON data, do
//
//     final detailRiwayatPembayaran = detailRiwayatPembayaranFromJson(jsonString);

import 'dart:convert';

DetailRiwayatPembayaran detailRiwayatPembayaranFromJson(String str) => DetailRiwayatPembayaran.fromJson(json.decode(str));

String detailRiwayatPembayaranToJson(DetailRiwayatPembayaran data) => json.encode(data.toJson());

class DetailRiwayatPembayaran {
    DetailRiwayatPembayaran({
        this.data,
        this.summary,
    });

    List<Datum>? data = [];
    Summary? summary;

    factory DetailRiwayatPembayaran.fromJson(Map<String, dynamic> json) => DetailRiwayatPembayaran(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        summary: Summary.fromJson(json["summary"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
    };
}

class Datum {
    Datum({
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
    dynamic status;
    String? nokwitansi;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        "createdat": createdat?.toIso8601String(),
        "status": status,
        "nokwitansi": nokwitansi,
    };
}

class Summary {
    Summary({
        this.total,
    });

    String? total;

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
    };
}
