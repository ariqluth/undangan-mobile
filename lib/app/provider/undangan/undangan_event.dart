import 'package:equatable/equatable.dart';
import 'package:myapp/app/models/undangan.dart'; 

abstract class UndanganEvent extends Equatable {
  const UndanganEvent();
}

class GetUndangans extends UndanganEvent {
  @override
  List<Object> get props => [];
}

class CreateUndangan extends UndanganEvent {
  final int order_id;
  final int order_list_id;
  final String nama_pengantin_pria;
  final String nama_pengantin_wanita;
  final String tanggal_pernikahan;
  final String lokasi_pernikahan;
  final String longitude;
  final String latitude;


 const CreateUndangan({
    required this.order_id,
    required this.order_list_id,
    required this.nama_pengantin_pria,
    required this.nama_pengantin_wanita,
    required this.tanggal_pernikahan,
    required this.lokasi_pernikahan,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [
        order_id,
        order_list_id,
        nama_pengantin_pria,
        nama_pengantin_wanita,
        tanggal_pernikahan,
        lokasi_pernikahan,
        latitude,
        longitude,
      ];
}

class UpdateUndangan extends UndanganEvent {
  final int id;
  final Undangan undangan;

  const UpdateUndangan(this.id, this.undangan);

  @override
  List<Object> get props => [id, undangan];
}

class ShowUndangan extends UndanganEvent {
  final int id;

  const ShowUndangan(this.id);

  @override
  List<Object> get props => [id];
}

class ShowUndanganbypetugas extends UndanganEvent {
  final int order_list_id;

  const ShowUndanganbypetugas(this.order_list_id);

  @override
  List<Object> get props => [order_list_id];
}



class ShowUndanganProfile extends UndanganEvent {
  final int id;

  const ShowUndanganProfile(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteUndangan extends UndanganEvent {
  final int id;

  const DeleteUndangan(this.id);

  @override
  List<Object> get props => [id];
}

class BroadcastUndangan extends UndanganEvent {
  final int id;

  const BroadcastUndangan(this.id);

  @override
  List<Object> get props => [id];
}

