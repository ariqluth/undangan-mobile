class Tamu {
  final int id;
  final int undanganId;
  final String namaTamu;
  final String emailTamu;
  final String alamatTamu;
  final String nomerTamu;
  final String status;
  final String kategori;
  final String kodeqr;
  final String tipeUndangan;

  Tamu({
    required this.id,
    required this.undanganId,
    required this.namaTamu,
    required this.emailTamu,
    required this.alamatTamu,
    required this.nomerTamu,
    required this.status,
    required this.kategori,
    required this.kodeqr,
    required this.tipeUndangan,
  });

  factory Tamu.fromJson(Map<String, dynamic> json) {
    return Tamu(
      id: json['id'],
      undanganId: json['undangan_id'],
      namaTamu: json['nama_tamu'],
      emailTamu: json['email_tamu'],
      alamatTamu: json['alamat_tamu'],
      nomerTamu: json['nomer_tamu'],
      status: json['status'],
      kategori: json['kategori'],
      kodeqr: json['kodeqr'],
      tipeUndangan: json['tipe_undangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'undangan_id': undanganId,
      'nama_tamu': namaTamu,
      'email_tamu': emailTamu,
      'alamat_tamu': alamatTamu,
      'nomer_tamu': nomerTamu,
      'status': status,
      'kategori': kategori,
      'kodeqr': kodeqr,
      'tipe_undangan': tipeUndangan,
    };
  }
}
