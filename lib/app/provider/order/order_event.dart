import 'package:equatable/equatable.dart';
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

class showOrderProfile extends OrderEvent {
  final int id;

  const showOrderProfile(this.id);

  @override
  List<Object> get props => [id];
}

class ShowDropdown extends OrderEvent {
  final int orderListId;

  const ShowDropdown(this.orderListId);

  @override
  List<Object> get props => [orderListId];
}

class DeleteOrder extends OrderEvent {
  final int id;

  const DeleteOrder(this.id);

  @override
  List<Object> get props => [id];
}

class BroadcastOrder extends OrderEvent {
  final int id;

  BroadcastOrder(this.id);

  @override
  List<Object> get props => [id];
}

class CloseOrder extends OrderEvent {
  final int id;

  CloseOrder(this.id);

  @override
  List<Object> get props => [id];
}

class verifyStatusOrder extends OrderEvent {
 @override
  List<Object> get props => [];
}
