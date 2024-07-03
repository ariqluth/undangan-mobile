class Tamu {
  final int? id;
  final int? undangan_id;
  final String? nama_tamu;
  final String? email_tamu;
  final String? alamat_tamu;
  final String? nomer_tamu;
  final String? status;
  final String? kategori;
  final String? kodeqr;
  final String? tipe_undangan;

  Tamu({
    this.id,
    this.undangan_id,
    this.nama_tamu,
    this.email_tamu,
    this.alamat_tamu,
    this.nomer_tamu,
    this.status,
    this.kategori,
    this.kodeqr,
    this.tipe_undangan,
  });

  factory Tamu.fromJson(Map<String, dynamic> json) {
    return Tamu(
      id: json['id'],
      undangan_id: json['undangan_id'],
      nama_tamu: json['nama_tamu'],
      email_tamu: json['email_tamu'],
      alamat_tamu: json['alamat_tamu'],
      nomer_tamu: json['nomer_tamu'],
      status: json['status'],
      kategori: json['kategori'],
      kodeqr: json['kodeqr'],
      tipe_undangan: json['tipe_undangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'undangan_id': undangan_id,
      'nama_tamu': nama_tamu,
      'email_tamu': email_tamu,
      'alamat_tamu': alamat_tamu,
      'nomer_tamu': nomer_tamu,
      'status': status,
      'kategori': kategori,
      'kodeqr': kodeqr,
      'tipe_undangan': tipe_undangan,
    };
  }
}
