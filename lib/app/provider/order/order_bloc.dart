// Order_bloc.dart
import 'package:bloc/bloc.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  OrderBloc(this.apiService, this.authProvider) : super(OrderInitial()) {
    on<GetOrders>(_onGetOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrder>(_onUpdateOrder);
    on<DeleteOrder>(_onDeleteOrder);
    on<showOrder>(_showOrder);
    on<showOrderProfile>(_showOrderProfile);
    on<ShowDropdown>(_showDropdown);
    on<BroadcastOrder>(_onBroadcastOrder);
    on<CloseOrder>(_onCloseOrder);
    on<verifyStatusOrder>(_onVerifyStatusOrder);
  }

  void _onGetOrders(GetOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final Orders = await apiService.getOrders(authProvider.token!);
      emit(OrderLoaded(Orders));
    } catch (e) {
      print('Error loading Orders: $e');
      emit(OrderError(e.toString()));
    }
  }


  void _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await apiService.createOrder(event.order, authProvider.token!);
      final Orders = await apiService.getOrders(authProvider.token!);
      emit(OrderLoaded(Orders));
    } catch (e) {
      // print('Error creating Order: $e');
      emit(OrderError(e.toString()));
    }
  }

  void _onUpdateOrder(UpdateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await apiService.updateOrder(event.id, event.order, authProvider.token!);
      final Orders = await apiService.getOrders(authProvider.token!);
      emit(OrderLoaded(Orders));
    } catch (e) {
      print('Error updating Order: $e');
      emit(OrderError(e.toString()));
    }
  }

  void _showOrder(showOrder event, Emitter<OrderState> emit) async{
    emit(OrderLoading());
    try{
      final Order = await apiService.showOrder(event.id, authProvider.token!);
      emit(OrderLoaded([Order]));
    }catch(e){
      print('Error loading Order: $e');
      emit(OrderError(e.toString()));
    }
  }

   void _showOrderProfile(showOrderProfile event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await apiService.showOrderProfile(event.id, authProvider.token!);
      emit(OrderLoaded(orders));
    } catch (e) {
      print('Error loading orders: $e');
      emit(OrderError(e.toString()));
    }
  }

void _showDropdown(ShowDropdown event, Emitter<OrderState> emit) async {
  emit(OrderLoading());

  try {
    final orders = await apiService.showdropdown(event.orderListId, authProvider.token!);

    // Print the token for debugging
    print("Token: ${authProvider.token}");

    // Print each order for debugging
    for (var order in orders) {
      print("Order ID: ${order.id}, Jumlah: ${order.jumlah}");
    }

    emit(OrderLoaded(orders));
  } catch (e) {
    print('Error loading orders dropdown cok: $e');
    emit(OrderError(e.toString()));
  }
}


 void _onDeleteOrder(DeleteOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await apiService.deleteOrder(event.id, authProvider.token!);
      final Orders = await apiService.getOrders(authProvider.token!);
      emit(OrderLoaded(Orders));
    } catch (e) {
      print('Error deleting Order: $e');
      emit(OrderError(e.toString()));
    }
  }

  void _onBroadcastOrder(BroadcastOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await apiService.broadcastOrder(event.id, authProvider.token!);
      final orders = await apiService.getOrders(authProvider.token!);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

   void _onCloseOrder(CloseOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await apiService.closeOrder(event.id, authProvider.token!);
      final orders = await apiService.getOrders(authProvider.token!);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void _onVerifyStatusOrder(verifyStatusOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await apiService.verifyStatusOrder(authProvider.token!);
      final orders = await apiService.verifyStatusOrder(authProvider.token!);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}