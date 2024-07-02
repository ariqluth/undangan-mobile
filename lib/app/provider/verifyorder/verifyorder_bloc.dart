import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';
import 'verifyorder_event.dart';
import 'verifyorder_state.dart';

class OrderVerifyBloc extends Bloc<OrderVerifyEvent, OrderVerifyState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  OrderVerifyBloc(this.apiService, this.authProvider) : super(OrderVerifyInitial()) {
    on<GetOrderVerify>(_onGetOrderVerify);
    on<CreateOrderVerify>(_onCreateOrderVerify);
    on<UpdateOrderVerify>(_onUpdateOrderVerify);
    on<DeleteOrderVerify>(_onDeleteOrderVerify);
    on<ShowOrderVerify>(_ShowOrderVerify);
    on<GetOrderVerifyByPetugas>(_GetOrderVerifyByPetugas);
  }

  void _onGetOrderVerify(GetOrderVerify event, Emitter<OrderVerifyState> emit) async {
    emit(OrderVerifyLoading());
    try {
      final orderVerify = await apiService.getOrderVerify(authProvider.token!);
      emit(OrderVerifyLoaded(orderVerify));
    } catch (e) {
      print('Error loading OrdersVerify: $e');
      emit(OrderVerifyError(e.toString()));
    }
  }

  void _onCreateOrderVerify(CreateOrderVerify event, Emitter<OrderVerifyState> emit) async {
    debugPrint('Creating order verification for order: ${event.orderId}');
    emit(OrderVerifyLoading());
    try {
      await apiService.createOrderVerify(event.orderId, event.profileId, authProvider.token!);
      debugPrint('Order verification created for order: ${event.orderId}');
    } catch (e) {
      debugPrint('Error creating OrderVerify: $e');
      emit(OrderVerifyError(e.toString()));
    }
  }

  void _onUpdateOrderVerify(UpdateOrderVerify event, Emitter<OrderVerifyState> emit) async {
    emit(OrderVerifyLoading());
    try {
      await apiService.UpdateOrderVerify(event.id, event.orderverify, authProvider.token!);
      final orderVerify = await apiService.getOrderVerify(authProvider.token!);
      emit(OrderVerifyLoaded(orderVerify));
    } catch (e) {
      print('Error updating OrderVerify: $e');
      emit(OrderVerifyError(e.toString()));
    }
  }

  void _ShowOrderVerify(ShowOrderVerify event, Emitter<OrderVerifyState> emit) async {
    emit(OrderVerifyLoading());
    try {
      final orderVerify = await apiService.showOrderVerify(event.id, authProvider.token!);
      emit(OrderVerifyLoaded([orderVerify]));
    } catch (e) {
      print('Error loading OrderVerify: $e');
      emit(OrderVerifyError(e.toString()));
    }
  }

  void _onDeleteOrderVerify(DeleteOrderVerify event, Emitter<OrderVerifyState> emit) async {
    emit(OrderVerifyLoading());
    try {
      await apiService.DeleteOrderVerify(event.id, authProvider.token!);
      final orderVerify = await apiService.getOrderVerify(authProvider.token!);
      emit(OrderVerifyLoaded(orderVerify));
    } catch (e) {
      print('Error deleting OrderVerify: $e');
      emit(OrderVerifyError(e.toString()));
    }
  }

  void _GetOrderVerifyByPetugas(GetOrderVerifyByPetugas event, Emitter<OrderVerifyState> emit) async {
    emit(OrderVerifyLoading());
    try {
      await apiService.getVerifybypetugas(event.id_petugas, authProvider.token!);
      final orderVerify = await apiService.getVerifybypetugas(event.id_petugas, authProvider.token!);
      emit(OrderVerifyLoaded(orderVerify));
    } catch (e) {
      print('Error loading OrderVerifyByPetugas: $e');
      emit(OrderVerifyError(e.toString()));
    }
  }
}
