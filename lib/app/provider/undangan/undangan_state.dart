import 'package:equatable/equatable.dart';

abstract class UndanganState extends Equatable {
  const UndanganState();

  @override
  List<Object> get props => [];
}

class UndanganInitial extends UndanganState {}

class UndanganLoading extends UndanganState {}

class UndanganLoaded extends UndanganState {
  final List<dynamic> undangans;

  const UndanganLoaded(this.undangans);

  @override
  List<Object> get props => [undangans];
}

class UndanganEmpty extends UndanganState {
  final String message;

  const UndanganEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class UndanganError extends UndanganState {
  final String message;

  const UndanganError(this.message);

  @override
  List<Object> get props => [message];
}
