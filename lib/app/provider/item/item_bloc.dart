// item_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/item.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  ItemBloc(this.apiService, this.authProvider) : super(ItemInitial()) {
    on<GetItems>(_onGetItems);
    on<CreateItem>(_onCreateItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
  }

  void _onGetItems(GetItems event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      final items = await apiService.getItems(authProvider.token!);
      emit(ItemLoaded(items));
    } catch (e) {
      print('Error loading items: $e');
      emit(ItemError(e.toString()));
    }
  }

  void _onCreateItem(CreateItem event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      await apiService.createItem(event.item, authProvider.token!, event.imageFile);
      final items = await apiService.getItems(authProvider.token!);
      emit(ItemLoaded(items));
    } catch (e) {
      // print('Error creating item: $e');
      emit(ItemError(e.toString()));
    }
  }

  void _onUpdateItem(UpdateItem event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      await apiService.updateItem(event.id, event.item, authProvider.token!, event.imageFile);
      final items = await apiService.getItems(authProvider.token!);
      emit(ItemLoaded(items));
    } catch (e) {
      print('Error updating item: $e');
      emit(ItemError(e.toString()));
    }
  }

 void _onDeleteItem(DeleteItem event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      await apiService.deleteItem(event.id, authProvider.token!);
      final items = await apiService.getItems(authProvider.token!);
      emit(ItemLoaded(items));
    } catch (e) {
      print('Error deleting item: $e');
      emit(ItemError(e.toString()));
    }
  }
}