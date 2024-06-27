// profile_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/profile.dart';
import '../../service/api_service.dart';
import '../../service/auth.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiService apiService;
  final AuthProvider authProvider;

  ProfileBloc(this.apiService, this.authProvider) : super(ProfileInitial()) {
    on<GetProfiles>(_onGetProfiles);
    on<CreateProfile>(_onCreateProfile); 
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }

  void _onGetProfiles(GetProfiles event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profiles = await apiService.getProfile(authProvider.token!);
      emit(ProfileLoaded(profiles));
    } catch (e) {
      print('Error loading Profiles: $e');
      emit(ProfileError(e.toString()));
    }
  }

  void _onCreateProfile(CreateProfile event, Emitter<ProfileState> emit) async { 
    emit(ProfileLoading());
    try {
      await apiService.createProfile(event.profile, authProvider.token!);
      final profiles = await apiService.getProfile(authProvider.token!);
      emit(ProfileLoaded(profiles));
    } catch (e) {
      print('Error creating Profile: $e');
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await apiService.updateProfile(event.id, event.profile, authProvider.token!);
      final profiles = await apiService.getProfile(authProvider.token!);
      emit(ProfileLoaded(profiles));
    } catch (e) {
      print('Error updating Profile: $e');
      emit(ProfileError(e.toString()));
    }
  }

  void _onDeleteProfile(DeleteProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await apiService.deleteProfile(event.id, authProvider.token!);
      final profiles = await apiService.getProfile(authProvider.token!);
      emit(ProfileLoaded(profiles));
    } catch (e) {
      print('Error deleting Profile: $e');
      emit(ProfileError(e.toString()));
    }
  }
}
