// Order_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/order.dart';
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
}