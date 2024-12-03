class Ajk {
  final int id;
  final String namaAjk;
  final int jabatanId; // Merubah tipe data dari String menjadi int untuk jabatan_id
  final int mesjidId;
  final String photo;
  final int status;
  final String createdAt;
  final String updatedAt;

  Ajk({
    required this.id,
    required this.namaAjk,
    required this.jabatanId,
    required this.mesjidId,
    required this.photo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ajk.fromJson(Map<String, dynamic> json) {
    return Ajk(
      id: json['id'],
      namaAjk: json['nama_ajk'],
      jabatanId: json['jabatan_id'], // Menggunakan 'jabatan_id' dari JSON
      mesjidId: json['mesjid_id'],
      photo: json['photo'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
