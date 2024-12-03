import 'package:flutter/material.dart';

class Berita {
  int id;
  String? photo;
  int mesjidId;
  String? tajuk;
  String? perenggan;
  DateTime? tanggal;
  String? acaraAwal;
  String? acaraAkhir;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Berita({
    required this.id,
    this.photo,
    required this.mesjidId,
    this.tajuk,
    this.perenggan,
    this.tanggal,
    this.acaraAwal,
    this.acaraAkhir,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Berita.fromJson(Map<String, dynamic> json) => Berita(
        id: json["id"],
        photo: json["photo"] ?? "",
        mesjidId: json["mesjid_id"],
        tajuk: json["tajuk"] ?? "",
        perenggan: json["perenggan"] ?? "",
        tanggal: json["tanggal"] != null ? DateTime.parse(json["tanggal"]) : null,
        acaraAwal: json["acara_awal"],
        acaraAkhir: json["acara_akhir"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo ?? "",
        "mesjid_id": mesjidId,
        "tajuk": tajuk ?? "",
        "perenggan": perenggan ?? "",
        "tanggal": tanggal?.toIso8601String(),
        "acara_awal": acaraAwal,
        "acara_akhir": acaraAkhir,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  String getStatusText() {
    if (status == 0) {
      return "Arkib";
    } else if (status == 1) {
      return "Akan Datang";
    } else {
      return "Unknown"; // Jika status tidak sesuai dengan 0 atau 1
    }
  }

  Color getStatusColor() {
    if (status == 0) {
      return const Color(0xFF22C55E); // Warna untuk status "Arkib"
    } else if (status == 1) {
      return const Color(0xFFF9A109); // Warna untuk status "Akan Datang"
    } else {
      return Colors.black; // Warna default jika status tidak dikenali
    }
  }
}
