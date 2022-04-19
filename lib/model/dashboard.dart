// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  Dashboard({
    this.absensi,
    this.bDepanSekarang,
    this.saldo,
    this.nilaiDashboard,
    this.nilaiDashboardGrafik,
    this.showtanggungan,
    this.batasmateri,
    this.tahfis,
    this.totalumum,
    this.totalkhusus,
  });

  List<Absensi>? absensi = [];
  List<BDepanSekarang>? bDepanSekarang = [];
  int? saldo;
  List<NilaiDashboard>? nilaiDashboard;
  List<NilaiDashboardGrafik>? nilaiDashboardGrafik;
  List<Showtanggungan>? showtanggungan;
  List<Batasmateri>? batasmateri;
  List<Tahfi>? tahfis;
  List<Total>? totalumum;
  List<Total>? totalkhusus;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        absensi:
            List<Absensi>.from(json["absensi"].map((x) => Absensi.fromJson(x))),
        bDepanSekarang: List<BDepanSekarang>.from(
            json["b_depan_sekarang"].map((x) => BDepanSekarang.fromJson(x))),
        saldo: json["saldo"],
        nilaiDashboard: List<NilaiDashboard>.from(
            json["nilaiDashboard"].map((x) => NilaiDashboard.fromJson(x))),
        nilaiDashboardGrafik: List<NilaiDashboardGrafik>.from(
            json["nilaiDashboardGrafik"]
                .map((x) => NilaiDashboardGrafik.fromJson(x))),
        showtanggungan: List<Showtanggungan>.from(
            json["showtanggungan"].map((x) => Showtanggungan.fromJson(x))),
        batasmateri: List<Batasmateri>.from(
            json["batasmateri"].map((x) => Batasmateri.fromJson(x))),
        tahfis: List<Tahfi>.from(json["tahfis"].map((x) => Tahfi.fromJson(x))),
        totalumum:
            List<Total>.from(json["totalumum"].map((x) => Total.fromJson(x))),
        totalkhusus:
            List<Total>.from(json["totalkhusus"].map((x) => Total.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "absensi": List<dynamic>.from(absensi!.map((x) => x.toJson())),
        "b_depan_sekarang":
            List<dynamic>.from(bDepanSekarang!.map((x) => x.toJson())),
        "saldo": saldo,
        "nilaiDashboard":
            List<dynamic>.from(nilaiDashboard!.map((x) => x.toJson())),
        "nilaiDashboardGrafik":
            List<dynamic>.from(nilaiDashboardGrafik!.map((x) => x.toJson())),
        "showtanggungan":
            List<dynamic>.from(showtanggungan!.map((x) => x.toJson())),
        "batasmateri": List<dynamic>.from(batasmateri!.map((x) => x.toJson())),
        "tahfis": List<dynamic>.from(tahfis!.map((x) => x.toJson())),
        "totalumum": List<dynamic>.from(totalumum!.map((x) => x.toJson())),
        "totalkhusus": List<dynamic>.from(totalkhusus!.map((x) => x.toJson())),
      };
}

class Absensi {
  Absensi({
    required this.idsiswa,
    required this.namaSiswa,
    required this.kelas,
    required this.tingkat,
    required this.namapel,
    required this.namaguru,
    required this.kehadiran,
    required this.pertemuan,
  });

  int idsiswa;
  String namaSiswa;
  String kelas;
  int tingkat;
  String namapel;
  String namaguru;
  String kehadiran;
  String pertemuan;

  factory Absensi.fromJson(Map<String, dynamic> json) => Absensi(
        idsiswa: json["idsiswa"],
        namaSiswa: json["nama_siswa"],
        kelas: json["kelas"],
        tingkat: json["tingkat"],
        namapel: json["namapel"],
        namaguru: json["namaguru"],
        kehadiran: json["kehadiran"],
        pertemuan: json["pertemuan"],
      );

  Map<String, dynamic> toJson() => {
        "idsiswa": idsiswa,
        "nama_siswa": namaSiswa,
        "kelas": kelas,
        "tingkat": tingkat,
        "namapel": namapel,
        "namaguru": namaguru,
        "kehadiran": kehadiran,
        "pertemuan": pertemuan,
      };
}

class BDepanSekarang {
  BDepanSekarang({
    this.blnSekarang,
    this.blnDepan,
  });

  String? blnSekarang;
  String? blnDepan;

  factory BDepanSekarang.fromJson(Map<String, dynamic> json) => BDepanSekarang(
        blnSekarang: json["blnSekarang"],
        blnDepan: json["blnDepan"],
      );

  Map<String, dynamic> toJson() => {
        "blnSekarang": blnSekarang,
        "blnDepan": blnDepan,
      };
}

class Batasmateri {
  Batasmateri({
    required this.namaguru,
    required this.namakelas,
    required this.namapel,
    required this.materi,
    required this.tugas,
    required this.tanggal,
    required this.semesterid,
  });

  String namaguru;
  String namakelas;
  String namapel;
  String materi;
  String tugas;
  DateTime tanggal;
  int semesterid;

  factory Batasmateri.fromJson(Map<String, dynamic> json) => Batasmateri(
        namaguru: json["namaguru"],
        namakelas: json["namakelas"],
        namapel: json["namapel"],
        materi: json["materi"],
        tugas: json["tugas"],
        tanggal: DateTime.parse(json["tanggal"]),
        semesterid: json["semesterid"],
      );

  Map<String, dynamic> toJson() => {
        "namaguru": namaguru,
        "namakelas": namakelas,
        "namapel": namapel,
        "materi": materi,
        "tugas": tugas,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "semesterid": semesterid,
      };
}

class NilaiDashboard {
  NilaiDashboard({
    required this.idsiswa,
    required this.tahunajaran,
    required this.tipesemester,
    required this.nama,
    required this.namapel,
    required this.realnamapel,
    required this.tanggal,
    required this.tipe,
    required this.nilainya,
    required this.idmpel,
    required this.idguru,
  });

  int idsiswa;
  String? tahunajaran;
  int tipesemester;
  String nama;
  String namapel;
  String realnamapel;
  DateTime tanggal;
  String? tipe;
  int nilainya;
  int idmpel;
  int idguru;

  factory NilaiDashboard.fromJson(Map<String, dynamic> json) => NilaiDashboard(
        idsiswa: json["idsiswa"],
        tahunajaran: json["tahunajaran"],
        tipesemester: json["tipesemester"],
        nama: json["nama"],
        namapel: json["namapel"],
        realnamapel: json["realnamapel"],
        tanggal: DateTime.parse(json["tanggal"]),
        tipe: json["tipe"],
        nilainya: json["nilainya"],
        idmpel: json["idmpel"],
        idguru: json["idguru"],
      );

  Map<String, dynamic> toJson() => {
        "idsiswa": idsiswa,
        "tahunajaran": tahunajaran,
        "tipesemester": tipesemester,
        "nama": nama,
        "namapel": namapel,
        "realnamapel": realnamapel,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "tipe": tipe,
        "nilainya": nilainya,
        "idmpel": idmpel,
        "idguru": idguru,
      };
}

class NilaiDashboardGrafik {
    NilaiDashboardGrafik({
        required this.mid,
        required this.uas,
        required this.idsiswa,
        required this.tahun,
        required this.nama,
        required this.namapel,
        required this.realnamapel,
        required this.idmpel,
        required this.tahunajaran,
    });

    int mid;
    int uas;
    int idsiswa;
    int tahun;
    String nama;
    String namapel;
    String realnamapel;
    int idmpel;
    String tahunajaran;

    factory NilaiDashboardGrafik.fromJson(Map<String, dynamic> json) => NilaiDashboardGrafik(
        mid: json["MID"],
        uas: json["UAS"],
        idsiswa: json["idsiswa"],
        tahun: json["tahun"],
        nama: json["nama"],
        namapel: json["namapel"],
        realnamapel: json["realnamapel"],
        idmpel: json["idmpel"],
        tahunajaran: json["tahunajaran"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "UAS": uas,
        "idsiswa": idsiswa,
        "tahun": tahun,
        "nama": nama,
        "namapel": namapel,
        "realnamapel": realnamapel,
        "idmpel": idmpel,
        "tahunajaran": tahunajaran,
    };
}

class Showtanggungan {
  Showtanggungan({
    required this.nama,
    required this.namatingkat,
    required this.ortuid,
    required this.namaortu,
    this.propicortu,
    required this.idsiswa,
    required this.namasiswa,
    required this.noinduk,
    required this.ppsiswa,
    required this.tempatLahir,
    required this.agama,
    required this.alamat,
    required this.jenisKelamin,
    required this.nisn,
  });

  String nama;
  String namatingkat;
  int ortuid;
  String namaortu;
  dynamic propicortu;
  int idsiswa;
  String namasiswa;
  String noinduk;
  String ppsiswa;
  String tempatLahir;
  String agama;
  String alamat;
  String jenisKelamin;
  String nisn;

  factory Showtanggungan.fromJson(Map<String, dynamic> json) => Showtanggungan(
        nama: json["nama"],
        namatingkat: json["namatingkat"],
        ortuid: json["ortuid"],
        namaortu: json["namaortu"],
        propicortu: json["propicortu"],
        idsiswa: json["idsiswa"],
        namasiswa: json["namasiswa"],
        noinduk: json["noinduk"],
        ppsiswa: json["ppsiswa"],
        tempatLahir: json["tempat_lahir"],
        agama: json["agama"],
        alamat: json["alamat"],
        jenisKelamin: json["jenis_kelamin"],
        nisn: json["nisn"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "namatingkat": namatingkat,
        "ortuid": ortuid,
        "namaortu": namaortu,
        "propicortu": propicortu,
        "idsiswa": idsiswa,
        "namasiswa": namasiswa,
        "noinduk": noinduk,
        "ppsiswa": ppsiswa,
        "tempat_lahir": tempatLahir,
        "agama": agama,
        "alamat": alamat,
        "jenis_kelamin": jenisKelamin,
        "nisn": nisn,
      };
}

class Tahfi {
  Tahfi({
    required this.ayat,
    required this.nama,
    required this.idsiswa,
    required this.surah,
    required this.tgl,
  });

  String ayat;
  String nama;
  int idsiswa;
  String surah;
  DateTime tgl;

  factory Tahfi.fromJson(Map<String, dynamic> json) => Tahfi(
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
        "tgl":
            "${tgl.year.toString().padLeft(4, '0')}-${tgl.month.toString().padLeft(2, '0')}-${tgl.day.toString().padLeft(2, '0')}",
      };
}

class Total {
  Total({
    required this.count,
  });

  int count;

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => MapEntry(v, k));
    }
    return reverseMap;
  }
}
