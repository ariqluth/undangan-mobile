import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  ManagementUserBlock(this.userRepository) : super(UserInitial());

  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUsers) {
      yield UserLoading();
      try {
        final users = await userRepository.getUsers();
        yield UserLoaded(users);
      } catch (e) {
        yield UserError(e.toString());
      }
    } else if (event is UpdateUserVerifiedAt) {
      yield UserLoading();
      try {
        await userRepository.updateUserVerifiedAt(event.id, event.emailVerifiedAt);
        final users = await userRepository.getUsers();
        yield UserLoaded(users);
      } catch (e) {
        yield UserError(e.toString());
      }
    }
  }
}
