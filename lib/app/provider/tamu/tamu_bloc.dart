// Tamu_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:myapp/app/provider/tamu/tamu_event.dart';
import 'package:myapp/app/provider/tamu/tamu_state.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';


class TamuBloc extends Bloc<TamuEvent, TamuState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  TamuBloc(this.apiService, this.authProvider) : super(TamuInitial()) {
    on<GetTamu>(_onGetTamu);
    on<CreateTamu>(_onCreateTamu); 
    on<UpdateTamu>(_onUpdateTamu);
    on<DeleteTamu>(_onDeleteTamu);
    on<ShowTamu>(_onShowTamu);
    on<ShowTamubypetugas>(_showTamuByPetugas);
    on<SearchTamuEvent>(_onSearchTamu);
    on<ImportTamuEvent>(_onImportTamu);
  }

  void _onGetTamu(GetTamu event, Emitter<TamuState> emit) async {
    emit(TamuLoading());
    try {
      final Tamus = await apiService.getTamu(authProvider.token!);
      emit(TamuLoaded(Tamus));
    } catch (e) {
      print('Error loading Tamus: $e');
      emit(TamuError(e.toString()));
    }
  }

 void _onCreateTamu(CreateTamu event, Emitter<TamuState> emit) async {
  emit(TamuLoading());
  try {
    await apiService.createTamu(
      event.undangan_id,
      event.nama_tamu,
      event.email_tamu,
      event.alamat_tamu,
      event.nomer_tamu,
      event.status,
      event.kategori,
      event.kodeqr,
      event.tipe_undangan,
      authProvider.token!,
    );

    final tamus = await apiService.getTamu(authProvider.token!);

    // Emit the loaded state with the updated list of Tamus
    emit(TamuLoaded(tamus));
  } catch (e) {
    print('Error creating Tamu: $e');
    emit(TamuError(e.toString()));
  }
}


  void _onUpdateTamu(UpdateTamu event, Emitter<TamuState> emit) async {
    emit(TamuLoading());
    try {
      await apiService.updateTamu(event.user_id, event.tamu, authProvider.token!);
      final Tamus = await apiService.getTamu(authProvider.token!);
      emit(TamuLoaded(Tamus));
    } catch (e) {
      print('Error updating Tamu: $e');
      emit(TamuError(e.toString()));
    }
  }

   void _onShowTamu(ShowTamu event, Emitter<TamuState> emit) async {
  emit(TamuLoading());

  try {
    final tamu = await apiService.showTamu(event.id, authProvider.token!);
    emit(TamuLoaded([tamu])); 
  } catch (e) {
    print('Error Show Tamu: $e');
    emit(TamuError(e.toString()));
  }
}

  void _onDeleteTamu(DeleteTamu event, Emitter<TamuState> emit) async {
    emit(TamuLoading());
    try {
      await apiService.deleteTamu(event.id, authProvider.token!);
      final Tamus = await apiService.getTamu(authProvider.token!);
      emit(TamuLoaded(Tamus));
    } catch (e) {
      print('Error deleting Tamu: $e');
      emit(TamuError(e.toString()));
    }
  }

   void _showTamuByPetugas(ShowTamubypetugas event, Emitter<TamuState> emit) async {
    emit(TamuLoading());
  try {
    final token = authProvider.token!;
    final tamuList = await apiService.ShowTamubyPetugas(event.undangan_id, token);
    emit(TamuLoaded(tamuList));
  } catch (e) {
    print('Error loading Tamu by petugas: $e');
    emit(TamuError('Failed to load tamu list'));
  }
}

 void _onSearchTamu(SearchTamuEvent event, Emitter<TamuState> emit) {
    if (state is TamuLoaded) {
      final tamuList = (state as TamuLoaded).tamus;
      final filteredTamus = tamuList.where((tamu) {
        return tamu.nama_tamu!.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(TamuLoaded(filteredTamus));
    }
  }

  void _onImportTamu(ImportTamuEvent event, Emitter<TamuState> emit) async {
    emit(TamuLoading());
    try {
      // Simpan data yang diimpor ke dalam database
      for (var tamu in event.tamus) {
        await apiService.createTamu(
          tamu.undangan_id!,
          tamu.nama_tamu!,
          tamu.email_tamu!,
          tamu.alamat_tamu!,
          tamu.nomer_tamu!,
          tamu.status!,
          tamu.kategori!,
          tamu.kodeqr!,
          tamu.tipe_undangan!,
          authProvider.token!,
        );
      }

      // Ambil daftar tamu yang diperbarui dari database
      final tamus = await apiService.ShowTamubyPetugas(event.undangan_id, authProvider.token!);
      emit(TamuLoaded(tamus));
    } catch (e) {
      print('Error importing Tamus: $e');
      emit(TamuError('Failed to import tamus'));
    }
  }

}
