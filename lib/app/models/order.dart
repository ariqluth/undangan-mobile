class Order {
  final int id;
  final int profileId;
  final String itemId;
  final String tanggalTerakhir;
  final String kode;
  final String status;

  Order({
    required this.id,
    required this.profileId,
    required this.itemId,
    required this.tanggalTerakhir,
    required this.kode,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      profileId: json['profile_id'],
      itemId: json['item_id'],
      tanggalTerakhir: json['tanggal_terakhir'],
      kode: json['kode'],
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
      'status': status,
    };
  }
}
