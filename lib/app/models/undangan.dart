class Undangan {
  final int? id;
  final int? order_id;
  final int? order_list_id;
  final String? nama_pengantin_pria;
  final String? nama_pengantin_wanita;
  final String? tanggal_pernikahan;
  final String? lokasi_pernikahan;
  final String? longitude;
  final String? latitude;

  Undangan({
    this.id,
    this.order_id,
    this.order_list_id,
    required this.nama_pengantin_pria,
    required this.nama_pengantin_wanita,
    required this.tanggal_pernikahan,
    required this.lokasi_pernikahan,
    required this.longitude,
    required this.latitude,
  });

  factory Undangan.fromJson(Map<String, dynamic> json) => Undangan(
        id: json["id"],
        order_id: json["order_id"],
        order_list_id: json["order_list_id"],
        nama_pengantin_pria: json["nama_pengantin_pria"],
        nama_pengantin_wanita: json["nama_pengantin_wanita"],
        tanggal_pernikahan: json["tanggal_pernikahan"],
        lokasi_pernikahan: json["lokasi_pernikahan"],
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": order_id,
        "order_list_id": order_list_id,
        "nama_pengantin_pria": nama_pengantin_pria,
        "nama_pengantin_wanita": nama_pengantin_wanita,
        "tanggal_pernikahan": tanggal_pernikahan,
        "lokasi_pernikahan": lokasi_pernikahan,
        "longitude": longitude,
        "latitude": latitude,
      };
}
