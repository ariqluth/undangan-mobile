class Item {
  final int? id;
  final int userId;
  final String gambar;
  final String namaItem;

  Item({this.id, required this.userId, required this.gambar, required this.namaItem});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id']),
      gambar: json['gambar'],
      namaItem: json['nama_item'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'gambar': gambar,
      'nama_item': namaItem,
    };
  }
}