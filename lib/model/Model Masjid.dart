class Masjid {
  final int id;
  final String namaMesjid;
  final String address;
  final String daerah;
  final double latitude;
  final double longitude;
  final int capacity;
  final DateTime tahunBuka;
  final String noTelp;
  final String emailMesjid;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int tabungan; // Tambah properti tabungan

  Masjid({
    required this.id,
    required this.namaMesjid,
    required this.address,
    required this.daerah,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.tahunBuka,
    required this.noTelp,
    required this.emailMesjid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.tabungan, // Tambah properti tabungan
  });

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      id: json['id'],
      namaMesjid: json['nama_mesjid'],
      address: json['address'],
      daerah: json['daerah'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      capacity: json['capacity'],
      tahunBuka: DateTime.parse(json['tahun_buka']),
      noTelp: json['no_telp'],
      emailMesjid: json['email_mesjid'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      tabungan: json['tabungan'], // Ambil nilai tabungan dari JSON
    );
  }
}
