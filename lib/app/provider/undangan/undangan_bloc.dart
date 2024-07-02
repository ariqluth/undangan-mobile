import 'package:bloc/bloc.dart';

import 'package:myapp/app/provider/undangan/undangan_event.dart';
import 'package:myapp/app/provider/undangan/undangan_state.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';

class UndanganBloc extends Bloc<UndanganEvent, UndanganState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  UndanganBloc(this.apiService, this.authProvider) : super(UndanganInitial()) {
    on<GetUndangans>(_onGetUndangans);
    on<CreateUndangan>(_onCreateUndangan);
    on<UpdateUndangan>(_onUpdateUndangan);
    on<DeleteUndangan>(_onDeleteUndangan);
    on<ShowUndangan>(_showUndangan);
    on<ShowUndanganbypetugas>(_showUndanganByPetugas);
  }

  void _onGetUndangans(GetUndangans event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    try {
      final undangans = await apiService.getUndanganList(authProvider.token!);
      emit(UndanganLoaded(undangans));
    } catch (e) {
      print('Error loading undangans: $e');
      emit(UndanganError(e.toString()));
    }
  }

  void _onCreateUndangan(CreateUndangan event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    try {
      await apiService.createUndanganList(
        event.order_id,
        event.order_list_id,
        event.nama_pengantin_pria,
        event.nama_pengantin_wanita,
        event.tanggal_pernikahan,
        event.lokasi_pernikahan,
        event.latitude,
        event.longitude,
        authProvider.token!,
      );
      final undangans = await apiService.ShowUndanganbyPetugas(event.order_list_id, authProvider.token!);
      emit(UndanganLoaded([undangans['data']]));
    } catch (e) {
      print('Error creating undangan: $e');
      emit(UndanganError(e.toString()));
    }
  }

  void _onUpdateUndangan(UpdateUndangan event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    try {
      await apiService.UpdateUndangan(event.id, event.undangan, authProvider.token!);
      final undangans = await apiService.getUndanganList(authProvider.token!);
      emit(UndanganLoaded(undangans));
    } catch (e) {
      print('Error updating undangan: $e');
      emit(UndanganError(e.toString()));
    }
  }

  void _showUndangan(ShowUndangan event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    try {
      final undangan = await apiService.ShowUndangan(event.id, authProvider.token!);
      emit(UndanganLoaded([undangan]));
    } catch (e) {
      print('Error loading undangan: $e');
      emit(UndanganError(e.toString()));
    }
  }

  void _showUndanganByPetugas(ShowUndanganbypetugas event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    try {
      final response = await apiService.ShowUndanganbyPetugas(event.order_list_id, authProvider.token!);
      if (response['success']) {
        emit(UndanganLoaded(response['data']));
      } else {
        emit(UndanganEmpty(response['message']));
      }
    } catch (e) {
      print('Error loading undangan by petugas: $e');
      emit(UndanganError(e.toString()));
    }
  }

  void _onDeleteUndangan(DeleteUndangan event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    try {
      await apiService.DeleteUndangan(event.id, authProvider.token!);
      final undangans = await apiService.getUndanganList(authProvider.token!);
      emit(UndanganLoaded(undangans));
    } catch (e) {
      print('Error deleting undangan: $e');
      emit(UndanganError(e.toString()));
    }
  }
}
