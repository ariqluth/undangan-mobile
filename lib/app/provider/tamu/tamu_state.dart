import 'package:equatable/equatable.dart';
import 'package:myapp/app/models/tamu.dart';

abstract class TamuState extends Equatable {
  const TamuState();
}

class TamuInitial extends TamuState {
  @override
  List<Object> get props => [];
}

class TamuLoading extends TamuState {
  @override
  List<Object> get props => [];
}

class TamuLoaded extends TamuState {
  final List<Tamu> tamus;

  const TamuLoaded(this.tamus);

  @override
  List<Object> get props => [tamus];
}

class TamuError extends TamuState {
  final String message;

  const TamuError(this.message);

  @override
  List<Object> get props => [message];
}
class TamuEmpty extends TamuState {
  final String message;

  const TamuEmpty(this.message);

  @override
  List<Object> get props => [message];
}