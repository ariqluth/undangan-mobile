import 'package:equatable/equatable.dart';
import 'package:myapp/app/models/orderverify.dart';

abstract class OrderVerifyState extends Equatable {
  const OrderVerifyState();
}

class OrderVerifyInitial extends OrderVerifyState {
  @override
  List<Object> get props => [];
}

class OrderVerifyLoading extends OrderVerifyState {
  @override
  List<Object> get props => [];
}

class OrderVerifyLoaded extends OrderVerifyState {
  final List<OrderVerify> OrdersVerify;

  const OrderVerifyLoaded(this.OrdersVerify);

  @override
  List<Object> get props => [OrdersVerify];
}

class OrderVerifyError extends OrderVerifyState {
  final String message;

  const OrderVerifyError(this.message);

  @override
  List<Object> get props => [message];
}
