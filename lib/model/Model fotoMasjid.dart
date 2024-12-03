class FotoMasjid {
  final int id;
  final String namaFoto;
  final int mesjidId; // Relasi ke Masjid
  final String kategori; // Kategori foto
  final String photo;

  FotoMasjid({
    required this.id,
    required this.namaFoto,
    required this.mesjidId,
    required this.kategori,
    required this.photo,
  });

  factory FotoMasjid.fromJson(Map<String, dynamic> json) {
    return FotoMasjid(
      id: json['id'],
      namaFoto: json['nama_foto'],
      mesjidId: json['mesjid_id'],
      kategori: json['kategori'], // Menambahkan kategori
      photo: json['photo'],
    );
  }
}
