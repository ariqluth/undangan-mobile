import 'package:equatable/equatable.dart';
import 'package:myapp/app/models/orderverify.dart';

abstract class OrderVerifyEvent extends Equatable {
  const OrderVerifyEvent();
}

class GetOrderVerify extends OrderVerifyEvent {
  @override
  List<Object> get props => [];
}


class CreateOrderVerify extends OrderVerifyEvent {
  final int orderId;
  final int profileId;

  const CreateOrderVerify(this.orderId, this.profileId);

  @override
  List<Object> get props => [OrderVerify];
}

class UpdateOrderVerify extends OrderVerifyEvent {
  final int id;
  final OrderVerify orderverify;

  const UpdateOrderVerify(this.id, this.orderverify);

  @override
  List<Object> get props => [id, OrderVerify];
}

class ShowOrderVerify extends OrderVerifyEvent {
  final int id;

  const ShowOrderVerify(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteOrderVerify extends OrderVerifyEvent {
  final int id;

  const DeleteOrderVerify(this.id);

  @override
  List<Object> get props => [id];
}

class GetOrderVerifyByPetugas extends OrderVerifyEvent {
  final int id_petugas;

  const GetOrderVerifyByPetugas(this.id_petugas);

  @override
  List<Object> get props => [id_petugas];
}

