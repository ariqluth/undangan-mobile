import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/app/service/auth.dart';
import '../models/managementuser.dart';
import '../service/api_service.dart';
// Events
abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetUsers extends UserEvent {
  @override
  List<Object> get props => [];
}

class UpdateUserVerifiedAt extends UserEvent {
  final int id;
  final String emailVerifiedAt;

  const UpdateUserVerifiedAt(this.id, this.emailVerifiedAt);

  @override
  List<Object> get props => [id, emailVerifiedAt];
}

class UserVerifiedAt extends UserEvent {
  final int id;
  final String emailVerifiedAt;

  const UserVerifiedAt(this.id, this.emailVerifiedAt);

  @override
  List<Object> get props => [id, emailVerifiedAt];
}

// States
abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<Managementuser> users;

  const UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ManagementUserBlock extends Bloc<UserEvent, UserState> {
  final ApiService userRepository;
  final AuthProvider authProvider;

  ManagementUserBlock(this.userRepository, this.authProvider) : super(UserInitial()) {
    on<GetUsers>(_onGetUsers);
    on<UpdateUserVerifiedAt>(_onUpdateUserVerifiedAt);
    on<UserVerifiedAt>(_onUserVerifiedAt);
  }

   void _onGetUsers(GetUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await userRepository.getUsers(authProvider.token!);
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateUserVerifiedAt(UpdateUserVerifiedAt event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.updateUserVerifiedAt(event.id, event.emailVerifiedAt, authProvider.token!);
      final users = await userRepository.getUsers(authProvider.token!);
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

   void _onUserVerifiedAt(UserVerifiedAt event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.updateUserVerifiedAt(event.id, event.emailVerifiedAt, authProvider.token!);
      final users = await userRepository.getUsers(authProvider.token!);
      emit(UserLoaded(users));
    } catch (e) {
      print('Error verifying user: $e');
      emit(UserError(e.toString()));
    }
  }
}
