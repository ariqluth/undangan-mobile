// Tamu_event.dart
import 'package:equatable/equatable.dart';
import 'package:myapp/app/models/tamu.dart';

abstract class TamuEvent extends Equatable {
  const TamuEvent();

  @override
  List<Object> get props => [];
}

class GetTamu extends TamuEvent {}

class CreateTamu extends TamuEvent { 
  final int undangan_id;
  final String nama_tamu;
  final String email_tamu;
  final String nomer_tamu;
  final String alamat_tamu;
  final String status;
  final String kategori;
  final String kodeqr;
  final String tipe_undangan;

  const CreateTamu({
    required this.undangan_id,
    required this.nama_tamu,
    required this.email_tamu,
    required this.nomer_tamu,
    required this.alamat_tamu,
    required this.status,
    required this.kategori,
    required this.kodeqr,
    required this.tipe_undangan,
  });

  @override
  List<Object> get props => [
    undangan_id,
    nama_tamu,
    email_tamu,
    nomer_tamu,
    alamat_tamu,
    status,
    kategori,
    kodeqr,
    tipe_undangan,
  ];
}

class UpdateTamu extends TamuEvent {
  final int user_id;
  final Tamu tamu;

  const UpdateTamu(this.user_id, this.tamu);

  @override
  List<Object> get props => [user_id, tamu];
}

class DeleteTamu extends TamuEvent {
  final int id;

  const DeleteTamu(this.id);

  @override
  List<Object> get props => [id];
}

class ShowTamu extends TamuEvent {
  final int id;

  const ShowTamu(this.id);

  @override
  List<Object> get props => [id];
}

class ShowTamubypetugas extends TamuEvent {
  final int undangan_id;

  const ShowTamubypetugas(this.undangan_id);

  @override
  List<Object> get props => [undangan_id];
}


class SearchTamuEvent extends TamuEvent {
  final String query;

  const SearchTamuEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ImportTamuEvent extends TamuEvent {
  final List<Tamu> tamus;
  final int undangan_id;

  ImportTamuEvent(this.tamus, this.undangan_id);

  @override
  List<Object> get props => [tamus, undangan_id];
}
