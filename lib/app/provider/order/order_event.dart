import 'package:equatable/equatable.dart';
import 'dart:io';
import '../../models/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class GetOrders extends OrderEvent {
  @override
  List<Object> get props => [];
}


class CreateOrder extends OrderEvent {
  final Order order;

  const CreateOrder(this.order);

  @override
  List<Object> get props => [Order];
}

class UpdateOrder extends OrderEvent {
  final int id;
  final Order order;

  const UpdateOrder(this.id, this.order);

  @override
  List<Object> get props => [id, Order];
}

class showOrder extends OrderEvent {
  final int id;

  const showOrder(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteOrder extends OrderEvent {
  final int id;

  const DeleteOrder(this.id);

  @override
  List<Object> get props => [id];
}
