class Order {
  final int? id;
  final int profile_id;
  final int item_id;
  final String tanggal_terakhir;
  final String kode;
  final String jumlah;
  final String status;
  final String? nama_item;
  final String? name;

  Order({
    this.id,
    required this.profile_id,
    required this.item_id,
    required this.tanggal_terakhir,
    required this.kode,
    required this.jumlah,
    required this.status,
    this.nama_item,
    this.name,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      profile_id: json['profile_id'],
      item_id: json['item_id'],
      tanggal_terakhir: json['tanggal_terakhir'],
      kode: json['kode'],
      jumlah: json['jumlah'],
      status: json['status'],
      nama_item: json['nama_item'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profile_id,
      'item_id': item_id,
      'tanggal_terakhir': tanggal_terakhir,
      'kode': kode,
      'jumlah': jumlah,
      'status': status,
      'nama_item': nama_item,
      'name': name,
    };
  }

  static List<Order> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Order.fromJson(json)).toList();
  }
}
