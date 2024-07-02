import 'package:equatable/equatable.dart';
import '../../models/orderlist.dart';

abstract class OrderListState extends Equatable {
  const OrderListState();
}

class OrderListInitial extends OrderListState {
  @override
  List<Object> get props => [];
}

class OrderListLoading extends OrderListState {
  @override
  List<Object> get props => [];
}

class OrderListLoaded extends OrderListState {
  final List<OrderList> OrderLists;

  const OrderListLoaded(this.OrderLists);

  @override
  List<Object> get props => [OrderLists];
}

class OrderListError extends OrderListState {
  final String message;

  const OrderListError(this.message);

  @override
  List<Object> get props => [message];
}
