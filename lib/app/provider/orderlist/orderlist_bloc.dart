// Orderlist_bloc.dart
import 'package:bloc/bloc.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';
import 'orderlist_event.dart';
import 'orderlist_state.dart';

class OrderlistBloc extends Bloc<OrderListEvent, OrderListState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  OrderlistBloc(this.apiService, this.authProvider) : super(OrderListInitial()) {
    on<GetOrderLists>(_onGetOrderlists);
    on<CreateOrderList>(_onCreateOrderlist);
    on<UpdateOrderList>(_onUpdateOrderlist);
    on<DeleteOrderList>(_onDeleteOrderlist);
    on<showOrderList>(_showOrderlist);
    on<showPetugasOrderList>(_showPetugasOrderList);
    // on<showOrderListProfile>(_showOrderlistProfile);
 
  }

  void _onGetOrderlists(GetOrderLists event, Emitter<OrderListState> emit) async {
    emit(OrderListLoading());
    try {
      final Orderlists = await apiService.getOrderList(authProvider.token!);
      emit(OrderListLoaded(Orderlists));
    } catch (e) {
      print('Error loading Orderlists: $e');
      emit(OrderListError(e.toString()));
    }
  }


 void _onCreateOrderlist(CreateOrderList event, Emitter<OrderListState> emit) async {
    emit(OrderListLoading());
    try {
      await apiService.createOrderList(event.orderId, event.verifyId, event.profileId, event.kode, event.type, authProvider.token!);
      final orderlists = await apiService.getOrderList(authProvider.token!);
      emit(OrderListLoaded(orderlists));
    } catch (e) {
      emit(OrderListError(e.toString()));
    }
  }


  void _onUpdateOrderlist(UpdateOrderList event, Emitter<OrderListState> emit) async {
    emit(OrderListLoading());
    try {
      await apiService.UpdateOrderList(event.id, event.orderList, authProvider.token!);
      final Orderlists = await apiService.getOrderList(authProvider.token!);
      emit(OrderListLoaded(Orderlists));
    } catch (e) {
      print('Error updating Orderlist: $e');
      emit(OrderListError(e.toString()));
    }
  }

  void _showOrderlist(showOrderList event, Emitter<OrderListState> emit) async{
    emit(OrderListLoading());
    try{
      final Orderlist = await apiService.showOrderList(event.id, authProvider.token!);
      emit(OrderListLoaded([Orderlist]));
    }catch(e){
      print('Error loading Orderlist: $e');
      emit(OrderListError(e.toString()));
    }
  }

  void _showPetugasOrderList(showPetugasOrderList event, Emitter<OrderListState> emit) async{
    emit(OrderListLoading());
    try{
    final Orderlists = await apiService.showPetugasOrderList(event.id_petugas,authProvider.token!);
      emit(OrderListLoaded(Orderlists));
    } catch (e) {
      print('Error loading Orderlists: $e');
      emit(OrderListError(e.toString()));
    }
  }

  //  void _showOrderlistProfile(showOrderListProfile event, Emitter<OrderListState> emit) async {
  //   emit(OrderListLoading());
  //   try {
  //     final orderlists = await apiService.showOrderList(event.id, authProvider.token!);
  //     emit(OrderListLoaded(orderlists));
  //   } catch (e) {
  //     print('Error loading orderlists: $e');
  //     emit(OrderListError(e.toString()));
  //   }
  // }

 void _onDeleteOrderlist(DeleteOrderList event, Emitter<OrderListState> emit) async {
    emit(OrderListLoading());
    try {
      await apiService.DeleteOrderList(event.id, authProvider.token!);
      final Orderlists = await apiService.getOrderList(authProvider.token!);
      emit(OrderListLoaded(Orderlists));
    } catch (e) {
      print('Error deleting Orderlist: $e');
      emit(OrderListError(e.toString()));
    }
  }

}