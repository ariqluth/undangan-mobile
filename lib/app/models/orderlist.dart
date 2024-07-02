class OrderList {
  final int? id;
  final int? nomerid;
  final int? profile_id;
  final int? item_id;
  final String? tanggal_terakhir;
  final String? kode;
  final String? kode_undangan;
  final String? jumlah;
  final String? status;
  final String? nama_item;
  final String? name;

  OrderList({
    this.id,
    this.nomerid,
    required this.profile_id,
    required this.item_id,
    required this.tanggal_terakhir,
    required this.kode,
    required this.jumlah,
    required this.status,
    required this.kode_undangan,
    this.nama_item,
    this.name,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      id: json['id'],
      nomerid: json['nomerid'],
      profile_id: json['profile_id'],
      item_id: json['item_id'],
      tanggal_terakhir: json['tanggal_terakhir'],
      kode: json['kode'],
      kode_undangan: json['kode_undangan'],
      jumlah: json['jumlah'],
      status: json['type_undangan'],
      nama_item: json['nama_item'],
      name: json['nama_petugas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomerid': nomerid,
      'profile_id': profile_id,
      'item_id': item_id,
      'tanggal_terakhir': tanggal_terakhir,
      'kode': kode,
      'kode_undangan': kode_undangan,
      'jumlah': jumlah,
      'status': status,
      'nama_item': nama_item,
      'name': name,
    };
  }

  static List<OrderList> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderList.fromJson(json)).toList();
  }
}
