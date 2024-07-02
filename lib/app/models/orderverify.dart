class OrderVerify {
  final int? id;
  final int? orderId;
  final int? profileId;
  final String? nama_pelanggan;
  final int? item_id;
  final String? jumlah;
  final String? tanggal_terakhir;
  final String? kode;
  final String? status;
  final String? nama_item;
  final String? nama_petugas;
  final int? id_petugas;

  OrderVerify({
    this.id,
    required this.orderId,
    required this.profileId,
    this.nama_pelanggan,
    this.item_id,
    this.jumlah,
    this.tanggal_terakhir,
    this.kode,
    this.status,
    this.nama_item,
    this.nama_petugas,
    this.id_petugas,
  });

  factory OrderVerify.fromJson(Map<String, dynamic> json) {
    return OrderVerify(
      id: json['id'],
      orderId: json['order_id'],
      profileId: json['profile_id'],
      nama_pelanggan: json['nama_pelanggan'],
      item_id: json['item_id'],
      jumlah: json['jumlah'],
      tanggal_terakhir: json['tanggal_terakhir'],
      kode: json['kode'],
      status: json['status'],
      nama_item: json['nama_item'],
      nama_petugas: json['nama_petugas'],
      id_petugas: json['id_petugas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'profile_id': profileId,
      'nama_pelanggan': nama_pelanggan,
      'item_id': item_id,
      'jumlah': jumlah,
      'tanggal_terakhir': tanggal_terakhir,
      'kode': kode,
      'status': status,
      'nama_item': nama_item,
      'nama_petugas': nama_petugas,
      'id_petugas': id_petugas,
    };
  }
}
