class Order {
  final int? id;
  final int profileId;
  final int itemId;
  final String tanggalTerakhir;
  final String kode;
  final String jumlah;
  final String status;

  Order({
    this.id,
    required this.profileId,
    required this.itemId,
    required this.tanggalTerakhir,
    required this.kode,
    required this.jumlah,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      profileId: json['profile_id'],
      itemId: json['item_id'],
      tanggalTerakhir: json['tanggal_terakhir'],
      kode: json['kode'],
      jumlah: json['jumlah'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'item_id': itemId,
      'tanggal_terakhir': tanggalTerakhir,
      'kode': kode,
      'jumlah': jumlah,
      'status': status,
    };
  }
}
