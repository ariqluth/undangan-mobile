import 'package:equatable/equatable.dart';
import '../../models/item.dart';

abstract class ItemState extends Equatable {
  const ItemState();
}

class ItemInitial extends ItemState {
  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemState {
  @override
  List<Object> get props => [];
}

class ItemLoaded extends ItemState {
  final List<Item> items;

  const ItemLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object> get props => [message];
}
