import 'package:equatable/equatable.dart';
import 'package:myapp/app/models/orderlist.dart';


abstract class OrderListEvent extends Equatable {
  const OrderListEvent();
}

class GetOrderLists extends OrderListEvent {
  @override
  List<Object> get props => [];
}

class CreateOrderList extends OrderListEvent {
  final int orderId;
  final int verifyId;
  final int profileId;
  final String kode;
  final String type;

  const CreateOrderList(this.orderId, this.verifyId, this.profileId, this.kode, this.type);

  @override
  List<Object> get props => [orderId, verifyId, profileId, kode, type];
}

class UpdateOrderList extends OrderListEvent {
  final int id;
  final OrderList orderList;

  const UpdateOrderList(this.id, this.orderList);

  @override
  List<Object> get props => [id, OrderList];
}

class showOrderList extends OrderListEvent {
  final int id;

  const showOrderList(this.id);

  @override
  List<Object> get props => [id];

}

class showPetugasOrderList extends OrderListEvent {
  final int id_petugas;

  const showPetugasOrderList (this.id_petugas);

  @override
  List<Object> get props => [id_petugas];
}

class showOrderListProfile extends OrderListEvent {
  final int id;

  const showOrderListProfile(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteOrderList extends OrderListEvent {
  final int id;

  const DeleteOrderList(this.id);

  @override
  List<Object> get props => [id];
}

class BroadcastOrderList extends OrderListEvent {
  final int id;

  BroadcastOrderList(this.id);

  @override
  List<Object> get props => [id];
}

class CloseOrderList extends OrderListEvent {
  final int id;

  CloseOrderList(this.id);

  @override
  List<Object> get props => [id];
}

class verifyStatusOrderList extends OrderListEvent {
 @override
  List<Object> get props => [];
}
